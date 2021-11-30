Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18189C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhK3Kha (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:37:30 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49526 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbhK3Kh3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:37:29 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F26606063C
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 11:31:51 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_exthdr: break evaluation if setting TCP option fails
Date:   Tue, 30 Nov 2021 11:34:04 +0100
Message-Id: <20211130103404.65387-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Break rule evaluation on malformed TCP options.

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index af4ee874a067..dbe1f2e7dd9e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -236,7 +236,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
-		return;
+		goto err;
 
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
@@ -251,16 +251,16 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			continue;
 
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
-			return;
+			goto err;
 
 		if (skb_ensure_writable(pkt->skb,
 					nft_thoff(pkt) + i + priv->len))
-			return;
+			goto err;
 
 		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
 					      &tcphdr_len);
 		if (!tcph)
-			return;
+			goto err;
 
 		offset = i + priv->offset;
 
@@ -303,6 +303,9 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		return;
 	}
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
-- 
2.30.2

