From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 3/3] nft-ipv46: replace offset var with ctx->payload.offset
Date: Thu, 16 Oct 2014 16:29:53 +0200
Message-ID: <1413469793-21382-3-git-send-email-giuseppelng@gmail.com>
References: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58460 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPOaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:30:04 -0400
Received: by mail-wi0-f176.google.com with SMTP id hi2so1688755wib.3
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2014 07:30:02 -0700 (PDT)
In-Reply-To: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The offset variable (undefined) is passed to DEBUGP function,
so you get a compilation error if you try to build iptables
with debug enabled

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-ipv4.c | 2 +-
 iptables/nft-ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index eedcb50..a2c5806 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -205,7 +205,7 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 			cs->fw.ip.invflags |= IPT_INV_FRAG;
 		break;
 	default:
-		DEBUGP("unknown payload offset %d\n", offset);
+		DEBUGP("unknown payload offset %d\n", ctx->payload.offset);
 		break;
 	}
 }
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 2e50627..5489398 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -142,7 +142,7 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_PROTO;
 	default:
-		DEBUGP("unknown payload offset %d\n", offset);
+		DEBUGP("unknown payload offset %d\n", ctx->payload.offset);
 		break;
 	}
 }
-- 
1.9.1

