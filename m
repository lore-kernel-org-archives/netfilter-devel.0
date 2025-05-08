Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D58F27FD4F
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716988; cv=none; b=fEvD1zC+MF0/GyBN5rSJcYUgyKk7hZIAV6wt6rrrLxME6Urs4OkDIp6zPqcHWRlneysBKotAh7U0Zen9HvWcNvHVzcNWq5JHubbCAQ4mzqGPG1smCJJETlzboMWARtCkxUkS7RcCQ2F/IMIvu/0Ic9zkJZHS2XPX3bowG5dzWuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716988; c=relaxed/simple;
	bh=qAxtul1JmapCF1JWaqve2nIKLCXRfz6pj8RHpwwo7XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YphuMaQsWscp/TT7iapKgHerdpTURftCArU8z7grZqMWsSI+Vovrij3m7HJdDCvOuMx9UFr/ZplsIM0DQQXSUw3fizQb7hf6ML7VEvKSHvvsHL+P9N9Jdfy/N70rZMLXTbj/iX0ylrHNsqNv4PcOAtDRdojNkbUXpIP8W1oZCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uD2sa-0004uV-EH; Thu, 08 May 2025 17:09:44 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: add packets conntrack state to debug trace info
Date: Thu,  8 May 2025 17:08:52 +0200
Message-ID: <20250508150855.6902-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508150855.6902-1-fw@strlen.de>
References: <20250508150855.6902-1-fw@strlen.de>
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
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_trace.c          | 65 +++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7d6bc19a0153..19cddbd1a315 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1841,6 +1841,7 @@ enum nft_xfrm_keys {
  * @NFTA_TRACE_MARK: nfmark (NLA_U32)
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ * @NFTA_TRACE_CT: connection tracking information (NLA_NESTED: nft_ct_keys)
  */
 enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
@@ -1861,6 +1862,7 @@ enum nft_trace_attributes {
 	NFTA_TRACE_NFPROTO,
 	NFTA_TRACE_POLICY,
 	NFTA_TRACE_PAD,
+	NFTA_TRACE_CT,
 	__NFTA_TRACE_MAX
 };
 #define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 580c55268f65..ba8b0a8c00e6 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -15,6 +15,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
@@ -90,6 +91,59 @@ static int nf_trace_fill_dev_info(struct sk_buff *nlskb,
 	return 0;
 }
 
+static int nf_trace_fill_ct_info(struct sk_buff *nlskb,
+				 const struct sk_buff *skb)
+{
+	const struct nf_ct_hook *ct_hook;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	struct nlattr *nest;
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
+	nest = nla_nest_start(nlskb, NFTA_TRACE_CT);
+	if (!nest)
+		return -1;
+
+	if (nla_put_be32(nlskb, NFT_CT_STATE, htonl(state)))
+		goto nla_put_failure;
+
+	if (ct) {
+		u32 id = ct_hook->get_id(&ct->ct_general);
+		u32 status = READ_ONCE(ct->status);
+		u8 dir = CTINFO2DIR(ctinfo);
+
+		if (nla_put_u8(nlskb, NFT_CT_DIRECTION, dir))
+			goto nla_put_failure;
+
+		if (nla_put_be32(nlskb, NFT_CT_ID, (__force __be32)id))
+			goto nla_put_failure;
+
+		if (status && nla_put_be32(nlskb, NFT_CT_STATUS, htonl(status)))
+			goto nla_put_failure;
+	}
+
+	nla_nest_end(nlskb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(nlskb, nest);
+	return -1;
+}
+
 static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 				  const struct nft_pktinfo *pkt)
 {
@@ -210,7 +264,12 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 		nla_total_size(sizeof(__be32)) +	/* trace type */
 		nla_total_size(0) +			/* VERDICT, nested */
 			nla_total_size(sizeof(u32)) +	/* verdict code */
-		nla_total_size(sizeof(u32)) +		/* id */
+		nla_total_size(0) +			/* nft_ct_keys, nested */
+			nla_total_size(sizeof(u8)) +	/* direction */
+			nla_total_size(sizeof(u32)) +	/* state */
+			nla_total_size(sizeof(u32)) +	/* status */
+			nla_total_size(sizeof(u32)) +	/* id */
+		nla_total_size(sizeof(u32)) +		/* trace id */
 		nla_total_size(NFT_TRACETYPE_LL_HSIZE) +
 		nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE) +
 		nla_total_size(NFT_TRACETYPE_TRANSPORT_HSIZE) +
@@ -291,6 +350,10 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 
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

