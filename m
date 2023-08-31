Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A585C83F12
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 10:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344751AbjHaKqs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 06:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345195AbjHaKqo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 06:46:44 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6498EE5B
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 03:46:25 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-7870821d9a1so374807241.1
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 03:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693478784; x=1694083584; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9HH0pKuwxbpYfmmH3wi8yllUGUsscm71vXLck0Atrk=;
        b=VY2qSViwUdZpm7BiKSWkPIGF8/vT3DE+iwJXBp0nhnR/HIUzGzb6zBE7ji2WVPGN/h
         2EgWwWdfIQ1l4tV+bp0TR8mFO4aF/vffo2ogooySDBEO9SSOZIZs5Nit+3l46kAf5u5K
         /hnDSxfbRlEG+W6aoPwpsFLYq+b1N3eBRz3v1egxtpVYD82YlVYQwv5lBD4buTuaAwbP
         e8cl4XqCkiss9xgfKj3pE4gNV9BexMW5AzCM4a3eAE/AQNx12bTBBheU06FKPIZ2AyC5
         grdkEOyMwNfZCLBw1yNGtnJoyKOa3jnokBGdcWv4j1thbwGrgfeEoXV+9kCmL+hbwOsn
         bLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693478784; x=1694083584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9HH0pKuwxbpYfmmH3wi8yllUGUsscm71vXLck0Atrk=;
        b=bxH9AadEdxi/bHTFD/2TQVA349pBEDnbT39P1UfRal8KKAl7/byOfvxJhTE1hwueSy
         A8Pc5NuQCkDpsd3z5IATv4WIYUWhwyXHI0cl8fdZMc5+rQScwNzs63nx9aIRaiJcFMwR
         8kbPmH8jG4byHJgCfABTWrxtinmHfE9XPACKndR0O8jiafX32CV/uu3mIojvt0LPKdBe
         a5fOybxMkY0KVoQHqv8H4pTKIfbZodCJknkN3+HYpVJMAkKKGaPDZyVi3bS6bIpDz5bw
         wviyYaNJ0OOgP457s2DWZHOWuaP8rjjMPF2P2/c4RK6R4ROMiogFy6VUVxs8fSG/o1Fn
         PmwA==
X-Gm-Message-State: AOJu0Yx/0Hs2L3ro1Ts4B2LfYDhdTrGYVG9eV6gvcf9/pYSoweKeDtv0
        aJND5mK2CrlSFPe+M17L/OGgMsAgKm2QEIbmiuI=
X-Google-Smtp-Source: AGHT+IGrKj3N6MdUOyuhiWR5r9pKDrL1JMZaDeXJF2FOvVok8Na1yQUKHC/L+Do66tUdrT3eFWsw007a96blXZwmgSw=
X-Received: by 2002:a05:6102:823:b0:44e:e45f:3543 with SMTP id
 k3-20020a056102082300b0044ee45f3543mr950002vsb.7.1693478783737; Thu, 31 Aug
 2023 03:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZsLFsThq4jz1gx0UZj5ab+6SUbhPxy+gsM1d7o2S49LdA@mail.gmail.com>
 <86o37onn-8431-noor-1p0p-8764n0855n74@vanv.qr> <CAA85sZvuN5f4Lf3VxOe1Dj9-gq=gD9z4_DwPN_CedJiNeviNsg@mail.gmail.com>
 <47p877oo-o3q5-55q4-03s4-110290n2oq70@vanv.qr>
In-Reply-To: <47p877oo-o3q5-55q4-03s4-110290n2oq70@vanv.qr>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Thu, 31 Aug 2023 12:46:12 +0200
Message-ID: <CAA85sZsQtX_D3_FsRe9QteCRvyX177zdaHFeAkP9o+9KDquRQw@mail.gmail.com>
Subject: Re: MASQ leak?
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 31, 2023 at 11:53=E2=80=AFAM Jan Engelhardt <jengelh@inai.de> w=
rote:
> On Thursday 2023-08-31 11:40, Ian Kumlien wrote:
> >> >               type filter hook forward priority 0
> >> >                ct state invalid counter drop # <- this one
> >> >
> >> >It just seems odd to me that traffic can go through without being NAT=
:ed
> >>
> >> MASQ requires connection tracking; if tracking is disabled for a conne=
ction,
> >> addresses cannot be changed.
> >
> >I don't disable connection tracking - this is most likely a expired
> >session that is reused and IMHO it should just be added
>
> "invalid" is not just invalid but also untracked (or untrackable)
> CTs, and icmpv6-NDISC is not tracked for example (icmpv6-PING is).

This was normal udp and tcp traffic...

> Expired (forgotten) CTs are automatically recreated in the middle by defa=
ult,
> one needs extra rules to change the behavior (e.g. `tcp syn` test when
> ctstate=3D=3DNEW).

I can do more debugging about the traffic that goes haywire, I have
all the logs at home.

But with:
nf_conntrack_tcp_loose - BOOLEAN
0 - disabled
not 0 - enabled (default)

If it is set to zero, we disable picking up already established
connections.

Which is the default value:
cat /proc/sys/net/netfilter/nf_conntrack_tcp_loose
1

IMHO iI shouldn't have to fudge things to make conntrack pick things up aga=
in.
