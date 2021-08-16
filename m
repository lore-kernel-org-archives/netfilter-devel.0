Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24959C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 15:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24F460F4B
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 15:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhHPPs2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 11:48:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55608 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbhHPPsY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 11:48:24 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id AD7DA6004F;
        Mon, 16 Aug 2021 17:47:02 +0200 (CEST)
Date:   Mon, 16 Aug 2021 17:47:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     proelbtn <contact@proelbtn.com>
Cc:     netfilter-devel@vger.kernel.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH v5 2/2] netfilter: add netfilter hooks to SRv6 data plane
Message-ID: <20210816154745.GA1928@salvia>
References: <20210808164323.498860-1-contact@proelbtn.com>
 <20210808164323.498860-3-contact@proelbtn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210808164323.498860-3-contact@proelbtn.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, Aug 08, 2021 at 04:43:23PM +0000, proelbtn wrote:
> This patch introduces netfilter hooks for solving the problem that
> conntrack couldn't record both inner flows and outer flows.

Using pktgen_bench_xmit_mode_netif_receive.sh, I don't see any
noticeable impact in the seg6_input path for non-netfilter users:
similar numbers with and without your patchset.

This is a sample of the perf report output:

    11.67%  kpktgend_0       [ipv6]                    [k] ipv6_get_saddr_eval
     7.89%  kpktgend_0       [ipv6]                    [k] __ipv6_addr_label
     7.52%  kpktgend_0       [ipv6]                    [k] __ipv6_dev_get_saddr
     6.63%  kpktgend_0       [kernel.vmlinux]          [k] asm_exc_nmi
     4.74%  kpktgend_0       [ipv6]                    [k] fib6_node_lookup_1
     3.48%  kpktgend_0       [kernel.vmlinux]          [k] pskb_expand_head
     3.33%  kpktgend_0       [ipv6]                    [k] ip6_rcv_core.isra.29
     3.33%  kpktgend_0       [ipv6]                    [k] seg6_do_srh_encap
     2.53%  kpktgend_0       [ipv6]                    [k] ipv6_dev_get_saddr
     2.45%  kpktgend_0       [ipv6]                    [k] fib6_table_lookup
     2.24%  kpktgend_0       [kernel.vmlinux]          [k] ___cache_free
     2.16%  kpktgend_0       [ipv6]                    [k] ip6_pol_route
     2.11%  kpktgend_0       [kernel.vmlinux]          [k] __ipv6_addr_type

I made a few small updates here on top of your patch, not changing the
numbers that I obtain here either.

#1 Just remove slwt initialization to NULL.

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index f29cdd753a37..cf3d831d7b62 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1115,9 +1115,9 @@ static int seg6_local_input_core(struct net *net, struct sock *sk,
                                 struct sk_buff *skb)
 {
        struct dst_entry *orig_dst = skb_dst(skb);
-       struct seg6_local_lwt *slwt = NULL;
        struct seg6_action_desc *desc;
        unsigned int len = skb->len;
+       struct seg6_local_lwt *slwt;
        int rc;

        slwt = seg6_local_lwtunnel(orig_dst->lwtstate);

#2 encapsulate the netfilter hook codepath.

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 09870ef41768..91d5491b140e 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -355,21 +355,27 @@ static int seg6_input_core(struct net *net, struct sock *sk,
        return seg6_input_finish(dev_net(skb->dev), NULL, skb);
 }

-static int seg6_input(struct sk_buff *skb)
+static int seg6_input_nf(struct sk_buff *skb)
 {
-       int proto;
+       struct net_device *dev = skb_dst(skb)->dev;
+       struct net *net = dev_net(skb->dev);
+
+       switch (skb->protocol) {
+       case htons(ETH_P_IP):
+               return NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING, net,
+                              NULL, skb, NULL, dev, seg6_input_core);
+       case htons(ETH_P_IPV6):
+               return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, net,
+                              NULL, skb, NULL, dev, seg6_input_core);
+       }

-       if (skb->protocol == htons(ETH_P_IPV6))
-               proto = NFPROTO_IPV6;
-       else if (skb->protocol == htons(ETH_P_IP))
-               proto = NFPROTO_IPV4;
-       else
-               return -EINVAL;
+       return -EINVAL;
+}

+static int seg6_input(struct sk_buff *skb)
+{
        if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
-               return NF_HOOK(proto, NF_INET_POST_ROUTING, dev_net(skb->dev),
-                              NULL, skb, NULL, skb_dst(skb)->dev,
-                              seg6_input_core);
+               return seg6_input_nf(skb);

        return seg6_input_core(dev_net(skb->dev), NULL, skb);
 }

First chunk is needed, second chunk I think the use of variable
proto might make __builtin_constant_p() return false in nf_hook().
If you choose to take chunk #2 above, then same idiom could apply to
the seg6_output path (there's a similar function in your patch).

Thanks for your patience.
