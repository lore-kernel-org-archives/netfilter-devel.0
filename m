Return-Path: <SRS0=Qa8H=6C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424BEC352BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Apr 2020 18:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A82F21BE5
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Apr 2020 18:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEDsP6OH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgDRSZV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Apr 2020 14:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgDRSZU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Apr 2020 14:25:20 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BCAC061A0C
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2020 11:25:20 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id y129so1463019vkf.6
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2020 11:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uc5wtqxGcR85QDx9ywZRewLKmynLUqWrEKf98QlmrKc=;
        b=YEDsP6OHJeUnm4Acg4fRTHbQkFDSIMiQix5FvcPcckHfBriJ44sOOOLeDmbEajXRi5
         y7chv5y0H2nw4fyKwkHBv3YxUMG3NrmR3kXjdfGmMziIMZJSZ1XKyx/2xx7wsjqnol69
         Us7sv8Oe95csiL8xWN4EoY4WenBFMUIoLdMYqJnB3LlDtGPrg70itQLwjAVTZBuhYZQ9
         7wII43oHZNQjjUGC031jox1aKY6azSbq4pDEJiRfS6e9Gz0+fVsIriA/X2L0dgK64x/1
         teYc4wIUhqMptEwxKy2W8Ft+Qkg+KQhjRAZd+ce2kF/TMdPYzzw2XqYKjKv7p3NeDCA8
         MAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uc5wtqxGcR85QDx9ywZRewLKmynLUqWrEKf98QlmrKc=;
        b=CrGWvbxx8CKsVXRbrl9jGjInTArNnTCMWsV+9fPx9m/DrFaosZrwP+Y30K6eDqNDT4
         xWEuLIeld8PjUyrtU80LLLnqoVdXboW4YBYGkvWZgvwzW50thk+39xG4bHtpMV4hthfe
         yDhfEyGEa5i2uo2TWV1nw2nd6AX7mga/xaLFj06Y1VCMaOQaY5oefgQnBFGQ0VC0eK2k
         SfUpA8a3swZIgmr+MSsuDfp9ETTLyJCRFEKlbe4koyICIFpesaNCIWWOCfIprSu7uTed
         YCwezwdrwuOhCYRlF6E0upn3Qi0XPP/rjPriRlrdJhw4swAFDQT40OtQIGZepB8ewan7
         K7+w==
X-Gm-Message-State: AGi0PuaOEZuDoWKMxL5P9FeLeCrunmnGSp87s9c4mok+juMo6Tl3nrYT
        IiTTEkkSxm7N5TUvhfns1nVCmbZk+okinnX6bZLUTw==
X-Google-Smtp-Source: APiQypJAvMjGw2yJLcTVX/Yw1GKUY4bFEOH6REXVg95IY5uA1L6rEiJwRwIjlgBiIzSXME3LjpmmPqJiwTEpfWmLdZE=
X-Received: by 2002:a1f:2ac4:: with SMTP id q187mr6526757vkq.6.1587234319008;
 Sat, 18 Apr 2020 11:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200407180124.19169-1-ydahhrk@gmail.com> <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
 <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
In-Reply-To: <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Sat, 18 Apr 2020 20:25:07 +0200
Message-ID: <CAF90-WhkRhsY6D+NgUCjVxaT2G+hzfgaP_UP4_MUusADUPA1xQ@mail.gmail.com>
Subject: Re: [nft PATCH 2/2] expr: add jool expressions
To:     Alberto Leiva <ydahhrk@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 15, 2020 at 11:41 PM Alberto Leiva <ydahhrk@gmail.com> wrote:
>
> > Looking at the code, the pool4db is pretty much an adaptation of what
> > conntrack already does. So, why not to put the efforts in extending
> > conntrack to support NAT64/NAT46 ?
>
> Ok, please don't take this as an aggressively defensive gesture, but I
> feel like this is an unfair question.
>

Sorry, but I don't get your point. What I meant is that both pool4db
and conntrack are natting machines, so extending conntrack (which is
already integrated in the kernel) with what pool4db does could be a
good way to go.

Anyway, please let me come back to the technical discussion.

> If I provide a ready and simple but effective means to bridge our
> projects I feel like it befalls on you to justify why you wish to
> commit to the far more troublesome course of action.
>
> Merging the projects seems to me like several (if not many) months
> worth of development and testing, little of which would be made in
> benefit of our users. (No real functionality would be added, and some
> functionality might be dropped--eg. atomic configuration, session
> synchronization.)
>

Atomic configuration is already supported in nftables and extending
conntrack all the security functionalities and session replication
with conntrackd will be also available.

> I mean I get that you want to avoid some duplicate functionality, but
> is this really a more important use of my time than, say, adding MAP-T
> support? ([0])
>
> > This way, the support of this natting is likely to be included in the
> > kernel vanilla and just configure it with just one rule:
> >
> > sudo nft add rule inet table1 chain1 dnat 64 64:ff9b::/96
>
> Ok, but I don't think an IP translator is *meant* to be configured in
> a single line. Particularly in the case of NAT46. How do you populate
> a large EAM table ([1]) on a line? If your translator instance is
> defined entirely in a rule matched by IPv6 packets, how do you tell
> the corresponding IPv4 rule to refer to the same instance?
>

nft supports maps generation from user space, so something like this
could be configured:

table inet my_table {
    map my_eamt {
        type ipv4_addr : ipv6_addr;
        flags interval;
        elements = { 192.0.2.1/32 : 2001:db8:aaaa::5/128,
                     198.51.100.0/24 : 2001:db8:bbbb::/120,
                     203.0.113.8/29 : 2001:db8:cccc::/125 }
    }
}

And then, use this map to perform the nat rule:

nft add rule inet my_table my_chain snat ip saddr to @my_eamt

Currently, the map structure doesn't work cause the second item should
be a singleton, but probably it can be fixed easily.

> It is my humble opinion that some level of separation between nftables
> rules and translator instances is clean design.
>

My humble opinion is that this model will be hard to accept after the
great efforts done with nftables that joins different commands that
were used in the age of iptables.

> > One more thing, it seems that jool only supports PREROUTING, is that right?
>
> Yes, although this might presently only be because nobody has asked elsewhat.
>
> I tried adding LOCAL_OUT support some years ago and forgot to write
> down the problems that prevented me from succeeding. I can give it
> another shot if this is important for you.
>

My concern is that this can break the normalization of having source
nat in the postrouting instead of in the prerouting phase. Note that
integrating a new feature must ensure not breaking other subsystems.

Cheers.
