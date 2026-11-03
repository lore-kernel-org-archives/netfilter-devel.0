Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714617;
	b=CYni8G1XOEwJvUlLc8y2I+QDY+vBLCWSZez6Lg632j8bCjy9BNHGSzMpDUmfM1yYJrz5
	 rKBgdrfL1RPBBMH8pqX38aYSlYfLl9E2qnxttMTqNq36zlHj3ykt6Bq1bwU69a3M0OM1i
	 RJTJdfOFItzDxqvr38XXjeSHTA9F/XVXXwYReTPEdr1oL2Ss7v8spnJ2zQL51wpn1XHA+
	 WlE83AXaKcu7OwVbaMUivUmbR02IHxsnwV8Qfoo7tB2k6EHJRHHPt7VU15pEATP5mxIYS
	 CbiSs1Wu8MG3BNsVA/8E9Z+TmN+QtGHYG0JY+KKLnjcHOUTqdyaRkifVi81iuup/QHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714617;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ERbJJjui3uMopKOsLz17s2PXsaNLTajEI06p8Pfiz/I=;
	b=adBg1ap6Wr9R3US8v+RamO+1IyxdUmx5Gyd7JYCtZSLOCeYqUXpMVhuZNlPY5X2VFjkb
	 RcY7Vah/NHaYgXpwrFF7ABdDFsaQIiuCQrhqVGNYZwP+4l2MXu5A8ou2B2RpKh9J4GCxw
	 cW72ydwxc9OduwuXfmHPFcPVIdO/vtpFJjpqNY2FF1o4N6wnDvHsAvXcjaBtYm+x7NHDR
	 lnyAjHSlvq1ulDVnRoO7c5ii8UE3QKcyiq0d7IW6rd09jy1itsuexrE4fgLksPpuLCCNi
	 RoiI+qRqRl2esyQbfREEPpjLnJXvlv2NZ78/+Rt2Zj9FteIeh4jTrQK5E73BON4/1HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wRBO1Xmu;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAFE6082BF4;
	Tue,  3 Nov 2026 14:03:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BAFE6082BF4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wRBO1Xmu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714615;
	bh=ERbJJjui3uMopKOsLz17s2PXsaNLTajEI06p8Pfiz/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRBO1XmuRUOIzepZDvscokquKpBi8UgUv5osay53/5ahmUEPWJyM+vljCgD7H7Ei9
	 CCrPxi5sJP7uXsAkv7PdSDu/57sHHXNXb9chFXFpfsPWSukUFOjKzHr2ZaZlFK+o3W
	 01D0yibZhC5tc8+JglCfdscMJkoyoRR+reijD4L1rF362oZggWJz0YbOAgvHJ1q2zZ
	 h8F1Q7DAR/yhhqsakM/8G5C+Vjx3KbrCuni86MWEYGkFIyaI7PLO05R1Pbxb5lXdxy
	 F2lxA4YaPGy+hVivM60t3lmq/4G/09Mw4FWw65W7bauoJAsvL26yyzbwS4txxWYClt
	 CSxtBf+SfoyPg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D7C460092;
	Tue,  3 Nov 2026 15:03:34 +0100 (CET)
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
Subject: [PATCH net 13/15] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Tue,  3 Nov 2026 15:03:06 +0100
Message-ID: <20261103140308.591690-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

