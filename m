Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F747ACF0
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 09:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788254803; cv=none; b=SRKJgzKL9ZfcVfkGeoOrN9VuXFqe1VEe15HlkAGpO3ljNle7F/WQ6+xWFzdDJoVWlMBTwtEpl915xpX/gTYZwzXXwN1SO5hKlmEsn+CtJl5jIVlNHz2bm3bnYY81J/AAA9D7dD2bgqIijtq2SBKD/bNZxfjKWqq6xErJ0EB/Za8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788254803; c=relaxed/simple;
	bh=486JyvxoR2eg9x09oSX4uB43Q8gO3J5bOat7K487kfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TyiJFRFPvVGxCtQ2yH5yEhNUlLUqcfvnPUYkH1Sh61NQQQlClS4O+QroWxdkUHZyfcgQd+kHT5LptRVnJCKgLQm2CJ+UOXQ9RBbVuMb65PnPEOXy7GNw3P72kMHtU3RUx244/p0uux8Tos/o9iX89OZjiKlVW6TB6IJpO0H1OSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=qOrJRXdB; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="qOrJRXdB"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2531f453eeso691871766b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 02:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788254799; x=1788859599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=W02+miOc40enO8Kk7fWVAuXmWTmU4/GB4n7lg/BSofo=;
        b=qOrJRXdB3HevmYq39yGXrM7ck8HCbpJ1c9eIxEPRGaxZlJ0Ezsmh0YH9LhCcuZAtBA
         RMw8pYaT1/FGIf+fQ8DWDWGMabT9eIS0kX5RDP3Hkp5j3/AWignHYUZFBqEGGt6gBOOs
         ijwBmOZIiakVWW5j7pjbjPLYFbC5xNfAAYgKYVQVLIPL0eRwo7lRDoFEYyCA3f/gKrVd
         iCMe26eb2xzVyJxRXa5ioBrFe0c8TPuZoH42YLe0isoZfZsu4g28tln0CVda3SCFMsdP
         HvE/nSHzg4Au2RdpVreOs9CX2riK1Khr2U+9mMoq4TRAQsDCdSElbkG6TXr7PODkEOF1
         CFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788254799; x=1788859599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W02+miOc40enO8Kk7fWVAuXmWTmU4/GB4n7lg/BSofo=;
        b=aGeSqmxNVEuqTfDXnNj7SFfqNkNQQIRg4gYYxiX6Yl3WzAZNXI7eQLb/yJc7KAYHk8
         /EVkljlvP5NyfJuGiirG1HQkurN4+5yvy8IuGXiCE+VAa5Q48ZyisRKp4mlQY8rte9kZ
         BzoxO7X/1v4z1PtEA0Ov9VKM8/Noi4FV31iADIIqhGuQKve/okiti9UtX0MZzF+UcDGg
         yTlVUkopKzz6oDFjKiv6cKVSo1EXSfkO5rYsDENLQiFXjtFk7k7Dy7J6owzfiVADykCf
         big9vCiqpbkqiZal3V402NN0Lq4Xfw2O0cl8OgVt9J13x1/n/tGfQbOxoY/aEx9dg79s
         UQ1g==
X-Forwarded-Encrypted: i=1; AHgh+Rp/z3RsCW7PZ7yNHxU6fH5g4Wdc5FSgW27b6TjWbOJf+9pKY4YBBDuyBvU+uTQGNKNRWQy31d/XVZUKm2m4Bn4=@vger.kernel.org
X-Gm-Message-State: AFuF++ln1wlcKQR5Y7Z0VyPfKKDcfvXOxNw2q+EyclW8xRx73b+ciHy5
	PDsh/WDvGw5dtVuwAkBE5fDzjNZzJTSTZXvGq8fMtWqvBCP3w17y5ws4jEAEsQscEg==
