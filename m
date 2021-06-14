Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BD1C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 13:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2896061245
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 13:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhFNNVF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 09:21:05 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:47080 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhFNNVF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 09:21:05 -0400
Received: by mail-wm1-f44.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so12763763wmq.5
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2021 06:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZTA57oOz8Cdz7Ap0zeagZ1NVaajdzSi2IzO+/mv1lRI=;
        b=FarIWjuocwFevFTICawiUlOPLBkN2IDCx6tamjQ4Uvo82pD/sTH1drfgDw5Ih7tNu9
         PifDWuz4jhapKG+nwMQI/byFbG1qKJrHhzsg5p2R8SSO3huy9fwZowADDIQ8X3thBXBH
         keCY+l87rrat6v4mfdoFQ9N0Lvw1XvOxRrXh5+2p8OKQ1RawRAfAj56zPBbIl2wC7DVm
         0Cz6OcZ0MMUxzn2diYQANRXndxzk5tIxQwNkFDg6TMM/T+sw6lgS5a6B7zSab7uOQJYT
         rfvhQ5dLjv5ZDrFqbWHbJw4E2MeKb0etToK/FbesgqlwgZzIlHn7SJjG4HDlcRWjIXfh
         2J1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZTA57oOz8Cdz7Ap0zeagZ1NVaajdzSi2IzO+/mv1lRI=;
        b=Ykt3Trf59R0Su11aPfJ2ftmH5eFLB1kQPmtSssWOGHsHpSWirEAsmNLljpuQums84z
         HKNT0/3Nhs6karkyXTCTf2lbp73ouwpFaf9bigohxI7ND7FpcjprQXtOzNEq7GjDEHiK
         m8tyLgjyV35ZAsyKJi02WQ0Bxy5myV1Pr68Gx4TXRqlPdT9+/o4Dr0QThUWsXHYTWv7Q
         5YlGUPLtqqA5s2CVMry+iN/hPYeZdeepkIj3az6UI4VTy3ueBVqqYSmk3JO+4q4idFtj
         pPs/Beui4zPTchdsi892LYz8FjiO7tMhRKTo9lpQ+E0OYV0TE/le886rhpYUKIbVdLYZ
         bbsQ==
X-Gm-Message-State: AOAM532Rx88Gdcnl6ADmNY60l3aK/1PkweW4RAXToLa2dGa4D4Polxhz
        G/DR+2RvxBqZf5w56guiLr3Idg==
X-Google-Smtp-Source: ABdhPJzI5raTilhic38b/8STLJOYFtdiUsvq4un3+YbZDUVNkkFAx43hiKBHx78KUY8Dj9/Jk1ZuMA==
X-Received: by 2002:a7b:cb01:: with SMTP id u1mr33141372wmj.188.1623676682254;
        Mon, 14 Jun 2021 06:18:02 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:ddd2:2038:ae02:164a? ([2a01:e0a:410:bb00:ddd2:2038:ae02:164a])
        by smtp.gmail.com with ESMTPSA id n10sm16570348wre.95.2021.06.14.06.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:18:01 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] MAINTAINERS: netfilter: add irc channel
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netdev <netdev@vger.kernel.org>
References: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9b60107e-dcd4-3ca0-f83d-0e51ccf5d67c@6wind.com>
Date:   Mon, 14 Jun 2021 15:18:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 28/05/2021 à 10:48, Nicolas Dichtel a écrit :
> The community #netfilter IRC channel is now live on the libera.chat network
> (https://libera.chat/).
> 
> CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
> Link: https://marc.info/?l=netfilter&m=162210948632717
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
I have no feedback on this. Is there a problem to add the irc channel in the
MAINTAINERS file?


Regards,
Nicolas

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d834bebf469..d9c7f8b5cae2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12649,6 +12649,7 @@ W:	http://www.netfilter.org/
>  W:	http://www.iptables.org/
>  W:	http://www.nftables.org/
>  Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
> +C:	irc://irc.libera.chat/netfilter
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
>  F:	include/linux/netfilter*
> 
