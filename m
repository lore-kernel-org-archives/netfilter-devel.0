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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A102C432C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 12:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE752214DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 12:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ex9lJ9Qx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504951AbfIXMmv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 08:42:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54227 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504949AbfIXMmv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 08:42:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so2126993wmd.3
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2019 05:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=T+ftxq8ndwJez69NIKUo0sZGI9Yu86V5tHn7T1Io/E0=;
        b=ex9lJ9Qxfe7HdrHVZC8glzQsVrTcRoXLYQnu3LsGT71yL1HAqvIPElB0t8IsQlbzvL
         8RR9+z7UjWm/nA9UsTRoBEyLkaT2Bqv2RrR8O3HoYt2XNYoETZ4989E5EBCOIq8OAfTi
         R5F7erPKQXuB40crL2sRP+HGrz5c1+SsUadH6D3uQtOg50PbS+7MKf0K6nypztGbY50X
         NU46RKmdcEdpMEVUI3Rveqg/cZE0zCKFExhhglNSWe/n3XrBQvD/Cii3NZueelwg1kNE
         LiTJXIgsAgMJlpNDprG0ziR7h/l2qoGO8Yb4PycxowZL036hALWxMMwiI3h2g+06y+vh
         0YGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=T+ftxq8ndwJez69NIKUo0sZGI9Yu86V5tHn7T1Io/E0=;
        b=WY2ntgDoh9Kb2ETcnS7LkclDaYsMwxYqJIRNYuf06pSb6oX+7q5Eo7EjZYIqny+Ler
         OuBqfmEBTDRkpivNka/GVfXTKw548zOkiy4b/KfnKO3LBC7o9QQCAdG9QMkQVv1G3H9O
         I7lwws/qp0Z0dVnJp0lR1k9tX3h3QULYlJHrFNZ0aDVGLRZ5i2s6JwwEMjaLlfjvgIho
         mXw5LxMDgIsw+CTrTyiyvNDxmMU9hNeYuYwa8ysdNbpKTty3J2ePYDjmW10F4CvLoaKz
         pmqoBeZLc3wEtXj+ujrOfPPNi2bgSBw+abOc+/rjpf0zMBRWtdIzz/E5pdMk4GglLZ9T
         mGbw==
X-Gm-Message-State: APjAAAVHqF6x2wieaK22OMQOQqYG5GZ0sAS2N6S0mzEo4W/FUeJs/JfT
        whlCiavmX5WHoP8vysYkQH4Am0tI
X-Google-Smtp-Source: APXvYqxKXNAU04Aee0xzLS6hq5TEthz7Puz4pUlsdNjIlM+gMTUyjpF8fSdoxhc1NemP6+AKl94R/Q==
X-Received: by 2002:a1c:5444:: with SMTP id p4mr2613277wmi.69.1569328968659;
        Tue, 24 Sep 2019 05:42:48 -0700 (PDT)
Received: from nevthink ([185.79.20.147])
        by smtp.gmail.com with ESMTPSA id j1sm3111189wrg.24.2019.09.24.05.42.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Sep 2019 05:42:47 -0700 (PDT)
Date:   Tue, 24 Sep 2019 14:42:44 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH v2 nf] netfilter: nf_tables: bogus EBUSY when deleting
 flowtable after flush
Message-ID: <20190924124244.3wrbb5ba7nc6cj2o@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The deletion of a flowtable after a flush in the same transaction
results in EBUSY. This patch adds an activation and deactivation of
flowtables in order to update the _use_ counter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
v2: simplify switch case

 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 16 ++++++++++++++++
 net/netfilter/nft_flow_offload.c  | 19 +++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a26d64056fc8..001d294edf57 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1183,6 +1183,10 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 					   const struct nlattr *nla,
 					   u8 genmask);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase);
+
 void nft_register_flowtable_type(struct nf_flowtable_type *type);
 void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6dc46f9b5f7b..d481f9baca2f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5598,6 +5598,22 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nft_flowtable_lookup);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		flowtable->use--;
+		/* fall through */
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

