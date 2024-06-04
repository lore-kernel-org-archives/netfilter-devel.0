Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127C3145B13
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502735; cv=none; b=J1+zQgxBNDd6nkYR0yjR0ih7UsILEiOs353LtDzBXAHG+Is9K5oTgPhML5xIe2smptfy9EbCVJ/awTrNPh4TNO5pVC3FSJDpblf3Fl2odw0NEYZrvnZQZdJpxnNmUaKXapm1HjaN4b6BGCmog7euxrUAdY3K05cvFTSJr8lt63o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502735; c=relaxed/simple;
	bh=MPCHXTGpKw1I73BQyd0H+J9U1xPpUj5vieVb1qLJP+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AUuJrg98YeO50DZlxQpNPCXqiNBwpwWJ2DUfEJu8N2oM7negtyYZ1d3l31YIer7U5Pa+atUlx8oddAD/+C1GP11yJs6gdDiyRH+f7/+zd9jjFThbniRCRpPv4TD9QUL+zwlfIPpMJDsFjvjy62tAs0kYW1YM+8C+f5o4h9Fq4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sESuw-0001OS-Vc; Tue, 04 Jun 2024 14:05:30 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Date: Tue,  4 Jun 2024 14:03:05 +0200
Message-ID: <20240604120311.27300-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skb_get_hash() triggers a (harmless) warn when neither skb->sk or skb->dev
is set.

In case of nf-generated tcp reset, both sk and dev are NULL:

WARNING: .. net/core/flow_dissector.c:1104
[..]
 skb_flow_dissect_flow_keys include/linux/skbuff.h:1536 [inline]
 skb_get_hash include/linux/skbuff.h:1578 [inline]
 nft_trace_init+0x7d/0x120 net/netfilter/nf_tables_trace.c:320
 nft_do_chain+0xb26/0xb90 net/netfilter/nf_tables_core.c:268
 nft_do_chain_ipv4+0x7a/0xa0 net/netfilter/nft_chain_filter.c:23
 nf_hook_slow+0x57/0x160 net/netfilter/core.c:626
 __ip_local_out+0x21d/0x260 net/ipv4/ip_output.c:118
 ip_local_out+0x26/0x1e0 net/ipv4/ip_output.c:127
 nf_send_reset+0x58c/0x700 net/ipv4/netfilter/nf_reject_ipv4.c:308
 nft_reject_ipv4_eval+0x53/0x90 net/ipv4/netfilter/nft_reject_ipv4.c:30
 [..]

Fixes: d0e13a1488ad ("flow_dissector: lookup netns by skb->sk if skb->dev is NULL")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 1 +
 net/ipv6/netfilter/nf_reject_ipv6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 04504b2b51df..9333a779eab2 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -278,6 +278,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (nskb->len > dst_mtu(skb_dst(nskb)))
 		goto free_nskb;
 
+	nskb->dev = skb_dst(nskb)->dev;
 	nf_ct_attach(nskb, oldskb);
 	nf_ct_set_closing(skb_nfct(oldskb));
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index dedee264b8f6..386223311579 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -334,6 +334,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		return;
 	}
 
+	nskb->dev = dst->dev;
 	skb_dst_set(nskb, dst);
 
 	nskb->mark = fl6.flowi6_mark;
-- 
2.44.2

