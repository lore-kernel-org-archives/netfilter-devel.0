From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 6/7] netfilter: ebt_limit: add CONFIG_COMPAT support
Date: Mon, 15 Feb 2010 22:05:38 +0100
Message-ID: <1266267939-7736-7-git-send-email-fw@strlen.de>
References: <1266267939-7736-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33316 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089Ab0BOVGz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:06:55 -0500
In-Reply-To: <1266267939-7736-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebt_limit structure is larger on 64 bit systems due
to "long" type used in the (kernel-only) data section.

Setting .compatsize is enough in this case, these values
have no meaning in userspace.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 net/bridge/netfilter/ebt_limit.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 9dd16e6..7a81827 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -84,6 +84,19 @@ static bool ebt_limit_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
+
+#ifdef CONFIG_COMPAT
+/*
+ * no conversion function needed --
+ * only avg/burst have meaningful values in userspace.
+ */
+struct ebt_compat_limit_info {
+	compat_uint_t avg, burst;
+	compat_ulong_t prev;
+	compat_uint_t credit, credit_cap, cost;
+};
+#endif
+
 static struct xt_match ebt_limit_mt_reg __read_mostly = {
 	.name		= "limit",
 	.revision	= 0,
@@ -91,6 +104,9 @@ static struct xt_match ebt_limit_mt_reg __read_mostly = {
 	.match		= ebt_limit_mt,
 	.checkentry	= ebt_limit_mt_check,
 	.matchsize	= sizeof(struct ebt_limit_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct ebt_compat_limit_info),
+#endif
 	.me		= THIS_MODULE,
 };
 
-- 
1.6.4.4

