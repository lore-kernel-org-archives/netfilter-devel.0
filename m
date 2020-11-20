Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E51C56201
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 18:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE5A924137
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 18:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="02O/nS3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgKTS01 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbgKTS01 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 13:26:27 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760642224C;
        Fri, 20 Nov 2020 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896786;
        bh=C1JYVYbiH42EE/uLPi+6zsu3Ta2+yYlrVB4LGZYwlek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=02O/nS3V848EYX5SWiVylqOyVZ2x8zgyL7+aqZVLGDMvG9GObDZnOMdRvtc5KZhRN
         BFHp4vvUT3rf3/onWxVYy0ayCbU3GWwUSSinDiR/bR2twi9ckY/EjwqcUmRb81A3Y0
         CeL2jMn6s7eOQvxy531gNDfpAmCjf+lZ6F4sCgq4=
Date:   Fri, 20 Nov 2020 12:26:31 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 015/141] netfilter: Fix fall-through warnings for Clang
Message-ID: <ed43418cabacc651f198fbad9a9fcfe32c6ddf6f.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 1 +
 net/netfilter/nf_tables_api.c           | 1 +
 net/netfilter/nft_ct.c                  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b3f4a334f9d7..94001eb51ffe 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -397,6 +397,7 @@ dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			msg = "not picking up existing connection ";
 			goto out_invalid;
 		}
+		break;
 	case CT_DCCP_REQUEST:
 		break;
 	case CT_DCCP_INVALID:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0f58e98542be..78d0bbc8868c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8342,6 +8342,7 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 							data->verdict.chain);
 				if (err < 0)
 					return err;
+				break;
 			default:
 				break;
 			}
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 322bd674963e..fec68b75f39a 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -530,6 +530,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 	case NFT_CT_ZONE:
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		break;
 #endif
 	default:
 		break;
-- 
2.27.0

