From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_ct: fix random validation errors for zone set support
Date: Mon, 13 Feb 2017 22:26:49 +0100
Message-ID: <20170213212649.10176-1-fw@strlen.de>
References: <20170213191354.GA5325@mwanda>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54750 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752886AbdBMV0d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 16:26:33 -0500
In-Reply-To: <20170213191354.GA5325@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dan reports:
 net/netfilter/nft_ct.c:549 nft_ct_set_init()
 error: uninitialized symbol 'len'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: edee4f1e924582 ("netfilter: nft_ct: add zone id set support")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index c6b8022c0e47..bf548a7a71ec 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -528,6 +528,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		if (!nft_ct_tmpl_alloc_pcpu())
 			return -ENOMEM;
 		nft_ct_pcpu_template_refcnt++;
+		len = sizeof(u16);
 		break;
 #endif
 	default:
-- 
2.10.2

