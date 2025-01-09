Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B4C2153CE;
	Thu,  9 Jan 2025 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736415435; cv=none; b=bdBvhJZ3m8OVkxEbz/7saI8Zdjg5sTjIEDAxFRvRGvp2NDHxnnno+fGkDF3gvkwjUv58wS5tM4+BbwxpI02VWQlFzkFIHMYT9YmHb6jeRAPgYaCULyFV9cdjLVC3yYmtxCMRrIlJxVxn2Qu58pW/VZEx/HG0tFjAA7xpaVJeqtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736415435; c=relaxed/simple;
	bh=aqJf6bJtcvpupemt4+UV6C4fhRmFmBym9M66ZRrUbZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nivW+sOT7y5fRzttvBGACCuz2alu9E03c3tz9waaj9il1YQ4K27fLE9ILt+FPhhK4eiVDo9dLFI6+UPDbegk9IhKhybRWfjNHL2qR1b4EB1wppuK5MTdTop74AKjatzxce037kadyu9Lu2/VlxhJqdp3qB8Lsn+/yent7ErTyPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O61cUJnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O61cUJnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829DBC4CED2;
	Thu,  9 Jan 2025 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736415433;
	bh=aqJf6bJtcvpupemt4+UV6C4fhRmFmBym9M66ZRrUbZ4=;
	h=From:To:Cc:Subject:Date:From;
	b=O61cUJnXYsX7To1dvkwt8c4Nd7CJ54k+XHRR7bAjSfv3iF990+fmp0U75gvyQpf0P
	 cS7+ln1P1Sq93SULHUFkeZD3a1Fhkmc5l7tH09RlqiQ3VsIcgNc9qP0lKl4PmxfD54
	 CtOK7vvBzkkAkRgpCLA8FktAnQqWKDu+pFgU5v+2mWJKoMuX4RhzczF4V/p3X+hZt0
	 wGiphn5Yg3Sz8qWCFcsneMMeDHxGAFQjkh2+0Kmj/J9lE8kvb6lFSGqhnLt58+IXDn
	 FD8i+PXpvF955hlVFC44K5BUHxban49TVa/OllW5Olis+l0YrEMrDEdQZVFVLTW5nK
	 fIED9p+VtbdTw==
From: Antoine Tenart <atenart@kernel.org>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: Antoine Tenart <atenart@kernel.org>,
	dsahern@kernel.org,
	menglong8.dong@gmail.com,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next] netfilter: br_netfilter: remove unused conditional and dead code
Date: Thu,  9 Jan 2025 10:37:09 +0100
Message-ID: <20250109093710.494322-1-atenart@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SKB_DROP_REASON_IP_INADDRERRORS drop reason is never returned from
any function, as such it cannot be returned from the ip_route_input call
tree. The 'reason != SKB_DROP_REASON_IP_INADDRERRORS' conditional is
thus always true.

Looking back at history, commit 50038bf38e65 ("net: ip: make
ip_route_input() return drop reasons") changed the ip_route_input
returned value check in br_nf_pre_routing_finish from -EHOSTUNREACH to
SKB_DROP_REASON_IP_INADDRERRORS. It turns out -EHOSTUNREACH could not be
returned either from the ip_route_input call tree and this since commit
251da4130115 ("ipv4: Cache ip_error() routes even when not
forwarding.").

Not a fix as this won't change the behavior. While at it use
kfree_skb_reason.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 451e45b9a6a5..94cbe967d1c1 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -393,38 +393,10 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 		reason = ip_route_input(skb, iph->daddr, iph->saddr,
 					ip4h_dscp(iph), dev);
 		if (reason) {
-			struct in_device *in_dev = __in_dev_get_rcu(dev);
-
-			/* If err equals -EHOSTUNREACH the error is due to a
-			 * martian destination or due to the fact that
-			 * forwarding is disabled. For most martian packets,
-			 * ip_route_output_key() will fail. It won't fail for 2 types of
-			 * martian destinations: loopback destinations and destination
-			 * 0.0.0.0. In both cases the packet will be dropped because the
-			 * destination is the loopback device and not the bridge. */
-			if (reason != SKB_DROP_REASON_IP_INADDRERRORS || !in_dev ||
-			    IN_DEV_FORWARD(in_dev))
-				goto free_skb;
-
-			rt = ip_route_output(net, iph->daddr, 0,
-					     ip4h_dscp(iph), 0,
-					     RT_SCOPE_UNIVERSE);
-			if (!IS_ERR(rt)) {
-				/* - Bridged-and-DNAT'ed traffic doesn't
-				 *   require ip_forwarding. */
-				if (rt->dst.dev == dev) {
-					skb_dst_drop(skb);
-					skb_dst_set(skb, &rt->dst);
-					goto bridged_dnat;
-				}
-				ip_rt_put(rt);
-			}
-free_skb:
-			kfree_skb(skb);
+			kfree_skb_reason(skb, reason);
 			return 0;
 		} else {
 			if (skb_dst(skb)->dev == dev) {
-bridged_dnat:
 				skb->dev = br_indev;
 				nf_bridge_update_protocol(skb);
 				nf_bridge_push_encap_header(skb);
-- 
2.47.1

