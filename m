From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 15/43] Renames libipt_NOTRACK.c to libxt_NOTRACK.c
Date: Sun, 15 Jul 2007 02:24:36 +0900 (JST)
Message-ID: <200707141724.l6EHOa6p024145@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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


---
 extensions/Makefile         |    3 +-
 extensions/libipt_NOTRACK.c |   62 -------------------------------------------
 extensions/libxt_NOTRACK.c  |   62 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 63 deletions(-)
 delete mode 100644 extensions/libipt_NOTRACK.c
 create mode 100644 extensions/libxt_NOTRACK.c

diff --git a/extensions/Makefile b/extensions/Makefile
index 90acd5f..85d0bf2 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,8 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
 PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libipt_NOTRACK.c b/extensions/libipt_NOTRACK.c
deleted file mode 100644
index 2276eb6..0000000
--- a/extensions/libipt_NOTRACK.c
+++ /dev/null
@@ -1,62 +0,0 @@
-/* Shared library add-on to iptables to add NOTRACK target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <xtables.h>
-#include <linux/netfilter/x_tables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"NOTRACK target v%s takes no options\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
-{
-	return 0;
-}
-
-static void
-final_check(unsigned int flags)
-{
-}
-
-static
-struct xtables_target notrack =
-{
-	.family		= AF_INET,
-	.name		= "NOTRACK",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(0),
-	.userspacesize	= XT_ALIGN(0),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	xtables_register_target(&notrack);
-}
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
new file mode 100644
index 0000000..2276eb6
--- /dev/null
+++ b/extensions/libxt_NOTRACK.c
@@ -0,0 +1,62 @@
+/* Shared library add-on to iptables to add NOTRACK target support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"NOTRACK target v%s takes no options\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct xt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      struct xt_entry_target **target)
+{
+	return 0;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+static
+struct xtables_target notrack =
+{
+	.family		= AF_INET,
+	.name		= "NOTRACK",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(0),
+	.userspacesize	= XT_ALIGN(0),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.extra_opts	= opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&notrack);
+}
-- 
1.5.2.2
