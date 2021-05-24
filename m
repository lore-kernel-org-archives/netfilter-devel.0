Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED29C04FF3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 08:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5CF610CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 08:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhEXIl1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 May 2021 04:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhEXIl1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 May 2021 04:41:27 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAA3C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 24 May 2021 01:39:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x8so27621999wrq.9
        for <netfilter-devel@vger.kernel.org>; Mon, 24 May 2021 01:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7zZuzVqmuaHMJO5S+QLO0cH8fZ9HhZ5oRucdZk+itBU=;
        b=ZW8elDXg0TDKbfq3Pgj2SmfDGxNMgBGrQWqyWaw9CVPdKRYUKVNsWj9y0f7ISbj/8M
         VDhUQZhbrlvMmykbprD5XRYLLklOFImD/XtM9jHAJSGnj6wKbePOeZG1hqeF+Bg6Wp6M
         fseW1mzeVbqff8wjtX+bC1utQMfUMrFERFqX++dqWGq/VJps7voP6ndIxUM1jAHuBiVM
         vPbg6lGvJgsw0rmJa4CJaaWLlF67Nxet5FBl5/cMGtIUHzDlKQS3GsnKOMSTPnEZbdpJ
         6LtES8fVWeBDXqBz+vcupKs7fEuGuCXHhcmrmUTK4twPAWj5+1ESXdPyPaZ7dw7NN97l
         t11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7zZuzVqmuaHMJO5S+QLO0cH8fZ9HhZ5oRucdZk+itBU=;
        b=UqhGND6xk8EgkCRuAXEtnT895XYcJHr+ohbDPnefN/ce7nOu13bgFleI3aVMykwfAS
         ccX1x9LyYIeUckLYJLkn+f0419BmBPNQkF03AzFtTqnWgeAIa4pOCT4q2P5F0CuBdgPB
         NbxaujhWB2lvbDu9/6sLEJZl4RqX5KXsN1d/grZekU7TpLlNnyTY4YcFmXAT87ZgXMxS
         SvfseX9eTPkDsW5Z+yy6FTSgPElIqnuu9/7tlsEU+V6uz7XS/JZD9TxZyDVz/x0Ycxu+
         zWW1lJsMXMB8V+roqf6HueZokLnJCjzdEXIJ8Zx+pPE6d+gNs59YsjlosCjbstUsBr84
         5wsA==
X-Gm-Message-State: AOAM530HBrAXnQ999rPM6nrwS+yzEaqrDMLzizQ3kKEBttbSsXE9Hc1S
        MrJPB5I2BLqJFivU8EaUGX+MZwoh3kshww==
X-Google-Smtp-Source: ABdhPJxwcsKaTuelU9YSLo9PxfYi7unux+CMfsnYLclfwoLlz77h9zB0/eKXz2phUDDol7pTyh0MMA==
X-Received: by 2002:adf:ce85:: with SMTP id r5mr21923199wrn.198.1621845598326;
        Mon, 24 May 2021 01:39:58 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:a492:2b05:80b4:7953? ([2a01:e0a:410:bb00:a492:2b05:80b4:7953])
        by smtp.gmail.com with ESMTPSA id q1sm7225133wmq.48.2021.05.24.01.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 01:39:57 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] Disable RST seq number check when tcp_be_liberal is
 greater 1
To:     Ali Abdallah <ali.abdallah@suse.com>,
        netfilter-devel@vger.kernel.org
References: <20210521090342.vcuwd7nupytqjwt3@Fryzen495>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <8fd301da-ff2e-9311-6fc4-4f9c718ea0c8@6wind.com>
Date:   Mon, 24 May 2021 10:39:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521090342.vcuwd7nupytqjwt3@Fryzen495>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 21/05/2021 à 11:03, Ali Abdallah a écrit :
> This patch adds the possibility to disable RST seq number check by
> setting tcp_be_liberal to a value greater than 1. The default old
> behaviour is kept unchanged.
> 
> Signed-off-by: Ali Abdallah <aabdallah@suse.de>
> ---
>  Documentation/networking/nf_conntrack-sysctl.rst | 10 ++++++----
>  net/netfilter/nf_conntrack_proto_tcp.c           |  3 ++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index 11a9b76786cb..cfcc3bbd5dda 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -103,12 +103,14 @@ nf_conntrack_max - INTEGER
>  	Size of connection tracking table.  Default value is
>  	nf_conntrack_buckets value * 4.
>  
> -nf_conntrack_tcp_be_liberal - BOOLEAN
> +nf_conntrack_tcp_be_liberal - INTEGER
>  	- 0 - disabled (default)
> -	- not 0 - enabled
> +        - 1 - RST sequence number check only
nit: this line is indented with spaces where other are with tabs.

> +	- greater than 1 - turns off all sequence number/window checks
Why not having a fixed value (like 2 for example)? It will allow to add
different behavior in the future.


Regards,
Nicolas
