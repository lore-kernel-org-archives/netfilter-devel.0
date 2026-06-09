Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58294028DE
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005934; cv=none; b=CFmdXd9W4clCGivZyeyfP9EeuiU2wJptzEHD3/h5kqeaS5IjSZ7dyEAfT1QxGKbeXIQ4OpKZbd3xCEvA1OH1sKePWVWY8ZpdR53dtbuUxP9AacjOzDWcoczddUfNcu0+OB1TGYW4L5FwSap2Fro+LK0aDU0/AtO2M+VPzEM2jIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005934; c=relaxed/simple;
	bh=lbEQGr8bbRAyvn3x7yS6nfELdgdWpgcI+oWSQMNeU7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh5pod3HKIAskHKqI7ykY9n4mrnVFEhrleT/D4XV6537CmB92zyR8cjNaLzl3oHFIXqYHe4w6N49j3tssHAhOdYwl8fLP/Yt4JM9da+f/fMB49nWfNYSXjsfcNlVGCo2+I9QW1jbOQhHSwWXAuHimiFfZLybvFNUPSPUe2TClJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 26343605BD; Tue, 09 Jun 2026 13:52:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 1/3] netfilter: nfnetlink_queue: restrict writes to network header
Date: Tue,  9 Jun 2026 13:51:53 +0200
Message-ID: <20260609115201.2563-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609115201.2563-1-fw@strlen.de>
References: <20260609115201.2563-1-fw@strlen.de>
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

Add minimal validation of the new ip/ipv6 header.  Check total len
matches skb length.  Disallow ip option modifications after prerouting.

IPv6 extension headers are also disabled.
IP options and exthdrs could be allowed later after validation pass or
ip option recompile.

Transport header is not checked.

Bridge modifications are rejected.  Given userspace doesn't even receive
L2 headers, use is limited and I don't think there are any users of
bridge nfnetlink_queue, let alone users that modifiy payload.

Arp isn't supported at all.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: don't support bridge writes for now; I don't think there are users.

 net/netfilter/nfnetlink_queue.c | 170 ++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 60ab88d45096..48fdef7ef145 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1136,6 +1136,173 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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
+static bool nfqnl_validate_write(const void *data, unsigned int data_len,
+				 const struct nf_queue_entry *e)
+{
+	switch (e->state.pf) {
+	case NFPROTO_IPV4:
+		return nfqnl_validate_ip4(data, data_len, e);
+	case NFPROTO_IPV6:
+		return nfqnl_validate_ip6(data, data_len, e) &&
+		       !(IP6CB(e->skb)->flags & IP6SKB_JUMBOGRAM);
+	case NFPROTO_BRIDGE:
+		/* No write support. Bridge is dubious: userspace doesn't even see L2 header */
+		return false;
+	}
+
+	return false;
+}
+
 static int
 nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
@@ -1144,6 +1311,9 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 	if (e->state.net->user_ns != &init_user_ns)
 		return -EPERM;
 
+	if (!nfqnl_validate_write(data, data_len, e))
+		return -EINVAL;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
-- 
2.53.0

