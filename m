Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5C0C32792
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 20:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C60E22500
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 20:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfI3Uo2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 16:44:28 -0400
Received: from ja.ssi.bg ([178.16.129.10]:40676 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729158AbfI3Uo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 16:44:28 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 16:44:27 EDT
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x8UIncN1008757;
        Mon, 30 Sep 2019 21:49:39 +0300
Date:   Mon, 30 Sep 2019 21:49:38 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     zhang kai <zhangkaiheb@126.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: no need to update skb route entry for local
 destination packets.
In-Reply-To: <20190930051455.GA20692@toolchain>
Message-ID: <alpine.LFD.2.21.1909302146530.2706@ja.home.ssi.bg>
References: <20190930051455.GA20692@toolchain>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Mon, 30 Sep 2019, zhang kai wrote:

> In the end of function __ip_vs_get_out_rt/__ip_vs_get_out_rt_v6,the
> 'local' variable is always zero.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	Simon, this is for -next kernels...

> ---
>  net/netfilter/ipvs/ip_vs_xmit.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 9c464d24beec..037c7c91044e 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -407,12 +407,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  		goto err_put;
>  
>  	skb_dst_drop(skb);
> -	if (noref) {
> -		if (!local)
> -			skb_dst_set_noref(skb, &rt->dst);
> -		else
> -			skb_dst_set(skb, dst_clone(&rt->dst));
> -	} else
> +	if (noref)
> +		skb_dst_set_noref(skb, &rt->dst);
> +	else
>  		skb_dst_set(skb, &rt->dst);
>  
>  	return local;
> @@ -574,12 +571,9 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  		goto err_put;
>  
>  	skb_dst_drop(skb);
> -	if (noref) {
> -		if (!local)
> -			skb_dst_set_noref(skb, &rt->dst);
> -		else
> -			skb_dst_set(skb, dst_clone(&rt->dst));
> -	} else
> +	if (noref)
> +		skb_dst_set_noref(skb, &rt->dst);
> +	else
>  		skb_dst_set(skb, &rt->dst);
>  
>  	return local;
> -- 
> 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>
