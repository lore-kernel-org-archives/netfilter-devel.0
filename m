Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E6FC28CC1
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0179427775
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfFASYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 14:24:22 -0400
Received: from mail.us.es ([193.147.175.20]:40074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfFASYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11A34FEFB6
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF634DA707
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77CCEFF2D5; Sat,  1 Jun 2019 20:23:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1150DA716;
        Sat,  1 Jun 2019 20:23:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7BBB54265A32;
        Sat,  1 Jun 2019 20:23:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/15] netfilter: nf_tables: prefer skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:36 +0200
Message-Id: <20190601182340.2662-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

.. so skb_make_writable can be removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c  | 3 ++-
 net/netfilter/nft_payload.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a940c9fd9045..45c8a6c07783 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -156,7 +156,8 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			return;
 
-		if (!skb_make_writable(pkt->skb, pkt->xt.thoff + i + priv->len))
+		if (skb_ensure_writable(pkt->skb,
+					pkt->xt.thoff + i + priv->len))
 			return;
 
 		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 54e15de4b79a..1465b7d6d2b0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -243,7 +243,7 @@ static int nft_payload_l4csum_update(const struct nft_pktinfo *pkt,
 					  tsum));
 	}
 
-	if (!skb_make_writable(skb, l4csum_offset + sizeof(sum)) ||
+	if (skb_ensure_writable(skb, l4csum_offset + sizeof(sum)) ||
 	    skb_store_bits(skb, l4csum_offset, &sum, sizeof(sum)) < 0)
 		return -1;
 
@@ -259,7 +259,7 @@ static int nft_payload_csum_inet(struct sk_buff *skb, const u32 *src,
 		return -1;
 
 	nft_csum_replace(&sum, fsum, tsum);
-	if (!skb_make_writable(skb, csum_offset + sizeof(sum)) ||
+	if (skb_ensure_writable(skb, csum_offset + sizeof(sum)) ||
 	    skb_store_bits(skb, csum_offset, &sum, sizeof(sum)) < 0)
 		return -1;
 
@@ -312,7 +312,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 			goto err;
 	}
 
-	if (!skb_make_writable(skb, max(offset + priv->len, 0)) ||
+	if (skb_ensure_writable(skb, max(offset + priv->len, 0)) ||
 	    skb_store_bits(skb, offset, src, priv->len) < 0)
 		goto err;
 
-- 
2.11.0

