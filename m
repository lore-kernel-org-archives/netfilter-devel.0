From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 12/13] Add IPv6 support to helper match
Date: Tue, 24 Jul 2007 15:59:11 +0900 (JST)
Message-ID: <200707240659.l6O6xCtf011009@toshiba.co.jp>
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


 extensions/Makefile                            |    4 +-
 extensions/{libipt_helper.c => libxt_helper.c} |   34 +++++++++++++++++------
 include/linux/netfilter/xt_helper.h            |    8 +++++
 include/linux/netfilter_ipv4/ipt_helper.h      |    8 -----
 4 files changed, 35 insertions(+), 19 deletions(-)
 rename extensions/{libipt_helper.c => libxt_helper.c} (70%)
 create mode 100644 include/linux/netfilter/xt_helper.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_helper.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 39c8568..2072f91 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
+PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn icmp iprange owner policy realm tos ttl unclean DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy HL LOG
-PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CLASSIFY CONNMARK DSCP MARK NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connmark comment dscp esp hashlimit helper length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CLASSIFY CONNMARK DSCP MARK NFQUEUE NOTRACK TCPMSS TRACE
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libipt_helper.c b/extensions/libxt_helper.c
similarity index 70%
rename from extensions/libipt_helper.c
rename to extensions/libxt_helper.c
index 3c1c739..fb22970 100644
--- a/extensions/libipt_helper.c
+++ b/extensions/libxt_helper.c
@@ -5,8 +5,8 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_helper.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_helper.h>
 
 /* Function which prints out usage message. */
 static void
@@ -32,7 +32,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-	struct ipt_helper_info *info = (struct ipt_helper_info *)(*match)->data;
+	struct xt_helper_info *info = (struct xt_helper_info *)(*match)->data;
 
 	switch (c) {
 	case '1':
@@ -68,7 +68,7 @@ print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	struct ipt_helper_info *info = (struct ipt_helper_info *)match->data;
+	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
 
 	printf("helper match %s\"%s\" ", info->invert ? "! " : "", info->name);
 }
@@ -77,25 +77,41 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_helper_info *info = (struct ipt_helper_info *)match->data;
+	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
 
 	printf("%s--helper \"%s\" ",info->invert ? "! " : "", info->name);
 }
 
-static struct iptables_match helper = { 
+static struct xtables_match helper = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "helper",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_helper_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
 	.help		= &help,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
-	.extra_opts	= opts
+	.extra_opts	= opts,
+};
+
+static struct xtables_match helper6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "helper",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
 };
 
 void _init(void)
 {
-	register_match(&helper);
+	xtables_register_match(&helper);
+	xtables_register_match(&helper6);
 }
diff --git a/include/linux/netfilter/xt_helper.h b/include/linux/netfilter/xt_helper.h
new file mode 100644
index 0000000..6b42763
--- /dev/null
+++ b/include/linux/netfilter/xt_helper.h
@@ -0,0 +1,8 @@
+#ifndef _XT_HELPER_H
+#define _XT_HELPER_H
+
+struct xt_helper_info {
+	int invert;
+	char name[30];
+};
+#endif /* _XT_HELPER_H */
diff --git a/include/linux/netfilter_ipv4/ipt_helper.h b/include/linux/netfilter_ipv4/ipt_helper.h
deleted file mode 100644
index 6f12ecb..0000000
--- a/include/linux/netfilter_ipv4/ipt_helper.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _IPT_HELPER_H
-#define _IPT_HELPER_H
-
-struct ipt_helper_info {
-	int invert;
-	char name[30];
-};
-#endif /* _IPT_HELPER_H */
-- 
1.5.2.2
