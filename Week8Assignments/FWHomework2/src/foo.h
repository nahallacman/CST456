#ifndef _FOO_H
	#define _FOO_H

	#include <stdint.h>

	typedef enum
	{
		GOOD,
		FAIR,
		SERIOUS
	} concernLevel_t;

	typedef enum
	{
		NO_ALERT,
		ALERT_USER,
		ALERT_DOCTOR
	} alertStatus_t;

	extern alertStatus_t alertStatus;

	concernLevel_t returnHeartRateConcern (uint8_t heartRate);
	concernLevel_t returnTemperatureConcern (uint8_t temperature);
	void updateAlertStatus (uint8_t heartRate, uint8_t temperature);
	void initAlertStatus (void);
#endif // _FOO_H


