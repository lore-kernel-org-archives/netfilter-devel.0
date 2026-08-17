Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888DA3F3269;
	Mon, 17 Aug 2026 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009409; cv=none; b=TgB5tLvkDJ/woCW+0cvS8/OPQd/bxVR/cX56Ydm1GZgL7l6QWYdTIJjxooXrXv0DzFxRn6KZqgmYmwCSrzRNTl8b626tjx5F/TYk4tFT0qerLW3Ha4z57ZBVBpqtMMcH7n8L4VK7hs8PX4wxiAuNU2tatl3RT/r0PdbNPePABkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009409; c=relaxed/simple;
	bh=QQvuhruh716hml4fHHissdjiHU1M8hHWTGR67xGP6xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwMOpHbGLE8przDXCbva5Z53P+lmjFeZl4DXUAMPvq0FXQepnvZdTfkc1Wcs4lhbq9u6ou8Ri2zVJIUhrQGGQZSODVtbvP8EfPTK+5axKZphDehSxXM+Nj0uGl33fG2/DH+zhc8+QhUx/SfoEohY42zs67ItMfw9UhxFib7zy50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i2Nw6lml; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i2Nw6lml"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009405;
	bh=I+XUX5T3MloOr1Yhm8jqZbc3yYw+IV9YvJLbtWiXOoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2Nw6lml4WCbz/nbxzMXcaZbIrBL2/aeeoXszCKO8aBN1YFYnH9DulW6gsNnLjVOw
	 cYsUWrJi3QRnsmCLiWn6oSBUntBmqOw1t6PJX2sxST9EYroxMcfty+jLEbMcumkTPY
	 DxB1g4kSRt/NppklObGXprI1Q8Y/P37yVNigKXxEWK74Xlg848aM5cvs0PRPyB0BJL
	 b/aJ+Pt6rZEGDiL/zHN4uBjgUO6LiXxPLwXKNlAaznhfCqy1r0cmpy8Pm9d0XiC0JB
	 gnIWpbzbW91UNA5Lz1rF5tW23dGFSys9nlVnjyaeSq3OYGohDw/DtnqL0uZi/6Cbpu
	 TsBc62t87DCYA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A64246008C;
	Tue, 18 Aug 2026 01:30:04 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 1/8] netfilter: validate L4 headers after userspace packet writes
Date: Tue, 18 Aug 2026 01:29:50 +0200
Message-ID: <20260817232957.1281637-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

NFQUEUE and nft_payload can hand packet data modified by userspace back
to the stack. Recent restrictions keep link and network headers stable,
but transport header fields can still be changed.

A packet can therefore keep the same network header and conntrack entry
while changing the transport header layout. For TCP, increasing doff can
make later helper or NAT code use a different transport-header base than
the parser used, and can make offsets point past skb->tail.

Extend NFQUEUE payload validation to check the final L4 protocol and
known base headers after IPv4 options or IPv6 extension headers. Reject
packets whose L4 protocol no longer matches an attached non-template
conntrack entry, and reject IP fragments that already have such a
conntrack entry before trying to validate transport headers. Unknown L4
protocols are left to their normal protocol handlers.

For nft payload writes, reject transport-header stores that overlap TCP
doff. nft_nh_write_ok() already rejects network-header protocol changes,
so keeping doff stable prevents nft payload writes from changing the TCP
header length underneath conntrack and helper users.

