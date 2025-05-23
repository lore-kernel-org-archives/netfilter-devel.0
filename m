Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA816292935;
	Fri, 23 May 2025 13:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006879; cv=none; b=ar6ereMLXS8dRNbi3bn8T/YzAjNIOcvIx1Gycq59nYJCS8yf/OWj9YgqZe+Z6BgVqFjewp2zzkGpIfG5+Z2YOJKmQOT02hkQ6HVR1ISdMD4bXDvrxoTtMAjI311xiuGeAlO2tAt8LqHI2REIqFfnvhrD0eYV8YDlsSnWZBEPae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006879; c=relaxed/simple;
	bh=XDQ0tLO/EZ7FEN9tiJzhtV2vp+j2OjzKeEzRijHGHXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qfMOxihP71HI7BCKeu96eh3l2ULfMSoyUdMCZw/l4RD0DW6s6oWy3NnpSF3DJrLpQ6YGD6Qe7jYt517usoHpu9DXxsoqiIRePe+9ttxLD0NC/Lm/Z/9TwfqKYTziAdelOQxO8pYzBvSdAFYEJpTcO9lP0GFyl1x2Zgb0MI64sXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gnck/S3z; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GfXU9NQj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gnck/S3z";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GfXU9NQj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5D5CE6029E; Fri, 23 May 2025 15:27:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006876;
	bh=BLpjsMX87D8mY75Cvazue0spW0/GyfhAZk3tvo5Ttho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnck/S3zNhwJMT/Fbum0U6tZ3S9zVgzhsfMLretrS/pwdIjjvlkCk2myTjCEBaxze
	 D5eHTnjA01R8ybyayVv9lB7Sz13zLX+hyUMmbtc1jOY8E5jyN6XzlOaBH6dj8CZiHy
	 uErRYD8BFFm+0fXDcQJp2prXO2tDSfe+JUwICfY45XiDfOUpyUkMH669YD4VvFR/Sl
	 IX2VLDT8XZ6zZa7D5GwBEwxVqR3xo1e0IusyHyNnaOUlBsXsnxYAKvB5S2ERs8ISHd
	 3QQOuhvFF6Pspr1INBFt3FykIDhNhHK4Kir0dRRw0UX8Q+DE4NA0oy7koyS5pcbAm+
	 aOyXSUXqN1tKg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5F87960765;
	Fri, 23 May 2025 15:27:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006848;
	bh=BLpjsMX87D8mY75Cvazue0spW0/GyfhAZk3tvo5Ttho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfXU9NQjNGhyybai1dlsEZitU+msohH6ZMCQtXRIpajQxV1S5l6EUVGOMGQFyg/o0
	 i4c8dnP4V4U3ZP5p7JYcWXNU/RL8r/Lp1Fl/eN57VgL+EfK9h7A0yZiXiWTl6qyKMU
	 saiL1HypgJrY9z1pXJj8z4RIxphQzS7xaA/EO2rK7tkOhh+od9ZhpGIvbJ15+yl1OQ
	 v8M9cNdFq1Exneq9WVDJW/0kz5Y6qC0EjJq5AEJjmXyYO12bANZwFYEW3UTVv/gHxJ
	 G0wno8SpJ+r521V603i0HYB+uPKvb6VN98h9M21DRMyw6XZp86DLlEm8uQiYaUKOOt
	 ruVM3o7GPz0EQ==
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
Date: Fri, 23 May 2025 15:26:59 +0200
Message-Id: <20250523132712.458507-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
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

