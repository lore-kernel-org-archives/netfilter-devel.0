From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/47] netfilter: x_tables: fix build with CONFIG_COMPAT=n
Date: Fri, 30 Mar 2018 13:43:07 +0200
Message-ID: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

I placed the helpers within CONFIG_COMPAT section, move them
outside.

Fixes: 472ebdcd15ebdb ("netfilter: x_tables: check error target size too")
Fixes: 07a9da51b4b6ae ("netfilter: x_tables: check standard verdicts in core")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 62 ++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 7521e8a72c06..bac932f1c582 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -577,6 +577,37 @@ int xt_check_table_hooks(const struct xt_table_info *info, unsigned int valid_ho
 }
 EXPORT_SYMBOL(xt_check_table_hooks);
 
+static bool verdict_ok(int verdict)
+{
+	if (verdict > 0)
+		return true;
+
+	if (verdict < 0) {
+		int v = -verdict - 1;
+
+		if (verdict == XT_RETURN)
+			return true;
+
+		switch (v) {
+		case NF_ACCEPT: return true;
+		case NF_DROP: return true;
+		case NF_QUEUE: return true;
+		default:
+			break;
+		}
+
+		return false;
+	}
+
+	return false;
+}
+
+static bool error_tg_ok(unsigned int usersize, unsigned int kernsize,
+			const char *msg, unsigned int msglen)
+{
+	return usersize == kernsize && strnlen(msg, msglen) < msglen;
+}
+
 #ifdef CONFIG_COMPAT
 int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta)
 {
@@ -736,37 +767,6 @@ struct compat_xt_error_target {
 	char errorname[XT_FUNCTION_MAXNAMELEN];
 };
 
-static bool verdict_ok(int verdict)
-{
-	if (verdict > 0)
-		return true;
-
-	if (verdict < 0) {
-		int v = -verdict - 1;
-
-		if (verdict == XT_RETURN)
-			return true;
-
-		switch (v) {
-		case NF_ACCEPT: return true;
-		case NF_DROP: return true;
-		case NF_QUEUE: return true;
-		default:
-			break;
-		}
-
-		return false;
-	}
-
-	return false;
-}
-
-static bool error_tg_ok(unsigned int usersize, unsigned int kernsize,
-			const char *msg, unsigned int msglen)
-{
-	return usersize == kernsize && strnlen(msg, msglen) < msglen;
-}
-
 int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int target_offset,
 				  unsigned int next_offset)
-- 
2.11.0
