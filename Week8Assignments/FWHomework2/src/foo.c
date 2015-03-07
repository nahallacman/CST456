// See foo.h for the typedefs for concernLevel_t and alertStatus_t.
#include "foo.h"

// stateCounter[] keeps track of consecutive alert recommendations.
// stateCounter[0] keeps track of NO_ALERT; stateCounter[1] keeps track of ALERT_USER.
// We don't need a counter for SERIOUS since it transitions instantly. 
uint8_t stateCounter[2];
alertStatus_t alertStatus;

// initAlertStatus is called on reset or when the device powers up.
void initAlertStatus (void)
{
	stateCounter[0] = 0;
	stateCounter[1] = 0;

	alertStatus = NO_ALERT;
}

/*
void updateAlertStatus (uint8_t heartRate, uint8_t temperature)
{
	concernLevel_t heartRateConcern, temperatureConcern;
		
	heartRateConcern = returnHeartRateConcern (heartRate);
	temperatureConcern = returnTemperatureConcern (temperature);
	
	// If assesment is SERIOUS then alert doctor immediately.
	if ((heartRateConcern == SERIOUS) || (temperatureConcern == SERIOUS))
	{	
		alertStatus = ALERT_DOCTOR;
	}
	// If assesment is ALERT_USER then alert user after two consecutive calls.
	else if ((heartRateConcern == FAIR) && (temperatureConcern == FAIR))
	{
		stateCounter[0] = 0;
		stateCounter[1]++;
		
		if (alertStatus != ALERT_USER)
		{
			if (stateCounter[1] == 2)
			{
				alertStatus = ALERT_USER;
			}
		}
	}
	// If assesment is NO_ALERT then turn off alerts after three consecutive calls.
	else
	{
		stateCounter[0]++;
		stateCounter[1] = 0;
		
		if (alertStatus != NO_ALERT)
		{
			if (stateCounter[0] == 3)
			{
				alertStatus = NO_ALERT;
			}
		}
	}	
}
*/

void updateAlertStatus (uint8_t heartRate, uint8_t temperature)
{
	concernLevel_t heartRateConcern, temperatureConcern;
		
	heartRateConcern = returnHeartRateConcern (heartRate);
	temperatureConcern = returnTemperatureConcern (temperature);
	
	// If assessment is SERIOUS then alert doctor immediately.
	if ((heartRateConcern == SERIOUS) || (temperatureConcern == SERIOUS))
	{	
		stateCounter[0] = 0;
		stateCounter[1] = 0;
		
		alertStatus = ALERT_DOCTOR;
	}
	// If assessment is ALERT_USER then alert user after two consecutive calls.
	else if ((heartRateConcern == FAIR) && (temperatureConcern == FAIR))
	{
		stateCounter[0] = 0;
		stateCounter[1]++;
		
		if (alertStatus != ALERT_USER)
		{
			if (stateCounter[1] == 2)
			{
				alertStatus = ALERT_USER;
				//stateCounter[1] = 0;
			}
		}
	}
	// If assessment is NO_ALERT then turn off alerts after three consecutive calls.
	else
	{
		stateCounter[0]++;
		stateCounter[1] = 0;
		
		if (alertStatus != NO_ALERT)
		{
			if (stateCounter[0] == 3)
			{
				alertStatus = NO_ALERT;
				//stateCounter[0] = 0;
			}
		}
	}	
}

// returnTemperatureConcern returns a concern level based on the user's temperature.
/*
concernLevel_t returnTemperatureConcern (uint8_t temperature)
{	
	if (temperature <= 33)
	{
		return SERIOUS;
	}
	else if (temperature <= 35)
	{
		return GOOD;
	}
	else if (temperature <= 38)
	{
		return GOOD;
	}
	else if (temperature <= 40)
	{
		return FAIR;
	}
	else
	{
		return SERIOUS;
	}
}
*/
concernLevel_t returnTemperatureConcern (uint8_t temperature)
{	
	if (temperature <= 33)
	{
		return SERIOUS;
	}
	else if (temperature <= 35)
	{
		return FAIR;
	}
	else if (temperature <= 38)
	{
		return GOOD;
	}
	else if (temperature <= 40)
	{
		return FAIR;
	}
	else
	{
		return SERIOUS;
	}
}

// returnHeartRateConcern returns a concern level based on the user's heart rate. 
/*
concernLevel_t returnHeartRateConcern (uint8_t heartRate)
{	
	if (heartRate < 40)
	{
		return SERIOUS;
	}
	else if (heartRate < 60)
	{
		return FAIR;
	}
	else if (heartRate < 91)
	{
		return GOOD;
	}
	else if (heartRate < 120)
	{
		return FAIR;
	}
	else
	{
		return SERIOUS;
	}
}
*/
concernLevel_t returnHeartRateConcern (uint8_t heartRate)
{	
	if (heartRate < 40)
	{
		return SERIOUS;
	}
	else if (heartRate < 60)
	{
		return FAIR;
	}
	else if (heartRate < 91)
	{
		return GOOD;
	}
	else if (heartRate < 121)
	{
		return FAIR;
	}
	else
	{
		return SERIOUS;
	}
}