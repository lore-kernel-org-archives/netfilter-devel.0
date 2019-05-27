Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D80C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 21:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FB452075E
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 21:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfE0V2T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 17:28:19 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37348 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbfE0V2S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 17:28:18 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hVNAG-0000Um-Dc; Mon, 27 May 2019 23:28:16 +0200
Date:   Mon, 27 May 2019 23:28:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 3/4] netfilter: synproxy: extract SYNPROXY
 infrastructure from {ipt,ip6t}_SYNPROXY
Message-ID: <20190527212816.2xs6isymbgp5mp2d@breakpoint.cc>
References: <20190524170106.2686-1-ffmancera@riseup.net>
 <20190524170106.2686-4-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524170106.2686-4-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> +static void
> +synproxy_send_tcp_ipv6(struct net *net,
> +		       const struct sk_buff *skb, struct sk_buff *nskb,
> +		       struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
> +		       struct ipv6hdr *niph, struct tcphdr *nth,
> +		       unsigned int tcp_hdr_size)
> +{
> +	struct dst_entry *dst;
> +	struct flowi6 fl6;
> +
> +	nth->check = ~tcp_v6_check(tcp_hdr_size, &niph->saddr, &niph->daddr, 0);
> +	nskb->ip_summed   = CHECKSUM_PARTIAL;
> +	nskb->csum_start  = (unsigned char *)nth - nskb->head;
> +	nskb->csum_offset = offsetof(struct tcphdr, check);
> +
> +	memset(&fl6, 0, sizeof(fl6));
> +	fl6.flowi6_proto = IPPROTO_TCP;
> +	fl6.saddr = niph->saddr;
> +	fl6.daddr = niph->daddr;
> +	fl6.fl6_sport = nth->source;
> +	fl6.fl6_dport = nth->dest;
> +	security_skb_classify_flow((struct sk_buff *)skb,
> +				   flowi6_to_flowi(&fl6));
> +	dst = ip6_route_output(net, NULL, &fl6);

All good, BUT the above function call also pulls in ipv6.ko.
You can fold this patch to avoid it, it coverts it to use the
nf_ip6_route() wrapper which internally uses the v6ops pointer
for ip6_route_output if needed.

diff --git a/net/netfilter/nf_synproxy.c b/net/netfilter/nf_synproxy.c
--- a/net/netfilter/nf_synproxy.c
+++ b/net/netfilter/nf_synproxy.c
@@ -434,6 +434,7 @@ synproxy_send_tcp_ipv6(struct net *net,
 {
 	struct dst_entry *dst;
 	struct flowi6 fl6;
+	int err;
 
 	nth->check = ~tcp_v6_check(tcp_hdr_size, &niph->saddr, &niph->daddr, 0);
 	nskb->ip_summed   = CHECKSUM_PARTIAL;
@@ -448,11 +449,10 @@ synproxy_send_tcp_ipv6(struct net *net,
 	fl6.fl6_dport = nth->dest;
 	security_skb_classify_flow((struct sk_buff *)skb,
 				   flowi6_to_flowi(&fl6));
-	dst = ip6_route_output(net, NULL, &fl6);
-	if (dst->error) {
-		dst_release(dst);
+	err = nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
+	if (err)
 		goto free_nskb;
-	}
+
 	dst = xfrm_lookup(net, dst, flowi6_to_flowi(&fl6), NULL, 0);
 	if (IS_ERR(dst))
 		goto free_nskb;
