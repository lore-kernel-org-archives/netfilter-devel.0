Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086B7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 12:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiDIMt5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 08:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241711AbiDIMt4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 08:49:56 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1042A0469
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 05:47:49 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id s13so14613388ljd.5
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2022 05:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RzyQ1uxJHnnFWZsDThvXbSqCzJK3Etrf5qjnSk3yTGg=;
        b=JhYVQMT9Fj0gcR1XdcFjSkuHzl89Q5+lHljjjxmbKGax2hp626AT7eKgfEw1F+RD7t
         KwhVZnI2XZkFNIpGxGTpyMPZXsqVoR8OVlReb+F4Ge8S39hWSlz7J8rq4uWAzJo2P7Fe
         /jPtWxDhQyDcEjHZTjiXFi+s1+Lcuont5ug9JOH4GLPxTQfYGQ6Nn7ar8nB0urdxlO0J
         5b127R5jatST5Nj7dI2P3rvsrC6Nl8zWRCrFPyF5jDVfwSUdKev0clPjWhUULR4/kpZc
         OkkQeRplwcj0XfF7NhWgnp1y4XQgvGtbB+nHk574Fik/Lz16OAbvbu//E+sWTCMkX70r
         paKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RzyQ1uxJHnnFWZsDThvXbSqCzJK3Etrf5qjnSk3yTGg=;
        b=MM2UwPE5mQm6HuaPCDXbQQO7bOmVucVDkhEHOjCA/y8YIIxBBZZY86lG2qHXpsPyaQ
         95Ggg7PaTAsCH8uK/p0+81BGQaCFQMcf2rNi+1MiZDiOTATjml8b7W/RxHfwmScFWGSO
         DCgTRUqEcJ7jL89J9uE2fAg25pItV5GVYN0CtJ344iHjfV0AzkfFBGC8s09O0X3G+tic
         DJUk5+RSanHe6t7mgMYoRSJmIoxyr6dgePd258YTew53S+BMo/Td0DXumKV3mUYi+jO8
         QYQbHF2jUvA28bSi9+pzscu2j9cZDjg1WaE4Lw0IOrYCsy2eIpT1nbpIn9DyDDoGNPzB
         D7FQ==
X-Gm-Message-State: AOAM533l1DRRpYly4XmBMM5pQm+1Pw9DoSSxHAc7jQoizwg3OLutH+L4
        2QAbMo10u2rQ92h3FJkigyU=
X-Google-Smtp-Source: ABdhPJz9WbLiTfF0wdvUDVCHp0RokBxUjuz8gQIQ9+wpj+kmZQprVB2E+1yWMnMhGDlE8kMzPSI/CA==
X-Received: by 2002:a2e:b994:0:b0:24b:5810:6492 with SMTP id p20-20020a2eb994000000b0024b58106492mr1693674ljp.482.1649508467514;
        Sat, 09 Apr 2022 05:47:47 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id p3-20020a056512312300b0046b83c2f92fsm488412lfd.58.2022.04.09.05.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 05:47:47 -0700 (PDT)
Message-ID: <f5e82293-6ba0-5e4d-58a6-ceb0780ca0a6@gmail.com>
Date:   Sat, 9 Apr 2022 15:47:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH nf] netfilter: nft_socket: make cgroup match work in input
 too
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220409112019.12113-1-fw@strlen.de>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220409112019.12113-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 9.4.2022 14.20, Florian Westphal wrote:
> cgroupv2 helper function ignores the already-looked up sk
> and uses skb->sk instead.
> 
> Just pass sk from the calling function instead; this will
> make cgroup matching work for udp and tcp in input even when
> edemux did not set skb->sk already.
> 
> Cc: Topi Miettinen <toiwoton@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   NB: compile tested only.
> 
>   net/netfilter/nft_socket.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
> index bd3792f080ed..6d9e8e0a3a7d 100644
> --- a/net/netfilter/nft_socket.c
> +++ b/net/netfilter/nft_socket.c
> @@ -37,12 +37,11 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
>   
>   #ifdef CONFIG_SOCK_CGROUP_DATA
>   static noinline bool
> -nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
> +nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
>   {
> -	struct sock *sk = skb_to_full_sk(pkt->skb);
>   	struct cgroup *cgrp;
>   
> -	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
> +	if (!sk_fullsock(sk))
>   		return false;
>   
>   	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> @@ -109,7 +108,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
>   		break;
>   #ifdef CONFIG_SOCK_CGROUP_DATA
>   	case NFT_SOCKET_CGROUPV2:
> -		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
> +		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
>   			regs->verdict.code = NFT_BREAK;
>   			return;
>   		}

Great, now rule 'ct state new socket cgroupv2 level 1 vmap 
@dict_cgroup_level_1_in' in input filter started matching incoming packets.

Tested-by: Topi Miettinen <toiwoton@gmail.com>

-Topi
