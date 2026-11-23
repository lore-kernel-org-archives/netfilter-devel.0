Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442099;
	b=2aaeF6AASGBB5nXhyjH793q5xygTFvmChauwd+tW9DxAeD+HcRAYKJD6B2x2fvkeDR2e
	 fCyYYppQwUcl4aZfjVdCvfgGEtxZtMctcLLdMbktWXESRWBb7VicDFb8fFzya0xSVhS/z
	 lD2Nm8uaQ0lYKR5NQ/92ouJGRq1nXrtpYLPf4/uMSbwtpEdBOUZyql+2+5hbjpI9R7hMg
	 7NZ4NyhVcpGrdmHkdZn6+tCdT8sc6NhfHyaL104bYpN+Smd/8+Ou3gYarxCuqwsXBjaEx
	 0qTWWsNvPzAS2acEujFUrlxsW91BUU34z36d+GRa0QyQGYZTHav0NSW5OCtCikns+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442099;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=yOW9YNJL9sjA3bJFgWWxixTU2xU4gwJYXG8cgx+Z8Hw=;
	b=2EAczMB1Tz6TJrPXZPYxD0OIIV5YKJyZJ6b/EH7YIsJjPpo4i2a0FodaYHM8Jb8f2x35
	 jQlK/fjRC1vM0WB2+Fup7wZeUzjFbe4ZkUqToZmJpL/mLezhZ2o/dO/gSLzAdJS1/yP8b
	 8xaFtqamI6xCSfj8awNrGlsb2nvuGgxIjFObDT67EoW/OmbkAGPwNBwNVrNaAiX7sqh2q
	 Gybzbdd7OOA0fcqNEAumTG/4p3s+cMp58EeYCMdUEyhWpm0nfwG3xR96q9Mnyc7y+ZGOm
	 CXf4YmN/fuqfx6bW2l7EQnilsDsEq4/PHBpEG/tY/RgOnJ3y911TQ8sE2g5PfQiyWGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FzRmfzqh;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90907606A31A;
	Mon, 23 Nov 2026 13:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90907606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FzRmfzqh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442095;
	bh=yOW9YNJL9sjA3bJFgWWxixTU2xU4gwJYXG8cgx+Z8Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzRmfzqh5R3+ED64nC+Vppd23kRGVavR4SEhLbw/oZckQqfQpnrGAbejB1D9VzAV5
	 Rc49wXbvHQAyAoV8Nh/La6ugC8Mosy01ecPGj85n8fW+h/lbbtcz08J+bNwCa7Ga9i
	 fIlvjoS2jSBHRbvvJb3pdjiSWtktbm2vJ+Weh06Uz1zVkjho3u5Ggn8ANqqsUwhy6L
	 fq1RHIpdEPgAXUNultDi3+OQX9PeJS6bJPY5M3hw39dOPD7pKNYo6ki9/c4bzjFG5F
	 uaZFnypeLb+RYeh83tIGy/8Ho2+EI6F5scbuPT7XhEKXJUHX+suo2GrZgq0ftXHwsV
	 czo8vQF/J1VQw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1B052602D1;
	Mon, 23 Nov 2026 14:54:55 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 05/15] netfilter: conntrack: replace open-coded helper invocation
Date: Mon, 23 Nov 2026 14:54:32 +0100
Message-ID: <20261123135442.3940372-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Replace duplicated logic with the new nf_ct_call_helper() helper.
No functional changes intended, except the additional checks to
ensure the helper can process the given packet.

LLM complains about the existing early !helper-return in
nf_ct_helper(), but I prefer to keep this as-is.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ovs.c | 53 +-------------------------------
 1 file changed, 1 insertion(+), 52 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index fe525b324af4..2a80eaf05186 100644
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
2.47.3

