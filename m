From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: iptables u32 match code for review/testing/...
Date: Fri, 27 Dec 2002 10:54:41 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212271854.gBRIsf131987@isis.cs3-inc.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Code below.  Doc is in the code for the kernel module.
I've given up on the comment and multiple argument specs - 
now all the tests are in the same argument.
A few remaining questions are marked with "***" in the code.
I look forward to suggestions/corrections etc.

==== <kernel>include/linux/netfilter_ipv4/ipt_u32.h
#ifndef _IPT_U32_H
#define _IPT_U32_H
#include <linux/netfilter_ipv4/ip_tables.h>

enum ipt_u32_ops
{
  IPT_U32_AND,
  IPT_U32_LEFTSH,
  IPT_U32_RIGHTSH,
  IPT_U32_AT
};

/* *** What's this about?
   Must fit inside union ipt_matchinfo: 16 bytes */
struct ipt_u32_location_element
{
  u_int32_t number;
  u_int8_t nextop;
};
struct ipt_u32_value_element
{
  u_int32_t min;
  u_int32_t max;
};
/* *** any way to allow for an arbitrary number of elements?
   for now I settle for a limit of 10 of each */
#define U32MAXSIZE 10
struct ipt_u32_test
{
  u_int8_t nnums;
  struct ipt_u32_location_element location[U32MAXSIZE+1];
  u_int8_t nvalues;
  struct ipt_u32_value_element value[U32MAXSIZE+1];
};

struct ipt_u32
{
  u_int8_t ntests;
  struct ipt_u32_test tests[U32MAXSIZE+1];
};

#endif /*_IPT_U32_H*/

==== <kernel>net/ipv4/netfilter/ipt_u32.c
/* Kernel module to match u32 packet content. */

/* 
U32 tests whether quantities of up to 4 bytes extracted from a packet 
have specified values.  The specification of what to extract is general 
enough to find data at given offsets from tcp headers or payloads.

 --u32 tests
 The argument amounts to a program in a small language described below.
 tests := location = value |  tests && location = value
 value := range | value , range
 range := number | number : number
  a single number, n, is interpreted the same as n:n
  n:m is interpreted as the range of numbers >=n and <=m
 location := number | location operator number
 operator := & | << | >> | @

 The operators &, <<, >>, && mean the same as in c.  The = is really a set
 membership operator and the value syntax describes a set.  The @ operator
 is what allows moving to the next header and is described further below.

 *** Until I can find out how to avoid it, there are some artificial limits
 on the size of the tests:
 - no more than 10 ='s (and 9 &&'s) in the u32 argument
 - no more than 10 ranges (and 9 commas) per value
 - no more than 10 numbers (and 9 operators) per location

 To describe the meaning of location, imagine the following machine that
 interprets it.  There are three registers:
  A is of type char*, initially the address of the IP header
  B and C are unsigned 32 bit integers, initially zero

  The instructions are:
   number	B = number;
   		C = (*(A+B)<<24)+(*(A+B+1)<<16)+(*(A+B+2)<<8)+*(A+B+3)
   &number	C = C&number
   <<number	C = C<<number
   >>number	C = C>>number
   @number	A = A+C; then do the instruction number
  Any access of memory outside [skb->head,skb->end] causes the match to fail.
  Otherwise the result of the computation is the final value of C.

 Whitespace is allowed but not required in the tests.
 However the characters that do occur there are likely to require
 shell quoting, so it's a good idea to enclose the arguments in quotes.

Example:
 match IP packets with total length >= 256
 The IP header contains a total length field in bytes 2-3.
 --u32 "0&0xFFFF=0x100:0xFFFF" 
 read bytes 0-3
 AND that with FFFF (giving bytes 2-3),
 and test whether that's in the range [0x100:0xFFFF]

Example: (more realistic, hence more complicated)
 match icmp packets with icmp type 0
 First test that it's an icmp packet, true iff byte 9 (protocol) = 1
 --u32 "6&0xFF=1 && ...
 read bytes 6-9, use & to throw away bytes 6-8 and compare the result to 1
 Next test that it's not a fragment.
  (If so it might be part of such a packet but we can't always tell.)
  n.b. This test is generally needed if you want to match anything
  beyond the IP header.
 The last 6 bits of byte 6 and all of byte 7 are 0 iff this is a complete
 packet (not a fragment).  Alternatively, you can allow first fragments
 by only testing the last 5 bits of byte 6.
 ... 4&0x3FFF=0 && ...
 Last test: the first byte past the IP header (the type) is 0
 This is where we have to use the @syntax.  The length of the IP header
 (IHL) in 32 bit words is stored in the right half of byte 0 of the
 IP header itself.
 ... 0>>22&0x3C@0>>24=0"
 The first 0 means read bytes 0-3,
 >>22 means shift that 22 bits to the right.  Shifting 24 bits would give
   the first byte, so only 22 bits is four times that plus a few more bits.
 &3C then eliminates the two extra bits on the right and the first four 
 bits of the first byte.
 For instance, if IHL=5 then the IP header is 20 (4 x 5) bytes long.
 In this case bytes 0-1 are (in binary) xxxx0101 yyzzzzzz, 
 >>22 gives the 10 bit value xxxx0101yy and &3C gives 010100.
 @ means to use this number as a new offset into the packet, and read
 four bytes starting from there.  This is the first 4 bytes of the icmp
 payload, of which byte 0 is the icmp type.  Therefore we simply shift
 the value 24 to the right to throw out all but the first byte and compare
 the result with 0.

Example: 
 tcp payload bytes 8-12 is any of 1, 2, 5 or 8
 First we test that the packet is a tcp packet (similar to icmp).
 --u32 "6&0xFF=6 && ...
 Next, test that it's not a fragment (same as above).
 ... 0>>22&0x3C@12>>26&0x3C@8=1,2,5,8"
 0>>22&3C as above computes the number of bytes in the IP header.
 @ makes this the new offset into the packet, which is the start of the
 tcp header.  The length of the tcp header (again in 32 bit words) is
 the left half of byte 12 of the tcp header.  The 12>>26&3C
 computes this length in bytes (similar to the IP header before).
 @ makes this the new offset, which is the start of the tcp payload.
 Finally 8 reads bytes 8-12 of the payload and = checks whether the
 result is any of 1, 2, 5 or 8
*/

