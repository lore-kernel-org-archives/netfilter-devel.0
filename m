From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NFSIM]: Fix invalid IP checksums on 64bit
Date: Fri, 07 Jan 2005 02:25:57 +0100
Message-ID: <41DDE525.8020103@trash.net>
References: <41DD4B67.6010205@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060804090206080809000409"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <41DD4B67.6010205@trash.net>
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
--------------060804090206080809000409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> IP checksums are calculated wrong on 64 bit because too large types 
> are used.
> This patch fixes them and a couple of unrelated 
> snprintf-sizeof-warnings in the
> same file. I still get invalid TCP checksums, but couldn't locate the 
> problem yet.
>
I found the real bug, my previous fix just hid it. This patch fixes
all checksum problems, the calculated checksum are equal to the ones
of a 32-bit binary.


--------------060804090206080809000409
Content-Type: text/x-patch;
 name="6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="6.diff"

Index: core/ipv4/ipv4.c
===================================================================
--- core/ipv4/ipv4.c	(revision 3579)
+++ core/ipv4/ipv4.c	(working copy)
@@ -600,7 +600,7 @@
 		if (count) {
 		        unsigned long carry = 0;
 			do {
-				unsigned long w = *(unsigned long *) buff;
+				unsigned int w = *(unsigned int *) buff;
 				count--;
 				buff += 4;
 				result += carry;
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

--------------060804090206080809000409--
