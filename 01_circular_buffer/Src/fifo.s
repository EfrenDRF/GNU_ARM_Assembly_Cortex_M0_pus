/**
  ******************************************************************************
  * @file      fifo.s
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

/***********************************************************
 * Regiter usage:
 */


/***********************************************************
 * LOCAL CONSTANT
 */
.equ	FIFO_SIZE,		8
.equ	FIFO_OK,		0
.equ	FIFO_NOT_OK,	1

.equ	FIFO_EMPTY,		1
.equ	FIFO_FULL,		0


/************************************************************
 *
 */
	        .section .data
			ptrWrite:		.space			4
			ptrRead:		.space			4
			ptrFifo:		.space			FIFO_SIZE
			ptrStatus:		.space			1


/************************************************************
 *
 */
			.section .text
			.global	FIFO_Init
			.global FIFO_WriteData
			.global FIFO_ReadData

/******************************************************
 * @brief Initalize the 8 byte FIFO buffer
 * @param  None
 * @retval None
 *****************************************************/
FIFO_Init:
			ldr		r2, =ptrFifo
			ldr		r3, =ptrWrite
			str		r2, [r3]
			ldr		r3, =ptrRead
			str		r2, [r3]
			ldr		r2, =ptrStatus
			movs	r3, #FIFO_EMPTY
			strb	r3, [r2]
			bx		lr


/******************************************************
 * @brief Write a byte in the FIFO buffer
 * @param  R0 - byte to be ket in the buffer
 * @retval R1 - return a boolean value
 *****************************************************/
 FIFO_WriteData:
 			ldr		r5,	=ptrStatus				// r5 = &ptrStatus, Load the memory address
 			ldrb	r2, [r5]					// r2 = *r5
 			cmp		r2, #FIFO_FULL				// (r2 == FIFO_FULL)?
 			beq		__IsFull					// -Yes,
 												// -No continue with the next instructions
			ldr		r2, =ptrWrite				// r2 = &ptrWrite
			ldr		r3, [r2]					// r3 = *r2
			strb	r0, [r3]					// *r3 = r0, Stores r0 byte into the buffer
			adds	r3, #1						// r3++ , Increases the position to the next buffer element
			ldr		r4, =ptrFifo + FIFO_SIZE
			cmp		r3, r4						// (r3 == r4)?
			bne		__PtrWriteInRange			// No
			ldr		r3, =ptrFifo				// Yes, Restore the initial buffer memory address

__PtrWriteInRange:
			ldr		r4, =ptrRead				// r4 = &ptrRead
			ldr		r4, [r4]					// r4 = *r4
			str 	r3, [r2]					// Update ptrWrite with the new memory address
			cmp		r3,r4						// (r3 != r4)?
			bne		__IsNotFull					// -Yes,
												// -No, continue with the next instructions
			movs	r4, #FIFO_FULL				//
			strb	r4, [r5]					// Changes ptrStatus to FIFO_FULL
__IsFull:
			movs	r1, #FIFO_NOT_OK			// Return negative response
			bx		lr


__IsNotFull:

			movs	r0, #0						// Clean R0
			movs	r1, #FIFO_OK				// Return positive response
			bx		lr

 /******************************************************
 * @brief Read a byte in the FIFO buffer
 * @param  R0 - holds the byte read
 * @retval R1 - return a boolean value
 *****************************************************/
FIFO_ReadData:
			ldr		r3, =ptrRead				// r3 = &ptrRead
			ldr		r4,	[r3]					// r4 = *r3
			ldr		r5, =ptrStatus				// r5 = &ptrStatus
			ldrb	r2, [r5]					// r2 = *r5
			cmp		r2, #FIFO_EMPTY             // (r2 != FIFO_EMPTY)?
			bne		__IsNotEmpty				// -Yes,
												// -No, Continue with the next instructions
			ldr		r2, =ptrWrite				// r2 = &ptrWrite
			ldr		r2, [r2]					// r2 = *r2
			cmp		r4,	r2						// (r4 != r2)?
			bne		__IsNotEmpty				// -Yes
												// -No, Continue with the next instructions
			movs	r0, #0						// Clean the register
			movs	r1, #FIFO_NOT_OK			// Return negative response
			bx		lr


__IsNotEmpty:
			movs	r2,	#0
			ldrsb	r0,	[r4, r2]				// r0 = *(r4 + 0), Gets a byte from buffer
			adds	r4, #1						// r4++, Increases the position to the next buffer element
			ldr		r2, =ptrFifo + FIFO_SIZE	//
			cmp		r4, r2						// (r4 == r2)?
			bne		__PtrReadInRange			// -No
			ldr		r4,	=ptrFifo				// -Yes, restore the initial memory address


__PtrReadInRange:
			str		r4,	[r3]					// Update ptrRead with the new memory address
			movs	r3, #FIFO_EMPTY
			strb	r3, [r5]					// Changes ptrStatus to FIFO_EMPTY
			movs	r1,	#FIFO_OK				// Return positive response
			bx		lr


.end
/***********************************END OF FILE*********************************/
