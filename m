Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D130C1CD;
	Mon,  5 May 2025 23:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488524; cv=none; b=k8f10pCgvmhss13bso4gR8pfwvxSyubt8o0eIyrGonwg0H+JbMGdFnLkhXnQSRWpIVKghD3QwSODtBZdVN5EaaDlj9ERBjq+aB2tyxhBiBlDOMGFDf2UN7RXzSGnH2ntFc3q2svf0piyIKflPIkBSzkKp8ymLL5Te+rnhNhW4zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488524; c=relaxed/simple;
	bh=H0dzNovKLvIBLklQFlFnikZaRkarnH1xScn0BdbIKuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EuFqdrV4t1wuG91PV5DWiY5gTUsgA5ebr3XdFi0TsdBkqSi+1R4efS6rYBuOzN+y3ieBME6oRjZIcr3EwwfAEYwKeuTlHnqalp/bNx256Uqfbj1kv9xiJw9frNj2Q7zuxCG+PsW3eY9FCyd3yph19qX+iUS+EVE11edp3Ps6FnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q6CaCM7S; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h3Jbf3qo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q6CaCM7S";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h3Jbf3qo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B0A2360663; Tue,  6 May 2025 01:41:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488519;
	bh=bscAxmK47VqRM+vrJm/FhaqyZXZ7e+a+WUwk0y6DnDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6CaCM7SaEDQTLUFjsbJn8FviCLMUS8jFRqLNhMv09Y0K3nQ3isXcfzSEUR8rF5Pg
	 KTC/zj7TaBJER+h2D8NWLDTiHZQW8tzLfwVev2B0Z640N6rAlqf8hxRxDaPVR8uPtw
	 eMZaS0VXrHpmT6SoU//vRDfAhtCQM4aSISaLK5/onMnZDkQPJgTYYDBoK6sWuHOjmV
	 zLKkWg7znlpCtlNxbYxPf+hKQs2qmjb+SLBbv+iQL//RK6GwpZVq5EwnRhpzwtDvj6
	 8EzlRNt8yiaUVvVfWFkIi2V63zDkfqZi6JCM/LTq78r+JWx76YrgQv60kd4KHJhyEw
	 kZBiN1dga3a4w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A000A60655;
	Tue,  6 May 2025 01:41:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488517;
	bh=bscAxmK47VqRM+vrJm/FhaqyZXZ7e+a+WUwk0y6DnDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3Jbf3qo69EYg4gbIq0v0EN5rYhWCqESKe2bwL4e+payRvUD226LeDlykO9LAzyGW
	 5wADIuAjo4CDzHq/qDzzcEZv35bjTo0saHxDWNFNHxXxFtJz0ADEQ00rsUf7v+wtbK
	 p3DF/Y3uRcop/cIIjaKBc4PN2pHUFktAIst8OCwArL1F8QR6ZbOb0ahpZOQhkZPSNL
	 Hk+FX6TYCOW7FeY64DLqHWlVHlQrnBPKBLAufDO6hpu7kw3mu79aG02hFsQIYdBOh+
	 q6X7B8zlai3PhdGrXrNYW/fHsVDF0WJWjHN565fyYbKo7ftfSTEQAbaT/7WXTJuWnR
	 y+J9+TQYSGeUA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 1/7] netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it
Date: Tue,  6 May 2025 01:41:45 +0200
Message-Id: <20250505234151.228057-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huajian Yang <huajianyang@asrmicro.com>

The config NF_CONNTRACK_BRIDGE will change the bridge forwarding for
fragmented packets.

The original bridge does not know that it is a fragmented packet and
forwards it directly, after NF_CONNTRACK_BRIDGE is enabled, function
nf_br_ip_fragment and br_ip6_fragment will check the headroom.

In original br_forward, insufficient headroom of skb may indeed exist,
but there's still a way to save the skb in the device driver after
dev_queue_xmit.So droping the skb will change the original bridge
forwarding in some cases.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Huajian Yang <huajianyang@asrmicro.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 12 ++++++------
 net/ipv6/netfilter.c                       | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..6482de4d8750 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -60,19 +60,19 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 		struct ip_fraglist_iter iter;
 		struct sk_buff *frag;
 
-		if (first_len - hlen > mtu ||
-		    skb_headroom(skb) < ll_rs)
+		if (first_len - hlen > mtu)
 			goto blackhole;
 
-		if (skb_cloned(skb))
+		if (skb_cloned(skb) ||
+		    skb_headroom(skb) < ll_rs)
 			goto slow_path;
 
 		skb_walk_frags(skb, frag) {
-			if (frag->len > mtu ||
-			    skb_headroom(frag) < hlen + ll_rs)
+			if (frag->len > mtu)
 				goto blackhole;
 
-			if (skb_shared(frag))
+			if (skb_shared(frag) ||
+			    skb_headroom(frag) < hlen + ll_rs)
 				goto slow_path;
 		}
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 581ce055bf52..4541836ee3da 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -164,20 +164,20 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		struct ip6_fraglist_iter iter;
 		struct sk_buff *frag2;
 
-		if (first_len - hlen > mtu ||
-		    skb_headroom(skb) < (hroom + sizeof(struct frag_hdr)))
+		if (first_len - hlen > mtu)
 			goto blackhole;
 
-		if (skb_cloned(skb))
+		if (skb_cloned(skb) ||
+		    skb_headroom(skb) < (hroom + sizeof(struct frag_hdr)))
 			goto slow_path;
 
 		skb_walk_frags(skb, frag2) {
-			if (frag2->len > mtu ||
-			    skb_headroom(frag2) < (hlen + hroom + sizeof(struct frag_hdr)))
+			if (frag2->len > mtu)
 				goto blackhole;
 
 			/* Partially cloned skb? */
-			if (skb_shared(frag2))
+			if (skb_shared(frag2) ||
+			    skb_headroom(frag2) < (hlen + hroom + sizeof(struct frag_hdr)))
 				goto slow_path;
 		}
 
-- 
2.30.2