#include <linux/module.h>
#include <linux/skbuff.h>

#include <linux/netfilter_ipv4/ipt_u32.h>
#include <linux/netfilter_ipv4/ip_tables.h>

/* #include <asm-i386/timex.h> for timing */

MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
MODULE_DESCRIPTION("IP tables u32 matching module");
MODULE_LICENSE("GPL");

static int
match(const struct sk_buff *skb,
      const struct net_device *in,
      const struct net_device *out,
      const void *matchinfo,
      int offset,
      const void *hdr,
      u_int16_t datalen,
      int *hotdrop)
{
  const struct ipt_u32 *data = matchinfo;
  int testind, i;
  unsigned char* origbase = (char*)skb->nh.iph;
  unsigned char* base = origbase;
  unsigned char* head = skb->head;
  unsigned char* end = skb->end;
  int nnums, nvals;
  u_int32_t pos, val;
  /* unsigned long long cycles1, cycles2, cycles3, cycles4;
     cycles1 = get_cycles(); */
  for (testind=0; testind < data->ntests; testind++) {
    base=origbase; /* reset for each test */
    pos = data->tests[testind].location[0].number;
    if (base+pos+3 > end || base+pos < head) return 0;
    val = (base[pos]<<24) + (base[pos+1]<<16) +
      (base[pos+2]<<8) + base[pos+3];
    nnums = data->tests[testind].nnums;
    for (i=1; i<nnums; i++) {
      u_int32_t number = data->tests[testind].location[i].number;
      switch (data->tests[testind].location[i].nextop) {
      case IPT_U32_AND: val = val & number; break;
      case IPT_U32_LEFTSH: val = val << number; break;
      case IPT_U32_RIGHTSH: val = val >> number; break;
      case IPT_U32_AT:
	base = base + val;
	pos = number;
	if (base+pos+3 > end || base+pos < head) return 0;
	val = (base[pos]<<24) + (base[pos+1]<<16) +
	  (base[pos+2]<<8) + base[pos+3];
	break;
      }
    }
    nvals = data->tests[testind].nvalues;
    for (i=0; i < nvals; i++) {
      if ((data->tests[testind].value[i].min <= val) &&
	  (val <= data->tests[testind].value[i].max))
	{break;}}
    if(i >= data->tests[testind].nvalues) {
      /* cycles2 = get_cycles(); 
	 printk("failed %d in %d cycles\n", testind, cycles2-cycles1); */
      return 0;}
  }
  /* cycles2 = get_cycles();
     printk("succeeded in %d cycles\n", cycles2-cycles1); */
  return 1;
}

