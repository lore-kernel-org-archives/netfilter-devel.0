Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A1DC282DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A357B206BA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiqy09bu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbfDQNSd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:18:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45601 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbfDQNSd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:18:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id y3so11990539pgk.12;
        Wed, 17 Apr 2019 06:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vkoxkn4VZXgP/wvxt6Ouomzj/8M228ZmcfFjY6/Q5YI=;
        b=aiqy09bu+01scWi6ccyj3f7Ql9d46Q86dJDDGdZJ564RgsC2gqUp9eGmownSwhGN8i
         e1GTcv7UHv/0w7iuMNmnj531EFJkHENsPCeoc98PaQiuBuZf4si0LYAK4Ovx+6e8yVr5
         WfMZfiSEVswHYD/mrFBQLPX9WtF9OcZBSV3UaqhqhnTzVbVmziA0fFISvXFvPUepRHW/
         Y8iRDjn7h7RB9mel9n07iXX1w3EKRW79COP6Yc5b/IiNUY7mdfPZID67d0NRGAcfU5on
         ooANrKbgWNcn6VSqiNJHyQIWrK8okWrRwqtQ0I9pACloSurzW+dvFFBL7E8wFQVMCN5M
         ZPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vkoxkn4VZXgP/wvxt6Ouomzj/8M228ZmcfFjY6/Q5YI=;
        b=GShVR5+h3ijzLAQxCAZfdVtVxByS9r4vvrUc02iJ4+y4AGbYqXBNOVm4PYpuBmiucr
         Ha/sOlFDKc7LJCc1YnB7bJkriLXuluPnfQx7d85ezBbGJfygneLwxv0EoMflwwUuMZ8H
         FX29H/AFO8j5IDqrkuZUH4Zebi8lJBulrNmBI74pH0lP6/CB1uAefS3hJl1gYnLcxzo8
         BhTTZa0nLcR7dL59lyD/O1xTiXrySOfv0DFIJYgZK+D5I1LYAdUNU2lsVaVNTZaOXGtD
         bEnuiAlLr5MfRJkM4KdtuhJPSuCETsFDR+J8Xbc6GSRgS9XpvQu2Uu0rgMY6kc4nS6o+
         OfMw==
X-Gm-Message-State: APjAAAX3vfB0Vm2S7Ako1meI3dReyjEuj2cR8aDMY7hIccdUTthBXfQR
        KdOLj6qk1mo2ITj0+Mt4pyo=
X-Google-Smtp-Source: APXvYqw541zVY/D5a26cCyeKDsda3TyQGzlO0i0i78boi1L9CHlGfvokWgM0rY8LLhl6yRUX54TDOg==
X-Received: by 2002:a62:1193:: with SMTP id 19mr87553441pfr.82.1555507112570;
        Wed, 17 Apr 2019 06:18:32 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id z21sm78024521pfn.139.2019.04.17.06.18.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 06:18:31 -0700 (PDT)
Subject: Re: [PATCH] ipvs:set sock send/receive buffer correctly
To:     linmiaohe <linmiaohe@huawei.com>, wensong@linux-vs.org,
        horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Cc:     Mingfangsen <mingfangsen@huawei.com>, liujie165@huawei.com
References: <501e5522-1d69-7c67-a1bc-fd8502d3b5d1@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <60c11e72-99eb-fcde-e130-a35ecdc1d2d1@gmail.com>
Date:   Wed, 17 Apr 2019 06:18:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <501e5522-1d69-7c67-a1bc-fd8502d3b5d1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 04/17/2019 02:18 AM, linmiaohe wrote:
> From: Jie Liu <liujie165@huawei.com>
> 
> If we set sysctl_wmem_max or sysctl_rmem_max larger than INT_MAX,
> the send/receive buffer of sock will be an negative value. Same as
> when the val is larger than INT_MAX/2.
> 
> Fixes: 1c003b1580e2 ("ipvs: wakeup master thread")
> Reported-by: Qiang Ning <ningqiang1@huawei.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Jie Liu <liujie165@huawei.com>
> ---
>  net/netfilter/ipvs/ip_vs_sync.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 2526be6b3d90..c0e4cbed6e74 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -1278,14 +1278,12 @@ static void set_sock_size(struct sock *sk, int mode, int val)
>  	/* setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &val, sizeof(val)); */
>  	lock_sock(sk);
>  	if (mode) {
> -		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
> -			      sysctl_wmem_max);
> -		sk->sk_sndbuf = val * 2;
> +		val = min_t(u32, val, sysctl_wmem_max);
> +		sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);

What prevents val * 2 to overflow ? 

Code in sock_setsockopt() looks quite different.

>  		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
>  	} else {
> -		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
> -			      sysctl_rmem_max);
> -		sk->sk_rcvbuf = val * 2;
> +		val = min_t(u32, val, sysctl_rmem_max);
> +		sk->sk_rcvbuf = max_t(int, val * 2, SOCK_MIN_RCVBUF);
>  		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
>  	}
>  	release_sock(sk);
> 
