Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAD8C43460
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83DD60BBB
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349252AbhDNIVg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 04:21:36 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34551 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349776AbhDNIVf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 04:21:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5DDE85803E5;
        Wed, 14 Apr 2021 04:21:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 14 Apr 2021 04:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/OsC9Zi84Dwx7rnrAIWYWxiCOc4LXNyFGsLFdSYXBpM=; b=UtyQAYQp
        tphJBo48Zb6rfv2mDN/sH3e9vYFfUCwm2RTlnDfgy28cNjFROtA4lnk4zcvYmAyN
        xbt9jNo4OvKCuQ4qLmMVMjFkXvQfgs8mkb5JUz0b9PRJThL9Ly4Y9nduAoSQ1q67
        zQa+fBgK3sLDCx/5zmJPA7GmwjLOddv5AYwMiUQJRhyS4okoosdiLG62VJKxNjaM
        VIcKxIGg3o74f8pAso00DXkxBgrLllx5psVKqteFgZRBbduTSlpLsvX08fyrpWzW
        jw6Qntdta1gIausTBW3k+BhZUiroYdXLSjCkytPI+ImMGC/PCa5V7++l/BDa1qFq
        +o0AXiWUd9cdGg==
X-ME-Sender: <xms:-qV2YK4QCQLGxHhUqkb1k0jC5jlGvVujLqPONlLVH2ugKCsKOof-8A>
    <xme:-qV2YD6KNo-8gdNmh9JEdXeAXCuid9IGzKFfnypr6lQ-O4TNNzd621L3FL_mFdaXX
    WzgpEkXbWgyXCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeluddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-qV2YJfo9CZFOvhoL7M6izhP0qdswctUOp2GrWQccXUjMmEMZOreaA>
    <xmx:-qV2YHIeVkGboc8cMKNrp5i7zrCJld8Igi0xdVs_xiyz_81qlNfgsg>
    <xmx:-qV2YOImYVosT6Z_SfpH03Dc99UrBbssRs8Fa0gqWCzV8mkz8yLNXQ>
    <xmx:-qV2YPofb6CBBzCVm0r1TKB0mszwEWq3j7YkdW4VNeQC_Ay7ydCAzw>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89D5424005D;
        Wed, 14 Apr 2021 04:21:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        msoltyspl@yandex.pl, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH nf-next v2 1/2] netfilter: Dissect flow after packet mangling
Date:   Wed, 14 Apr 2021 11:20:32 +0300
Message-Id: <20210414082033.1568363-2-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414082033.1568363-1-idosch@idosch.org>
References: <20210414082033.1568363-1-idosch@idosch.org>
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

