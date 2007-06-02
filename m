From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 1/2] xt_u32 (kernel) - match arbitrary bits and bytes of a
 packet
Date: Sat, 2 Jun 2007 23:50:18 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706022346490.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Adds the U32 module that has been sitting in POM-NG for ages.
Additionally, more features:

along comes xt_u32, a revamped ipt_u32,

    *	added ipv6 support since that seemed dead simple, given u32's
	task. I would have even liked to unlock u32 for _all_ protocols,
	but .family = AF_UNSPEC does not do the right thing right now,  
	but that's not so much a showstopper.

	And arptables seems miles away from using iptables modules. So
	AF_INET and AF_INET6 it is for now.

    *	Reduced the buffer size to 17 KB. I think that is quite ok since
	I added an overflow check,  SHOULD THERE BE ANY device with an  
	MTU larger than our loopback masterpiece (16436 bytes).

	Are there such devices that support Megasuperjumboframes?
	The previous buffer size of 64 KB was probably the cutting edge,
	as a single IPv4 fragment/packet does not support more than that
	anyway.


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/xt_u32.h |   37 ++++++
 net/netfilter/Kconfig            |   13 ++
 net/netfilter/Makefile           |    1 
 net/netfilter/xt_u32.c           |  234 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 285 insertions(+)

Index: linux-2.6.22-rc3-git6/include/linux/netfilter/xt_u32.h
===================================================================
--- /dev/null
+++ linux-2.6.22-rc3-git6/include/linux/netfilter/xt_u32.h
@@ -0,0 +1,37 @@
+#ifndef _XT_U32_H
+#define _XT_U32_H 1
+
+enum xt_u32_ops {
+	XT_U32_AND,
+	XT_U32_LEFTSH,
+	XT_U32_RIGHTSH,
+	XT_U32_AT,
+};
+
+struct xt_u32_location_element {
+	uint32_t number;
+	uint8_t nextop;
+};
+
+struct xt_u32_value_element {
+	uint32_t min, max;
+};
+
+/*
+ * Any way to allow for an arbitrary number of elements?
+ * For now, I settle with a limit of 10 each.
+ */
+#define XT_U32_MAXSIZE 10
+
+struct xt_u32_test {
+	struct xt_u32_location_element location[XT_U32_MAXSIZE+1];
+	struct xt_u32_value_element value[XT_U32_MAXSIZE+1];
+	uint8_t nnums, nvalues;
+};
+
+struct xt_u32 {
+	struct xt_u32_test tests[XT_U32_MAXSIZE+1];
+	uint8_t ntests;
+};
+
+#endif /* _XT_U32_H */
Index: linux-2.6.22-rc3-git6/net/netfilter/Kconfig
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/Kconfig
+++ linux-2.6.22-rc3-git6/net/netfilter/Kconfig
@@ -644,6 +644,19 @@ config NETFILTER_XT_MATCH_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_U32
+	tristate '"u32" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  u32 allows you to extract quantities of up to 4 bytes from a packet,
+	  AND them with specified masks, shift them by specified amounts and
+	  test whether the results are in any of a set of specified ranges.
+	  The specification of what to extract is general enough to skip over
+	  headers with lengths stored in the packet, as in IP or TCP header
+	  lengths.
+
+	  Details and examples are in the kernel module source.
+
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
 	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
