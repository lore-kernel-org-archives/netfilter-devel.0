Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE3A29AB1D;
	Thu, 22 May 2025 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932802; cv=none; b=j2kZ0wnj2boXymI1gnhU8pBcDV7jcEPVlIBrlzr0dO5cef701vNLB9MdIiztHot56Zw7y3emzPCMF8DY1pDX7O1HjSbVzr8l+9G8JKNv0vKNpoWi6e+qnSKo44yFO840XHPPM7d4LQL/spRXm2GLKbxjAv6uTdffGSfYTlO2bWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932802; c=relaxed/simple;
	bh=XDQ0tLO/EZ7FEN9tiJzhtV2vp+j2OjzKeEzRijHGHXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PlYyR4fnAAh5cEkGbxWZ+yy9B50nZ09yDdqFTe5B7wRjo+DL+lyi5jN1LjqLWaX3rBqAASJruAQ3bUCYhuDLhDGR10wZndhaTjZNz2D2SUmJtHxIV910BCbu3AQ3IIkbEPZkfL4fT8uq60AT+UJ2wbCBA+mqsL82hX7ldTRWhnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b66mNtrh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jwUWqN7g; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b66mNtrh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jwUWqN7g"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3CF21606E2; Thu, 22 May 2025 18:53:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932799;
	bh=BLpjsMX87D8mY75Cvazue0spW0/GyfhAZk3tvo5Ttho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b66mNtrhV/KnACSlqIalWokR4Qkuzb4q9ZwECRbdUlMV1rQ7qHkhUcmql1pkrWWKT
	 A7GXkTZcHdMVAIyNHaTkWdQgO8dGFDMMPUw7kAusQxaAeh85yXPdmWzH6dnq0sML+t
	 DEvnSZye+g4wJI4qmXDVPX+5mvPAQt42HgTLxEf9SrRyq0DOLPhC61DmP3Ieu/C3mD
	 ZjkuI3tJL6u5WkC2Cqc7kdWNXuK2GX3Rw9sq9L1I0euhiFTvXfHg8Myg1z3efMmgDt
	 k2hHGytRogUacaRERgmMUwEo4zQzu2AMIdz53ARhyGGZf4ebsT7qLjK+BpDpPlmQb0
	 SEWnajaDspB4w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 594896073D;
	Thu, 22 May 2025 18:52:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932775;
	bh=BLpjsMX87D8mY75Cvazue0spW0/GyfhAZk3tvo5Ttho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwUWqN7gx30WyAF08+epGiU6CjemCiHWHhPMAY2LVrbQRkLOVHNdrVl7Hruks4TQv
	 wGYIpTgNu00fOlfW0BkTvrXS3sBox1ZQHY2dVs76nf+4jqv4bd6YMp+UkxjrfSlzhq
	 tACdZbj4M1xCoFKhVFnxJ+Ghrt804IGRI02yOKp9lzuznnoG+jysKlTiHd+zRSeRGf
	 FXJAe85eNu9vg7zTstADLsycG4/CeSfwu2GNWkwFH5PBvgdwTnimhmO0RI+3zaaamw
	 gv8rAyTGDC37ZICCeprUangMbII+qTbslJuI1+WSbTS3bgX53foa/igWZf9TVG5RFa
	 inMVdPrdAYTDw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 13/26] netfilter: nf_tables: add packets conntrack state to debug trace info
Date: Thu, 22 May 2025 18:52:25 +0200
Message-Id: <20250522165238.378456-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.30.2

