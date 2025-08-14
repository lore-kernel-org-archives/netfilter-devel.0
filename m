Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6704321ADCB
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Aug 2025 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755187733; cv=none; b=XWkapoQllRbTeIClcLVTrVnS7aMACJRuC8gxL6IKscRd6Z4Tb1TScPax3c2yzNWgJR72Jjm/5VYcBaSCjkBUg8Nf3W6Z82WNZLM1jx5qo93XhPYNSmv9BM1uzBIkPXDNskP6rkeW6nVKFwee6R3/JsbPNbaN4gi0PYsrcWKnwr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755187733; c=relaxed/simple;
	bh=hZuFFFW/wEMvJnAtk5brpz6V1orwx1vdkKIqF5ccg1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DuvcLTq1quYRCG8c/p6doDjc1/a5gdwedSwxfHuhUZ2y9Omk59uHsMFfYdsdlbfRlnx8VJIBSPJwOPZQqssl12cnDYISKfnds8R6NChhV80R/dtadwywdiyreh2MGyaC88YL0sAUawrGuG7k24KTEkIq1S8P8WpTH+w+9Qo9fYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 065EF601B0; Thu, 14 Aug 2025 18:08:48 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	syzbot ci <syzbot+ci1b726090b21fedf1@syzkaller.appspotmail.com>
Subject: [PATCH nf] netfilter: nf_reject: don't leak dst refcount for loopback packets
Date: Thu, 14 Aug 2025 18:08:19 +0200
Message-ID: <20250814160833.24351-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

recent patches to add a WARN() when replacing skb dst entry found an
old bug:

WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
[..]
Call Trace:
 nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
 nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 ..

This is because blamed commit forgot about loopback packets.
Such packets already have a dst_entry attached, even in PRE_ROUTING stage.

Instead of checking hook just check if the skb already has a route
attached to it.

Cc: Stanislav Fomichev <stfomichev@gmail.com>
Reported-by: syzbot ci <syzbot+ci1b726090b21fedf1@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/netdev/689c457b.a70a0220.7865.0049.GAE@google.com/
Fixes: f53b9b0bdc59 ("netfilter: introduce support for reject at prerouting stage")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++----
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 87fd945a0d27..0d3cb2ba6fc8 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -247,8 +247,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
-	    nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -321,8 +320,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
-	    nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) ||
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 838295fa32e3..cb2d38e80de9 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -293,7 +293,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) {
+	if (!skb_dst(oldskb)) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
@@ -397,8 +397,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_INGRESS) &&
-	    nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
-- 
2.49.1

