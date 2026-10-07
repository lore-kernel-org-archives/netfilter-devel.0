Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2396720D4FC
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791412978; cv=none; b=TB2anMPSGXrz0mrEqcD82RfPQXdF8irnAIS6LmPo+0h76uYJVhpjKJ6kAqMZtgmtASkKiUz64+FCCmLsxnzUAFLO0JDKYsNE+2XLfsXbD01uDXpPelfpgXdYLDhZKitT0+nzzZC5kxTmbVqNgDwoIHiGGxLzr2JZdJGwBm6mYaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791412978; c=relaxed/simple;
	bh=gD4sPNq1uISypdbnRNd4fHhlz4iXw52HSVyevPd2U2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EfojSApk67sCa7GIlKkinl3D9YPL69BzTqSUniClwtdESsvpuV9hDdq4ex9tl7oeTqYq7W59sLbpSAGT66SNlMQqhcfD1s07ZdCKPeQS7h/nEdVlWIKxDupywYYoBttDan3S3W5z70GRApVlA1iB64J7MFpTWGyLgcgpj+m1EGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIYoQF3u; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1cIfO7d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIYoQF3u";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1cIfO7d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791412976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=13gxPsURjLzCdi+sDd2xIfT4EKUZ/Mngu1xOwIk0swU=;
	b=RIYoQF3uh7QwuKNHFShhGSWlWREsTp/175iwCn4MlKClNLqe2OG/v5NT2WOwWp/tNjIt+H
	jMJjHoYw8LFp74eeWzi5N+7mdLpaxtHOZGqXhnBCNIHI+jGdSwJhqEWBg5yIK7RI5LyUBt
	RyL6v0gvkenqW+eec8BNU5IZ/PiTQu0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-0MTqmcHnPVyLwfRJHex3UQ-1; Wed, 07 Oct 2026 18:42:54 -0400
X-MC-Unique: 0MTqmcHnPVyLwfRJHex3UQ-1
X-Mimecast-MFC-AGG-ID: 0MTqmcHnPVyLwfRJHex3UQ_1791412974
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a020cf06c3so27353335e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Oct 2026 15:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791412973; x=1792017773; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=13gxPsURjLzCdi+sDd2xIfT4EKUZ/Mngu1xOwIk0swU=;
        b=T1cIfO7dnx8gEKE6L/AgU8I+HZODTob3wHgiHuDuZBeIrWsU5qMm10kkJRjFen9wT4
         Lk3eedzp+8S9PriXFHUNDreznWU0JiQhMPxaSIUs/zJ0yPSS3gvHTHMbfSNHQBQzKUPO
         rSKUHifQERAIuB6FO2fLjkAVWPTKPFjmGz8l93mPONVQsAAqgKijMk+NX34FWys5rl/y
         D0HAyMsHec8Gm6fNqkEAJHomon9YfsywcrMxcX67WbqN9nyY2uZfES017GDtiVVRx9xh
         LxnLmsYu3MlaZLupCRqfXi+PUriyxS4y/BjtVne7CZkcZSteg0SWupIHhC1iD25ZQwcc
         uMoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412973; x=1792017773;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=13gxPsURjLzCdi+sDd2xIfT4EKUZ/Mngu1xOwIk0swU=;
        b=Bz2WAnUk7j7utGhp7KoQj+KUUtmYGas0Bxk3ZwbLItOWTWNG3v9BQqMwkJtnsTVXJp
         CNnXUkV5DMWLbKwYM24/on1hHj7x/H///kCNVLaga9K5mjgdWHFQnL/1R3ZtoHCcJm3F
         2XY7cPT8Oirgex042ggG2xiEAl5M+cBmdb4u4H7jdHkOAmukTIKLf0Px7oOHTZgFp14m
         YkOxpufIecauweSoa255lMlaTeE4k/Gf3QQNb0gmh2DffoFX0BXpwUwsee1s0aGWTxd9
         iJM00Pp/Zeb3P4k0kUHZD85sNe80LIzme+BQnM6Ov62jy9ei8pPvzTDXnnPjmIVQpkX5
         vjhA==
X-Forwarded-Encrypted: i=1; AKwUvBzmvNdifSMAPsDP6tWRNfc9WZNlAF06FKNM/miK2yN72nj3KDfwx6Q5AdOeV9qqpxiUzwqO2tF4ohSQFt2YNpI=@vger.kernel.org
X-Gm-Message-State: AFuF++mcSqz0yHxJ0XTGPCq+SaJkgudj1RG+KF5B4D2l2c/YGJmcDyjH
	+OhCMn5EyWOibM+SKYY+qBEN94E6lNyJ8aczYLfxEm2BgC77YsnuIsSY4IJJ92T/oY7h3BULwC+
	GT+QXJDgz7luO5tBjSWSrKWFiIuCgbyUCXnUMrqctJbIohAX3ukDv4xjHWAtdeYQNOedRHaROx1
	wYlw==
