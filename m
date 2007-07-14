From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 14/43] Use unified API in NOTRACK target
Date: Sun, 15 Jul 2007 02:24:27 +0900 (JST)
Message-ID: <200707141724.l6EHOReA023364@toshiba.co.jp>
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
 extensions/libipt_NOTRACK.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/extensions/libipt_NOTRACK.c b/extensions/libipt_NOTRACK.c
index 7aec15c..2276eb6 100644
--- a/extensions/libipt_NOTRACK.c
+++ b/extensions/libipt_NOTRACK.c
@@ -4,8 +4,8 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
 
 /* Function which prints out usage message. */
 static void
@@ -42,22 +42,21 @@ final_check(unsigned int flags)
 }
 
 static
-struct iptables_target notrack 
-= {	.next = NULL,
-	.name = "NOTRACK",
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
 };
 
 void _init(void)
 {
-	register_target(&notrack);
+	xtables_register_target(&notrack);
 }
-- 
1.5.2.2