This patch is a follow up to commit df07998dfd40 ("netfilter: nftables:
restrict linklayer and network header writes") and commit 54f34607d184
("netfilter: nfnetlink_queue: restrict writes to network header").

Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 72 +++++++++++++++++++++++++++++++--
 net/netfilter/nft_payload.c     | 13 ++++++
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b8aaf39cb4d8..c727668b0c5b 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -28,10 +28,17 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/ip.h>
 #include <linux/list.h>
+#include <linux/sctp.h>
 #include <linux/cgroup-defs.h>
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/gre.h>
 #include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
@@ -1206,10 +1213,62 @@ static bool nfqnl_validate_ipopts(const struct iphdr *iph_new,
 	return memcmp(iph_new + 1, ip_hdr(e->skb) + 1, ihl - sizeof(*iph_orig)) == 0;
 }
 
+static bool nfqnl_validate_l4(const u8 *data, unsigned int data_len,
+			      const struct nf_queue_entry *e, u8 proto,
+			      bool fragment)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(e->skb, &ctinfo);
+	if (ct && !nf_ct_is_template(ct)) {
+		if (fragment || nf_ct_protonum(ct) != proto)
+			return false;
+	}
+#endif
+
+	if (fragment)
+		return true;
+
+	switch (proto) {
+	case IPPROTO_TCP: {
+		const struct tcphdr *th = (const struct tcphdr *)data;
+		unsigned int thlen;
+
+		if (data_len < sizeof(*th))
+			return false;
+
+		thlen = __tcp_hdrlen(th);
+		if (thlen < sizeof(*th) || data_len < thlen)
+			return false;
+
+		return true;
+	}
+	case IPPROTO_UDP:
+		return data_len >= sizeof(struct udphdr);
+	case IPPROTO_ICMP:
+		return data_len >= sizeof(struct icmphdr);
+	case IPPROTO_ICMPV6:
+		return data_len >= sizeof(struct icmp6hdr);
+	case IPPROTO_SCTP:
+		return data_len >= sizeof(struct sctphdr);
+	case IPPROTO_GRE:
+		return data_len >= sizeof(struct gre_base_hdr);
+	case IPPROTO_AH:
+		return data_len >= sizeof(struct ip_auth_hdr);
+	case IPPROTO_ESP:
+		return data_len >= sizeof(struct ip_esp_hdr);
+	}
+
+	return true;
+}
+
 static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
 			       const struct nf_queue_entry *e)
 {
 	unsigned int ihl;
+	bool fragment;
 
 	if (data_len < sizeof(*iph))
 		return false;
@@ -1226,10 +1285,14 @@ static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
 	if (ntohs(iph->tot_len) != data_len)
 		return false;
 
+	fragment = iph->frag_off & htons(IP_MF | IP_OFFSET);
+
 	/* support for ipopts mangling would require
 	 * recompile + skb transport header update.
 	 */
-	return nfqnl_validate_ipopts(iph, e);
+	return nfqnl_validate_ipopts(iph, e) &&
+	       nfqnl_validate_l4((const u8 *)iph + ihl, data_len - ihl, e,
+				 iph->protocol, fragment);
 }
 
 static bool nfqnl_validate_one_exthdr(const u8 *data,
@@ -1273,6 +1336,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 	const u8 *data = (const u8 *)ip6_new;
 	u8 orig_nexthdr = ip6_orig->nexthdr;
 	u8 new_nexthdr = ip6_new->nexthdr;
+	bool fragment = false;
 
 	if (new_nexthdr != orig_nexthdr)
 		return false;
@@ -1286,7 +1350,8 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 		int hdrlen;
 
 		if (orig_nexthdr == NEXTHDR_NONE)
-			return true;
+			return nfqnl_validate_l4(data, data_len, e,
+						 new_nexthdr, fragment);
 
 		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
 			return false;
@@ -1297,6 +1362,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 
 		switch (orig_nexthdr) {
 		case NEXTHDR_FRAGMENT:
+			fragment = true;
 			hdrlen = sizeof(struct frag_hdr);
 			break;
 		case NEXTHDR_AUTH:
@@ -1323,7 +1389,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 		data += hdrlen;
 	}
 
-	return true;
+	return nfqnl_validate_l4(data, data_len, e, new_nexthdr, fragment);
 }
 
 static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 8a4472fd77d9..e315d35f73d4 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1067,6 +1067,17 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 	return false;
 }
 
+static bool nft_th_write_ok(const struct nft_pktinfo *pkt,
+			    const struct nft_payload_set *priv)
+{
+	unsigned int doff = offsetof(struct tcphdr, ack_seq) + sizeof(__be32);
+
+	if (pkt->tprot != IPPROTO_TCP)
+		return true;
+
+	return priv->offset > doff || priv->offset + priv->len <= doff;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -1105,6 +1116,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
+		if (!nft_th_write_ok(pkt, priv))
+			goto err;
 		offset = nft_thoff(pkt);
 		break;
 	case NFT_PAYLOAD_INNER_HEADER:
-- 
2.47.3

