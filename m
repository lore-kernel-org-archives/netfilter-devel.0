From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 10/13] Add IPv6 support to DSCP target
Date: Tue, 24 Jul 2007 15:58:57 +0900 (JST)
Message-ID: <200707240658.l6O6wwAc020133@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


 extensions/Makefile                                |    4 +-
 extensions/{libipt_DSCP.c => libxt_DSCP.c}         |   52 +++++++++++++------
 .../ipt_DSCP.h => netfilter/xt_DSCP.h}             |   16 +++---
 3 files changed, 45 insertions(+), 27 deletions(-)
 rename extensions/{libipt_DSCP.c => libxt_DSCP.c} (73%)
 rename include/linux/{netfilter_ipv4/ipt_DSCP.h => netfilter/xt_DSCP.h} (53%)

diff --git a/extensions/Makefile b/extensions/Makefile
index f404bba..39c8568 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
+PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy HL LOG
-PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CLASSIFY CONNMARK MARK NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CLASSIFY CONNMARK DSCP MARK NFQUEUE NOTRACK TCPMSS TRACE
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libipt_DSCP.c b/extensions/libxt_DSCP.c
similarity index 73%
rename from extensions/libipt_DSCP.c
rename to extensions/libxt_DSCP.c
index 8845af2..c54b076 100644
--- a/extensions/libipt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -14,9 +14,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_DSCP.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_DSCP.h>
 
 /* This is evil, but it's my code - HW*/
 #include "libipt_dscp_helper.c"
@@ -49,7 +49,7 @@ static struct option opts[] = {
 };
 
 static void
-parse_dscp(const char *s, struct ipt_DSCP_info *dinfo)
+parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
 {
 	unsigned int dscp;
        
@@ -57,7 +57,7 @@ parse_dscp(const char *s, struct ipt_DSCP_info *dinfo)
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
-	if (dscp > IPT_DSCP_MAX)
+	if (dscp > XT_DSCP_MAX)
 		exit_error(PARAMETER_PROBLEM,
 			   "DSCP `%d` out of range\n", dscp);
 
@@ -67,7 +67,7 @@ parse_dscp(const char *s, struct ipt_DSCP_info *dinfo)
 
 
 static void
-parse_class(const char *s, struct ipt_DSCP_info *dinfo)
+parse_class(const char *s, struct xt_DSCP_info *dinfo)
 {
 	unsigned int dscp = class_to_dscp(s);
 
@@ -81,8 +81,8 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_target **target)
 {
-	struct ipt_DSCP_info *dinfo
-		= (struct ipt_DSCP_info *)(*target)->data;
+	struct xt_DSCP_info *dinfo
+		= (struct xt_DSCP_info *)(*target)->data;
 
 	switch (c) {
 	case 'F':
@@ -127,8 +127,8 @@ print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
-	const struct ipt_DSCP_info *dinfo =
-		(const struct ipt_DSCP_info *)target->data;
+	const struct xt_DSCP_info *dinfo =
+		(const struct xt_DSCP_info *)target->data;
 	printf("DSCP set ");
 	print_dscp(dinfo->dscp, numeric);
 }
@@ -137,28 +137,46 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_DSCP_info *dinfo =
-		(const struct ipt_DSCP_info *)target->data;
+	const struct xt_DSCP_info *dinfo =
+		(const struct xt_DSCP_info *)target->data;
 
 	printf("--set-dscp 0x%02x ", dinfo->dscp);
 }
 
-static struct iptables_target dscp = { 
+static struct xtables_target dscp = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "DSCP",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_DSCP_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_DSCP_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
-	.extra_opts	= opts
+	.extra_opts	= opts,
+};
+
+static struct xtables_target dscp6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "DSCP",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
 };
 
 void _init(void)
 {
-	register_target(&dscp);
+	xtables_register_target(&dscp);
+	xtables_register_target(&dscp6);
 }
diff --git a/include/linux/netfilter_ipv4/ipt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
similarity index 53%
rename from include/linux/netfilter_ipv4/ipt_DSCP.h
rename to include/linux/netfilter/xt_DSCP.h
index 678edee..3c7c963 100644
--- a/include/linux/netfilter_ipv4/ipt_DSCP.h
+++ b/include/linux/netfilter/xt_DSCP.h
@@ -1,20 +1,20 @@
-/* iptables module for setting the IPv4 DSCP field
+/* x_tables module for setting the IPv4/IPv6 DSCP field
  *
  * (C) 2002 Harald Welte <laforge@gnumonks.org>
  * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
  * This software is distributed under GNU GPL v2, 1991
- * 
+ *
  * See RFC2474 for a description of the DSCP field within the IP Header.
  *
- * Id: ipt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
+ * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
 */
-#ifndef _IPT_DSCP_TARGET_H
-#define _IPT_DSCP_TARGET_H
-#include <linux/netfilter_ipv4/ipt_dscp.h>
+#ifndef _XT_DSCP_TARGET_H
+#define _XT_DSCP_TARGET_H
+#include <linux/netfilter/xt_dscp.h>
 
 /* target info */
-struct ipt_DSCP_info {
+struct xt_DSCP_info {
 	u_int8_t dscp;
 };
 
-#endif /* _IPT_DSCP_TARGET_H */
+#endif /* _XT_DSCP_TARGET_H */
-- 
1.5.2.2
