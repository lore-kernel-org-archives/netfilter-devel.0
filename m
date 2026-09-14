Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B003F3D47A7
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405162; cv=none; b=Gt0zD7/fQ2lRSr+PvQj6vJsgOnHoh3k0/zqcMlBY7s2Pu7K5owECRDGGXnhJwHPRSfskV2IGiaUNCOF+Q9xS289+7bYaw5zNFHh/N/5hTQTNM5KympYKU8VfVK1mOC5rNF21gPKiQRa6y9PdS8dYM2WYzItj7YwNYOIpS+HvcVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405162; c=relaxed/simple;
	bh=0d9Pr15XwJ4TT5PnfecahX97v6ZWqoDfoJqW/VPHYys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGeH+K0nZAzspg55XD1sDkZN1ZPiF5YRaxN/wsPUUZMoqNd/NOs2o19NXel9WUv+4AFQU2+cBvJIcIGoFl4TCMK0UkJzEswjN1GkLYZFe1wxUbgVNGyzQuBd8htLg6q5pOSJlbVs5WKz6aEgU50fjHAztAmxu5n/J42iiNb5GNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7161460468; Mon, 14 Sep 2026 18:59:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/6] netfilter: conntrack: replace open-coded helper invocation
Date: Mon, 14 Sep 2026 18:58:40 +0200
Message-ID: <20260914165842.4505-5-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914165842.4505-2-fw@strlen.de>
References: <20260914165842.4505-2-fw@strlen.de>
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

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ovs.c | 50 +-------------------------------
 1 file changed, 1 insertion(+), 49 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index b4085af3ad1c..b4c44e915d91 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -12,13 +12,8 @@
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
 
 	if (ctinfo == IP_CT_RELATED_REPLY)
 		return NF_ACCEPT;
@@ -35,50 +30,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
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

