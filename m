From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] icmpv6 match --icmpv6-type confusion
Date: Fri, 30 Jun 2006 13:18:58 -0700
Message-ID: <20060630201858.GA5845@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Adding a rule such as this:

-A INPUT -p ipv6-icmp -m icmpv6

ends up creating a rule with "ipv6-icmp type 0", instead of "ipv6-icmp type any"
which is what was expected.  Granted, the match is redundant anyway, but it
should not assume a specific type when one is not specified.

Below patches (to both kernel and userspace) fix this, and resolve bug #461.
In keeping with icmpv4, 0xFF is used to designate "any". And since I was
looking at it, I fixed up a 255 -> any in icmpv4 printing.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-icmpv6-kernel

--- linux-std/net/ipv6/netfilter/ip6_tables.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-po/net/ipv6/netfilter/ip6_tables.c	2006-06-29 23:05:09.000000000 -0400
@@ -1308,7 +1308,7 @@
 		     u_int8_t type, u_int8_t code,
 		     int invert)
 {
-	return (type == test_type && code >= min_code && code <= max_code)
+	return ((test_type == 0xFF) || (type == test_type && code >= min_code && code <= max_code))
 		^ invert;
 }
 

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-icmpv6-user

diff -ru ipt-orig/extensions/libip6t_icmp6.c ipt-new/extensions/libip6t_icmp6.c
--- ipt-orig/extensions/libip6t_icmp6.c	2006-04-14 20:05:41.000000000 -0700
+++ ipt-new/extensions/libip6t_icmp6.c	2006-06-29 18:07:19.000000000 -0700
@@ -149,6 +149,7 @@
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
 
+	icmpv6info->type = 0xFF;
 	icmpv6info->code[1] = 0xFF;
 }
 
@@ -206,7 +207,12 @@
 	if (invert)
 		printf("!");
 
-	printf("type %u", type);
+	/* special hack for 'any' case */
+	if (type == 0xFF)
+		printf("type any ");
+	else
+		printf("type %u", type);
+
 	if (code_min == 0 && code_max == 0xFF)
 		printf(" ");
 	else if (code_min == code_max)
@@ -241,7 +247,12 @@
 	if (icmpv6->invflags & IP6T_ICMP_INV)
 		printf("! ");
 
-	printf("--icmpv6-type %u", icmpv6->type);
+	/* special hack for 'any' case */
+	if (icmpv6->type == 0xFF)
+		printf("--icmpv6-type any ");
+	else
+		printf("--icmpv6-type %u", icmpv6->type);
+
 	if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
 		printf("/%u", icmpv6->code[0]);
 	printf(" ");
diff -ru ipt-orig/extensions/libipt_icmp.c ipt-new/extensions/libipt_icmp.c
--- ipt-orig/extensions/libipt_icmp.c	2005-02-14 05:13:04.000000000 -0800
+++ ipt-new/extensions/libipt_icmp.c	2006-06-29 17:57:47.000000000 -0700
@@ -231,7 +231,12 @@
 	if (invert)
 		printf("!");
 
-	printf("type %u", type);
+	/* special hack for 'any' case */
+	if (type == 0xFF)
+		printf("type any ");
+	else
+		printf("type %u", type);
+
 	if (code_min == 0 && code_max == 0xFF)
 		printf(" ");
 	else if (code_min == code_max)

--KsGdsel6WgEHnImy--
