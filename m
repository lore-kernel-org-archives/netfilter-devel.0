Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A77C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD61C619F8
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355095AbhJARrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355123AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E493C06177E
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qvM2AYsBThgn0GREf1z5XcFC3BbKJgT6ntXsns8gC6c=; b=ZYBkm57MGS+AD3BmHCO5/2SljN
        /t6GE/J1wd+DadOrxgJAnrTVxOIiLuiaB4k6qb4huLexqN8AsR4Xr79bJgD+C2xn96cNLlNVH6i6I
        BiBjSbi1GBSbl+JZhGDZ132N4aLxeCqwukCBmx5PfcA25rAmcfIQQQlOWl9kQULvPDk+o48/fI7gL
        6ZSz1RZg4oi2iApsdQnyLziFSZYoxxjqH7vBDtqIsHJSISri2HIDXHoAAuqBZ+C7ARhdM1oqcA+PO
        MbpvTrASLBcIc7Le8/JH0fuySd3MbnNCdtgk1mRADPIGEkasHXUhhrkTI+zh8Sty403v7PrORJyiv
        3jcqjAXA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbF-002RLP-V8; Fri, 01 Oct 2021 18:45:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 2/8] extensions: libxt_NFLOG: use nft built-in logging instead of xt_NFLOG
Date:   Fri,  1 Oct 2021 18:41:36 +0100
Message-Id: <20211001174142.1267726-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kyle Bowman <kbowman@cloudflare.com>

Replaces the use of xt_NFLOG with the nft built-in log statement.

This additionally adds support for using longer log prefixes of 128
characters in size. Until now NFLOG has truncated the log-prefix to the
64-character limit supported by iptables-legacy. We now use the struct
xtables_target's udata member to store the longer 128-character prefix
supported by iptables-nft.

Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
Signed-off-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.c |  6 ++++++
 iptables/nft.c           | 28 ++++++++++++++++++++++++++++
 iptables/nft.h           |  1 +
 3 files changed, 35 insertions(+)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 02a1b4aa35a3..2b78e27808f8 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -5,6 +5,7 @@
 #include <getopt.h>
 #include <xtables.h>
 
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
 
@@ -53,12 +54,16 @@ static void NFLOG_init(struct xt_entry_target *t)
 
 static void NFLOG_parse(struct xt_option_call *cb)
 {
+	char *nf_log_prefix = cb->udata;
+
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_PREFIX:
 		if (strchr(cb->arg, '\n') != NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
+
+		snprintf(nf_log_prefix, NF_LOG_PREFIXLEN, "%s", cb->arg);
 		break;
 	}
 }
@@ -149,6 +154,7 @@ static struct xtables_target nflog_target = {
 	.save		= NFLOG_save,
 	.x6_options	= NFLOG_opts,
 	.xlate		= NFLOG_xlate,
+	.udata_size	= NF_LOG_PREFIXLEN
 };
 
 void _init(void)
diff --git a/iptables/nft.c b/iptables/nft.c
index 5613bc968046..53506c9475c0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -39,6 +39,7 @@
 #include <linux/netfilter/nf_tables_compat.h>
 
 #include <linux/netfilter/xt_limit.h>
+#include <linux/netfilter/xt_NFLOG.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
@@ -1331,6 +1332,8 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 			ret = add_verdict(r, NF_DROP);
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			ret = add_verdict(r, NFT_RETURN);
+		else if (strcmp(cs->jumpto, "NFLOG") == 0)
+			ret = add_log(r, cs);
 		else
 			ret = add_target(r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
@@ -1343,6 +1346,31 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 	return ret;
 }
 
+int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
+{
+	struct nftnl_expr *expr;
+	struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;
+
+	expr = nftnl_expr_alloc("log");
+	if (!expr)
+		return -ENOMEM;
+
+	if (info->prefix[0] != '\0')
+		nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX,
+				   cs->target->udata);
+
+	nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
+	if (info->flags & XT_NFLOG_F_COPY_LEN)
+		nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
+				   info->len);
+	if (info->threshold)
+		nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_QTHRESHOLD,
+				   info->threshold);
+
+	nftnl_rule_add_expr(r, expr);
+	return 0;
+}
+
 static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
 {
 #ifdef NLDEBUG
diff --git a/iptables/nft.h b/iptables/nft.h
index ef79b018f783..440b23af68df 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -194,6 +194,7 @@ int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
 enum nft_rule_print {
-- 
2.33.0

