Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F205D13A258
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746023; cv=none; b=ix3WhiXjw6Zuyjol+9q4yOxhpKddY9PUXn3eSKzjcf20CFLnqAY1D10+x625ExmCsc/zYTAVQU/BeJPAhftrtM2fJ6echjCi1uWwRyXs8KO2hwAzaJd3pzyIFtwx7/KI8tkZcIpifz5Z4WWe+0ypDHqhG9sI420CNHICHn3gh+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746023; c=relaxed/simple;
	bh=AKTyDWdCFofVwTBNBQAbVUB+t/I945u7zwQ4bFLldTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppq9SRdflLOPdKiXIsBZXp4AjhWySIXNDCAVYlstqMVBBw2CGz9ZYKVHktMNJgOwe6rO1fW95dh+Vz91gxf1hWgENYswnFCy5QWDdr6mMf+UTddrYo7WQVF337CosaA0K+BKhq5zYQ0zqT0WSpcc4JnQ4+bLYgnXywFUghkZfFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 977A160468; Fri, 18 Sep 2026 17:40:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 4/6] netfilter: conntrack: replace open-coded helper invocation
Date: Fri, 18 Sep 2026 16:58:07 +0200
Message-ID: <20260918145809.12938-5-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918145809.12938-1-fw@strlen.de>
References: <20260918145809.12938-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace duplicated logic with the new nf_ct_call_helper() helper.
No functional changes intended, except the additional checks to
ensure the helper can process the given packet.

LLM complains about the the existing early !helper-return in
nf_ct_helper(), but I prefer to keep this as-is.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ovs.c | 53 +-------------------------------
 1 file changed, 1 insertion(+), 52 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index b4085af3ad1c..fa64ec168e6e 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -12,16 +12,8 @@
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		 enum ip_conntrack_info ctinfo, u16 proto)
 {
-	int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
-			 struct nf_conn *ct,
-			 enum ip_conntrack_info conntrackinfo);
 	const struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *help;
-	unsigned int protoff;
-	int err;
-
-	if (ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
 
 	help = nfct_help(ct);
 	if (!help)
@@ -35,50 +27,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 	    helper->nfproto != proto)
 		return NF_ACCEPT;
 
-	switch (proto) {
-	case NFPROTO_IPV4:
-		protoff = ip_hdrlen(skb);
-		proto = ip_hdr(skb)->protocol;
-		break;
-	case NFPROTO_IPV6: {
-		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-		__be16 frag_off;
-		int ofs;
-
-		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				       &frag_off);
-		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
-			pr_debug("proto header not found\n");
-			return NF_ACCEPT;
-		}
-		protoff = ofs;
-		proto = nexthdr;
-		break;
-	}
-	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
-		return NF_DROP;
-	}
-
-	if (helper->l4proto != proto)
-		return NF_ACCEPT;
-
-	helper_cb = rcu_dereference(helper->help);
-	if (!helper_cb)
-		return NF_ACCEPT;
-
-	err = helper_cb(skb, protoff, ct, ctinfo);
-	if (err != NF_ACCEPT)
-		return err;
-
-	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
-	 * FTP with NAT) adusting the TCP payload size when mangling IP
-	 * addresses and/or port numbers in the text-based control connection.
-	 */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
-		return NF_DROP;
-	return NF_ACCEPT;
+	return nf_ct_call_helper(skb, ct, ctinfo);
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper);
 
-- 
2.55.0

