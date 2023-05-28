Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C07BC7EE2C
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 19:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjE1TPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 15:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjE1TPR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 15:15:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6C5C4;
        Sun, 28 May 2023 12:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 138206158B;
        Sun, 28 May 2023 19:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303CDC433D2;
        Sun, 28 May 2023 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685301315;
        bh=KdbP9Gju9nKc/REI7lJ1C9p5zHGg4yjYdtLkDpLXh3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhOWavd6AsvLTe/vaY5Wq5+UxRh/qfJIEKZ/s8iy5UaGEtK/YDgJncv7+mZi90HFQ
         pphuHLDUSPG14T6YV8NZxD7nokY6rT/u1PXfI3+uGtcUlm5Jk8qGgVCFX8zuQJULTa
         EibfjDfnUzd8H+4Bf5DhiMdN0vfu2LiiU88hrsy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 67/86] netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL
Date:   Sun, 28 May 2023 20:10:41 +0100
Message-Id: <20230528190831.122346503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 215a31f19dedd4e92a67cf5a9717ee898d012b3a ]

NFT_SET_EVAL is signalling the kernel that this sets can be updated from
the evaluation path, even if there are no expressions attached to the
element. Otherwise, set updates with no expressions fail. Update
description to describe the right semantics.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    2 +-
 net/netfilter/nft_dynset.c               |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -258,7 +258,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
- * @NFT_SET_EVAL: set contains expressions for evaluation
+ * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
  */
 enum nft_set_flags {
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -190,9 +190,7 @@ static int nft_dynset_init(const struct
 		priv->expr = nft_expr_init(ctx, tb[NFTA_DYNSET_EXPR]);
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
-
-	} else if (set->flags & NFT_SET_EVAL)
-		return -EINVAL;
+	}
 
 	nft_set_ext_prepare(&priv->tmpl);
 	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);


