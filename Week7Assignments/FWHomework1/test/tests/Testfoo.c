#include "unity.h"
#include "foo.h"

void setUp(void)
{
}

void tearDown(void)
{
}

// Create one passing and one failing assertion using TEST_ASSERT_TRUE.
void testTEST_ASSERT_TRUE (void)
{
	TEST_ASSERT_EQUAL(1, 0x01);
	TEST_ASSERT_NOT_EQUAL(0, 0x01);
}

// Create one passing and one failing assertion using TEST_ASSERT_FALSE.
void testTEST_ASSERT_FALSE (void)
{
	TEST_ASSERT_NOT_EQUAL(0, 1);
	TEST_ASSERT_EQUAL( 1, 1);
}

// Create one passing and one failing assertion using TEST_ASSERT_EQUAL_INT8.
// Try it with negative decimal numbers, positive decimal numbers, and hexadecimal numbers.
void testTEST_ASSERT_EQUAL_INT8 (void)
{
	TEST_ASSERT_EQUAL_INT8(0x80, -128);
	TEST_ASSERT_EQUAL_INT8(0xFF, -1);
	TEST_ASSERT_EQUAL_INT8(0x01, 1);
	TEST_ASSERT_EQUAL_INT8(1, 0x01);
	TEST_ASSERT_EQUAL_INT8(1, 257);
	TEST_ASSERT_EQUAL_INT8(0, 256);
	TEST_ASSERT_EQUAL_INT8(-1, 255);
}

// Create one passing and one failing assertion using TEST_ASSERT_EQUAL_UINT8.
// Try it with negative decimal numbers, positive decimal numbers, and hexadecimal numbers.
void testTEST_ASSERT_EQUAL_UINT8 (void)
{
	TEST_ASSERT_EQUAL_UINT8(0x80, -128);
	TEST_ASSERT_EQUAL_UINT8(0xFF, -1);
	TEST_ASSERT_EQUAL_UINT8(0x01, 1);
	TEST_ASSERT_EQUAL_UINT8(1, 0x01);
	TEST_ASSERT_EQUAL_UINT8(1, 257);
	TEST_ASSERT_EQUAL_UINT8(0, 256);
	TEST_ASSERT_EQUAL_UINT8(-1, 255);
}

// Create one passing and one failing assertion using TEST_ASSERT_EQUAL_HEX8.
// Try it with negative decimal numbers, positive decimal numbers, and hexadecimal numbers.
void testTEST_ASSERT_EQUAL_HEX8 (void)
{
	TEST_ASSERT_EQUAL_HEX8(0x80, -128);
	TEST_ASSERT_EQUAL_HEX8(0xFF, -1);
	TEST_ASSERT_EQUAL_HEX8(0x01, 1);
	TEST_ASSERT_EQUAL_HEX8(1, 0x01);
	TEST_ASSERT_EQUAL_HEX8(1, 257);
	TEST_ASSERT_EQUAL_HEX8(0, 256);
	TEST_ASSERT_EQUAL_HEX8(-1, 255);
}

// Create one passing and one failing assertion using TEST_ASSERT_UINT_WITHIN.
void testTEST_ASSERT_UINT_WITHIN (void)
{
	uint8_t a;
	a = 12;
	//a = randc();
	TEST_ASSERT_UINT_WITHIN(128, 128, a);
	TEST_ASSERT_UINT_WITHIN(2, 0, 1);
	//tests if 0 is within 2 of 1
}

// Create one passing and one failing assertion using TEST_ASSERT_BITS.
void testTEST_ASSERT_BITS (void)
{
	TEST_ASSERT_BITS(0x01, 1, 0x01);
	TEST_ASSERT_BITS(0xFF, -1, 0xFF);
	TEST_ASSERT_BITS(0x08, 8, 0x08);
	//TEST_ASSERT_BITS(0xFF, -1, 0x01);
}

// Create one passing and one failing assertion using TEST_ASSERT_BITS_HIGH.
void testTEST_ASSERT_BITS_HIGH (void)
{

}

// Create one passing and one failing assertion using TEST_ASSERT_BIT_HIGH.
void testTEST_ASSERT_BIT_HIGH (void)
{

}

// Exhaustively test the squareNumber function located in foo.c.
// squareNumber takes an 8-bit unsigned integer as input, squares it, and then returns the squared value as a 16-bit unsigned integer.
void testsquareNumber (void)
{
	uint8_t testval;
	uint16_t count;
	uint16_t returnval;
	for( testval = 0, count = 0; count < 256; testval++, count++)
	{
		returnval = squareNumber( testval );
		TEST_ASSERT_EQUAL(returnval, testval * testval);
		TEST_ASSERT_EQUAL(count, testval);
		TEST_ASSERT_EQUAL(testval * testval, squareNumber(testval) );
		// assert_equal(returnval, testval * testval);
	}
}