Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB327C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9445F24296
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfE2WXR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 18:23:17 -0400
Received: from ja.ssi.bg ([178.16.129.10]:56316 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbfE2WXR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 18:23:17 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x4TMM6Qe021583;
        Thu, 30 May 2019 01:22:06 +0300
Date:   Thu, 30 May 2019 01:22:06 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jacky Hu <hengqing.hu@gmail.com>
cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v3] ipvs: add checksum support for gue encapsulation
In-Reply-To: <20190528231107.14197-1-hengqing.hu@gmail.com>
Message-ID: <alpine.LFD.2.21.1905300115590.2934@ja.home.ssi.bg>
References: <20190528231107.14197-1-hengqing.hu@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 29 May 2019, Jacky Hu wrote:

>  	gueh = (struct guehdr *)skb->data;
>  
>  	gueh->control = 0;
>  	gueh->version = 0;
> -	gueh->hlen = 0;
> +	gueh->hlen = optlen >> 2;
>  	gueh->flags = 0;
>  	gueh->proto_ctype = *next_protocol;
>  
> +	data = &gueh[1];
> +
> +	if (need_priv) {
> +		__be32 *flags = data;
> +		u16 csum_start = skb_checksum_start_offset(skb);
> +		__be16 *pd = data;

	Packet tests show another problem. Fix is to defer
pd assignment after data += GUE_LEN_PRIV:

		__be16 *pd;

> +
> +		gueh->flags |= GUE_FLAG_PRIV;
> +		*flags = 0;
> +		data += GUE_LEN_PRIV;
> +
> +		if (csum_start < hdrlen)
> +			return -EINVAL;
> +
> +		csum_start -= hdrlen;

		pd = data;

> +		pd[0] = htons(csum_start);
> +		pd[1] = htons(csum_start + skb->csum_offset);
> +
> +		if (!skb_is_gso(skb)) {
> +			skb->ip_summed = CHECKSUM_NONE;
> +			skb->encapsulation = 0;
> +		}
> +
> +		*flags |= GUE_PFLAG_REMCSUM;
> +		data += GUE_PLEN_REMCSUM;
> +	}
> +

Regards

--
Julian Anastasov <ja@ssi.bg>
