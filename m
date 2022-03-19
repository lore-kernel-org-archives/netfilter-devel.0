Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A38C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Mar 2022 22:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiCSWbX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Mar 2022 18:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiCSWbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Mar 2022 18:31:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BDEE44A38
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Mar 2022 15:29:57 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7890060743;
        Sat, 19 Mar 2022 23:27:19 +0100 (CET)
Date:   Sat, 19 Mar 2022 23:29:52 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: conntrack: Add and use
 nf_ct_set_auto_assign_helper_warned()
Message-ID: <YjZZYCNd0juT1gAc@salvia>
References: <20220302210255.10177-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1YyPHQkbaOCQyNcj"
Content-Disposition: inline
In-Reply-To: <20220302210255.10177-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--1YyPHQkbaOCQyNcj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Phil,

On Wed, Mar 02, 2022 at 10:02:55PM +0100, Phil Sutter wrote:
> The function sets the pernet boolean to avoid the spurious warning from
> nf_ct_lookup_helper() when assigning conntrack helpers via nftables.

I'm going to apply this alternative patch, based on yours. No need to
expose a symbol to access the pernet area. I have also added the Fixes: tag.

Thanks.

--1YyPHQkbaOCQyNcj
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nft_ct-spurious-warning-when-assigning-con.patch"

From 292d6870c88cf855f1ccc72975974a50edd80720 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Wed, 2 Mar 2022 22:02:55 +0100
Subject: [PATCH] netfilter: nft_ct: spurious warning when assigning conntrack
 helpers

The function sets the pernet boolean to avoid the spurious warning from
nf_ct_lookup_helper() when assigning conntrack helpers via nftables.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5adf8bb628a8..2a6dcbd06590 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1041,6 +1041,9 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err_put_helper;
 
+	/* Avoid the bogus warning, helper will be assigned after CT init */
+	nf_ct_pernet(ctx->net)->auto_assign_helper_warned = true;
+
 	return 0;
 
 err_put_helper:
-- 
2.30.2


--1YyPHQkbaOCQyNcj--
