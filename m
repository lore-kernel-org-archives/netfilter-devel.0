From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 08/13] Unifies libip[6]t_TRACE into libxt_TRACE
Date: Tue, 24 Jul 2007 15:58:46 +0900 (JST)
Message-ID: <200707240658.l6O6wl6G010721@toshiba.co.jp>
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


 extensions/Makefile        |    6 ++--
 extensions/libip6t_TRACE.c |   63 -----------------------------------
 extensions/libipt_TRACE.c  |   63 -----------------------------------
 extensions/libxt_TRACE.c   |   78 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+), 129 deletions(-)
 delete mode 100644 extensions/libip6t_TRACE.c
 delete mode 100644 extensions/libipt_TRACE.c
 create mode 100644 extensions/libxt_TRACE.c

diff --git a/extensions/Makefile b/extensions/Makefile
index 4bf40c7..c7155e5 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy HL LOG TRACE
-PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
+PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy HL LOG
+PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp state standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS TRACE
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libip6t_TRACE.c b/extensions/libip6t_TRACE.c
deleted file mode 100644
index 2fc786f..0000000
--- a/extensions/libip6t_TRACE.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/* Shared library add-on to ip6tables to add TRACE target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"TRACE target v%s takes no options\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
-{
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
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
-struct ip6tables_target trace 
-= {	.next = NULL,
-	.name = "TRACE",
-	.version = IPTABLES_VERSION,
-	.size = IP6T_ALIGN(0),
-	.userspacesize = IP6T_ALIGN(0),
-	.help = &help,
-	.init = &init,
-	.parse = &parse,
-	.final_check = &final_check,
-	.print = NULL, /* print */
-	.save = NULL, /* save */
-	.extra_opts = opts
-};
-
-void _init(void)
-{
-	register_target6(&trace);
-}
diff --git a/extensions/libipt_TRACE.c b/extensions/libipt_TRACE.c
deleted file mode 100644
index f2a5d32..0000000
--- a/extensions/libipt_TRACE.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/* Shared library add-on to iptables to add TRACE target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"TRACE target v%s takes no options\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
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
-struct iptables_target trace 
-= {	.next = NULL,
-	.name = "TRACE",
-	.version = IPTABLES_VERSION,
-	.size = IPT_ALIGN(0),
-	.userspacesize = IPT_ALIGN(0),
-	.help = &help,
-	.init = &init,
-	.parse = &parse,
-	.final_check = &final_check,
-	.print = NULL, /* print */
-	.save = NULL, /* save */
-	.extra_opts = opts
-};
-
-void _init(void)
-{
-	register_target(&trace);
-}
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
new file mode 100644
index 0000000..f97881b
--- /dev/null
+++ b/extensions/libxt_TRACE.c
@@ -0,0 +1,78 @@
+/* Shared library add-on to iptables to add TRACE target support. */
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
+"TRACE target v%s takes no options\n",
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
+static struct xtables_target trace = {
+	.family		= AF_INET,
+	.name		= "TRACE",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(0),
+	.userspacesize	= XT_ALIGN(0),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= NULL, /* print */
+	.save		= NULL, /* save */
+	.extra_opts	= opts,
+};
+
+static struct xtables_target trace6 = {
+	.family		= AF_INET6,
+	.name		= "TRACE",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(0),
+	.userspacesize	= XT_ALIGN(0),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= NULL, /* print */
+	.save		= NULL, /* save */
+	.extra_opts	= opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&trace);
+	xtables_register_target(&trace6);
+}
-- 
1.5.2.2
