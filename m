Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793185634;
	b=yE0WWbP/0Tby/UhRA/tqKJU3Eaxghfguf+3kPY1cPVFDNR5bgQGRcfn8c5wDTezzWivb
	 TuB3wkAaNSaMCo2jVa49rl8iCxRZyGtcFT1pTIqNdgOxNZkT8SIVD499prBFRo8H7ffbS
	 4QSRFr0IoP+Wbx0nChg4NKxneA0oOLvcse0twKE5Z+YSX0P1EdefwT39yoRXO42Kv8XKN
	 2zUofif7wv5KyT/K4PzmSJH8B2OfL5kFwSqXb8ALqpfWHnDUU6HI/idx3OqcOe7a/6kVO
	 FXmMH0QJ5G1OYiza3MyAgivlNzJZ8Q/G2prEdpdB51i9Ifx4CzhW56xFiNcrf0KtGfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793185634;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=LIXhJKAL1toAkLrFn0ZMsbu26eLf5azGCvOky/MAPIg=;
	b=Gh3ujb407E1v1W7S8GeIocT+n2+VuY+0HED0mLUO6pC9inJc0OGMWaoNdWMVaU9VMSUU
	 eEumX5gcrtXX+Zivonvs5tJqW4J3wQ9XA3QRYKH44MUjvy2hz+Lp1kv0KaanP3Nlhztm5
	 fEGwIJbq9a1kbFk4z0xzu+eUSyRFI79QlvrX9ZStrLHArsk8xo+qHg5D96bT56udQs4Co
	 29+FSNvzhCcr4qTamo6fCzKrJC3CQ4bmlRUQEC5bH1sQfTeyFT+OrUBRfmbIrAh3g5rBo
	 yhyxsBQ3My09Y9eQaNAGJc0IxZiqiI5Zl62h8U32fuzpKoQw7UZFXIrjar7dJUIHOFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Eh5zaN55;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B2606A321
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 11:07:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 384B2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Eh5zaN55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793185629;
	bh=LIXhJKAL1toAkLrFn0ZMsbu26eLf5azGCvOky/MAPIg=;
	h=From:To:Subject:Date:From;
	b=Eh5zaN55Jl2ubHO9QCJ11D0ar+GYgQevYYExvVtGBiSFP3fywY323qE/6MWNotFeP
	 Oz9FU4CYSIlNlrPLYcGCvPji6iJis4svqnDTbbZfskS9abznMvryYbSLFxZAQcNe0N
	 OWD6t+MRCP3ZJx5iYwqFuR2KnBjAETVFbBYkPLa+FG14lG2tD84WYtJESM6HcwhEJe
	 7m2KtnGvigMfmQ+6DVcPOKHG1XhpNHopTms6Z617nfuj9qagd7hbdnPl9l503AiPVZ
	 CDg4OEnTT1f1D8PoF9Cwq0X5mafKSVZ0MyzE7IuXo6qDMMuLG54h/yH4t10zwPTTgr
	 xVtyQiHIW7BYQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1EA4E6005D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 12:07:09 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Wed, 28 Oct 2026 12:07:06 +0100
Message-ID: <20261028110706.108523-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate flow rule object after transaction has been allocation and
rule deactivation has been performed, otherwise memleak is possible.
Let the transaction unwind the existing rule deactivation from the
abort path.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1c7deca476fa..2d2156d05916 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -777,16 +777,6 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	if (trans == NULL)
 		return -ENOMEM;
 
-	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		flow = nft_flow_rule_create(ctx->net, rule);
-		if (IS_ERR(flow)) {
-			nft_trans_destroy(trans);
-			return PTR_ERR(flow);
-		}
-
-		nft_trans_flow_rule(trans) = flow;
-	}
-
 	err = nf_tables_delrule_deactivate(ctx, rule);
 	if (err < 0) {
 		nft_trans_destroy(trans);
@@ -794,6 +784,14 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	}
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_PREPARE);
 
+	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
+		flow = nft_flow_rule_create(ctx->net, rule);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		nft_trans_flow_rule(trans) = flow;
+	}
+
 	return 0;
 }
 
-- 
2.47.3

