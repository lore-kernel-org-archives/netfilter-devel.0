Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C467AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 02:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiBLCwO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 21:52:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLCwN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 21:52:13 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD6A2E095
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 18:52:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y5so19421186pfe.4
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 18:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/2em7yd3KJuiYs+UL39zrRw0YtQtwDWfyommQWzAoBs=;
        b=Ytg0pF2tV7J2/7kAy7DuPI7XJCVHUsBTSx7UIZRoUAvXbL2YSEEOPBQVkEIGeCxozh
         /+cgdPl1YNYhcdyLjDnTFzGAsQJX+MuTHKKH7o5zzT2JemBv8qU1zFyl7pJNDndT5bCF
         tKxQKopMyPu1SoItRxwVHcD4e9+fA6QEOWwlbZnnY6fh/MUJJS1v8Sufg3lPMfODcP7o
         XEp6RO5bRC6ntpKC9rhZe8+2yg3ywtiT3uxj9y2mS9BqykVmlTbcwX5sW9Qx4o+9x9yN
         7vKPLLaGxI/o35g2ygh3SctTPZZDTf35yuSLG+YaI3CnKmBHV6rqaDq8X5kwXiOgo3VL
         4l3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/2em7yd3KJuiYs+UL39zrRw0YtQtwDWfyommQWzAoBs=;
        b=kxw9sVd272ddOGxTwtRc9GH+RNFnk8zaL1ZhzzWFri7rwWHHaVdwLkV+oh65uQXVTv
         kJGqT491VQfkPk13cHOHzMI7bboR+vSVQo864Zmr8ZYJTZozRJLOvsk4/BW8/Z9L3vZo
         cjWVe7LDpD85eHMIQPkkkZ9NUbIPcu9LBELOAD+VtyDFtxRExrh1btkAGkg8aNHAkul6
         GkQoFDT1YAggLRpJwV5LX95QcMzWtpC47LQ8RVRO5L7FMpJof2TCGV+XYcqTFqC5M21E
         D5utWZ4r8NW5Lpg4JcyUoVXhjWYc1X1SquptLIkJTE/oPEJbXo5I9AcEz4HQv6vKqNwl
         gE/g==
X-Gm-Message-State: AOAM530wWKUo6lqZPXGOctPJM6dNfTwW42ZlWTYthv0Jp8pZk47EbwBu
        rNnJ9dF3Pn9IUWRpiYjb2AQ=
X-Google-Smtp-Source: ABdhPJzRCNMXQ9sgVZ6PNv4cM1Oe6mCeEp33iIZLzQ6DEmTqoyP1eC97PK+2ap2i4uejQgJEu/4Chw==
X-Received: by 2002:a63:6f45:: with SMTP id k66mr3711232pgc.511.1644634330742;
        Fri, 11 Feb 2022 18:52:10 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c14sm27075404pfm.169.2022.02.11.18.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 18:52:10 -0800 (PST)
Message-ID: <84a8a825-f6b6-53a2-607e-e579b3b6d733@gmail.com>
Date:   Fri, 11 Feb 2022 18:52:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH nf] netfilter: xt_socket: missing ifdef
 CONFIG_IP6_NF_IPTABLES dependency
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
References: <20220211235609.218507-1-pablo@netfilter.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220211235609.218507-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2/11/22 15:56, Pablo Neira Ayuso wrote:
> nf_defrag_ipv6_disable() requires CONFIG_IP6_NF_IPTABLES.
>
> Fixes: 75063c9294fb ("netfilter: xt_socket: fix a typo in socket_mt_destroy()")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   net/netfilter/xt_socket.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index 662e5eb1cc39..7013f55f05d1 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c
> @@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct xt_mtdtor_param *par)
>   {
>   	if (par->family == NFPROTO_IPV4)
>   		nf_defrag_ipv4_disable(par->net);
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>   	else if (par->family == NFPROTO_IPV6)
>   		nf_defrag_ipv6_disable(par->net);
> +#endif
>   }
>   
>   static struct xt_match socket_mt_reg[] __read_mostly = {


Thanks for the fix.

Reviewed-by: Eric Dumazet<edumazet@google.com>


