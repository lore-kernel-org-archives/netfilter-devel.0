Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA828C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 19:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBBF660C41
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 19:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhHITnW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhHITnW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 15:43:22 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A08EC0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 12:43:01 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id r19-20020a0568301353b029050aa53c3801so2315403otq.2
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 12:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=STOp8ir3j8FvvY85GjngV72ujYxIdR3Wphh0OIgu/lE=;
        b=woo8Wj3Qu3rsOn87kw8N885CGUtvo7zFSzbq9MbirnQiab40hqt9fAfeehf4ihMq/Y
         B8SNYi5ejL1EqT+3ZY75GyDSxeHlXpJ/DW4bC+ogXBfy0r9Tp1ukxZJVVzBXlquRsJZV
         UVB5743G6WK8a8W0U1r9oHApKC83Y11XB6XrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=STOp8ir3j8FvvY85GjngV72ujYxIdR3Wphh0OIgu/lE=;
        b=jPK8Ly44oUVfF5LYfRIWdD2g87hGcc8Icy6H9LD9W+SqCcqIlrqLvaDMrswvBGsu4m
         hXCp55vn2F62fhn0EXX0q+9uIy8nUpM26/QfiLzTmF5gpiuhn5e9frwOcJV+wleAXUQi
         KgjAo2G356IbZJ0nKhMTrgxFchsJymhpcQGdTkD6WSqP/9c1vQtCzWEA3oz8xw2MqswC
         6jdi+0n/JjWmzfnURo9HMv31J8+bAZ/XMPVpLToQMeaEKk44fq71VT7r8xWHFOFCrSbK
         5/XJojdH2E4qDxeLf61ZJm1tPs+ihGMsPFsi/J9poDmXJHsRugyZ1Rt+0Z5c5/5tVXKd
         ef/Q==
X-Gm-Message-State: AOAM533i/UXqix46R08UMO2DkIgilPMrgUjjAIYDFk0UlSN42bf0ziyd
        orodhNdYHlsoWAmcafgdMYY6pNnXDsYzFw==
X-Google-Smtp-Source: ABdhPJxAxk2cNM6P6bcaOMuXqAVjm2AXGw++mNqKQpcAnXrR0OA0O95q60E9YOU4MZvtj4hxhn0E/w==
X-Received: by 2002:a05:6830:2a0b:: with SMTP id y11mr18601449otu.275.1628538180304;
        Mon, 09 Aug 2021 12:43:00 -0700 (PDT)
Received: from localhost.localdomain (65-36-81-87.static.grandenetworks.net. [65.36.81.87])
        by smtp.gmail.com with ESMTPSA id x60sm2647735ota.72.2021.08.09.12.42.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 12:43:00 -0700 (PDT)
From:   Kyle Bowman <kbowman@cloudflare.com>
To:     netfilter-devel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH 1/3] extensions: libtxt_NFLOG: use nft built-in logging instead of xt_NFLOG
Date:   Mon,  9 Aug 2021 14:42:41 -0500
Message-Id: <20210809194243.53370-1-kbowman@cloudflare.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
index 02a1b4aa..2b78e278 100644
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
index 795dff86..aebbf674 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -39,6 +39,7 @@
 #include <linux/netfilter/nf_tables_compat.h>
 
 #include <linux/netfilter/xt_limit.h>
+#include <linux/netfilter/xt_NFLOG.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
@@ -1340,6 +1341,8 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 		       ret = add_verdict(r, NF_DROP);
 	       else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 		       ret = add_verdict(r, NFT_RETURN);
+	       else if (strcmp(cs->jumpto, "NFLOG") == 0)
+		       ret = add_log(r, cs);
 	       else
 		       ret = add_target(r, cs->target->t);
        } else if (strlen(cs->jumpto) > 0) {
@@ -1352,6 +1355,31 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
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
+	if (info->prefix[0] != '\0') {
+		nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, cs->target->udata);
+	}
+
+	nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
+	if (info->flags & XT_NFLOG_F_COPY_LEN)
+		nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
+				info->len);
+	if (info->threshold)
+		nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_QTHRESHOLD,
+				info->threshold);
+
+	nftnl_rule_add_expr(r, expr);
+	return 0;
+}
+
 static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
 {
 #ifdef NLDEBUG
diff --git a/iptables/nft.h b/iptables/nft.h
index 4ac7e009..28dc81b7 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -193,6 +193,7 @@ int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
 enum nft_rule_print {
-- 
2.20.1

