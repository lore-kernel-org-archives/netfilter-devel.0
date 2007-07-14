From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 23/43] Add support for string match to ip6tables.
Date: Sun, 15 Jul 2007 03:10:24 +0900 (JST)
Message-ID: <200707141810.l6EIAPCZ008175@toshiba.co.jp>
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
 extensions/libxt_string.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index e879dca..c58f481 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -349,7 +349,23 @@ static struct xtables_match string = {
 };
 
 
+static struct xtables_match string6 = {
+    .name		= "string",
+    .family			= AF_INET6,
+    .version		= IPTABLES_VERSION,
+    .size		= XT_ALIGN(sizeof(struct xt_string_info)),
+    .userspacesize	= offsetof(struct xt_string_info, config),
+    .help		= help,
+    .init		= init,
+    .parse		= parse,
+    .final_check	= final_check,
+    .print		= print,
+    .save		= save,
+    .extra_opts		= opts
+};
+
 void _init(void)
 {
 	xtables_register_match(&string);
+	xtables_register_match(&string6);
 }
-- 
1.5.2.2