Index: linux-2.6.22-rc3-git6/net/netfilter/Makefile
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/Makefile
+++ linux-2.6.22-rc3-git6/net/netfilter/Makefile
@@ -73,4 +73,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_u32.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_u32.c
@@ -0,0 +1,234 @@
+/*
+ *	xt_u32 - kernel module to match u32 packet content
+ *
+ *	Original author: Don Cohen <don@isis.cs3-inc.com>
+ *	© Jan Engelhardt <jengelh@gmx.de>, 2007
+ */
+
+/*
+U32 tests whether quantities of up to 4 bytes extracted from a packet
+have specified values.  The specification of what to extract is general
+enough to find data at given offsets from tcp headers or payloads.
+
+ --u32 tests
+ The argument amounts to a program in a small language described below.
+ tests := location = value |  tests && location = value
+ value := range | value , range
+ range := number | number : number
+  a single number, n, is interpreted the same as n:n
+  n:m is interpreted as the range of numbers >=n and <=m
+ location := number | location operator number
+ operator := & | << | >> | @
+
+ The operators &, <<, >>, && mean the same as in c.  The = is really a set
+ membership operator and the value syntax describes a set.  The @ operator
+ is what allows moving to the next header and is described further below.
+
+ *** Until I can find out how to avoid it, there are some artificial limits
+ on the size of the tests:
+ - no more than 10 ='s (and 9 &&'s) in the u32 argument
+ - no more than 10 ranges (and 9 commas) per value
+ - no more than 10 numbers (and 9 operators) per location
+
+ To describe the meaning of location, imagine the following machine that
+ interprets it.  There are three registers:
+  A is of type char*, initially the address of the IP header
+  B and C are unsigned 32 bit integers, initially zero
+
+  The instructions are:
+   number	B = number;
+                C = (*(A+B)<<24)+(*(A+B+1)<<16)+(*(A+B+2)<<8)+*(A+B+3)
+   &number	C = C&number
+   <<number	C = C<<number
+   >>number	C = C>>number
+   @number	A = A+C; then do the instruction number
+  Any access of memory outside [skb->head,skb->end] causes the match to fail.
+  Otherwise the result of the computation is the final value of C.
+
+ Whitespace is allowed but not required in the tests.
+ However the characters that do occur there are likely to require
+ shell quoting, so it's a good idea to enclose the arguments in quotes.
+
+Example:
+ match IP packets with total length >= 256
+ The IP header contains a total length field in bytes 2-3.
+ --u32 "0&0xFFFF=0x100:0xFFFF"
+ read bytes 0-3
+ AND that with FFFF (giving bytes 2-3),
+ and test whether that's in the range [0x100:0xFFFF]
+
+Example: (more realistic, hence more complicated)
+ match icmp packets with icmp type 0
+ First test that it's an icmp packet, true iff byte 9 (protocol) = 1
+ --u32 "6&0xFF=1 && ...
+ read bytes 6-9, use & to throw away bytes 6-8 and compare the result to 1
+ Next test that it's not a fragment.
+  (If so it might be part of such a packet but we can't always tell.)
+  n.b. This test is generally needed if you want to match anything
+  beyond the IP header.
+ The last 6 bits of byte 6 and all of byte 7 are 0 iff this is a complete
+ packet (not a fragment).  Alternatively, you can allow first fragments
+ by only testing the last 5 bits of byte 6.
+ ... 4&0x3FFF=0 && ...
+ Last test: the first byte past the IP header (the type) is 0
+ This is where we have to use the @syntax.  The length of the IP header
+ (IHL) in 32 bit words is stored in the right half of byte 0 of the
+ IP header itself.
+ ... 0>>22&0x3C@0>>24=0"
+ The first 0 means read bytes 0-3,
+ >>22 means shift that 22 bits to the right.  Shifting 24 bits would give
+   the first byte, so only 22 bits is four times that plus a few more bits.
+ &3C then eliminates the two extra bits on the right and the first four
+ bits of the first byte.
+ For instance, if IHL=5 then the IP header is 20 (4 x 5) bytes long.
+ In this case bytes 0-1 are (in binary) xxxx0101 yyzzzzzz,
+ >>22 gives the 10 bit value xxxx0101yy and &3C gives 010100.
+ @ means to use this number as a new offset into the packet, and read
+ four bytes starting from there.  This is the first 4 bytes of the icmp
+ payload, of which byte 0 is the icmp type.  Therefore we simply shift
+ the value 24 to the right to throw out all but the first byte and compare
+ the result with 0.
+
+Example:
+ tcp payload bytes 8-12 is any of 1, 2, 5 or 8
+ First we test that the packet is a tcp packet (similar to icmp).
+ --u32 "6&0xFF=6 && ...
+ Next, test that it's not a fragment (same as above).
+ ... 0>>22&0x3C@12>>26&0x3C@8=1,2,5,8"
+ 0>>22&3C as above computes the number of bytes in the IP header.
+ @ makes this the new offset into the packet, which is the start of the
+ tcp header.  The length of the tcp header (again in 32 bit words) is
+ the left half of byte 12 of the tcp header.  The 12>>26&3C
+ computes this length in bytes (similar to the IP header before).
+ @ makes this the new offset, which is the start of the tcp payload.
+ Finally 8 reads bytes 8-12 of the payload and = checks whether the
+ result is any of 1, 2, 5 or 8
+*/
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_u32.h>
+
+/* This is slow, but it's simple. --RR */
+
+/*
+ * I think 17KB should suffice. The largest MTU I have
+ * seen so far is lo's, being 16436. -jengelh
+ */
+static char xt_u32_buffer[17*1024];
+static DEFINE_SPINLOCK(xt_u32_lock);
+
+static int xt_u32_match(const struct sk_buff *skb, const struct net_device *in,
+			const struct net_device *out,
+			const struct xt_match *match, const void *matchinfo,
+			int offset, unsigned int protoff, int *hotdrop)
+{
+	const struct xt_u32 *data = matchinfo;
+	const struct xt_u32_test *ct;
+	const unsigned char *base, *head;
+	int i, nnums, nvals, testind;
+	uint32_t pos, val, at;
+
+	spin_lock_bh(&xt_u32_lock);
+
+	head = skb_header_pointer(skb, 0, min(skb->len,
+	       sizeof(xt_u32_buffer)), xt_u32_buffer);
+	if (head == NULL) {
+		*hotdrop = 1;
+		return false;
+	}
+
+	base = head;
+	for (testind = 0; testind < data->ntests; ++testind) {
+		ct = &data->tests[testind];
+
+		at  = 0;
+		pos = ct->location[0].number;
+		if (at + pos + 3 > skb->len || at + pos < 0) {
+			spin_unlock_bh(&xt_u32_lock);
+			return false;
+		}
+
+		val = (base[pos] << 24) | (base[pos+1] << 16) |
+		      (base[pos+2] << 8) | base[pos+3];
+		nnums = ct->nnums;
+
+		for (i = 1; i < nnums; ++i) {
+			uint32_t number = ct->location[i].number;
+			switch (ct->location[i].nextop) {
+			case XT_U32_AND:
+				val &= number;
+				break;
+			case XT_U32_LEFTSH:
+				val <<= number;
+				break;
+			case XT_U32_RIGHTSH:
+				val >>= number;
+				break;
+			case XT_U32_AT:
+				at += val;
+				pos = number;
+				if (at + pos + 3 > skb->len || at + pos < 0) {
+					spin_unlock_bh(&xt_u32_lock);
+					return 0;
+				}
+
+				val = (base[at+pos] << 24) |
+				      (base[at+pos+1] << 16) |
+				      (base[at+pos+2] << 8) | base[at+pos+3];
+				break;
+			}
+		}
+
+		nvals = ct->nvalues;
+		for (i = 0; i < nvals; ++i)
+			if (ct->value[i].min <= val && val <= ct->value[i].max)
+				break;
+
+		if (i >= ct->nvalues) {
+			spin_unlock_bh(&xt_u32_lock);
+			return false;
+		}
+	}
+
+	spin_unlock_bh(&xt_u32_lock);
+	return 1;
+}
+
+static struct xt_match xt_u32_reg[] = {
+	{
+		.name       = "u32",
+		.family     = AF_INET,
+		.match      = xt_u32_match,
+		.matchsize  = sizeof(struct xt_u32),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "u32",
+		.family     = AF_INET6,
+		.match      = xt_u32_match,
+		.matchsize  = sizeof(struct xt_u32),
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init xt_u32_init(void)
+{
+	return xt_register_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
+}
+
+static void __exit xt_u32_exit(void)
+{
+	xt_unregister_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
+	return;
+}
+
+module_init(xt_u32_init);
+module_exit(xt_u32_exit);
+MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
+MODULE_DESCRIPTION("netfilter u32 match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_u32");
