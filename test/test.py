# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer
@cocotb.test()
async def test_jh8_cpu(dut):
    dut._log.info("Starting NanoSilicon JH-8 CPU test")

    # 50 MHz clock (20 ns period)
    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Apply active-low reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 3)

    # Release reset
    dut.rst_n.value = 1

    dut._log.info("Running JH-8 program")

    # Allow enough cycles for the program to execute
    await ClockCycles(dut.clk, 20)
    await Timer(1, unit="ns")

    # Check that the CPU has halted
    halted = int(dut.uio_out.value) & 1
    assert halted == 1, "JH-8 did not halt"

    # Check that bidirectional pin 0 is configured as an output
    output_enable = int(dut.uio_oe.value)
    assert output_enable == 1, "HALTED pin is not enabled as an output"

    # Check the final program counter
    pc = int(dut.uo_out.value)
    assert pc == 8, f"Expected PC=8, got PC={pc}"

    dut._log.info("PASS: JH-8 executed program and halted")
    dut._log.info(f"Final PC: {pc}")
