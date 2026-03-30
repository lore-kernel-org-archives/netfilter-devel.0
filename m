Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B964237EFF5
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774861328; cv=none; b=Ad58V6ZvNEc6js7iSp2OnbxdNwms5o3h59wtJTrWJUAzDFwmZ1FgN/eqEZ2KUhaleHCWwcwRJVX3x+W6hBhbd0cSVFjiJAslkdu8WGeDWXynUU1eds66SUAdDl9n+q2UWZU8Msdd2V+b6ca4t5uFlA7OCXqvkaqMBqfRCIAImAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774861328; c=relaxed/simple;
	bh=y4jjoljjJl38d3JWVJJ3Y1gxuZusdNwusuQ0lQkghYc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Kav1DRsPr1eGmHXjUcqr6SRvRbBlYL/LzhOaQAUzgnae0StsbfNxB3dr69gd/gK9fpSZ7zXoB5k+JJOtXAvtYpb7yN/4Ph+hMG7AVIpGPaVi+E2xFb28EBrx6k7BO33T0v9mq2ZCYCzCfv14WMohVM46am2cfa5Z5NbiAsj8gOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ol34aShc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ol34aShc"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 65CD960177
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 11:01:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774861317;
	bh=R4bV+OKybGJTVGTJQv9qpMVJBxLZZwoC4FooMpcNHxY=;
	h=From:To:Subject:Date:From;
	b=ol34aShcwN2ZO+GqkrI/KhuiwK/5sDR9c7b4NPu4qJ/U0x2OxPqBQ8zjUTDKyCOiV
	 jLOGNo8u/ryO0/Ug/nzcn3KmcwuhpbsUpxwtiO9A/PAqBq4ddhzH8PuVynz/Z5seTc
	 /PiyFe7zadv5N98XUiDuD8p2OqhNNunYLNWSU0FfySEtJxCPW8uYgU1wcilJGwzOGS
	 67dg+frzwSdHA6mu8bbK8qQo1VPckYGR9HXKN8r9xj4HHyJvlZ98pltbg1feXpmIZR
	 IiRoJ24AbuQLw8/K/A3KcZKKT+rqNoj6ScWR7B0zYldff1sKlZoffBMhjp7n7Dc0od
	 KE08Ukc8Y7qlw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use it
Date: Mon, 30 Mar 2026 11:01:53 +0200
Message-ID: <20260330090153.809877-1-pablo@netfilter.org>
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

