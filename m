Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBFB3D16F0
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 12:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779883925; cv=none; b=bzlU5enHJuOahdLRmMZgd9BgkqY7V6/917ks/fpFgjpJHASphna5XWuFT9tzB+g6i122Bdb0HOJYBerUyOGCo1Jg+B/Kkxtdutck4XPBdQgc5xfzDV6xMrpkq2Mv7umsXOtPyniQULGICc/gAb5sEv5drAkr/Bfw58SoIVov2kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779883925; c=relaxed/simple;
	bh=2Ip2ZFt1V4FhOQDHJEzwlSUuoeoHWXGWX7zoZRwM/xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7y0//Npi3WOKWhxHgfUKNtUgdskSi+/uRkEZ8fjLdSnH0xYkTeUaL/VzivydF6gZgDgPab9d8M2KtbqTpn6tNZ1igPW86CceGLuqEkkNjfC6zQ/52u6+E5JRRH6iA1u0mY+nlYROXy2N/Cc3fnZf8wF1HPGmgMHE1xI85CTLzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5B0F7602AB; Wed, 27 May 2026 14:12:02 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC nf 1/2] netfilter: nfnetlink_queue: restrict writes to network header
Date: Wed, 27 May 2026 14:11:43 +0200
Message-ID: <20260527121147.22076-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527121147.22076-1-fw@strlen.de>
References: <20260527121147.22076-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nfnetlink_queue doesn't allow selective replacements of some part of the
payload, only complete replacement.
If the new data is shorter, skb is trimmed, otherwise expanded.

Add minimal validation of the new ip/ipv6 header.
Check total len matches skb length.  Disallow
ip option modifications after prerouting.

IPv6 extension headers are also disabled.
IP options and exthdrs could be allowed later after validation pass or
ip option recompile.

Transport header is not checked.
Bridge gets no validation other than size isn't below ethernet header
size.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 103 +++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 60ab88d45096..ae4257384e8e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1136,14 +1136,115 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	return err;
 }
 
+static bool nfqnl_validate_ipopts(const struct iphdr *iph_new,
+				  const struct nf_queue_entry *e)
+{
+	const struct iphdr *iph_orig = ip_hdr(e->skb);
+	unsigned int ihl = iph_new->ihl * 4;
+
+	if (iph_new->ihl != iph_orig->ihl)
+		return false;
+	if (ihl == sizeof(*iph_orig))
+		return true;
+
+	return memcmp(iph_new + 1, ip_hdr(e->skb) + 1, ihl - sizeof(*iph_orig)) == 0;
+}
+
+static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
+			       const struct nf_queue_entry *e)
+{
+	unsigned int ihl;
+
+	if (data_len < sizeof(*iph))
+		return false;
+
+	ihl = iph->ihl * 4u;
+	if (ihl < sizeof(*iph) || data_len < ihl)
+		return false;
+
+	if (iph->version != 4 ||
+	    iph->frag_off != ip_hdr(e->skb)->frag_off ||
+	    ntohs(iph->tot_len) != data_len)
+		return false;
+
+	/* ip parses (validates) options after PRE_ROUTING hook.
+	 * Do not allow later ip option modifications.
+	 */
+	if (e->state.hook != NF_INET_PRE_ROUTING &&
+	    !nfqnl_validate_ipopts(iph, e))
+		return false;
+
+	return true;
+}
+
+static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len)
+{
+	if (data_len < sizeof(*ip6))
+		return false;
+
+	/* netlink attribute size is limited to 2**16 - sizeof netlink header,
+	 * so we cannot support jumbograms.
+	 */
+	if (ntohs(ip6->payload_len) != data_len - sizeof(*ip6))
+		return false;
+
+	if (ip6->version != 6 ||
+	    ipv6_ext_hdr(ip6->nexthdr))
+		return false;
+
+	return true;
+}
+
+static bool nfqnl_validate_arp(unsigned int data_len)
+{
+	const unsigned int minsz = 8 + 2 * ETH_ALEN + 2 * sizeof(__be32);
+
+	/* don't allow truncation below min size */
+	return data_len >= minsz;
+}
+
+static bool nfqnl_validate_br(const struct ethhdr *eth, unsigned int data_len)
+{
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+	/* disallow truncation below ethernet header size */
+	if (data_len < sizeof(*eth))
+		return false;
+
+	return true;
+#else
+	return false;
+#endif
+}
+
+static bool nfqnl_validate_write(const void *data, unsigned int data_len,
+				 const struct nf_queue_entry *e)
+{
+	switch (e->state.pf) {
+	case NFPROTO_ARP:
+		return nfqnl_validate_arp(data_len);
+	case NFPROTO_IPV4:
+		return nfqnl_validate_ip4(data, data_len, e);
+	case NFPROTO_IPV6:
+		return nfqnl_validate_ip6(data, data_len) &&
+		       !(IP6CB(e->skb)->flags & IP6SKB_JUMBOGRAM);
+	case NFPROTO_BRIDGE:
+		return nfqnl_validate_br(data, data_len);
+	}
+
+	return false;
+}
+
 static int
-nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
+nfqnl_mangle(const void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
 	struct sk_buff *nskb;
 
 	if (e->state.net->user_ns != &init_user_ns)
 		return -EPERM;
 
+	if (!nfqnl_validate_write(data, data_len, e))
+		return -EINVAL;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
-- 
2.53.0

