Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11E5E732DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 14:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjI1Otc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjI1Otb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 10:49:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D9F1A3;
        Thu, 28 Sep 2023 07:49:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qlsKS-0005UE-VH; Thu, 28 Sep 2023 16:49:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 1/4] netfilter: nf_nat: undo erroneous tcp edemux lookup after port clash
Date:   Thu, 28 Sep 2023 16:48:58 +0200
Message-ID: <20230928144916.18339-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928144916.18339-1-fw@strlen.de>
References: <20230928144916.18339-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In commit 03a3ca37e4c6 ("netfilter: nf_nat: undo erroneous tcp edemux lookup")
I fixed a problem with source port clash resolution and DNAT.

A very similar issue exists with REDIRECT (DNAT to local address) and
port rewrites.

Consider two port redirections done at prerouting hook:

-p tcp --port 1111 -j REDIRECT --to-ports 80
-p tcp --port 1112 -j REDIRECT --to-ports 80

Its possible, however unlikely, that we get two connections sharing
the same source port, i.e.

saddr:12345 -> daddr:1111
saddr:12345 -> daddr:1112

This works on sender side because destination address is
different.

After prerouting, nat will change first syn packet to
saddr:12345 -> daddr:80, stack will send a syn-ack back and 3whs
completes.

The second syn however will result in a source port clash:
after dnat rewrite, new syn has

saddr:12345 -> daddr:80

This collides with the reply direction of the first connection.

The NAT engine will handle this in the input nat hook by
also altering the source port, so we get for example

saddr:13535 -> daddr:80

This allows the stack to send back a syn-ack to that address.
Reverse NAT during POSTROUTING will rewrite the packet to
daddr:1112 -> saddr:12345 again. Tuple will be unique on-wire
and peer can process it normally.

Problem is when ACK packet comes in:

After prerouting, packet payload is mangled to saddr:12345 -> daddr:80.
Early demux will assign the 3whs-completing ACK skb to the first
connections' established socket.

This will then elicit a challenge ack from the first connections'
socket rather than complete the connection of the second.
The second connection can never complete.

Detect this condition by checking if the associated sockets port
matches the conntrack entries reply tuple.

If it doesn't, then input source address translation mangled
payload after early demux and the found sk is incorrect.

Discard this sk and let TCP stack do another lookup.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_proto.c | 64 ++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 48cc60084d28..5a049740758f 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -697,6 +697,31 @@ static int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int
 }
 #endif
 
+static bool nf_nat_inet_port_was_mangled(const struct sk_buff *skb, __be16 sport)
+{
+	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return false;
+
+	switch (nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		break;
+	default:
+		return false;
+	}
+
+	dir = CTINFO2DIR(ctinfo);
+	if (dir != IP_CT_DIR_ORIGINAL)
+		return false;
+
+	return ct->tuplehash[!dir].tuple.dst.u.all != sport;
+}
+
 static unsigned int
 nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
@@ -707,8 +732,20 @@ nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
 
 	ret = nf_nat_ipv4_fn(priv, skb, state);
 
-	if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
-	    !inet_sk_transparent(sk))
+	if (ret != NF_ACCEPT || !sk || inet_sk_transparent(sk))
+		return ret;
+
+	/* skb has a socket assigned via tcp edemux. We need to check
+	 * if nf_nat_ipv4_fn() has mangled the packet in a way that
+	 * edemux would not have found this socket.
+	 *
+	 * This includes both changes to the source address and changes
+	 * to the source port, which are both handled by the
+	 * nf_nat_ipv4_fn() call above -- long after tcp/udp early demux
+	 * might have found a socket for the old (pre-snat) address.
+	 */
+	if (saddr != ip_hdr(skb)->saddr ||
+	    nf_nat_inet_port_was_mangled(skb, sk->sk_dport))
 		skb_orphan(skb); /* TCP edemux obtained wrong socket */
 
 	return ret;
@@ -937,6 +974,27 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 	return nf_nat_inet_fn(priv, skb, state);
 }
 
+static unsigned int
+nf_nat_ipv6_local_in(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	struct in6_addr saddr = ipv6_hdr(skb)->saddr;
+	struct sock *sk = skb->sk;
+	unsigned int ret;
+
+	ret = nf_nat_ipv6_fn(priv, skb, state);
+
+	if (ret != NF_ACCEPT || !sk || inet_sk_transparent(sk))
+		return ret;
+
+	/* see nf_nat_ipv4_local_in */
+	if (ipv6_addr_cmp(&saddr, &ipv6_hdr(skb)->saddr) ||
+	    nf_nat_inet_port_was_mangled(skb, sk->sk_dport))
+		skb_orphan(skb);
+
+	return ret;
+}
+
 static unsigned int
 nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state)
@@ -1051,7 +1109,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	},
 	/* After packet filtering, change source */
 	{
-		.hook		= nf_nat_ipv6_fn,
+		.hook		= nf_nat_ipv6_local_in,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC,
-- 
2.41.0

