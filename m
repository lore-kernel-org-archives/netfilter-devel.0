Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5393228C2BE
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 13:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922020; cv=none; b=HQPLb8mQjq4h2TA4CrYSO/mHtBnCk7cCLdB9yLnRzy2xOARGywXCPsRINBCT7OxsF0MNCQ2IobV3wc4QJv2U5L/WuhWJeeFftLz+CVrzmBZaS2wF4NfhyfyB6pGmwIFySkKcCv08gwdlZe6mznWyhKn4jW1X/ptDivFixiSBBjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922020; c=relaxed/simple;
	bh=KgmvkRml08cypLnkcMnPBXEonFe6NiqStw8XjA6DBPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkb5OAGxmZM+RmcY+dcUaLjlP1vbMgZqKRLzRg3tWePF2CUKA4fPjY6DfEMdrMvA6xnrY1NCHyjF1n7xBZWc9amWeNwsZ7QJoA3y1tK6INUVYNp52qRHKHBXsnHuQC7eknU1hWdSDJOA1Ynrcho0Q0e3yJiJIThpEtK57pW9g3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 92A156014F; Thu, 22 May 2025 15:53:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/2] netfilter: nf_tables: add packets conntrack state to debug trace info
Date: Thu, 22 May 2025 15:49:34 +0200
Message-ID: <20250522134938.30351-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250522134938.30351-1-fw@strlen.de>
References: <20250522134938.30351-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the minimal relevant info needed for userspace ("nftables monitor
trace") to provide the conntrack view of the packet:

- state (new, related, established)
- direction (original, reply)
- status (e.g., if connection is subject to dnat)
- id (allows to query ctnetlink for remaining conntrack state info)

Example:
trace id a62 inet filter PRE_RAW packet: iif "enp0s3" ether [..]
  [..]
trace id a62 inet filter PRE_MANGLE conntrack: ct direction original ct state new ct id 32
trace id a62 inet filter PRE_MANGLE packet: [..]
 [..]
trace id a62 inet filter IN conntrack: ct direction original ct state new ct status dnat-done ct id 32
 [..]

In this case one can see that while NAT is active, the new connection
isn't subject to a translation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: - use flat representation (no NLA_NESTED) and don't use
 nft_ct_keys.

 include/uapi/linux/netfilter/nf_tables.h |  8 ++++
 net/netfilter/nf_tables_trace.c          | 54 +++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7d6bc19a0153..2beb30be2c5f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1841,6 +1841,10 @@ enum nft_xfrm_keys {
  * @NFTA_TRACE_MARK: nfmark (NLA_U32)
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ * @NFTA_TRACE_CT_ID: conntrack id (NLA_U32)
+ * @NFTA_TRACE_CT_DIRECTION: packets direction (NLA_U8)
+ * @NFTA_TRACE_CT_STATUS: conntrack status (NLA_U32)
+ * @NFTA_TRACE_CT_STATE: packet state (new, established, ...) (NLA_U32)
  */
 enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
@@ -1861,6 +1865,10 @@ enum nft_trace_attributes {
 	NFTA_TRACE_NFPROTO,
 	NFTA_TRACE_POLICY,
 	NFTA_TRACE_PAD,
+	NFTA_TRACE_CT_ID,
+	NFTA_TRACE_CT_DIRECTION,
+	NFTA_TRACE_CT_STATUS,
+	NFTA_TRACE_CT_STATE,
 	__NFTA_TRACE_MAX
 };
 #define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 580c55268f65..ae3fe87195ab 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -15,6 +15,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
@@ -90,6 +91,49 @@ static int nf_trace_fill_dev_info(struct sk_buff *nlskb,
 	return 0;
 }
 
+static int nf_trace_fill_ct_info(struct sk_buff *nlskb,
+				 const struct sk_buff *skb)
+{
+	const struct nf_ct_hook *ct_hook;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	u32 state;
+
+	ct_hook = rcu_dereference(nf_ct_hook);
+	if (!ct_hook)
+		return 0;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct) {
+		if (ctinfo != IP_CT_UNTRACKED) /* not seen by conntrack or invalid */
+			return 0;
+
+		state = NF_CT_STATE_UNTRACKED_BIT;
+	} else {
+		state = NF_CT_STATE_BIT(ctinfo);
+	}
+
+	if (nla_put_be32(nlskb, NFTA_TRACE_CT_STATE, htonl(state)))
+		return -1;
+
+	if (ct) {
+		u32 id = ct_hook->get_id(&ct->ct_general);
+		u32 status = READ_ONCE(ct->status);
+		u8 dir = CTINFO2DIR(ctinfo);
+
+		if (nla_put_u8(nlskb, NFTA_TRACE_CT_DIRECTION, dir))
+			return -1;
+
+		if (nla_put_be32(nlskb, NFTA_TRACE_CT_ID, (__force __be32)id))
+			return -1;
+
+		if (status && nla_put_be32(nlskb, NFTA_TRACE_CT_STATUS, htonl(status)))
+			return -1;
+	}
+
+	return 0;
+}
+
 static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 				  const struct nft_pktinfo *pkt)
 {
@@ -210,7 +254,11 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 		nla_total_size(sizeof(__be32)) +	/* trace type */
 		nla_total_size(0) +			/* VERDICT, nested */
 			nla_total_size(sizeof(u32)) +	/* verdict code */
-		nla_total_size(sizeof(u32)) +		/* id */
+		nla_total_size(sizeof(u32)) +		/* ct id */
+		nla_total_size(sizeof(u8)) +		/* ct direction */
+		nla_total_size(sizeof(u32)) +		/* ct state */
+		nla_total_size(sizeof(u32)) +		/* ct status */
+		nla_total_size(sizeof(u32)) +		/* trace id */
 		nla_total_size(NFT_TRACETYPE_LL_HSIZE) +
 		nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE) +
 		nla_total_size(NFT_TRACETYPE_TRANSPORT_HSIZE) +
@@ -291,6 +339,10 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 
 		if (nf_trace_fill_pkt_info(skb, pkt))
 			goto nla_put_failure;
+
+		if (nf_trace_fill_ct_info(skb, pkt->skb))
+			goto nla_put_failure;
+
 		info->packet_dumped = true;
 	}
 
-- 
2.49.0

