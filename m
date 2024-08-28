Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C641AC438;
	Wed, 28 Aug 2024 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724881643; cv=none; b=MT9WgsGpjaiP6X8QepmhY531eGlNgj9hpXorkErF8/DihNwB1f0Ad6aUnM+ArvKH8e43gc23caMgYBVHShFgT/f19XDoJLfib4dZJgGiu9vHBcaKgdFzVg3EDzPgZASv9Bjl+JHv1GJ8FAW/PBnCtBFEoAvPdaLNXZVcYbHa9Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724881643; c=relaxed/simple;
	bh=l9zo+Siqyxe9QxRtclTXrGVatTjo4P7Ba7yEVR4Ua58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=erCNQEjzxmOyCSTrqftTqwV9i5xVyFr9BfPgS/MZhCPjN5mgK2a3NlkHRIz/lD+YMvYWy9uFt5vgKmGQDKIohXOU1c/rumQbY72njybUqkbOTo6Df29cwcGKsVpOvL35aG4DnCSKqPelDF+Z84mLV1tFQv1Eopdlgqp2FcVpD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 2/2] netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation
Date: Wed, 28 Aug 2024 23:47:08 +0200
Message-Id: <20240828214708.619261-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240828214708.619261-1-pablo@netfilter.org>
References: <20240828214708.619261-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From netdev/egress, skb->len can include the ethernet header, therefore,
subtract network offset from skb->len when validating IPv6 packet length.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_ipv6.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 467d59b9e533..a0633eeaec97 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -31,8 +31,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	struct ipv6hdr *ip6h, _ip6h;
 	unsigned int thoff = 0;
 	unsigned short frag_off;
+	u32 pkt_len, skb_len;
 	int protohdr;
-	u32 pkt_len;
 
 	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
 				  sizeof(*ip6h), &_ip6h);
@@ -43,7 +43,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	pkt_len = ntohs(ip6h->payload_len);
-	if (pkt_len + sizeof(*ip6h) > pkt->skb->len)
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	if (pkt_len + sizeof(*ip6h) > skb_len)
 		return -1;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-- 
2.30.2

