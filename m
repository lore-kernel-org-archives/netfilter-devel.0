Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB680C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F4C60187
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhHQIMV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 04:12:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57422 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbhHQIMU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:20 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9E52360049;
        Tue, 17 Aug 2021 10:10:59 +0200 (CEST)
Date:   Tue, 17 Aug 2021 10:11:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ryoga Saito <contact@proelbtn.com>
Cc:     netfilter-devel@vger.kernel.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH v6 2/2] netfilter: add netfilter hooks to SRv6 data plane
Message-ID: <20210817081142.GA30218@salvia>
References: <20210817063453.8487-1-contact@proelbtn.com>
 <20210817063453.8487-3-contact@proelbtn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210817063453.8487-3-contact@proelbtn.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

A few more comments.

On Tue, Aug 17, 2021 at 06:34:53AM +0000, Ryoga Saito wrote:
> This patch introduces netfilter hooks for solving the problem that
> conntrack couldn't record both inner flows and outer flows.
> 
> Signed-off-by: Ryoga Saito <contact@proelbtn.com>
> ---
>  net/ipv6/seg6_iptunnel.c |  79 +++++++++++++++++++++++++--
>  net/ipv6/seg6_local.c    | 114 +++++++++++++++++++++++++++------------
>  2 files changed, 153 insertions(+), 40 deletions(-)
> 
> diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
> index 897fa59c47de..83074b9f4b7e 100644
> --- a/net/ipv6/seg6_iptunnel.c
> +++ b/net/ipv6/seg6_iptunnel.c
> @@ -26,6 +26,8 @@
>  #ifdef CONFIG_IPV6_SEG6_HMAC
>  #include <net/seg6_hmac.h>
>  #endif
> +#include <net/lwtunnel.h>
> +#include <net/netfilter/nf_conntrack.h>

I think this #include <net/netfilter/nf_conntrack.h> is not required,
nf_reset_ct() is available through linux/skbuff.h. Same comment
applies to net/ipv6/seg6_local.c

>  static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
>  {
> @@ -295,25 +297,33 @@ static int seg6_do_srh(struct sk_buff *skb)
>  
>  	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
>  	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
> +	nf_reset_ct(skb);
>  
>  	return 0;
>  }
>  
> -static int seg6_input(struct sk_buff *skb)
> +static int seg6_input_finish(struct net *net, struct sock *sk,
> +			     struct sk_buff *skb)
> +{
> +	return dst_input(skb);
> +}
> +
> +static int seg6_input_core(struct net *net, struct sock *sk,
> +			   struct sk_buff *skb)
>  {
>  	struct dst_entry *orig_dst = skb_dst(skb);
>  	struct dst_entry *dst = NULL;
>  	struct seg6_lwt *slwt;
>  	int err;
>  
> +	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);

No need to move this assignement before calling seg6_do_srh()...

> +
>  	err = seg6_do_srh(skb);
>  	if (unlikely(err)) {
>  		kfree_skb(skb);
>  		return err;
>  	}
>  
> -	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);

... it could stay still here, right?

> -
>  	preempt_disable();
>  	dst = dst_cache_get(&slwt->cache);
>  	preempt_enable();
