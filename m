From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] netfilter: nf_tables: add reject module for
 NFPROTO_INET
Date: Thu, 6 Feb 2014 00:28:22 +0100
Message-ID: <20140205232821.GE5674@localhost>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
 <1391612619-30347-6-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51641 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaBEX21 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:28:27 -0500
Content-Disposition: inline
In-Reply-To: <1391612619-30347-6-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 03:03:39PM +0000, Patrick McHardy wrote:
> Add a reject module for NFPROTO_INET. It does nothing but dispatch
> to the AF-specific modules based on the hook family.

And also applied, including this chunk:

diff --git a/include/net/netfilter/nft_reject.h
b/include/net/netfilter/nft_reject.h
index 6ade783..72a18c0 100644
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -15,4 +15,12 @@ int nft_reject_init(const struct nft_ctx *ctx,
 
 int nft_reject_dump(struct sk_buff *skb, const struct nft_expr
*expr);
 
+void nft_reject_ipv4_eval(const struct nft_expr *expr,
+                         struct nft_data data[NFT_REG_MAX + 1],
+                         const struct nft_pktinfo *pkt);
+
+void nft_reject_ipv6_eval(const struct nft_expr *expr,
+                         struct nft_data data[NFT_REG_MAX + 1],
+                         const struct nft_pktinfo *pkt);
+
 #endif

thanks Patrick!
