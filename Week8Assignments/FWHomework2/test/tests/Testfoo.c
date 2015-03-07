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
	
	// Exhaustively test returnHeartRateConcern for heart rates from 40 to 59.
	// We expect it to return FAIR.
	for (heartRate = 40; heartRate <= 59; heartRate++)
	{
		TEST_ASSERT_EQUAL_INT (FAIR, returnHeartRateConcern(heartRate));
	}
	
	// Exhaustively test returnHeartRateConcern for heart rates from 60 to 90.
	// We expect it to return GOOD.
	for (heartRate = 60; heartRate <= 90; heartRate++)
	{
		TEST_ASSERT_EQUAL_INT (GOOD, returnHeartRateConcern(heartRate));
	}
	
	// Exhaustively test returnHeartRateConcern for heart rates from 91 to 120.
	// We expect it to return FAIR.
	for (heartRate = 91; heartRate <= 120; heartRate++)
	{
		TEST_ASSERT_EQUAL_INT (FAIR, returnHeartRateConcern(heartRate));
	}
	
	// Exhaustively test returnHeartRateConcern for heart rates from 121 to the max of the 8 bit number.
	// We expect it to return SERIOUS.
	for (heartRate = 121; heartRate <= 254; heartRate++)
	{
		TEST_ASSERT_EQUAL_INT (SERIOUS, returnHeartRateConcern(heartRate));
	}
}

//this test exhaustively tests all possible temperatures and the status they should return when returnTemperatureConcern is called
void testTemperatureConcern (void)
{
	uint8_t temperature;

	// Exhaustively test returnTemperatureConcern for temperatures from from 0 to 33.
	// We expect it to return SERIOUS.
	for (temperature = 0; temperature <= 33; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (SERIOUS, returnTemperatureConcern(temperature));
	}
	
	//test temperatures from 34 to 35
	//expect it to return FAIR.
	for (temperature = 34; temperature <= 35; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (FAIR, returnTemperatureConcern(temperature));
	}
	
	//test temperatures from 36 to 38
	//expect it to return GOOD.
	for (temperature = 36; temperature <= 38; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (GOOD, returnTemperatureConcern(temperature));
	}
	
	//test temperatures from 39 to 40
	//expect it to return FAIR.
	for (temperature = 39; temperature <= 40; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (FAIR, returnTemperatureConcern(temperature));
	}
	
	//test temperatures from 41 to max of 8 bit number
	//expect it to return SERIOUS.
	for (temperature = 41; temperature < 255; temperature++)
	{
		TEST_ASSERT_EQUAL_INT (SERIOUS, returnTemperatureConcern(temperature));
	}
	
}

// Test updateAlertStatus function. alertStatus is a global variable.
void testAlertStatus (void)
{
	// --- TEST 01 ---
	initAlertStatus ();
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// --- TEST 02 ---
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	// takes 2 consecutive alerts before transition
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	
	// --- TEST 03 ----
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	// takes 2 consecutive alerts before transition
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	
	//Transition back to NO_ALERT
	// takes 3 consecutive alerts before transition
	updateAlertStatus (60, 36);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	updateAlertStatus (60, 36);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);	
	updateAlertStatus (60, 36);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);

	// --- TEST 04 ----
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	// takes 2 consecutive alerts before transition
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	
	//Transition alert status to ALERT_DOCTOR
	// takes 1 alerts before transition
	updateAlertStatus ( 121, 36);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);

	// --- TEST 05 ----
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	// takes 2 consecutive alerts before transition
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	
	//Transition alert status to ALERT_DOCTOR
	// takes 1 alerts before transition
	updateAlertStatus ( 121, 36);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);

	//Transition alert status to NO_ALERT
	// takes 3 alerts before transition
	updateAlertStatus ( 60, 37);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);
	updateAlertStatus ( 60, 37);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);
	updateAlertStatus ( 60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	
	// --- TEST 06 ----
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	// takes 2 consecutive alerts before transition
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	
	//Transition alert status to ALERT_DOCTOR
	// takes 1 alerts before transition
	updateAlertStatus ( 121, 36);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);

	
	//Transition alert status to ALERT_USER
	// takes 2 alerts before transition
	updateAlertStatus ( 100, 40);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);
	
	//when testing, bug 3 happens here.
	updateAlertStatus ( 100, 40);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);


	/*
	// --- TEST 07 ----
	initAlertStatus ();
	
	// Verify the alert status is at NO_ALERT.
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
	
	// Transition alert status to ALERT_USER.
	// takes 2 consecutive alerts before transition
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);	
	updateAlertStatus (42, 35);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	
	//Transition alert status to ALERT_DOCTOR
	// takes 1 alerts before transition
	updateAlertStatus ( 121, 36);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);

	//Transition alert status to ALERT_USER
	// takes 2 alerts before transition
	updateAlertStatus ( 100, 40);
	TEST_ASSERT_EQUAL_INT (ALERT_DOCTOR, alertStatus);
	updateAlertStatus ( 100, 40);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);

	//Transition alert status to NO_ALERT
	// takes 3 alerts before transition	
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);
	updateAlertStatus (60, 37);
	TEST_ASSERT_EQUAL_INT (ALERT_USER, alertStatus);	
	updateAlertStatus (60, 37);	
	TEST_ASSERT_EQUAL_INT (NO_ALERT, alertStatus);
*/
}

