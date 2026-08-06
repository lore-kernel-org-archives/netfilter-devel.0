Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08E04248A7
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055753; cv=none; b=uO4cUysw7CcESnonVv8s4wdbHZEM6Jf79Om7tM07d/sNmSrmTMnwCpbmrTr993uu/Uv3LzWdO7QjHiTuo/iLa6J4hgJgNxujjdbcchTlkzb09iT5xoSiI3qf3zzDDT2MGY2JUpoErInUmPzkPVship5AhJpVyAlqIT2XkQdbgGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055753; c=relaxed/simple;
	bh=uxfvIPemSV3/pUrRjSnn88pmprQws2qzHtJ9UJBpHsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss8Tl/4uJGF9J8WdLSDCzW6MpYSQ/jxvUwDNHHfL2UcM0CcHDLFO1UEVYgm0nRByQO0BtYq8lR7Y87tSDjBEt4dDl2metFhXt7piuaDPuebuI6qUlmX/3l2pDjE4txfvur4wHWdmEXpclT2DqkLHAJ/hXiEsZsOlW6xaVAtnQFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=denWnLh2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="denWnLh2"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4CF7B601BF;
	Fri,  7 Aug 2026 00:35:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786055746;
	bh=Lh3BIlLBWW3wC28QFla7BfPGF+cQyr+IsVyujLg9wd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=denWnLh2a4p3yAzgw86RIUEhSRMwoZjdEOzCWrfD2g/6dZbmWapWD0eFQoLPvOOdo
	 TFRxFWmtwDG397XlRUTwuUxejFgQ19vYsuec2mGdnmB6LgS6PcYybsK8lLCuYYN4sv
	 gcYnK6xV8Yn3SefYBAclf8usfrN2u17IbE3kW6pEb3OGpOtOmiPLkZFecrTX2RHq34
	 P459VMKdYGDGEZb6iwm8cPzJFdxziJQO1IrzfLxC7o8qcUeVHWcqHMsDPS9axH7dqu
	 MsDIPQyBLcfhvr6c90sAjyuQcTI8O+MAjUiUsrdQX6B1LjDBZIDvbRf6Vl/kAznwPZ
	 JxDaOonWUrAgA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo.bianconi@oss.qualcomm.com,
	lorenzo@kernel.org
Subject: [PATCH nf-next 7/7] netfilter: flowtable: detach layer 2 encapsulation parser from lookup
Date: Fri,  7 Aug 2026 00:35:35 +0200
Message-ID: <20260806223535.523098-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806223535.523098-1-pablo@netfilter.org>
References: <20260806223535.523098-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the layer 2 encapsulation header parser out of the lookup function
to prepare for IPv4 over IPv6 and SIT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 18febca1dcef..af534000a287 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -458,12 +458,6 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb))
-		return NULL;
-
-	if (unlikely(ctx->ether_type != htons(ETH_P_IP)))
-		return NULL;
-
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
 		return NULL;
 
@@ -875,6 +869,12 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	};
 	int ret;
 
+	if (!nf_flow_skb_encap_protocol(&ctx, skb))
+		return NF_ACCEPT;
+
+	if (unlikely(ctx.ether_type != htons(ETH_P_IP)))
+		return NF_ACCEPT;
+
 	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
 	if (!tuplehash)
 		return NF_ACCEPT;
@@ -1115,12 +1115,6 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb))
-		return NULL;
-
-	if (unlikely(ctx->ether_type != htons(ETH_P_IPV6)))
-		return NULL;
-
 	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
 		return NULL;
 
@@ -1203,6 +1197,12 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	};
 	int ret;
 
+	if (!nf_flow_skb_encap_protocol(&ctx, skb))
+		return NF_ACCEPT;
+
+	if (unlikely(ctx.ether_type != htons(ETH_P_IPV6)))
+		return NF_ACCEPT;
+
 	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
 	if (!tuplehash)
 		return NF_ACCEPT;
-- 
2.47.3

