Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0094244A414
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134207; cv=none; b=BBDgjEbD9mSvKkm9bwHtJzt6N7nXbBx7+nyVL7G8LU6FDYJsspqBKlPVhdAGhwUKNGqhcQFxQ67B03hDxniGo1OozSfG8454CWrwnWhTyS50YFE6nJA3yErhdY1knNFEA0s/EozK7/N7ReDF/+noSa8b8SU2Hb0HZaO3k8KHsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134207; c=relaxed/simple;
	bh=h0fforI9/m/s0XSTv3gjhYlQx5oeqaJ+LYwUPqRIv18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koBTuiq3gbI75c3y2YJM+5NpgBBqxTFgTC1iDnjtLp44fK8M5KBw+MWzqIiuCe0xow1vM5/H7ASzKnZgd7LqwB3IPgJtSOkTCwllBNDnGEClVNLY4BquQZ6M13SeSnY9ZwGaU20QAfGfKLXGOrVURmEHVEu/lfmGBLu1vejupn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=OV8orMGt; arc=none smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="OV8orMGt"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6af7d408b51so716650a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134202; x=1791739002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O5uUcI1/RkV6pA20Ka1TbaV7lMFxccYVTKU3RyjDpPg=;
        b=OV8orMGtxEiRmqR7Gz3qQluEHMA+J1kKi3NSH6SNP9Rxo+NQEA0UWlEDklodBJUneA
         4mx52R2kQ0AZWJiODvKxZazNdlfbjEoP3wQJOO1ZBfIjmte0GrSK8MQ+6SXnQnWD4Bwd
         CnjOvdxIxAfMz/55dhhQ5VM7J0AiNlQlcjnWfS7SnqOsVu8zSdx2f4nF1QU6QTORtNHY
         XXzgrv49yAW6TafSGuqozIloa0OD10mQQkZE6VbRqdndEXYGjTUBLlzNiWKCs+Q1FZSE
         6zfFHH+DFX12Ysg5Cp5wXv0IsaSEadiY7uxDuaLvQa3IqGDR08ZwVusT999gHkps2Nws
         Oq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134202; x=1791739002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O5uUcI1/RkV6pA20Ka1TbaV7lMFxccYVTKU3RyjDpPg=;
        b=bz3bcsI82atKIpQI59/Y6VP5SvxCMkwgVapI0L5YJh1JytOGMXxuL6zcxzBaqpiJwG
         0WEj7cPd4xzB1juJ8BYlHqG3IcEsleKQrNfYm0VzuDAQFq6QECaK0/IJYZ7/IxxtogTD
         WoILeysh13FMjeILHGX70rtXZZszPHQPcnMzLT5yI5azRBoHNuOyrt+3l/xFRbh8kDLg
         C8uX1LTnGuQoH5Gms0k8KU1O3UAvEP9gKffMiW7H/+4Vefksu5BOb/O7N6ruEYs8+ys/
         8Ci1bBVDpGsqZAXRvm7pNnGKBlhL61KPkoBrmbfIqqh+zEIY/RTctjo1Obl2F/PG3rL+
         Tkzw==
X-Forwarded-Encrypted: i=1; AKwUvBzbUqLqLXkaQvsbSZqXYj8RbZj2J7E/imui4/tb90klKBuYGpmGnXzMvVDBdkTIFCfWCW1bIM3rmJ7759XFLEg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ921GBAHEZ7qykDMcGzEcu5wnzKrNZmxixuK1cVi9GxFVjWxEO
	gWwIshmYYNiV09FQ3llzqzRmzxp1D9Ar8S8kPlEYsxXV1t4NagpuQTKFnz+qTgTygA==
X-Gm-Gg: AYBFou227RMMWfYrYDnvo1WqjjGUkXbEJJwdahOc7L1yMCloO5CmmRFgJG2rKOooB42
	q9s9HWjPVjbnhlDlsMPIM72U1SyfxB309tzxy/7a+2Nvydo0qEpansQ6iYD/adOMj97Y7J1bl7g
	CjflFN4R8xpKrrLsc650CMYC2ast2VNRmkQlpGZ0ioyRDGmcWW0tr2Hroz8o5a26yMg4/TcSacU
	v1kEvecTgx0NQ/kONxfPwKhyX6ApjvnEmLqPNgZTxes9Iw73MbBTB0Nkd4CS8nVQl5Ft2hHulPt
	p41GagLt/pM9lSK8Y7frc6nwPJvd2rh5+7Y9H4PdjHjBU5kDl3ngsBDEb1DJodp9Kd+r6fk7LKK
	VMJJdjt35ELLvoVwtMsInV1qW+wWsEbALOkmlppLzl9xBm4QcBHolRg+Z/ZMBOxpcKULm0kkLX4
	4A5b4KM9Ne556/XZp2bSwinU+TTfLt9TTuYop+X6/+f3aB3GapezGt9/VBJhWPh5xPdQxUAuAhR
	8Xy7RF3UZK2U0zbcQrf7IiRFPUffuZz2ENkrMWZCWE8FtkpfrnkebQ9cekbSSLWa/4wDCHQYW6Q
	nYblq+BmZpvHg/DpYzePgP0VxIk5skQL72S5wT6uMBDTM0DQCEVaLiFjISkEKJNEdWsvYZfWOCB
	lxK27b95zCwYjPQ5HINc1F+eVcBLJLJ0ZIU4Xl+sB+jvM/h/xoek4+pkdFFaU1eBXOoCI+gaoo9
	Qr6r6crfGqd7Vz9HnemNlgHWxJRnIflX/SLA==
