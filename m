Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DD9C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Nov 2023 11:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbjKALdG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Nov 2023 07:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjKALdF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Nov 2023 07:33:05 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8F9F7
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2023 04:33:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9c53e8b7cf4so989608966b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Nov 2023 04:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1698838380; x=1699443180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K5zvKog8HQLzYN/XvwRtFabnNOCnUKmRFkdOP0ebbE4=;
        b=ONpA1wk7fSyJIFMn4r1LdsCfSCYDQnghp/sgvPPrAfkufx9Tm4WodqcGpmUeWKez+3
         +oOKZ3IMHiA3NDno6Hqj7oNR4WCztErF1CYL3vUPYiLYHEeRfUPb6o4g11f44ooYcAwf
         j3VEvFJMC/voGcILOUp7DlKcqDeEa7TXmdMtsGAEDua+w9i09hjACK4ZgApiGY+AHiHF
         RjcR+hkm0Z7wLHjLjZDlyJQfMWMkgeD5Ri/5XXJQzT9SvWAULElTospHZ0Pc04AYtF0R
         K6KcOR7P6eD3eLCPdK/CDiORqDjrFhXWBCIQZTUs+chr81O2tITkk8ndK28+EEtmN3fq
         Lhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698838380; x=1699443180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5zvKog8HQLzYN/XvwRtFabnNOCnUKmRFkdOP0ebbE4=;
        b=KzdjXdJUbt0yTWpggqXy4yY5DSjVT5tTzR+61jBZ8qI6uowg7ZARRCyctWnjH482u9
         avN9t7FNhIDYTg57zzErD2hSnz9NoL9mrlol2vfbt2QLdV1+CT02QfVKrACY8dJO3ZPO
         UUyefJUHdjPomHO3BrVd4gb17iUncWLFhx5gI41dhkwQUcnquoTTp9qckjvO64/kL5Oz
         Ia9BuDcdwoWV1uqmmKtE1q6s6B5CaC8dEiLkvmbAm5LUjwlpxa+t+SU6OgoBRbTy5xb9
         Y7pwlxfLleoAkrm29tX6rPkYWbkVNDFYXRTzI95uwPPd71gp3SCx1m7Le1L6PWQSstCS
         g0GQ==
X-Gm-Message-State: AOJu0YzSPOtDrgsQu+I8Ww5Sl3nk8yTQaxkQ8BdC8382NYl6cQCbbJpC
        mP292epGKHCkAqufc8ln2XQPaQ==
X-Google-Smtp-Source: AGHT+IFET6T7UbtnRkgYS3b8biNok8ggyPfsq03TAsox5mB78i8CFJp/EVzs29b9qBJV8fU9BRnf4w==
X-Received: by 2002:a17:907:a088:b0:9be:45b3:1c3b with SMTP id hu8-20020a170907a08800b009be45b31c3bmr1906271ejc.60.1698838380522;
        Wed, 01 Nov 2023 04:33:00 -0700 (PDT)
Received: from [192.168.0.106] (starletless.turnabout.volia.net. [93.73.214.90])
        by smtp.gmail.com with ESMTPSA id u11-20020a1709063b8b00b009829d2e892csm2345057ejf.15.2023.11.01.04.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 04:33:00 -0700 (PDT)
Message-ID: <b83796ec-39ff-38f1-2cbc-8ad2af22c75d@blackwall.org>
Date:   Wed, 1 Nov 2023 13:32:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] netfilter: bridge: initialize err to 0
Content-Language: en-US
To:     xiaolinkui <xiaolinkui@gmail.com>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, roopa@nvidia.com,
        edumazet@google.com
Cc:     netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
References: <20231101032018.10616-1-xiaolinkui@kylinos.cn>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20231101032018.10616-1-xiaolinkui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11/1/23 05:20, xiaolinkui wrote:
> From: Linkui Xiao <xiaolinkui@kylinos.cn>
> 
> K2CI reported a problem:
> 
> 	consume_skb(skb);
> 	return err;
> [nf_br_ip_fragment() error]  uninitialized symbol 'err'.
> 
> err is not initialized, because returning 0 is expected, initialize err
> to 0.
> 
> Reported-by: k2ci <kernel-bot@kylinos.cn>
> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> ---
>   net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 71056ee84773..0fcf357ea7ad 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -37,7 +37,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
>   	ktime_t tstamp = skb->tstamp;
>   	struct ip_frag_state state;
>   	struct iphdr *iph;
> -	int err;
> +	int err = 0;
>   
>   	/* for offloaded checksums cleanup checksum before fragmentation */
>   	if (skb->ip_summed == CHECKSUM_PARTIAL &&

The patch looks good, but needs a Fixes: tag. It's also not easy to say
if err can remain uninitialized, I think in theory (and maybe with a
specially crafted skb) it can be.
