/*
 * Copyright 2026 NXP
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "board.h"
#include "app.h"
#include "fsl_debug_console.h"
#include "tool.h"

extern void nfc_example_rwandce(void);
extern void nfc_example_rw(void);
extern void nfc_example_p2p(void);

typedef enum _app_task
{
    kAppTask_RWandCE,
    kAppTask_RW,
    kAppTask_P2P,
} app_task_t;

/* Normalize a single ASCII character so console command matching is case-insensitive. */
static char APP_ToLower(char ch)
{
    if ((ch >= 'A') && (ch <= 'Z'))
    {
        ch = (char)(ch - 'A' + 'a');
    }

    return ch;
}

/* Block until one character is received from the debug console. */
static int APP_WaitConsoleChar(void)
{
    int ch;

    do
    {
        ch = GETCHAR();
        if (ch < 0)
        {
            Sleep(10);
        }
    } while (ch < 0);

    return ch;
}

/* Read one printable command line from the console and echo the normalized characters. */
static void APP_ReadCommand(char *buffer, size_t bufferSize)
{
    size_t length = 0;

    while (true)
    {
        int ch = APP_WaitConsoleChar();

        if ((ch == '\r') || (ch == '\n'))
        {
            if (length == 0U)
            {
                continue;
            }

            buffer[length] = '\0';
            PRINTF("\r\n");
            return;
        }

        if ((ch == '\b') || (ch == 0x7F))
        {
            if (length > 0U)
            {
                length--;
                PRINTF("\b \b");
            }
            continue;
        }

        if ((ch >= ' ') && (ch <= '~') && (length < (bufferSize - 1U)))
        {
            char normalized = APP_ToLower((char)ch);
            buffer[length] = normalized;
            length++;
            PUTCHAR(normalized);
        }
    }
}

/* Compare a received command against one accepted selector token. */
static bool APP_CommandEquals(const char *command, const char *expected)
{
    return strcmp(command, expected) == 0;
}

/* Prompt until the user selects one of the supported NFC application modes. */
static app_task_t APP_SelectTask(void)
{
    char command[16];

    while (true)
    {
        PRINTF("\r\nSelect NFC application task:\r\n");
        PRINTF("  1 / rwandce - Reader/Writer + Card Emulation mode\r\n");
        PRINTF("  2 / rw      - Reader/Writer mode\r\n");
        PRINTF("  3 / p2p     - P2P mode\r\n");
        PRINTF("> ");

        APP_ReadCommand(command, sizeof(command));

        if (APP_CommandEquals(command, "1") || APP_CommandEquals(command, "rwandce") ||
            APP_CommandEquals(command, "rwce"))
        {
            return kAppTask_RWandCE;
        }

        if (APP_CommandEquals(command, "2") || APP_CommandEquals(command, "rw"))
        {
            return kAppTask_RW;
        }

        if (APP_CommandEquals(command, "3") || APP_CommandEquals(command, "p2p"))
        {
            return kAppTask_P2P;
        }

        PRINTF("Unknown command: %s\r\n", command);
    }
}

/* Initialize the board, select the NFC demo at runtime, and dispatch to the chosen task. */
int main(void)
{
    app_task_t selectedTask;

    /* Bring up clocks, pins, I2C, and the debug UART before using the console selector. */
    BOARD_InitHardware();

    PRINTF("MCUX SDK version: %s\r\n", MCUXSDK_VERSION_FULL_STR);
    PRINTF("\r\nRunning the NXP-NCI2.0 application selector for PN7160.\r\n");

    /* Block here until the user chooses which NFC demo should own the PN7160 session. */
    selectedTask = APP_SelectTask();

    /* Each selected demo initializes PN7160 for its own mode and then enters its discovery loop. */
    switch (selectedTask)
    {
        case kAppTask_RWandCE:
            PRINTF("\r\nStarting Reader/Writer + Card Emulation mode.\r\n");
            nfc_example_rwandce();
            break;

        case kAppTask_RW:
            PRINTF("\r\nStarting Reader/Writer mode.\r\n");
            nfc_example_rw();
            break;

        case kAppTask_P2P:
        default:
            PRINTF("\r\nStarting P2P mode.\r\n");
            nfc_example_p2p();
            break;
    }

    /* Demo functions normally do not return. Stay here if initialization failed and a demo exits. */
    while (1)
    {
    }
}