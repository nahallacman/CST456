#include "unity.h"
#include "foo.h"

// See foo.h for the typedefs for concernLevel_t and alertStatus_t.

void setUp(void)
{
}

void tearDown(void)
{
}

void testHeartRateConcern (void)
{
	uint8_t heartRate;

	// Exhaustively test returnHeartRateConcern for heart rates from 0 to 39.
	// We expect it to return SERIOUS.
	for (heartRate = 0; heartRate <= 39; heartRate++)
	{
		TEST_ASSERT_EQUAL_INT (SERIOUS, returnHeartRateConcern(heartRate));
	}
}

void testTemperatureConcern (void)
{
	uint8_t temperature;

	// Exhaustively test returnTemperatureConcern for temperatures from from 0 to 33.
	// We expect it to return SERIOUS.
	for (temperature = 0; temperature <= 33; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (SERIOUS, returnTemperatureConcern(temperature));
	}
	/*
	for (temperature = 34; temperature <= 35; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (FAIR, returnTemperatureConcern(temperature));
	}
	*/
	for (temperature = 36; temperature <= 38; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (GOOD, returnTemperatureConcern(temperature));
	}
	
	for (temperature = 39; temperature <= 40; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (FAIR, returnTemperatureConcern(temperature));
	}
	
	for (temperature = 34; temperature <= 35; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (SERIOUS, returnTemperatureConcern(temperature));
	}
}

// Test updateAlertStatus function. alertStatus is a global variable.
void testAlertStatus (void)
{
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
}

