Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815BAC432C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 11:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5214320872
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 11:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oBXXckMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409610AbfIXLYJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 07:24:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37661 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409609AbfIXLYJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 07:24:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so1514174wro.4
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2019 04:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=rgyrwQJvnY7ABWFFFsZzEoxMkZk9QHBeE8pzrK7dcy4=;
        b=oBXXckMVC0EbONhhN8z7tzkz92S55YBWmwS650tmTuUb1j2op5I3TSCF0VxSW6YJju
         uEDh1rIx+JJtNu8C6WNQmHRaOeRdWOTME//H3UW0+VPh4q4jplMBS+FVEMKw4oxQi5IU
         DIR+lwVJ95vaYvpIGq5gJg3GNE04/GIPFnlxVfNPlL3JFD40hxd9xNNadCSz4L26Om5k
         4QIdLaFBmdqnPxVuB0XP+OEcZgxsOF9yrV3n2fIZ8naoOVZUMYMFvvnnvE/W7H6Oz86A
         boKqXgmt0KR7ElVDL1gKKmZnIZDxbdn+cNB1ZaGsTe3QQXFJlGvf8neg2thtwU1cZhgh
         lo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=rgyrwQJvnY7ABWFFFsZzEoxMkZk9QHBeE8pzrK7dcy4=;
        b=G++LiGw37d6F9ZdxfsmqEUmp/e1c+NNeqPJSSf8NCnK/QYsJPMoxJ/uAldEf12u7jc
         5XT8YgFCiESjUzl/Jkk+wBOWTooYO93hWiZJJiVTvylOkbRQfv1J4cL+abo5NvL8VKQR
         Vr4OH9/4PxdyiPcPeLElsp2kzpcgBdQ+J4vZc/xH+wlhtdrHGsHGBJn8Z+apv/jZbLcd
         o/witNC1erD5y2skmLrhTpO3Dd1thItIdYBZpgCYLSpaKIVtpB8cPOFOIevhEclWTC+1
         5xeGaLM+BLFiBON/emM5zcioSGo94RxPDJhB1ktGKwhRf/BEqTCqSDOXTFFuVAA2Zph0
         WLlQ==
X-Gm-Message-State: APjAAAVficHRIjpMN46yz7wWkespSNWLuvVOHCrCineE542xVAQcmmKr
        9Cd2RP0avsawFINy0dDzVke1rty1
X-Google-Smtp-Source: APXvYqwKfkq9PLrD0VsozHWzl3Vdd0vaGwU0BGrcDbIHmaqbELzaTXm1lO92sdIxNA7c5/Kn/Sc/kw==
X-Received: by 2002:a05:6000:82:: with SMTP id m2mr1955685wrx.241.1569324246828;
        Tue, 24 Sep 2019 04:24:06 -0700 (PDT)
Received: from nevthink ([185.79.20.147])
        by smtp.gmail.com with ESMTPSA id y3sm2668118wmg.2.2019.09.24.04.24.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Sep 2019 04:24:06 -0700 (PDT)
Date:   Tue, 24 Sep 2019 13:24:03 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nf] netfilter: nf_tables: bogus EBUSY when deleting flowtable
 after flush
Message-ID: <20190924112403.wljydfejrs7ktv6v@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The deletion os a flowtable after a flush in the same transaction
results in EBUSY. This patch adds an activation and deactivation of
flowtables in order to update the _use_ counter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 18 ++++++++++++++++++
 net/netfilter/nft_flow_offload.c  | 19 +++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2655e03dbe1b..53c1f43a3591 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1181,6 +1181,10 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 					   const struct nlattr *nla,
 					   u8 genmask);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase);
+
 void nft_register_flowtable_type(struct nf_flowtable_type *type);
 void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e4a68dc42694..5b0b95cfe6eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5595,6 +5595,24 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nft_flowtable_lookup);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+		flowtable->use--;
+		return;
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		flowtable->use--;
+		return;
+	default:
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_deactivate_flowtable);
+
 static struct nft_flowtable *
 nft_flowtable_lookup_byhandle(const struct nft_table *table,
 			      const struct nlattr *nla, u8 genmask)
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 22cf236eb5d5..f29bbc74c4bf 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -177,6 +177,23 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
 
+static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr,
+					enum nft_trans_phase phase)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+
+	nf_tables_deactivate_flowtable(ctx, priv->flowtable, phase);
+}
+
+static void nft_flow_offload_activate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+
+	priv->flowtable->use++;
+}
+
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
@@ -205,6 +222,8 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
 	.eval		= nft_flow_offload_eval,
 	.init		= nft_flow_offload_init,
+	.activate	= nft_flow_offload_activate,
+	.deactivate	= nft_flow_offload_deactivate,
 	.destroy	= nft_flow_offload_destroy,
 	.validate	= nft_flow_offload_validate,
 	.dump		= nft_flow_offload_dump,
-- 
2.11.0

