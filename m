Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10272C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 18:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiD0SNo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiD0SNn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 14:13:43 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E52DFEB
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 11:10:31 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so4633110lfb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 11:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=80PrWU4Gt1uCt35DdC+XHqx47ZpIzXkofMoBem5NUrQ=;
        b=kisjsm3VlSQZAkZv9ZNLvwbfb1gYIt7IaeS4Bgs9ArDV4clKqs8YCi6/DoJ3uv17k8
         v8naHNMgi2htiYcEW05JcKE0Gb+YoLbYwQtzNFTAZa8LWr4ct6228Qh1ZrR3vC/vPCpN
         8viBXKlXB250PTn/8W82uvCT2ex3wF00DJzR8k+upIiI1RsXXMQM5bN6DbmVGNL/WC3E
         JYntHISOz2Kx/RYldljXiBPrgorQTsjYhoFQDDsAEL5tyQ5vQbsCfmV5cXb4y+O43ZHQ
         pnazo1ktiT/hjbOlwLN9UdC2oANyFsmzj/c/pcGnwJZl/ZcQ3fyfj+5lnyXxC+D2KI2+
         D/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=80PrWU4Gt1uCt35DdC+XHqx47ZpIzXkofMoBem5NUrQ=;
        b=pNJevMxo0WLSiqP3qcNm+aj1J0W/C4mAQM/3AGl4PU0VN79EybxdScuXTuJsQOi3tg
         S+dCR8LWYl5Iy59o5Vzf+SvEA7rx/8isoi29UKhTKE5FZ/QOoJMy5sZh7bvksMG0Zs4U
         BWvZHayqBPnu3TNwx7xtUuAvRR1NtZ77WUDnvt1W5HOEjinsqfdp4MHMKkUL718/4bZp
         fyauWrLWrnLoSRTTykBNpWPz64jmz7+nvrWhMttQOGf1ybLykwlKMSIBDpA1L0sFwWRK
         lqZH5E+wx63T64PpsR7IptSnUI1V4FwUH7kSyGZzfty28baeONWEi1cc7JrKel1It2aw
         ++gg==
X-Gm-Message-State: AOAM530P4ui3HBf5oPiNmdxu0E255QOOv27dAwr18qW6DWRWWWJOW8WN
        nrOrA1cIHd12cD7ArN1PbNmoKonNfA5gsQ==
X-Google-Smtp-Source: ABdhPJzj83R6sm1lJP1CYd42K3JahXTsAJSaAl3GDpjeJzX6mQNJGQPJk7e2zQjPoN3g1S2Q/hSJYg==
X-Received: by 2002:ac2:5f84:0:b0:471:fd0f:a6e7 with SMTP id r4-20020ac25f84000000b00471fd0fa6e7mr15033074lfe.41.1651083029480;
        Wed, 27 Apr 2022 11:10:29 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id t10-20020a2e780a000000b0024f0ea282acsm1157727ljc.100.2022.04.27.11.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 11:10:28 -0700 (PDT)
Message-ID: <2810eacb-5940-0c96-2996-74742365da5e@gmail.com>
Date:   Wed, 27 Apr 2022 21:10:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH nf] netfilter: nft_socket: only do sk lookup when indev is
 available
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220427160218.9997-1-fw@strlen.de>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220427160218.9997-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 27.4.2022 19.02, Florian Westphal wrote:
> nft_socket lacks .validate hooks to restrict its use to the prerouting
> and input chains.
> 
> Adding such restriction now may break existing setups, also, if skb
> has a socket attached to it, nft_socket will work fine.
> 
> Therefore, check if the incoming interface is available and NFT_BREAK
> in case neither skb->sk nor input device are set.
> 
> Reported-by: Topi Miettinen <toiwoton@gmail.com>
> Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks. After applying this patch, my test case which triggered a BUG in 
a few tries, doesn't do it anymore with 25 attempts.

Tested-by: Topi Miettinen <toiwoton@gmail.com>

> ---
>   net/netfilter/nft_socket.c | 41 +++++++++++++++++++++++++-------------
>   1 file changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
> index 6d9e8e0a3a7d..cbd1e4523ace 100644
> --- a/net/netfilter/nft_socket.c
> +++ b/net/netfilter/nft_socket.c
> @@ -54,6 +54,32 @@ nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo
>   }
>   #endif
>   
> +static struct sock *nft_socket_do_lookup(const struct nft_pktinfo *pkt)
> +{
> +	const struct net_device *indev = nft_in(pkt);
> +	const struct sk_buff *skb = pkt->skb;
> +	struct sock *sk = NULL;
> +
> +	if (!indev)
> +		return NULL;
> +
> +	switch(nft_pf(pkt)) {
> +	case NFPROTO_IPV4:
> +		sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, indev);
> +		break;
> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
> +	case NFPROTO_IPV6:
> +		sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, indev);
> +		break;
> +#endif
> +	default:
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +
> +	return sk;
> +}
> +
>   static void nft_socket_eval(const struct nft_expr *expr,
>   			    struct nft_regs *regs,
>   			    const struct nft_pktinfo *pkt)
> @@ -67,20 +93,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
>   		sk = NULL;
>   
>   	if (!sk)
> -		switch(nft_pf(pkt)) {
> -		case NFPROTO_IPV4:
> -			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
> -			break;
> -#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
> -		case NFPROTO_IPV6:
> -			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
> -			break;
> -#endif
> -		default:
> -			WARN_ON_ONCE(1);
> -			regs->verdict.code = NFT_BREAK;
> -			return;
> -		}
> +		sk = nft_socket_do_lookup(pkt);
>   
>   	if (!sk) {
>   		regs->verdict.code = NFT_BREAK;