static int
checkentry(const char *tablename,
           const struct ipt_ip *ip,
           void *matchinfo,
           unsigned int matchsize,
           unsigned int hook_mask)
{
  if (matchsize != IPT_ALIGN(sizeof(struct ipt_u32)))
    return 0;
  return 1;
}

static struct ipt_match u32_match
  = { { NULL, NULL }, "u32", &match, &checkentry, NULL, THIS_MODULE };

static int __init init(void)
{
  return ipt_register_match(&u32_match);
}

static void __exit fini(void)
{
  ipt_unregister_match(&u32_match);
}

module_init(init);
module_exit(fini);

==== <iptables-1.2.7a>/extensions/libipt_u32.c
/* Shared library add-on to iptables to add u32 matching,
   generalized matching on values found at packet offsets

   Detailed doc is in the kernel module source
   net/ipv4/netfilter/ipt_u32.c
*/
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ipt_u32.h>
#include <errno.h>
#include <ctype.h>

/* Function which prints out usage message. */
static void
help(void)
{
  printf(
	 "u32 v%s options:\n"
	 " --u32 tests\n"
	 " tests := location = value | tests && location = value\n"
	 " value := range | value , range\n"
	 " range := number | number : number\n"
	 " location := number | location operator number\n"
	 " operator := & | << | >> | @\n"
	 ,IPTABLES_VERSION);
}

/* defined in /usr/include/getopt.h maybe in man getopt */
static struct option opts[] = {
  { "u32", 1, 0, '1' },
  {0}
};

/* Initialize the match. */
static void
init(struct ipt_entry_match *m, unsigned int *nfcache)
{
  *nfcache |= NFC_UNKNOWN;
}

/* shared printing code */
static void print_u32(struct ipt_u32 *data)
{
  unsigned int testind;
  for (testind=0; testind < data->ntests; testind++) {
    if (testind) printf("&&");
    {
      unsigned int i;
      printf("0x%x", data->tests[testind].location[0].number);
      for (i=1; i < data->tests[testind].nnums; i++) {
	switch (data->tests[testind].location[i].nextop) {
	case IPT_U32_AND: printf("&"); break;
	case IPT_U32_LEFTSH: printf("<<"); break;
	case IPT_U32_RIGHTSH: printf(">>"); break;
	case IPT_U32_AT: printf("@"); break;
	}
	printf("0x%x", data->tests[testind].location[i].number);}
      printf("=");
      for (i=0; i < data->tests[testind].nvalues; i++) {
	if (i) printf(",");
	if (data->tests[testind].value[i].min
	    == data->tests[testind].value[i].max)
	  printf("0x%x", data->tests[testind].value[i].min);
	else printf("0x%x:0x%x", data->tests[testind].value[i].min,
		    data->tests[testind].value[i].max);}}}
  printf(" ");
}

/* string_to_number is not quite what we need here ... */
u_int32_t parse_number(char **s, int pos)
{
  u_int32_t number;
  char *end;
  errno = 0;
  number = strtol(*s, &end, 0);
  if (end == *s)
    exit_error(PARAMETER_PROBLEM, "u32: at char %d expected number", pos);
  if (errno)
    exit_error(PARAMETER_PROBLEM, "u32: at char %d error reading number", pos);
  *s=end;
  return number;
}

