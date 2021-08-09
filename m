Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE7FC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 19:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED8FB61052
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 19:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhHITnX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhHITnW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 15:43:22 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B898C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 12:43:02 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id be20so6308986oib.8
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 12:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUSLvN3WOQnhf0N6IuDrTH8hp8qpgqCS3DeO0tKoMtk=;
        b=P3TtNaRVGdhN4DsMFJvmI222g1rIAOY6b9Iqs8n021ufiX/v2feyua7z443qtgMBJf
         +I5AhIQcydvVU/y7B3b5sMe/nV6RNUtEzi12j72uH8WSoqtyPoJhbMlYrTOGwY+wu7kd
         8qmLFVYp5yZW6KHqoiGlCHEzYetbLzy06MVIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUSLvN3WOQnhf0N6IuDrTH8hp8qpgqCS3DeO0tKoMtk=;
        b=eE903rkpBQOmwbMd/bRbd/vY5eCbUW/TyRteiDcQkYqIWzKFm6MwOiXWHdizekD0N1
         bLTwDdGSZm7iQ539VZicgAKADL7PXTO45rPfinNJr9qZBxrolxmGeOP6K6sFU/DlRWJp
         xwHFyURX/6MNCkcjAwmYH4sglXJm5ObQHGAruSO7dpqzHhTxi8GMYQsERMIhJ/y6gkEk
         ScHlX4s0E7KFQLgm6Vbth6xFEgZd+1GwhFdioExNbZqySleYP+TlyE2UY/9ep2TPp3S2
         PmCsv9KkTfotap7ZD/b43W1YXbV1eqsebnFfBgHYe9woV+7MyRNfEaGoRSKjtpotAvqM
         MSAg==
X-Gm-Message-State: AOAM533pntD+XXIBESIdfEsZJTHBqucme5UBAsXpeNd8znQqi+4sF1TW
        l7aUklmpD0exo1cMe0SpI6n4YHeHlIZU2w==
X-Google-Smtp-Source: ABdhPJz/RuUKFI0Tfn9cSNv+LXZKLb9Nyu0FzCiL+dCrjqBpLeaUKMz56bGgV7jn8Z6ZsACQrV+cyw==
X-Received: by 2002:a05:6808:199a:: with SMTP id bj26mr5964510oib.91.1628538181195;
        Mon, 09 Aug 2021 12:43:01 -0700 (PDT)
Received: from localhost.localdomain (65-36-81-87.static.grandenetworks.net. [65.36.81.87])
        by smtp.gmail.com with ESMTPSA id x60sm2647735ota.72.2021.08.09.12.43.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 12:43:00 -0700 (PDT)
From:   Kyle Bowman <kbowman@cloudflare.com>
To:     netfilter-devel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH 2/3] extensions: libxt_NFLOG: dont truncate log prefix on print/save
Date:   Mon,  9 Aug 2021 14:42:42 -0500
Message-Id: <20210809194243.53370-2-kbowman@cloudflare.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809194243.53370-1-kbowman@cloudflare.com>
References: <20210809194243.53370-1-kbowman@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When parsing the rule, use a struct with a layout compatible to that of
struct xt_nflog_info, but with a buffer large enough to contain the
whole 128-character nft prefix.

We always send the nflog-group to the kernel since, for nft, log and
nflog targets are handled by the same kernel module, and are
distinguished by whether they define an nflog-group. Therefore, we must
send the group even if it is zero, or the kernel will configure the
target as a log, not an nflog.

Changes to nft_is_expr_compatible were made since only targets which
have an `nflog-group` are compatible. Since nflog targets are
distinguished by having an nflog-group, we ignore targets without one.

We also set the copy-len flag if the snap-len is set since without this,
iptables will mistake `nflog-size` for `nflog-range`.

Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
Signed-off-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 58 +++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.c        |  4 +++
 2 files changed, 62 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 4253b081..c164d140 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -20,8 +20,10 @@
 
 #include <xtables.h>
 
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
+#include <linux/netfilter/xt_NFLOG.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
@@ -595,6 +597,60 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
+static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
+{
+	struct xtables_target *target;
+	struct xt_entry_target *t;
+	size_t target_size;
+	/*
+	* In order to handle the longer log-prefix supported by nft, instead of
+	* using struct xt_nflog_info, we use a struct with a compatible layout, but
+	* a larger buffer for the prefix.
+	*/
+	struct xt_nflog_info_nft {
+		__u32 len;
+		__u16 group;
+		__u16 threshold;
+		__u16 flags;
+		__u16 pad;
+		char  prefix[NF_LOG_PREFIXLEN];
+	} info = {
+		.group     = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP),
+		.threshold = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD),
+	};
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_SNAPLEN)) {
+		info.len = nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
+		info.flags = XT_NFLOG_F_COPY_LEN;
+	}
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_PREFIX)) {
+		snprintf(info.prefix, sizeof(info.prefix), "%s",
+				nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
+	}
+
+	target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
+	if (target == NULL)
+		return;
+
+	target_size = XT_ALIGN(sizeof(struct xt_entry_target)) +
+		XT_ALIGN(sizeof(struct xt_nflog_info_nft));
+
+	t = xtables_calloc(1, target_size);
+	t->u.target_size = target_size;
+	strcpy(t->u.user.name, target->name);
+	t->u.user.revision = target->revision;
+
+	target->t = t;
+
+	struct xt_nflog_info *info = xtables_malloc(sizeof(struct xt_nflog_info));
+	info->group = group;
+	info->len = snaplen;
+	info->threshold = qthreshold;
+
+	memcpy(&target->t->data, &info, sizeof(info));
+
+	ctx->h->ops->parse_target(target, ctx->cs);
+}
+
 static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 			     struct nftnl_expr *e)
 {
@@ -644,6 +700,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_limit(&ctx, expr);
 		else if (strcmp(name, "lookup") == 0)
 			nft_parse_lookup(&ctx, h, expr);
+		else if (strcmp(name, "log") == 0)
+			nft_parse_log(&ctx, expr);
 
 		expr = nftnl_expr_iter_next(iter);
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index aebbf674..e9875f28 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3515,6 +3515,10 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
 	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_FLAGS) == 0)
 		return 0;
 
+	if (!strcmp(name, "log") &&
+	    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
+		return 0;
+
 	return -1;
 }
 
-- 
2.20.1

