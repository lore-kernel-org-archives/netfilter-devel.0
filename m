From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 3/4] netfilter: xt_TRACE: add explicitly nf_logger_find_get call
Date: Wed,  8 Jun 2016 20:43:19 +0800
Message-ID: <1465389800-27842-4-git-send-email-zlpnobody@163.com>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:33566 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422659AbcFHMoM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:44:12 -0400
In-Reply-To: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Consider such situation, if nf_log_ipv4 kernel module is not installed,
and the user add a following iptables rule:
  # iptables -t raw -I PREROUTING -j TRACE

There will be no trace log generated until the user install nf_log_ipv4
module manully. So we should add request related nf_log module
appropriately here.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/xt_TRACE.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index df48967..858d189 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -4,12 +4,23 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_DESCRIPTION("Xtables: packet flow tracing");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TRACE");
 MODULE_ALIAS("ip6t_TRACE");
 
+static int trace_tg_check(const struct xt_tgchk_param *par)
+{
+	return nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+}
+
+static void trace_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_logger_put(par->family, NF_LOG_TYPE_LOG);
+}
+
 static unsigned int
 trace_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -18,12 +29,14 @@ trace_tg(struct sk_buff *skb, const struct xt_action_param *par)
 }
 
 static struct xt_target trace_tg_reg __read_mostly = {
-	.name       = "TRACE",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.table      = "raw",
-	.target     = trace_tg,
-	.me         = THIS_MODULE,
+	.name		= "TRACE",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.table		= "raw",
+	.target		= trace_tg,
+	.checkentry	= trace_tg_check,
+	.destroy	= trace_tg_destroy,
+	.me		= THIS_MODULE,
 };
 
 static int __init trace_tg_init(void)
-- 
2.5.5


