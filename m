From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 13/13] Add IPv6 support to statistic match
Date: Tue, 24 Jul 2007 15:59:19 +0900 (JST)
Message-ID: <200707240659.l6O6xKm3011109@toshiba.co.jp>
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


 extensions/{.statistic-test => .statistic-testx}   |    0 
 .../{libipt_statistic.c => libxt_statistic.c}      |   24 ++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)
 rename extensions/{.statistic-test => .statistic-testx} (100%)
 rename extensions/{libipt_statistic.c => libxt_statistic.c} (89%)

diff --git a/extensions/.statistic-test b/extensions/.statistic-testx
similarity index 100%
rename from extensions/.statistic-test
rename to extensions/.statistic-testx
diff --git a/extensions/libipt_statistic.c b/extensions/libxt_statistic.c
similarity index 89%
rename from extensions/libipt_statistic.c
rename to extensions/libxt_statistic.c
index 52357ec..211321b 100644
--- a/extensions/libipt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -5,7 +5,7 @@
 #include <stddef.h>
 #include <getopt.h>
 
-#include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter/xt_statistic.h>
 
 static void
@@ -165,10 +165,25 @@ save(const void *ip, const struct xt_entry_match *match)
 	print_match(info, "--");
 }
 
-static struct iptables_match statistic = { 
+static struct xtables_match statistic = { 
+	.family		= AF_INET,
 	.name		= "statistic",
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct xt_statistic_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
+	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
+	.help		= help,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match statistic6 = { 
+	.family		= AF_INET6,
+	.name		= "statistic",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
 	.help		= help,
 	.parse		= parse,
@@ -180,5 +195,6 @@ static struct iptables_match statistic = {
 
 void _init(void)
 {
-	register_match(&statistic);
+	xtables_register_match(&statistic);
+	xtables_register_match(&statistic6);
 }
-- 
1.5.2.2