/* Function which parses command options; returns true if it ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      unsigned int *nfcache,
      struct ipt_entry_match **match)
{
  struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;
  char *arg = argv[optind-1]; /* the argument string */
  char *start = arg;
  int state=0, testind=0, locind=0, valind=0;
  if (c != '1') return 0;
  /* states: 0 = looking for numbers and operations, 1 = looking for ranges */
  while (1) { /* read next operand/number or range */
    while (isspace(*arg)) arg++;  /* skip white space */
    if (! *arg) { /* end of argument found */
      if (state == 0)
	exit_error(PARAMETER_PROBLEM, "u32: input ended in location spec");
      if (valind == 0)
	exit_error(PARAMETER_PROBLEM, "u32: test ended with no value spec");
      data->tests[testind].nnums = locind;
      data->tests[testind].nvalues = valind;
      testind++;
      data->ntests=testind;
      if (testind > U32MAXSIZE)
	exit_error(PARAMETER_PROBLEM, "u32: at char %d too many &&'s",
		   arg-start);
      /* debugging 
      print_u32(data);printf("\n");
      exit_error(PARAMETER_PROBLEM, "debugging output done"); */
      return 1;
    }
    if (state==0) {
      /* reading location: read a number if nothing read yet,
	 otherwise either op number or = to end location spec */	 
      if (*arg == '=') {
	if (locind == 0)
	  exit_error(PARAMETER_PROBLEM,
		     "u32: at char %d location spec missing", arg-start);
	else {arg++; state=1;}}
      else {
	if (locind) { /* need op before number */
	  if (*arg == '&') {
	    data->tests[testind].location[locind].nextop = IPT_U32_AND;}
	  else if (*arg == '<') {
	    arg++;
	    if (*arg != '<')
	      exit_error(PARAMETER_PROBLEM,
			 "u32: at char %d a second < expected", arg-start);
	    data->tests[testind].location[locind].nextop = IPT_U32_LEFTSH;}
	  else if (*arg == '>') {
	    arg++;
	    if (*arg != '>')
	      exit_error(PARAMETER_PROBLEM,
			 "u32: at char %d a second > expected", arg-start);
	    data->tests[testind].location[locind].nextop = IPT_U32_RIGHTSH;}
	  else if (*arg == '@') {
	    data->tests[testind].location[locind].nextop = IPT_U32_AT;}
	  else exit_error(PARAMETER_PROBLEM,
			  "u32: at char %d operator expected", arg-start);
	  arg++;}
	/* now a number; string_to_number skips white space? */
	data->tests[testind].location[locind].number =
	  parse_number(&arg, arg-start);
	locind++;
	if (locind > U32MAXSIZE)
	  exit_error(PARAMETER_PROBLEM,
		     "u32: at char %d too many operators", arg-start);
      }}
    else {
      /* state 1 - reading values: read a range if nothing read yet,
	 otherwise either ,range or && to end test spec */
      if (*arg == '&') {
	arg++;
	if (*arg != '&')
	  exit_error(PARAMETER_PROBLEM,
		     "u32: at char %d a second & expected", arg-start);
	if (valind == 0)
	  exit_error(PARAMETER_PROBLEM,
		     "u32: at char %d value spec missing", arg-start);
	else {
	  data->tests[testind].nnums = locind;
	  data->tests[testind].nvalues = valind;
	  testind++;
	  if (testind > U32MAXSIZE)
	    exit_error(PARAMETER_PROBLEM,
		       "u32: at char %d too many &&'s", arg-start);
	  arg++; state=0; locind=0; valind=0;}}
      else { /* read value range */
	if (valind) { /* need , before number */
	  if (*arg != ',')
	    exit_error(PARAMETER_PROBLEM,
		       "u32: at char %d expected , or &&", arg-start);
	  arg++;}
	data->tests[testind].value[valind].min = parse_number(&arg, arg-start);
	while (isspace(*arg)) arg++;  /* another place white space could be */
	if (*arg==':') {
	  arg++;
	  data->tests[testind].value[valind].max
	    = parse_number(&arg, arg-start);}
	else data->tests[testind].value[valind].max
	       = data->tests[testind].value[valind].min;
	valind++;
	if (valind > U32MAXSIZE)
	  exit_error(PARAMETER_PROBLEM,
		     "u32: at char %d too many ,'s", arg-start);
      }}}
}

/* Final check; must specify something. */
static void
final_check(unsigned int flags)
{
}

/* Prints out the matchinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_match *match,
      int numeric)
{
  printf("u32 ");
  print_u32((struct ipt_u32 *)match->data);
}

/* Saves the union ipt_matchinfo in parsable form to stdout. */
static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
  printf("--u32 ");
  print_u32((struct ipt_u32 *)match->data);
}

struct iptables_match u32
= { NULL,
    "u32",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_u32)),
    IPT_ALIGN(sizeof(struct ipt_u32)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void
_init(void)
{
	register_match(&u32);
}
