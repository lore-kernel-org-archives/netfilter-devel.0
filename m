Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B1B3F9F3C
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932217; cv=none; b=lrJFPpkRR1iXdWqWdi6BZ+bs8YoBwK2xYLEVhQpV9+yQsBkPYYkvSDURzg2YWoAYf7YpfKP1lg8s55VtWmNTbzJZYIA8rvxRpkQF609OCX7nV35lCz1osRWC4ztodce0Vg4xEBWigehQAN2SLZAsqKEWhMJosFEq8QsWEKdjcWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932217; c=relaxed/simple;
	bh=sg0SG2bPie6YvfdNUG10UAcVOAhDCNU6VZkPqGxUD48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA4v7B/YgSKNZC3IesyM1PC2pFZb4njRhIVJZ2IHA1Fn4WzNpID1c4xUDBMeAPoAAwMydo9Ism2m7KTvPnEY7CZVHPDTAFjEKbo5mAlyPWqSCtAEPV9DRNOopDHjAr5bPNtEoD/IKkrZWgTo10RiemrCu6PDfEZ+J8jXLt0/0ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2E971602F8; Mon, 08 Jun 2026 17:23:34 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/3] netfilter: nfnetlink_queue: restrict writes to network header
Date: Mon,  8 Jun 2026 17:23:16 +0200
Message-ID: <20260608152324.20700-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608152324.20700-1-fw@strlen.de>
References: <20260608152324.20700-1-fw@strlen.de>
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
 net/netfilter/nfnetlink_queue.c | 192 ++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 60ab88d45096..83c7b24e76be 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1136,6 +1136,195 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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
+	    ((iph->frag_off ^ ip_hdr(e->skb)->frag_off) & ~htons(IP_DF)) != 0)
+		return false;
+
+	/* BIG TCP won't work; netlink attr len is u16 */
+	if (ntohs(iph->tot_len) != data_len)
+		return false;
+
+	/* support for ipopts mangling would require
+	 * recompile + skb transport header update.
+	 */
+	return nfqnl_validate_ipopts(iph, e);
+}
+
+static bool nfqnl_validate_one_exthdr(const u8 *data,
+				      unsigned int data_len,
+				      const struct nf_queue_entry *e,
+				      int start, int hdrlen)
+{
+	u16 octets;
+
+	if (data_len < hdrlen || hdrlen < 2)
+		return false;
+
+	while (hdrlen > 0) {
+		if (data_len < sizeof(octets))
+			return false;
+		data_len -= sizeof(octets);
+
+		if (skb_copy_bits(e->skb, start, &octets, sizeof(octets)))
+			return false;
+
+		if (hdrlen < sizeof(octets))
+			return false;
+
+		hdrlen -= sizeof(octets);
+		if (memcmp(data, &octets, sizeof(octets)))
+			return false;
+
+		start += sizeof(octets);
+		data += sizeof(octets);
+	}
+
+	return true;
+}
+
+static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
+				  unsigned int data_len,
+				  const struct nf_queue_entry *e)
+{
+	const struct ipv6hdr *ip6_orig = ipv6_hdr(e->skb);
+	int exthdr_cnt = 0, start = sizeof(*ip6_orig);
+	const u8 *data = (const u8 *)ip6_new;
+	u8 orig_nexthdr = ip6_orig->nexthdr;
+	u8 new_nexthdr = ip6_new->nexthdr;
+
+	if (new_nexthdr != orig_nexthdr)
+		return false;
+
+	data += sizeof(*ip6_new);
+	data_len -= sizeof(*ip6_new);
+
+	while (ipv6_ext_hdr(orig_nexthdr)) {
+		const struct ipv6_opt_hdr *hp;
+		struct ipv6_opt_hdr _hdr;
+		int hdrlen;
+
+		if (orig_nexthdr == NEXTHDR_NONE)
+			return true;
+
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			return false;
+
+		hp = skb_header_pointer(e->skb, start, sizeof(_hdr), &_hdr);
+		if (!hp)
+			return false;
+
+		switch (orig_nexthdr) {
+		case NEXTHDR_FRAGMENT:
+			hdrlen = sizeof(struct frag_hdr);
+			break;
+		case NEXTHDR_AUTH:
+			hdrlen = ipv6_authlen(hp);
+			break;
+		default:
+			hdrlen = ipv6_optlen(hp);
+			break;
+		}
+
+		if (!nfqnl_validate_one_exthdr(data, data_len, e,
+					       start, hdrlen))
+			return false;
+
+		orig_nexthdr = hp->nexthdr;
+		hp = (const void *)data;
+		new_nexthdr = hp->nexthdr;
+
+		if (new_nexthdr != orig_nexthdr)
+			return false;
+
+		data_len -= hdrlen;
+		start += hdrlen;
+		data += hdrlen;
+	}
+
+	return true;
+}
+
+static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len,
+			       const struct nf_queue_entry *e)
+{
+	if (data_len < sizeof(*ip6))
+		return false;
+
+	/* BIG TCP/jumbograms won't work; netlink attr len is u16 */
+	if (ntohs(ip6->payload_len) != data_len - sizeof(*ip6))
+		return false;
+
+	if (ip6->version != 6)
+		return false;
+
+	return nfqnl_validate_exthdr(ip6, data_len, e);
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
+		return nfqnl_validate_ip6(data, data_len, e) &&
+		       !(IP6CB(e->skb)->flags & IP6SKB_JUMBOGRAM);
+	case NFPROTO_BRIDGE:
+		return nfqnl_validate_br(data, data_len);
+	}
+
+	return false;
+}
+
 static int
 nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
@@ -1144,6 +1333,9 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 	if (e->state.net->user_ns != &init_user_ns)
 		return -EPERM;
 
+	if (!nfqnl_validate_write(data, data_len, e))
+		return -EINVAL;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
-- 
2.53.0

