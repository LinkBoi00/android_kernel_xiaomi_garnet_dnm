# Makefile for the focaltech touchscreen drivers.
subdir-ccflags-y += -I$(srctree)/drivers/power/supply/

obj-m += ft3683g.o
ft3683g-y += focaltech_core.o \
		focaltech_ex_fun.o \
		focaltech_ex_mode.o \
		focaltech_gesture.o \
		focaltech_esdcheck.o \
		focaltech_point_report_check.o \
		focaltech_spi_v2.o \
		focaltech_flash.o \
		focaltech_upgrade_ft3683g.o \
		focaltech_test.o \
		focaltech_test_ini.o \
		focaltech_test_ft3683g.o \
		mi_disp_notifier.o
