#ifndef spi_H
#define spi_H

#ifdef __cplusplus
extern "C" {
#endif

//Includes-----------------------------------------------------------------//
#include "gd32f30x.h"
#include "hw_config.h"

//Defines-----------------------------------------------------------------//
//--------------------------------------
#ifdef      LCD_ON
#define     NUMB_LCD_SPI        0
#if         NUMB_LCD_SPI==0
#define     LCD_SPI             SPI0
#define     LCD_SPI_RCU       	RCU_SPI0
#elif       NUMB_LCD_SPI==1
#define     LCD_SPI             SPI1
#define     LCD_SPI_RCU       	RCU_SPI1
#endif
#endif

//--------------------------------------
#ifdef      W5500_ON
#define     NUMB_W5500_SPI      1
#if         NUMB_W5500_SPI==0
#define     W5500_SPI           SPI0
#define     W5500_SPI_RCU       RCU_SPI0
#elif       NUMB_W5500_SPI==1
#define     W5500_SPI           SPI1
#define     W5500_SPI_RCU       RCU_SPI1
#endif
#endif

//Prototypes--------------------------------------------------------//
void LCD_SPI_config(void);
void spi1_config(void);
void spi_write_byte (uint8_t );
void spi_write_buffer (uint8_t * , uint16_t );
void dma_config(void);
void spi_write_buffer_DMA (void);
void DMA0_Channel2_Callback(void);

//Variables---------------------------------------------------------//
extern char lcd_buf[];

#ifdef __cplusplus
}
#endif

#endif
