Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1C24048A3;
	Wed, 22 Jul 2026 21:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754878; cv=none; b=fJ6DTV8POxaxVsB3SgqIHL3Y3PlzsMxHYwykAcdLbb1WtqmdxmIB0zB+oTRXrNYqzubQViNzyPnySEvXX4dEErXqkErOQOmuGMjzyHF6pyz0O1nF+K2Y5yL2FXpsX4BIbiRxNMSukITkoExHf2Kg/VjDXocyfUiDm5ZYbvOOrt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754878; c=relaxed/simple;
	bh=NrYnVI9alrCDqvXvjRVV0ufwMXtxnjzAMBsKLeLOlpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKahvBI+cF3T0hBBwYEZMYSkmCQ0U3+uon+pArpTxEvdWwcFGRaA9nk3zcWfxYx/dvw0JyKzuvMgfz784M7NWuYAfTqCYYdWAiH2E2rXWybaD01+hhr8YKhREf1l0VAEIPiRo5f3BpzNj4YorpywOM9j/73DpXxaYYclIivAvw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dYxB1f6H; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dYxB1f6H"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E8336019C;
	Wed, 22 Jul 2026 23:14:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754868;
	bh=lRaiKkBstDxD/+jBirYz9dMhk2TjJNt6XNUE6aRNF+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYxB1f6H9dj/awuNT/AGBRsXaH40A2Qt6qCSSqfCQqy6+x/OQxL3cvok9qHkDnVIB
	 Piy6rHII7tdHsd26QqGR5IdLZwY5m39nrp7e6xZbA6PCo0QZDe8Qk7AwyO1MNWCPWo
	 ePROy8NWRdxXNRO2pdJES6fipQw4iHU6QwakfFMRDAv+bX1d0BZA6AKFIoZq/YP90O
	 dAdvW5+pOlr9NxPgv25ZFZS+B1XRcIbhDRqDBSCYBTf1DD/LvXBTLLBmgFr0l+NbdR
	 fZIeAPp2guBZMWn+z36QCnWw3h8Z5ISc5gWSw0ENqYrQtKdeF8emDLjgA6J5dgszk7
	 oO5/EA6rVK51A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/13] netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()
Date: Wed, 22 Jul 2026 23:14:08 +0200
Message-ID: <20260722211420.153933-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiang Mei <xmei5@asu.edu>

sip_help_tcp() stores the size change of each NAT-rewritten SIP message
in s16 diff and accumulates it in s16 tdiff, but a single message can
grow by more than S16_MAX while the packet stays under the 65535
enlarge_skb() limit: nf_nat_sip() rewrites every matching URI, and a long
Contact list expands the message by tens of kilobytes. diff then wraps,
and "datalen = datalen + diff - msglen" yields a huge unsigned datalen,
so the next iteration's ct_sip_get_header() reads past the linearized skb
tail.

Widen diff, tdiff and the seq_adjust hook to s32. Both are bounded by the
65535 byte packet limit, and the seqadj core is already s32
(nf_ct_seqadj_set() takes s32), so no previously accepted input is
rejected.

  BUG: KASAN: use-after-free in ct_sip_get_header (net/netfilter/nf_conntrack_sip.c:464)
  Read of size 1 at addr ffff888010800000 by task ksoftirqd/1/25
   ct_sip_get_header (net/netfilter/nf_conntrack_sip.c:464)
   sip_help_tcp (net/netfilter/nf_conntrack_sip.c:1694)
   nf_confirm (net/netfilter/nf_conntrack_proto.c:183)
   nf_hook_slow (net/netfilter/core.c:619)
   ip6_output (net/ipv6/ip6_output.c:246)
   ip6_forward (net/ipv6/ip6_output.c:690)
   ipv6_rcv (net/ipv6/ip6_input.c:351)
   __netif_receive_skb_one_core (net/core/dev.c:6212)
   process_backlog (net/core/dev.c:6676)
   __napi_poll (net/core/dev.c:7735)
   net_rx_action (net/core/dev.c:7955)
   handle_softirqs (kernel/softirq.c:622)
   run_ksoftirqd (kernel/softirq.c:1076)
   ...

Fixes: f5b321bd37fb ("netfilter: nf_conntrack_sip: add TCP support")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/netfilter-devel/20260712234201.3213635-1-xmei5@asu.edu
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_sip.h | 2 +-
 net/netfilter/nf_conntrack_sip.c           | 2 +-
 net/netfilter/nf_nat_sip.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index dbc614dfe0d5..aafa0c04f917 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -115,7 +115,7 @@ struct nf_nat_sip_hooks {
 			    unsigned int *datalen);
 
 	void (*seq_adjust)(struct sk_buff *skb,
-			   unsigned int protoff, s16 off);
+			   unsigned int protoff, s32 off);
 
 	unsigned int (*expect)(struct sk_buff *skb,
 			       unsigned int protoff,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f3f90a866338..e4a70d1d77b0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1663,7 +1663,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int matchoff, matchlen;
 	unsigned int msglen, origlen;
 	const char *dptr, *end;
-	s16 diff, tdiff = 0;
+	s32 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
 	unsigned long clen;
 	bool term;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aea02f6aff09..a93eaf0f7d30 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -321,7 +321,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 }
 
 static void nf_nat_sip_seq_adjust(struct sk_buff *skb, unsigned int protoff,
-				  s16 off)
+				  s32 off)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-- 
2.47.3

