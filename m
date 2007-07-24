From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 09/13] Add IPv6 support to CLASSIFY target
Date: Tue, 24 Jul 2007 15:58:52 +0900 (JST)
Message-ID: <200707240658.l6O6wreU010781@toshiba.co.jp>
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
 extensions/{libipt_CLASSIFY.c => libxt_CLASSIFY.c} |   46 ++++++++++++++------
 include/linux/netfilter/xt_CLASSIFY.h              |    8 +++
 include/linux/netfilter_ipv4/ipt_CLASSIFY.h        |    8 ---
 4 files changed, 42 insertions(+), 24 deletions(-)
 rename extensions/{libipt_CLASSIFY.c => libxt_CLASSIFY.c} (67%)
 create mode 100644 include/linux/netfilter/xt_CLASSIFY.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_CLASSIFY.h

diff --git a/extensions/Makefile b/extensions/Makefile
index c7155e5..f404bba 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
+PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy HL LOG
-PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CLASSIFY CONNMARK MARK NFQUEUE NOTRACK TCPMSS TRACE
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libipt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
similarity index 67%
rename from extensions/libipt_CLASSIFY.c
rename to extensions/libxt_CLASSIFY.c
index 16e47ac..efd6163 100644
--- a/extensions/libipt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -4,9 +4,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_CLASSIFY.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_CLASSIFY.h>
 #include <linux/types.h>
 #include <linux/pkt_sched.h>
 
@@ -50,8 +50,8 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_target **target)
 {
-	struct ipt_classify_target_info *clinfo
-		= (struct ipt_classify_target_info *)(*target)->data;
+	struct xt_classify_target_info *clinfo
+		= (struct xt_classify_target_info *)(*target)->data;
 
 	switch (c) {
 	case '1':
@@ -91,8 +91,8 @@ print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
-	const struct ipt_classify_target_info *clinfo =
-		(const struct ipt_classify_target_info *)target->data;
+	const struct xt_classify_target_info *clinfo =
+		(const struct xt_classify_target_info *)target->data;
 	printf("CLASSIFY set ");
 	print_class(clinfo->priority, numeric);
 }
@@ -101,29 +101,47 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_classify_target_info *clinfo =
-		(const struct ipt_classify_target_info *)target->data;
+	const struct xt_classify_target_info *clinfo =
+		(const struct xt_classify_target_info *)target->data;
 
 	printf("--set-class %.4x:%.4x ",
 	       TC_H_MAJ(clinfo->priority)>>16, TC_H_MIN(clinfo->priority));
 }
 
-static struct iptables_target classify = { 
+static struct xtables_target classify = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "CLASSIFY",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_classify_target_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_classify_target_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
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
+static struct xtables_target classify6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "CLASSIFY",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
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
-	register_target(&classify);
+	xtables_register_target(&classify);
+	xtables_register_target(&classify6);
 }
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_CLASSIFY.h
new file mode 100644
index 0000000..5811135
--- /dev/null
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -0,0 +1,8 @@
+#ifndef _XT_CLASSIFY_H
+#define _XT_CLASSIFY_H
+
+struct xt_classify_target_info {
+	u_int32_t priority;
+};
+
+#endif /*_XT_CLASSIFY_H */
diff --git a/include/linux/netfilter_ipv4/ipt_CLASSIFY.h b/include/linux/netfilter_ipv4/ipt_CLASSIFY.h
deleted file mode 100644
index 7596e3d..0000000
--- a/include/linux/netfilter_ipv4/ipt_CLASSIFY.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _IPT_CLASSIFY_H
-#define _IPT_CLASSIFY_H
-
-struct ipt_classify_target_info {
-	u_int32_t priority;
-};
-
-#endif /*_IPT_CLASSIFY_H */
-- 
1.5.2.2
