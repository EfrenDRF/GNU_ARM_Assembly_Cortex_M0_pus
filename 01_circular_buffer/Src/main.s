/**
  ******************************************************************************
  * @file      main.s
  * @author    Efren Del Real Frias
  * @Abstract : 
  * @version   V1.0.0
  * @date      2020-04-19
  ******************************************************************************
  */

.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb


        .section .text
        .global main


main:
        /* Initilize the fifo register */
        bl    FIFO_Init


		/* Get a byte from buffer*/
		bl FIFO_ReadData

		/* Put a byte in buffer*/
        movs    r0, #0x0A
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0x50
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0xFF
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0xAA
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0x22
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0xBB
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0x33
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0x48
        bl    FIFO_WriteData
		/* Put a byte in buffer*/
        movs    r0, #0x10
        bl    FIFO_WriteData
		/* Get a byte from buffer*/
		bl FIFO_ReadData

		/* Put a byte in buffer*/
        movs    r0, #0x42
        bl    FIFO_WriteData

		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData
 		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData
 		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData
 		/* Get a byte from buffer*/
		bl FIFO_ReadData
		/* Get a byte from buffer*/
		bl FIFO_ReadData


stop:        b   stop



.end
/***********************************END OF FILE*********************************/
