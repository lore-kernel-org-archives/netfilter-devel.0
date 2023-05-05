Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C17C77B7D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 18:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjEESfN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 14:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjEESfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 14:35:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A0715EDD
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 11:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+AYklI2ro7GhXoyeMxVuFpw/Wad1IiSZTeogwAIumQw=; b=cp1wm7Esl8qu2YX4mavypbfbPt
        BXYa3qItPGyYy722NvXfwrc1U6RCXJO/IWbshuibWcT3+W9N6z/Vhfpo0f9PRdzAE7nOWP6FOV65c
        aJUdMGiF8Cv322Exs5FAhXzuhI0PYrSXPG9xALiY08N/aiQ5MbMhug7XHCjSVqMmJaiebRAGLD1ko
        01lU1C2whoF6wGBpqHM0K8U0Xi4/SpGAdqou2xRlpTXvr9Sp2yWRLtR8h8W+LdkKkD+WyPXYgpV7k
        lzaDxSU/JEkn0g9D/gMHZqSAwNbk0IBUE1N8cHOQXqtzn84Jr2DEW/n2ecXRN+h2YSqNuj/iEexzj
        /qvQV8Kw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pv0Gp-0004Pc-9f; Fri, 05 May 2023 20:35:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: [iptables PATCH 2/4] nft: Introduce and use bool nft_handle::compat
Date:   Fri,  5 May 2023 20:34:44 +0200
Message-Id: <20230505183446.28822-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230505183446.28822-1-phil@nwl.cc>
References: <20230505183446.28822-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If set, create rules using compat expressions where possible and disable
the bitwise expression avoidance introduced in 323259001d617 ("nft:
Optimize class-based IP prefix matches").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 2 +-
 iptables/nft.c        | 6 +++++-
 iptables/nft.h        | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 12860fbf6d575..8e7a706f8765d 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -198,7 +198,7 @@ void add_addr(struct nft_handle *h, struct nftnl_rule *r,
 
 	for (i = 0; i < len; i++) {
 		if (m[i] != 0xff) {
-			bitwise = m[i] != 0;
+			bitwise = h->compat || m[i] != 0;
 			break;
 		}
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index 55f98c164846e..786e4a12cf720 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1468,6 +1468,9 @@ int add_match(struct nft_handle *h,
 	struct nftnl_expr *expr;
 	int ret;
 
+	if (h->compat && strcmp(m->u.user.name, "among"))
+		goto add_compat_expr;
+
 	if (!strcmp(m->u.user.name, "limit"))
 		return add_nft_limit(r, m);
 	else if (!strcmp(m->u.user.name, "among"))
@@ -1479,6 +1482,7 @@ int add_match(struct nft_handle *h,
 	else if (!strcmp(m->u.user.name, "mark"))
 		return add_nft_mark(h, r, m);
 
+add_compat_expr:
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
 		return -ENOMEM;
@@ -1532,7 +1536,7 @@ int add_target(struct nft_handle *h, struct nftnl_rule *r,
 	struct nftnl_expr *expr;
 	int ret;
 
-	if (strcmp(t->u.user.name, "TRACE") == 0)
+	if (!h->compat && strcmp(t->u.user.name, "TRACE") == 0)
 		return add_meta_nftrace(r);
 
 	expr = nftnl_expr_alloc("target");
diff --git a/iptables/nft.h b/iptables/nft.h
index c8d5bfdc50871..6f56f5b46e775 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -111,6 +111,7 @@ struct nft_handle {
 	struct list_head	cmd_list;
 	bool			cache_init;
 	int			verbose;
+	bool			compat;
 
 	/* meta data, for error reporting */
 	struct {
-- 
2.40.0

