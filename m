From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH NFSIM]: Fix invalid IP checksums on 64bit
Date: Thu, 06 Jan 2005 15:29:59 +0100
Message-ID: <41DD4B67.6010205@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080904070103020601010108"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080904070103020601010108
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

IP checksums are calculated wrong on 64 bit because too large types are 
used.
This patch fixes them and a couple of unrelated snprintf-sizeof-warnings 
in the
same file. I still get invalid TCP checksums, but couldn't locate the 
problem yet.



--------------080904070103020601010108
Content-Type: text/x-patch;
 name="4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="4.diff"

Index: core/ipv4/ipv4.c
===================================================================
--- core/ipv4/ipv4.c	(revision 3578)
+++ core/ipv4/ipv4.c	(working copy)
@@ -565,7 +565,7 @@
 	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 }
 
-static inline unsigned short from32to16(unsigned long x)
+static inline unsigned short from32to16(unsigned int x)
 {
 	/* add up 16-bit and 16-bit for 16+c bit */
 	x = (x & 0xffff) + (x >> 16);
@@ -574,10 +574,10 @@
 	return x;
 }
 
-static unsigned long do_csum(const unsigned char * buff, int len)
+static unsigned int do_csum(const unsigned char * buff, int len)
 {
 	int odd, count;
-	unsigned long result = 0;
+	unsigned int result = 0;
 
 	if (len <= 0)
 		return 0;
@@ -819,7 +819,7 @@
 	switch (iph->protocol) {
 	case IPPROTO_ICMP:
 		icmph = (struct icmphdr *)(iph + 1);
-		ptr += sprintf(ptr, "%u %u ",
+		ptr += sprintf(ptr, "%Zu %u ",
 		       iplen - sizeof(struct icmphdr), iph->protocol);
 
 		if (len < sizeof(struct icmphdr)) {
@@ -855,7 +855,7 @@
 
 	case IPPROTO_UDP:
 		udph = (struct udphdr *)(iph + 1);
-		ptr += sprintf(ptr, "%u %u ",
+		ptr += sprintf(ptr, "%Zu %u ",
 		       iplen - sizeof(struct udphdr), iph->protocol);
 
 		if (len < sizeof(struct udphdr)) {
@@ -891,7 +891,7 @@
 		tcph = (struct tcphdr *)(iph + 1);
 		if (len < sizeof(struct tcphdr)) {
 			/* Assume no tcp options... */
-			ptr += sprintf(ptr, "%u %u ",
+			ptr += sprintf(ptr, "%Zu %u ",
 				       iplen - sizeof(*tcph), iph->protocol);
 
 			ptr += sprintf(ptr, "-TRUNCATED-");

--------------080904070103020601010108--
