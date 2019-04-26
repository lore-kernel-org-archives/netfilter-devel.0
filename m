Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A25C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 15:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39B75206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 15:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p+k3zXC+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfDZPAS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:00:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45722 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfDZPAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 11:00:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id e24so1847673pfi.12;
        Fri, 26 Apr 2019 08:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A5Y+MEfrLrdu8cFgwukPbLeOMa8h8CDG6LEpPB89rIc=;
        b=p+k3zXC+msVwPDiTh8ZFLz2dOtBlIVpVmkiMWJMLrbujSRqsiO1qH5CsQ6Fqj8uvWv
         8saQw+waVQ242238j8bPgCHXA0ohHari7ghEBVdMaeNGGzNJAVMeESC96whtfP0Tmw/C
         qFQn1p8G4XKbzOVOfYJMGf3DcA63NGtu1arxjhgFZNfWxfhcHj4ErdBBngFmUdiKmEAk
         hU+CZFZROyJ8WVKIHalTVXwPT15QHT7im47RDFoot+Hxu9NNotgMMu1ZSbn2q8dgf/oP
         T92/isg/gsPnkOSc1dJb3AIf+vNgvXrNFYmNV1fa6E0h0xygfCj+PBTiMLC35uJSEW5D
         0UNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A5Y+MEfrLrdu8cFgwukPbLeOMa8h8CDG6LEpPB89rIc=;
        b=WYfqAkLK7RPjl1rYZnArEKP38bPdT1au55bRg5B7LWuFsbiLDUVYfo+GruSAcXr72e
         pA4c/GqFf92sqhi5/L0hLavs/ohN7iWYCotQ9B4Wp1jPaY1nKWg3Lro/AFNdXoQBAUMN
         oBf59F7GFlm9I2L0B9i+JNyDf2E4CemeRhx0Wp6uYRgvBIvV7pcTBBMFEXxRceIS++tn
         d+aNssAFkMARLLsVAoKlGrp9FwGJQhtLbc12F8Lwqbb+oRXK/3jET407fSUpozTuXQil
         aymrMgFHp7QHwQokGT109xXJ22pz5/FDVedP2it18je887HDumQmfMPlF3asMsChw8P3
         c3hw==
X-Gm-Message-State: APjAAAUHIpXsR6kUzHVofTJ03OSsqDtcSgVpAIj6oY2nb7QSnyyvfLr1
        xTvlIW2aCTgBg0Wu3ETch2AU1owL
X-Google-Smtp-Source: APXvYqxiR+Id+MWGuZ3Ujb9i4Tjd0ZnOAs81XzNPPfdZRya+E5UuH83bo9s6s/kqzm4/Ap7196sYCg==
X-Received: by 2002:a63:b53:: with SMTP id a19mr861877pgl.216.1556290816618;
        Fri, 26 Apr 2019 08:00:16 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c824:60cf:2bea:8fbc? ([2601:282:800:fd80:c824:60cf:2bea:8fbc])
        by smtp.googlemail.com with ESMTPSA id 4sm284982pfi.94.2019.04.26.08.00.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 08:00:15 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] make nla_nest_start() add NLA_F_NESTED flag
To:     Johannes Berg <johannes@sipsolutions.net>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1556269635.git.mkubecek@suse.cz>
 <1dcb87486a96785e3b9e6f337392aa904d977a0d.camel@sipsolutions.net>
 <20190426111954.GG26549@unicorn.suse.cz>
 <a3626aeca20280e8253b575fe72309b2009474a8.camel@sipsolutions.net>
 <20190426115629.GH26549@unicorn.suse.cz>
 <18db9ac8b398b215e3523dd5b79c7f86e21864ce.camel@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47f6daf9-2d14-1566-8ed1-fb5d4dd57bf8@gmail.com>
Date:   Fri, 26 Apr 2019 09:00:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <18db9ac8b398b215e3523dd5b79c7f86e21864ce.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/26/19 6:17 AM, Johannes Berg wrote:
> On Fri, 2019-04-26 at 13:56 +0200, Michal Kubecek wrote:
> 
>>>> I suppose we should, at least the part that attribute with NLA_NESTED
>>>> policy has NLA_F_NESTED flag. I'm not so sure about the opposite (i.e.
>>>> that attributes with other policies do not have the flag) as when I was
>>>> checking where kernel accesses nlattr::nla_type directly rather than
>>>> with nla_type(), I stumbled upon an attribute NL80211_ATTR_VENDOR_DATA
>>>> which has policy NLA_BINARY but is sometimes a nest, AFAICS.
>>>
>>> I guess anyway we can only do it for *new* things, not really for all
>>> existing attributes.
>>
>> Right... but what I wanted to say is that if there is already (at least)
>> one attribute which may or may not be a nest, depending on a context, we
>> should expect there may be also new attributes like that in the future.
> 
> Yeah, but we can handle that as we see it?
> 
> I just reposted my strict validation series - maybe we can right now, as
> it's not released yet, quickly add an NL_VALIDATED_NESTED_FLAG or so to
> it?
> 
> Do you want to take a stab at that? I have to go now, but I could check
> in the next few days.

What is a valid use case for an attribute sometimes being a nest and
sometimes not? That seems really weird to me (ie., wrong). They should
be 2 separate attributes even if the backend processing is the same.
