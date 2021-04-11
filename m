Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2774C433ED
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Apr 2021 19:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B6686108B
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Apr 2021 19:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhDKTdn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Apr 2021 15:33:43 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47981 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235391AbhDKTdn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Apr 2021 15:33:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 14095580655;
        Sun, 11 Apr 2021 15:33:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Apr 2021 15:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KFOWlITIZvMI0cVY3
        yMUuA5YDP6FhJz2hsfwRPVriEc=; b=C3wW8WNi/fYcOaCx5ZbDjcSSZlCiOKC19
        ZOvS/s9r+A3HD2Af9v8sXsS9gcaIFgu3f8n+VORIjk6HfHu5f0zIzYgoFZqVjT4t
        TbB2sE9X4iyTlzxjtVwSJTVZbQ2pqm4QTUgioi95PTy0ZIY5JxQXgRKu/iEOpZ27
        xDzg2yhGE9Gvhak0bbZAD+dzbReB9i+Ts4vkXvBk6sizpmfZb/MuBji0RCFiFZsU
        MB7DsO/cBNiRsxQaFAkgNyaW5aRlRVDWBWkrcxthUhDSEFB+m1Gn4S2ZpFXkpFp1
        u4gQQkUUMgY639qotleA+rE41aZ+s7UUXI9FLXuXaaCo52SuJA2wA==
X-ME-Sender: <xms:BE9zYLXOgiUI9Pe7Y4RyNT3xeezl77qWsxWyI4KfiztQChj-fX0aRw>
    <xme:BE9zYDm9OktwDEXHCWoy6LG_TzivZPL2PcV8LJlmMV7VrKzu0sbFveXVEwnEmuyv0
    glfB0zDSm-v53k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekhedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrudekjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BE9zYHYf8KPVSMu-nd_i_P_efDsO-BYyL5JnDooiua-7weU4goCXiQ>
    <xmx:BE9zYGXVLCMLBVuU3d84DVJtDOIZoMjRdDiHUYYbE7bR0PPdz7mRqQ>
    <xmx:BE9zYFleL82s3Y5_9RlZJLdE6bKmfuV4aizjmkLf7y9xN-FwcTpPzw>
    <xmx:Bk9zYLUHop-gH-yePDzRJeT6i2nfits7lBKXihD_nmtSBF48QzAlzg>
Received: from shredder.lan (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 35EAD240054;
        Sun, 11 Apr 2021 15:33:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        msoltyspl@yandex.pl, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH nf-next] netfilter: Dissect flow after packet mangling
Date:   Sun, 11 Apr 2021 22:32:51 +0300
Message-Id: <20210411193251.1220655-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Netfilter tries to reroute mangled packets as a different route might
need to be used following the mangling. When this happens, netfilter
does not populate the IP protocol, the source port and the destination
port in the flow key. Therefore, FIB rules that match on these fields
are ignored and packets can be misrouted.

Solve this by dissecting the outer flow and populating the flow key
before rerouting the packet. Note that flow dissection only happens when
FIB rules that match on these fields are installed, so in the common
case there should not be a penalty.

Reported-by: Michal Soltys <msoltyspl@yandex.pl>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
Targeting at nf-next since this use case never worked.
---
 net/ipv4/netfilter.c | 2 ++
 net/ipv6/netfilter.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 7c841037c533..aff707988e23 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -25,6 +25,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	__be32 saddr = iph->saddr;
 	__u8 flags;
 	struct net_device *dev = skb_dst(skb)->dev;
+	struct flow_keys flkeys;
 	unsigned int hh_len;
 
 	sk = sk_to_full_sk(sk);
@@ -48,6 +49,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 		fl4.flowi4_oif = l3mdev_master_ifindex(dev);
 	fl4.flowi4_mark = skb->mark;
 	fl4.flowi4_flags = flags;
+	fib4_rules_early_flow_dissect(net, skb, &fl4, &flkeys);
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index ab9a279dd6d4..6ab710b5a1a8 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,6 +24,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sock *sk = sk_to_full_sk(sk_partial);
+	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
@@ -38,6 +39,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	};
 	int err;
 
+	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
 	dst = ip6_route_output(net, sk, &fl6);
 	err = dst->error;
 	if (err) {
-- 
2.30.2

