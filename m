Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782969;
	b=g1EXCn5ezvdlwTZkf4t0aFie0IFgXA6lUc01uBqrEaJh/ozF3oV8ICyMFJ7mLQrtA0bH
	 0TwVTb1KFFIMsfCCdM9qHBMJTc4ADTwKqALNTYU4+nPlutw3pw5eqZsjS0UL8Shc/iIMP
	 8MwfUdLF8XbUU34NqNazKvUY32SeCPVkZFQtYwlxK7xPo3ThDHN8lsqp6HaHxC9AgSTNY
	 3jiROx393fOek9YPI4T3Zkvs4N2RpRetTHoCGnl+2GWY74mtjqdDnm9kDBOzvnGwCZ9se
	 lebGb6fPYfhI3jq9zXlOpqJCkhwDH36px0O2cdcVy6JCX4RppAa9iB95wyk6CNCmpsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782969;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ERbJJjui3uMopKOsLz17s2PXsaNLTajEI06p8Pfiz/I=;
	b=gFYz1cxdanQnDOqdjKe4u4pE+swfTrEciJ0EsKrrdk2/HJW7zrPhY/lXSg9+8pAuGPEj
	 GNZiEUSz7utqIolCbMDcWeUKu/lpqwXy1/EDvWkKNDq6JCzk0QZ/W0XccSHlEZM4JEpZN
	 KuZAQR9HL5BRUh84Cr5/jt2V0xBzPkM9psLS+J1YdUvRX6sCOS+AIKzQjkzBfK4E7Tl3a
	 boecTmE1wBY4XTZwET/g/BhM5RN4mQyrA6MNYdj9cpu6jjidQFnK0auPzYnw+52POoqjy
	 rbrmDGeznK/8F6VAZld9zNBZkp/zwOnTIYA2Cg+FuxJABoMq6Edg/gqcNiT7fk1fTyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=piCmQ6Ld;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BCD606A33D;
	Wed,  4 Nov 2026 09:02:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04BCD606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=piCmQ6Ld
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782967;
	bh=ERbJJjui3uMopKOsLz17s2PXsaNLTajEI06p8Pfiz/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piCmQ6LdQh/+r9K9JONkfoULRYTGA2T1SbR9n52cK4Q4J3K+JVwPG+DH+v2sOVw3g
	 GDH2oKEWePHrPU44X918wbvTrz+GV3vbw36LomSRFpVsOUDaPGAGWyvSVCsA54+eii
	 2188jL27cAWZrI9uA4dPRdZEvdNDIDQuj35b4EBFdSjaJ+KvJ0jGfPodya1k+g+TZ4
	 bBpYl63YmZ0lgm4xF4YkYchoPUYsjlXqQLZQ9jGIjznjkgJk3eFpD51QSkA+ML1Oxq
	 38gYArt6nOL0PNJ76g7TMBuuIeVnSvCEiKyGvbAKAapNF6PI75BNrRSMmBGC6CgTXc
	 YxyhtDV+FADxA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D6CFA6008B;
	Wed,  4 Nov 2026 10:02:46 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 11/13] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Wed,  4 Nov 2026 10:02:22 +0100
Message-ID: <20261104090224.750548-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
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

Allocate flow rule object after transaction has been allocation and rule
deactivation has been performed, otherwise memleak is possible.  Let the
transaction unwind the existing rule deactivation from the abort path,
this needs to update nft_flow_rule_destroy() to skip release if
flow_rule is null.

While at this, remove check for non-null flow_rule in newrule error path
now that nft_flow_rule_destroy() is skipped if flow_rule is null.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Link: https://patch.msgid.link/20261028062204.1079089-1-hdthky0@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c     | 21 +++++++++------------
 net/netfilter/nf_tables_offload.c |  3 +++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59ac623e6805..8b94b5e7dbdb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -760,16 +760,6 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
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
@@ -777,6 +767,14 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
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
 
@@ -4570,8 +4568,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
 err_destroy_flow:
-	if (flow)
-		nft_flow_rule_destroy(flow);
+	nft_flow_rule_destroy(flow);
 err_release_rule:
 	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 0ac3c26dfb3d..48b9e58e0c44 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -148,6 +148,9 @@ void nft_flow_rule_destroy(struct nft_flow_rule *flow)
 	struct flow_action_entry *entry;
 	int i;
 
+	if (!flow)
+		return;
+
 	flow_action_for_each(i, entry, &flow->rule->action) {
 		switch (entry->id) {
 		case FLOW_ACTION_REDIRECT:
-- 
2.47.3

