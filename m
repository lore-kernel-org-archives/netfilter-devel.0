Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442261;
	b=bMrVCn8qobgjGRlICi+coxbOTsxEta8T6FYXuLHrjH8RGJLrZHmTcDZCFPx84N/5G6sk
	 i0A0mYnQOFgXDa3TL842nw3ExmlJ7uddfdNlxd7bb8XstceR1jsOiaOtYA+34lSvM7sPa
	 L8WgpJKkfJRuCtjSHpKoHgg3lId4MlVnBfRPQlhOADe9c9nwmMPKr06LIZXLs40DV5wxb
	 MJ/aBuGjrvzrAYKr1WMs6unaPVWnvkeeWTqE/d/N5k6YXMaFpIvI7cB665v2hM0o7lgPW
	 fTEQ4uytjF3Tojh8fWTZLIuTgIcNynG1qo5NkpYkr1iCAzoSVgx+VOXNvjOlDPfB8AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442261;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=yOW9YNJL9sjA3bJFgWWxixTU2xU4gwJYXG8cgx+Z8Hw=;
	b=eupiIqo1/EIvEnee42Gk5onrAfTSVPG/BXTn2veJwipwPFrBfPWLlm4O2TtQ6MtUnLjJ
	 y2DemHond6wnZFo5pKOMApLwCcn8OPYcOMe9yvYmNbY5h6rTH4aB6ORbc98Ocd7QfdgcK
	 py9ci9gzOlNno3soXQbkVwtesqIDRKfvPfKcEkSPa4OVAVKkLQxjWq6wSdRgQIXv/Xnbg
	 BKDW6Ay5exOIDYEV0YHQdkDJSYO4b6GWWy2gUZ1rPEGzltjU8Reipa5ZJ/N1lDqGDmd/Q
	 jEvyA3Ebz2M3z9L4RGMbQcFlW0JIL6KnQdf1/LaD0MoijbIBM6Lg6OOeeA711MQR+hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rvUuORCm;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4C8606A696;
	Mon, 23 Nov 2026 13:57:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF4C8606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rvUuORCm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442258;
	bh=yOW9YNJL9sjA3bJFgWWxixTU2xU4gwJYXG8cgx+Z8Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvUuORCmSeejyfwZqjXqs22yDOD2s+g3fYlizPt6f2JPoWwn1Ms5CGBe20yTm8Pn8
	 kUnK7uZBG31jZaYia4EhQGh9C7cD2n6fTdI5R2O0t5tyhN0Z2aiYnoOYfZfB97ARGw
	 NttYhcj0mCCtKL+DyueznTLlwA/kBqoxQwD0JH/ysUI6p4n+DJ75jCLcNuo92c21Ah
	 FImhGz+eyXlmRVEzaXXniSZT+HUDCSkrCZChtZPOBeWbckcOKfNpKKpWtUrttWyJZ8
	 tKRlgbTOkOV5i0v7wSTxM8CFrLlIBWmJVOx5VEbMpXzDKYJiYQE7XSQ6z6q2atqeg8
	 618qNEg6LGR4Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 04F12602CF;
	Mon, 23 Nov 2026 14:57:37 +0100 (CET)
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
Date: Mon, 23 Nov 2026 14:57:16 +0100
Message-ID: <20261123135726.3940688-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
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