X-Gm-Gg: AYBFou29qG348PDrqONp4Fs6y1yU7Vy6rFZlQ+O/gMLSYOFjgtSe0cEb+jDwBSg/Rsa
	0VwXBhKKiyOSyhsAevAVo+DIzEjKIRrSV6Jus0VjCHgY/B3ChDK3VyUE46Uv+SgQKmolTdLflI8
	Pq0s78pln89XsRAdGzsguRiH4H3DekV9T/aj5117HrYwWx+vhIQpWbchx0QsArdajZ3MItKs9W3
	bQzENdD254MyAuMgNc/5joLQNrii6fB72ugvS8g6HI/AHycH4YjU51LsvKSRj2do3ZDLX5rIrQH
	2Qz3V7zEmx+vjcYNW0CCS047yUfEAOd/Dl5qRTI8lrVFlryon/9k6PDjNEfbIqxTE9m55UY=
X-Received: by 2002:a05:600c:468f:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4a1806508edmr61035695e9.30.1791412973496;
        Wed, 07 Oct 2026 15:42:53 -0700 (PDT)
X-Received: by 2002:a05:600c:468f:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4a1806508edmr61035375e9.30.1791412973041;
        Wed, 07 Oct 2026 15:42:53 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:3fd7:5300:3d6b:52a4:a23f:9d0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843dfb3bsm25148435e9.13.2026.10.07.15.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 15:42:51 -0700 (PDT)
Date: Wed, 7 Oct 2026 18:42:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev
Subject: [PATCH net] ipv4: validate checksum_start before completing checksum
Message-ID: <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent

If a packet with bad checksum metadata gets into the ipv4 stack,
skb_checksum_help can corrupt the network header and cause a bunch of
mischief.

This was discovered and reported by Paulos, and has been reporoduced
by others independently since.

We really shouldn't allow such packets in, but as a defence
in depth measure, let's also check before we complete the checksum.

A more complete validation at input is forthcoming, but needs more work.

Assisted-by: LLM
Fixes: f43798c27684 ("tun: Allow GSO using virtio_net_hdr")
Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
Closes: https://lore.kernel.org/netdev/20260922030310.8684-2-habte.yibelo@gmail.com/
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Lightly tested.

 include/net/ip.h                           |  7 +++++++
 net/bridge/netfilter/nf_conntrack_bridge.c | 10 +++++++---
 net/ipv4/ip_output.c                       | 10 +++++++---
 net/netfilter/nfnetlink_queue.c            |  7 +++++++
 net/netfilter/xt_CHECKSUM.c                |  6 +++++-
 net/xfrm/xfrm_output.c                     | 16 +++++++++++-----
 6 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 6f602df72ee6..d07c2c573024 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -74,6 +74,13 @@ static inline unsigned int ip_hdrlen(const struct sk_buff *skb)
 	return ip_hdr(skb)->ihl * 4;
 }
 
+static inline int ip_check_csum_start(const struct sk_buff *skb)
+{
+	if (unlikely(skb->csum_start < skb->network_header + ip_hdrlen(skb)))
+		return -EINVAL;
+	return 0;
+}
+
 struct ipcm_cookie {
 	struct sockcm_cookie	sockc;
 	__be32			addr;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 7ecb8a26bfa3..b5444335b86f 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -39,9 +39,13 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto blackhole;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = ip_check_csum_start(skb);
+		if (!err)
+			err = skb_checksum_help(skb);
+		if (err)
+			goto blackhole;
+	}
 
 	iph = ip_hdr(skb);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 74e095b6b7ca..bea79611617f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -771,9 +771,13 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto fail;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = ip_check_csum_start(skb);
+		if (!err)
+			err = skb_checksum_help(skb);
+		if (err)
+			goto fail;
+	}
 
 	/*
 	 *	Point into the IP datagram header.
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c727668b0c5b..5177e27174e7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -40,6 +40,7 @@
 #include <linux/udp.h>
 #include <net/gre.h>
 #include <net/gso.h>
+#include <net/ip.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
@@ -674,6 +675,12 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 
 static int nf_queue_checksum_help(struct sk_buff *entskb)
 {
+	if (entskb->protocol == htons(ETH_P_IP)) {
+		if (!pskb_network_may_pull(entskb, sizeof(struct iphdr)) ||
+		    ip_check_csum_start(entskb))
+			return -EINVAL;
+	}
+
 	if (skb_csum_is_sctp(entskb))
 		return skb_crc32c_csum_help(entskb);
 
diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
index 9d99f5a3d176..1fb0f8118404 100644
--- a/net/netfilter/xt_CHECKSUM.c
+++ b/net/netfilter/xt_CHECKSUM.c
@@ -15,6 +15,7 @@
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/ip.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael S. Tsirkin <mst@redhat.com>");
@@ -25,8 +26,11 @@ MODULE_ALIAS("ip6t_CHECKSUM");
 static unsigned int
 checksum_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb))
+	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb)) {
+		if (xt_family(par) == NFPROTO_IPV4 && ip_check_csum_start(skb))
+			return NF_DROP;
 		skb_checksum_help(skb);
+	}
 
 	return XT_CONTINUE;
 }
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e305ba32e356..f1f612cd7b43 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -823,16 +823,22 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		err = skb_checksum_help(skb);
-		if (err) {
-			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
-			kfree_skb(skb);
-			return err;
+		if (skb->protocol == htons(ETH_P_IP)) {
+			err = ip_check_csum_start(skb);
+			if (err)
+				goto error;
 		}
+		err = skb_checksum_help(skb);
+		if (err)
+			goto error;
 	}
 
 out:
 	return xfrm_output2(net, sk, skb);
+error:
+	XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+	kfree_skb(skb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(xfrm_output);
 
-- 
MST

