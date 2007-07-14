From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 29/43] Unifies libip[6]t_standard.c into libxt_standard.c
Date: Sun, 15 Jul 2007 03:11:34 +0900 (JST)
Message-ID: <200707141811.l6EIBY4x002858@toshiba.co.jp>
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
 extensions/Makefile           |    6 +-
 extensions/libip6t_standard.c |   66 ------------------------------
 extensions/libipt_standard.c  |   69 --------------------------------
 extensions/libxt_standard.c   |   88 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 138 deletions(-)
 delete mode 100644 extensions/libip6t_standard.c
 delete mode 100644 extensions/libipt_standard.c
 create mode 100644 extensions/libxt_standard.c

diff --git a/extensions/Makefile b/extensions/Makefile
index d57fabe..6522b80 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport tcp tcpmss udp NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=mark multiport standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_standard.c b/extensions/libip6t_standard.c
deleted file mode 100644
index 0d9f490..0000000
--- a/extensions/libip6t_standard.c
+++ /dev/null
@@ -1,66 +0,0 @@
-/* Shared library add-on to iptables for standard target support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <limits.h>
-#include <getopt.h>
-#include <ip6tables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"Standard v%s options:\n"
-"(If target is DROP, ACCEPT, RETURN or nothing)\n", IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{0}
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
-/* Final check; don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
-/* Saves the targinfo in parsable form to stdout. */
-static void
-save(const void *ip6, const struct xt_entry_target *target)
-{
-}
-
-static struct ip6tables_target standard = {
-	.name		= "standard",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(int)),
-	.userspacesize	= IP6T_ALIGN(sizeof(int)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_target6(&standard);
-}
diff --git a/extensions/libipt_standard.c b/extensions/libipt_standard.c
deleted file mode 100644
index 2b96697..0000000
--- a/extensions/libipt_standard.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/* Shared library add-on to iptables for standard target support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <limits.h>
-#include <getopt.h>
-#include <iptables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"Standard v%s options:\n"
-"(If target is DROP, ACCEPT, RETURN or nothing)\n", IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{0}
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
-/* Final check; don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
-/* Saves the targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-}
-
-static
-struct iptables_target standard = { 
-	.next		= NULL,
-	.name		= "standard",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(int)),
-	.userspacesize	= IPT_ALIGN(sizeof(int)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= NULL,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_target(&standard);
-}
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
new file mode 100644
index 0000000..02128a7
--- /dev/null
+++ b/extensions/libxt_standard.c
@@ -0,0 +1,88 @@
+/* Shared library add-on to iptables for standard target support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <getopt.h>
+#include <xtables.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"Standard v%s options:\n"
+"(If target is DROP, ACCEPT, RETURN or nothing)\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{0}
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
+/* Final check; don't care. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Saves the targinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_target *target)
+{
+}
+
+static
+struct xtables_target standard = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "standard",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(int)),
+	.userspacesize	= XT_ALIGN(sizeof(int)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= NULL,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static
+struct xtables_target standard6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "standard",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(int)),
+	.userspacesize	= XT_ALIGN(sizeof(int)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= NULL,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_target(&standard);
+	xtables_register_target(&standard6);
+}
-- 
1.5.2.2