X-Gm-Gg: AR+sD10htfrHka0ahhnBmOxhnxWM5e2WhDVnVoNFUzgcKFsFeFN0Cv0k5Jzl8o4baqr
	MGV5kVRlQzn8Ix6cBA/rlkXO2eZC6c78HMM4ohAp5n0GsiBJQ3cPySNlwT3p9F19ncpPOvRUOpQ
	T051RvEV6Bmsj97c59NFmBLV+UyxxLvZA5nAMA+IQZ1qqYVokskEFyEq4qkkhkSPILPIZAtpT5p
	5U8yZoUPZfLN39kLJioGpEsVN6OJRJmsdkNVVVmQqCJ5Ia7K73u/xnS9Ocr62Nppf+euR3TBtRi
	b8G5vh/gbXa5R0XmR6Sn55Im6/jWZCW6TQ0M+Y6/y8zZr+/NJyrDi7BonC25D6F5wuh37CtwDLn
	SWtEs07lKeIEPbIiTPpnHKX895/qSDwRTXONEnV2oXMDyZkfhk/3DRxah5awnK9onSUx1ox4UuB
	hgELDxg7aeKjsRnZ4CbMunasXbQhC3wiWeHc58+EstluvQYdKAan0weC9BRz3dEy62KFrW46Mc2
	dFaWYrn9uZxuwqm3K8E3ng8f5++J23ZEDo2WSHYzuKGsclXCxYDNJWbuVls4u2ds960amGBFGuY
	22Qfj6fosJUYJw2dlt/hBTEwdmZfzo+A4WFI5d5Yj/OWNvZwUhvKwqfI88U3jgJQOtaGahoMQsn
	1CaSly9znhSCbJXOUuKn4derKdWEbznceU0o6pUK0S4EGRrXgBKhbrRQTr34WZ+xTGca7Yli1
X-Received: by 2002:a17:907:1c28:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c25b3cc9a35mr447457466b.11.1788254799343;
        Tue, 01 Sep 2026 02:26:39 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.129.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f1fb965sm574724766b.49.2026.09.01.02.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 02:26:38 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: carry a priority into the offload
Date: Tue,  1 Sep 2026 11:26:32 +0200
Message-ID: <20260901092632.369248-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A flow rule handed to a driver describes NAT, encapsulation and the
output device, but not how the flow should be treated on the way out,
so hardware with priority queues can only fall back on the DSCP the
packet carries.

Carry skb->priority of the packet that created the flow and emit it as
FLOW_ACTION_PRIORITY, the action act_skbedit already emits on the tc
path. "meta priority set" before "flow add" then reaches the hardware.
A flow without a priority emits no action; mtk and airoha, the two
in-tree consumers of these rules, ignore the new one as they do
FLOW_ACTION_CSUM.

The flowtable holds one flow for both directions and the expression
runs once, so the priority applies to both; per-direction
classification is not carried.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
The consumer of the emitted action is a DSA driver for the IPQ8074 PPE,
maintained in OpenWrt; measured there, "meta priority set" ahead of
"flow add" places offloaded flows in the port's hardware priority
queues. The mtk and airoha hunks are compile-tested only. The new field
grows struct flow_offload by eight bytes on 64-bit; the entry allocates
from its own kmem_cache, so no allocation-class change.

 drivers/net/ethernet/airoha/airoha_ppe.c        |  1 +
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c |  1 +
 include/net/netfilter/nf_flow_table.h           |  1 +
 net/netfilter/nf_flow_table_offload.c           | 11 +++++++++++
 net/netfilter/nft_flow_offload.c                |  7 +++++++
 5 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 92611802801e..2afce76ad131 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1161,6 +1161,7 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 		case FLOW_ACTION_REDIRECT:
 			odev = act->dev;
 			break;
+		case FLOW_ACTION_PRIORITY:
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
index 32b4281038dd..dd3ac2b9c963 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -117,6 +117,13 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
+	/* Whatever classified this packet before it reached the flowtable also
+	 * describes every packet the hardware will forward in its place, so
+	 * carry it into the offload rather than losing it with the software
+	 * path.
+	 */
+	flow->priority = pkt->skb->priority;
+
 	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)

base-commit: 91ec2035134982b98fab0609a9fd8480e8217dc1
-- 
2.53.0

