Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141C82899;
	Wed,  9 Apr 2025 07:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744184751; cv=none; b=AGJfozxcNivVL/3l5VtxlpfD1WwLz2nOrp8V1g5bUxoDbdQ8Ufy3lW38898daEsAHPO5fEjDjGXR+3cJ2hHOCRfZVU1IhS61WN4fFaa9qXEc0LD038oRIFl08R65Qqq11S3Ql0O87X6tWajzoFgKLZDV4Hx2Bg1Fua1+saGek78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744184751; c=relaxed/simple;
	bh=fqYCoMpJIfChuAVwq1FHFJqFMnJx9VG5aYy9ssLpQIM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FwkoPzRHY6GXUFnYHKfF5knvB3fnNLKT8cqTSwciPDAj9zdC3zUplBUGq+7LEMgN7uqN2jqLkSlRp8phjtFA1z3PCB3FHg68L2wHwsOeNhJH/JiTl0gN1NIxQZ8VA+iGqQHQyoMLD926YSJ1G7MGriowPjIB3lFNYOwDAqi5o/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch03.asrmicro.com (exch03.asrmicro.com [10.1.24.118])
	by spam.asrmicro.com with ESMTPS id 5397ikCm006604
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 9 Apr 2025 15:44:46 +0800 (GMT-8)
	(envelope-from huajianyang@asrmicro.com)
Received: from localhost (10.26.128.141) by exch03.asrmicro.com (10.1.24.118)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 9 Apr 2025 15:44:49
 +0800
From: Huajian Yang <huajianyang@asrmicro.com>
To: <pablo@netfilter.org>
CC: <kadlec@netfilter.org>, <razor@blackwall.org>, <idosch@nvidia.com>,
        <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Huajian Yang <huajianyang@asrmicro.com>
Subject: [PATCH] net: Expand headroom to send fragmented packets in bridge fragment forward
Date: Wed, 9 Apr 2025 15:44:44 +0800
Message-ID: <20250409074444.8213-1-huajianyang@asrmicro.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch03.asrmicro.com (10.1.24.118) To exch03.asrmicro.com
 (10.1.24.118)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 5397ikCm006604

The config NF_CONNTRACK_BRIDGE will change the way fragments are processed.
Bridge does not know that it is a fragmented packet and forwards it
directly, after NF_CONNTRACK_BRIDGE is enabled, function nf_br_ip_fragment
will check and fraglist this packet.

Some network devices that would not able to ping large packet under bridge,
but large packet ping is successful if not enable NF_CONNTRACK_BRIDGE.

In function nf_br_ip_fragment, checking the headroom before sending is
undoubted, but it is unreasonable to directly drop skb with insufficient
headroom.

Using skb_copy_expand to expand the headroom of skb instead of dropping
it.

Signed-off-by: Huajian Yang <huajianyang@asrmicro.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 14 ++++++++++++--
 net/ipv6/netfilter.c                       | 14 ++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..b8fb81a49377 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -62,7 +62,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 		if (first_len - hlen > mtu ||
 		    skb_headroom(skb) < ll_rs)
-			goto blackhole;
+			goto expand_headroom;
 
 		if (skb_cloned(skb))
 			goto slow_path;
@@ -70,7 +70,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 		skb_walk_frags(skb, frag) {
 			if (frag->len > mtu ||
 			    skb_headroom(frag) < hlen + ll_rs)
-				goto blackhole;
+				goto expand_headroom;
 
 			if (skb_shared(frag))
 				goto slow_path;
@@ -97,6 +97,16 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 		return err;
 	}
+
+expand_headroom:
+	struct sk_buff *expand_skb;
+
+	expand_skb = skb_copy_expand(skb, ll_rs, skb_tailroom(skb), GFP_ATOMIC);
+	if (unlikely(!expand_skb))
+		goto blackhole;
+	kfree_skb(skb);
+	skb = expand_skb;
+
 slow_path:
 	/* This is a linearized skbuff, the original geometry is lost for us.
 	 * This may also be a clone skbuff, we could preserve the geometry for
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 581ce055bf52..cb67c31971e0 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -166,7 +166,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		if (first_len - hlen > mtu ||
 		    skb_headroom(skb) < (hroom + sizeof(struct frag_hdr)))
-			goto blackhole;
+			goto expand_headroom;
 
 		if (skb_cloned(skb))
 			goto slow_path;
@@ -174,7 +174,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		skb_walk_frags(skb, frag2) {
 			if (frag2->len > mtu ||
 			    skb_headroom(frag2) < (hlen + hroom + sizeof(struct frag_hdr)))
-				goto blackhole;
+				goto expand_headroom;
 
 			/* Partially cloned skb? */
 			if (skb_shared(frag2))
@@ -208,6 +208,16 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		kfree_skb_list(iter.frag);
 		return err;
 	}
+
+expand_headroom:
+	struct sk_buff *expand_skb;
+
+	expand_skb = skb_copy_expand(skb, hroom, skb_tailroom(skb), GFP_ATOMIC);
+	if (unlikely(!expand_skb))
+		goto blackhole;
+	kfree_skb(skb);
+	skb = expand_skb;
+
 slow_path:
 	/* This is a linearized skbuff, the original geometry is lost for us.
 	 * This may also be a clone skbuff, we could preserve the geometry for
-- 
2.48.1

