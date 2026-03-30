Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7453AB27C
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774861451; cv=none; b=VIzcUkodwE+9QI4KT04gXIn0Jc7eBV3MWckRh6wed9wIUg5ke5z3hRLXqBPJV1sXXFLMa/iot3V2GkufyLP/oMyK7jPRF37PijS8F1e8WE8RvILpsofoYG/R5zd//L9Cm60UQMnfoS21H6g6c1jnWfrPl/zX03EXfkS77w+lpZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774861451; c=relaxed/simple;
	bh=y4jjoljjJl38d3JWVJJ3Y1gxuZusdNwusuQ0lQkghYc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KCvFE3ROqJV63RQx1fPII3gPv/R4U38J0nCywEippYTNy0Hi00yJEMJZ8OVSMoPk+eWGoDQABhdY0fcelMBLLPtyyDZcBwVeuHTyrrQAQbHKSksgE8jsBBQi7teSb5MRob3mATuR2v0bWq4RDHZVOyYCU9AxrPMWJ0t0oxNr5XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ay3SeocO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ay3SeocO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F2CDE60177
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 11:04:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774861447;
	bh=R4bV+OKybGJTVGTJQv9qpMVJBxLZZwoC4FooMpcNHxY=;
	h=From:To:Subject:Date:From;
	b=ay3SeocOcNYQH8DexW4DpOfNnTIJVEXUss3bTniPJh1IA2gJJXhf7lLJczdpryAaR
	 C1aSuSv6D9GKu7xvFFBvuQgjqHM8lDdjrpImaS9k6pY76Wc1GkncwTaJCKeOkUa5Km
	 +1j8mayEHdYnSHGwZyezMd++eRlPTGc8sUOEFxNBlRjnR23wUAi0Yt3brzQZueCRiP
	 lyMkniROF0gaWH6Mk1DjN1VsnVNB8bDuWDTQwk1PHz2/y+Rp4bBlrMg0xWXctRwLNN
	 0/7qNcwTI/Xa20yyGZWZ4ZVkylHodI47OqMaeJOe/0QNnmaXauVa+eeWXyeAkFvSDu
	 XgOwPoxjnpMhw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use it
Date: Mon, 30 Mar 2026 11:04:02 +0200
Message-ID: <20260330090402.810083-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new helper function to retrieve the next action entry in flow
rule, check if the maximum number of actions is reached, bail out in
such case.

Replace existing opencoded iteration on the action array by this
helper function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h | 10 ++++++++++
 net/netfilter/nf_dup_netdev.c             |  5 ++++-
 net/netfilter/nft_immediate.c             |  4 +++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3568b6a2f5f0..14c427891ee6 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -67,6 +67,16 @@ struct nft_flow_rule {
 	struct flow_rule	*rule;
 };
 
+static inline struct flow_action_entry *
+nft_flow_action_entry_next(struct nft_offload_ctx *ctx,
+			   struct nft_flow_rule *flow)
+{
+	if (unlikely(ctx->num_actions >= flow->rule->action.num_entries))
+		return NULL;
+
+	return &flow->rule->action.entries[ctx->num_actions++];
+}
+
 void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 				 enum flow_dissector_key_id addr_type);
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index fab8b9011098..e348fb90b8dc 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -95,7 +95,10 @@ int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
 	if (!dev)
 		return -EOPNOTSUPP;
 
-	entry = &flow->rule->action.entries[ctx->num_actions++];
+	entry = nft_flow_action_entry_next(ctx, flow);
+	if (!entry)
+		return -E2BIG;
+
 	entry->id = id;
 	entry->dev = dev;
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 37c29947b380..0046baf44bdb 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -279,7 +279,9 @@ static int nft_immediate_offload_verdict(struct nft_offload_ctx *ctx,
 	struct flow_action_entry *entry;
 	const struct nft_data *data;
 
-	entry = &flow->rule->action.entries[ctx->num_actions++];
+	entry = nft_flow_action_entry_next(ctx, flow);
+	if (!entry)
+		return -E2BIG;
 
 	data = &priv->data;
 	switch (data->verdict.code) {
-- 
2.47.3

