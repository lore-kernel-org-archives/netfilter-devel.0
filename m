Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793186742;
	b=jiVr+kCxFtPM/ViNFFYQW5+YIcJMA6Rk3OLez3GVIkh+WRJYdPGZokH8wVcYmUCCcPi2
	 gtYYEgBsvOHSnrGgmszEy4A3gFUPP4r11d8PfnfjSWKNTp6U8MezgOHcqw6SYoW2LdtcS
	 LFMgzRiazstY1wTb7N5wwny8Qugm2qC9Mll+1lvfmNie3xJNhU6CuMzU7E7WJ03fyr33F
	 uRBSTTkTBPCaxv+TMvs87sw/olwGc9SNmXD0E+06XTsqwaWTSb+roh/3v3UHf/xmvgAH1
	 XINL4V1WB7sPIyT3tf2c2z27XrwBaKiTHzMZ+THzi1h0slc95gBHDWUnytFYybfXyow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793186742;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=UPrFPLW9GRAFnc4gRrUL7oB5PZw67n7vrdcaFGxc/3c=;
	b=joHQesxpLXtUZG6WC8qF6wVAvIAtBc/z0bwcB0seV67ypFC5YxdEZmWZP2FeLN/ZeDk/
	 h4rhkxe/OcSf0eN3+wINe/ChaqBbVatXn72cFlHMXHITEqLoRqVXjHIWDR3mkcus8sjXw
	 Oz849RNcKDpuDm7s+WWquVg5gO/ULQv6zuv35sqgxxgkoTAkHCIsHdw1HhJJphcfxmkOt
	 uc1hNJbTdxeHhklfWi3Uv7a4S+a3U8PK/fmLggRZpGVsxjA4LHVRzS0UJ+q3TuDIrGuiJ
	 VCyqrQWjcSv1eG/FOWzH7G8KFk5y5awlvPWVMMvUOcF2wyQPJvh5EfvuWPN0HzaQTNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ljE+VUA5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDD606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 11:25:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DFDD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ljE+VUA5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793186739;
	bh=UPrFPLW9GRAFnc4gRrUL7oB5PZw67n7vrdcaFGxc/3c=;
	h=From:To:Subject:Date:From;
	b=ljE+VUA5eXDAc7rAPFG4kGwM572dlzXwQEbGqL7uhRvErPgmk/cOmn+OjLqKzWqIh
	 hpMbmAgxfLm1aQp7gW3jQE5Gr/RWmj0YSuDm21pg5vjbqFaqE49gO/gnWUVMZnuH7S
	 TLHqnw7/nk5fvJUNhIUep1MS5s0fn+MFE/L2TgS27ci7NLiFHIhQXWx2WzYStUJ2qq
	 kKLQ/OqpjZXvVi8NPlrlnAQPJA4ENRlKGR4iJ83OT0VIXDoc+D9FArEf3F6ki+h6Ji
	 OQo7f6Uny77p8vn7ybtzPVRXzRK0+DNoPsablxwe4lY/SOG5TKWnu2WJUD9VTYumQk
	 6+Etv6gTKICNw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CCBFE60057
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 12:25:38 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Wed, 28 Oct 2026 12:25:35 +0100
Message-ID: <20261028112535.115054-1-pablo@netfilter.org>
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

Allocate flow rule object after transaction has been allocation and rule
deactivation has been performed, otherwise memleak is possible.  Let the
transaction unwind the existing rule deactivation from the abort path,
this needs to update nft_flow_rule_destroy() to skip release if
flow_rule is null.

While at this, remove check for non-null flow_rule in newrule error path
now that nft_flow_rule_destroy() is skipped if flow_rule is null.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fortify nft_flow_rule_destroy() by allowing null pointer when
    flow_rule is yet undefined, per sashiko feedback.

 net/netfilter/nf_tables_api.c     | 21 +++++++++------------
 net/netfilter/nf_tables_offload.c |  3 +++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1c7deca476fa..d26867ffc30a 100644
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
 
@@ -4553,8 +4551,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
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