X-Received: by 2002:a05:6402:27c9:b0:6aa:e251:ecb4 with SMTP id 4fb4d7f45d1cf-6af9e0468eamr6985282a12.2.1791134202135;
        Sun, 04 Oct 2026 10:16:42 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb014784bsm2256819a12.3.2026.10.04.10.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:40 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 2/3] netfilter: flowtable: carry a priority into the offload
Date: Sun,  4 Oct 2026 19:16:35 +0200
Message-ID: <20261004171636.3545085-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171636.3545085-1-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Packets forwarded by the flowtable skip the ruleset, so a priority set
by "meta priority set" before "flow add" only applies to the first
packets of a connection, and drivers never see it.

Store skb->priority of the packet that creates the flow, apply it in
the software fast path and emit it as FLOW_ACTION_PRIORITY, the action
act_skbedit uses. Flows without a priority are unchanged. On IPv4,
ip_forward() derives a priority from the TOS by default, so a flow can
carry one without a rule. The priority applies to both directions.

airoha uses it as the QoS queue of flows that leave through a GDM port,
as its software path does, mtk ignores it like FLOW_ACTION_CSUM, and
mlx5 ignores it on flowtable flows (previous patch). airoha and mtk
parse tc flower rules in the same function, so they now also accept
skbedit priority there.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 Documentation/networking/nf_flowtable.rst       |  4 +++-
 drivers/net/ethernet/airoha/airoha_ppe.c        |  3 +++
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c |  1 +
 include/net/netfilter/nf_flow_table.h           |  1 +
 net/netfilter/nf_flow_table_ip.c                |  6 ++++++
 net/netfilter/nf_flow_table_offload.c           | 11 +++++++++++
 net/netfilter/nft_flow_offload.c                |  2 ++
 7 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
index d757c21c10f2..5844ab19aec6 100644
--- a/Documentation/networking/nf_flowtable.rst
+++ b/Documentation/networking/nf_flowtable.rst
@@ -71,7 +71,9 @@ forwarding path including the Netfilter hooks and the flowtable fastpath bypass.
 
 The flowtable entry also stores the NAT configuration, so all packets are
 mangled according to the NAT policy that is specified from the classic IP
-forwarding path. The TTL is decremented before calling neigh_xmit(). Fragmented
+forwarding path. The TTL is decremented before calling neigh_xmit(). The flow
+also stores the priority of the packet that created it, so a priority set before
+``flow add`` applies to the packets that the flowtable forwards. Fragmented
 traffic is passed up to follow the classic IP forwarding path given that the
 transport header is missing, in this case, flowtable lookups are not possible.
 TCP RST and FIN packets are also passed up to the classic IP forwarding path to
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 92611802801e..e790305ea955 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1161,6 +1161,9 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 		case FLOW_ACTION_REDIRECT:
 			odev = act->dev;
 			break;
+		case FLOW_ACTION_PRIORITY:
+			priority = act->priority;
+			break;
 		case FLOW_ACTION_CSUM:
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 99b28aaa7cc4..4ee99e8e4a34 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -378,6 +378,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 		case FLOW_ACTION_REDIRECT:
 			odev = act->dev;
 			break;
+		case FLOW_ACTION_PRIORITY:
 		case FLOW_ACTION_CSUM:
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..23218c8cbc3d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -202,6 +202,7 @@ struct flow_offload {
 	unsigned long				flags;
 	u16					type;
 	u32					timeout;
+	u32					priority;
 	struct rcu_head				rcu_head;
 };
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..c85e2d608c32 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -509,6 +509,9 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	ip_decrease_ttl(iph);
 	skb_clear_tstamp(skb);
 
+	if (flow->priority)
+		skb->priority = flow->priority;
+
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
@@ -1104,6 +1107,9 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	ip6h->hop_limit--;
 	skb_clear_tstamp(skb);
 
+	if (flow->priority)
+		skb->priority = flow->priority;
+
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..caaadffc2563 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -696,6 +696,17 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
+	if (flow->priority) {
+		struct flow_action_entry *entry;
+
+		entry = flow_action_entry_next(flow_rule);
+		if (!entry)
+			return -1;
+
+		entry->id = FLOW_ACTION_PRIORITY;
+		entry->priority = flow->priority;
+	}
+
 	tuple = &flow->tuplehash[dir].tuple;
 
 	for (i = 0; i < tuple->encap_num; i++) {
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..c8eaf7bc356d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -117,6 +117,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
+	flow->priority = pkt->skb->priority;
+
 	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
-- 
2.53.0

