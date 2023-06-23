Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D732BC0015E
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jun 2023 14:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjFWOfz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jun 2023 10:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjFWOfy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2023 10:35:54 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3928426A0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2023 07:35:44 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1aa291b3fc9so569868fac.0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2023 07:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687530943; x=1690122943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SEBPStKVcWuK0U9+o4k9p1pZNT3HD7OxhCSF6G1cNQ=;
        b=lBwO2RYXA1FbofoshpI3lj93tY3ca60z4/PmDkydo4xoYcFMNeuPHdNBF1PhvE7mF5
         x+B9+fyQaWDspUByK4Dd38a763lzJM93zzmupkYVMv8Qtrs8STGdUMpu3gwqKlRdO4zf
         mDjg+/i0MeO7gX8VsR37GE7UxxozyYayG5JOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687530943; x=1690122943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2SEBPStKVcWuK0U9+o4k9p1pZNT3HD7OxhCSF6G1cNQ=;
        b=WtjAfUtdlT+8wiyBr3P5GHaBeBqfGFqm4MLH3+a0LWUIM90xNZ5T5ZieNalaFvpsIY
         ZN243VfPTvZkpFWWejQZKHRQS38clSUfajVpSUlsTWP5iHNtnEy6KAMnUdW62lhhJQCC
         VynOV3ciLZqKE0egJitSSdTlYRtVD0r4rJQCRkxp/cEUlkXF8a0gPzOn5IZc+Xr/yvS4
         nEQr8OqauT04ki+YnZGQUSB5c7ZRv5rPj4WUtq5BhsrghqVHlD4S6ljhhmTk3Nd6NwtE
         E9znaAvZScPNslp9cC2ck+7x2Baw0b4FSRTgKGP00iAUL9GkM04Z8wEdqPAGjdD0De9h
         4C+A==
X-Gm-Message-State: AC+VfDzqZE6wWfyvinDn9NE8lkt5Nexjyc0jgNSOz9tc5JDziJhydEzu
        gm8qq4DC8gLP/8Uvee28PHaX+iofxtxED4pdSRH++g==
X-Google-Smtp-Source: ACHHUZ41ySHwYAnHtH61CA+4dnkZdBqUtd5tQsOOy4llzFrD6Whs2u9HXzuxuQst1L9jHxAm1lQplvzBBmykSYenq/w=
X-Received: by 2002:a05:6870:e896:b0:196:8dc3:4e16 with SMTP id
 q22-20020a056870e89600b001968dc34e16mr17947005oan.39.1687530943485; Fri, 23
 Jun 2023 07:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-13-konstantin.meskhidze@huawei.com>
 <ZH89Pi1QAqNW2QgG@google.com> <CABi2SkWqHeLkmqONbmavcp2SCiwe6YeH_3dkBLZwSsk7neyPMw@mail.gmail.com>
 <86108314-de87-5342-e0fb-a07feee457a5@huawei.com> <97c15e23-8a89-79f2-4413-580153827ade@digikod.net>
 <00a03f2c-892d-683e-96a0-c0ba8f293831@digikod.net>
In-Reply-To: <00a03f2c-892d-683e-96a0-c0ba8f293831@digikod.net>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Fri, 23 Jun 2023 07:35:33 -0700
Message-ID: <CABi2SkWJT5xmjBvudEc725uN8iAMCKf5BBOppzgmRJRc2M4nrg@mail.gmail.com>
Subject: Re: [PATCH v11 12/12] landlock: Document Landlock's network support
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
        willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 22, 2023 at 9:50=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
>
> On 13/06/2023 22:12, Micka=C3=ABl Sala=C3=BCn wrote:
> >
> > On 13/06/2023 12:13, Konstantin Meskhidze (A) wrote:
> >>
> >>
> >> 6/7/2023 8:46 AM, Jeff Xu =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>> On Tue, Jun 6, 2023 at 7:09=E2=80=AFAM G=C3=BCnther Noack <gnoack@goo=
gle.com> wrote:
> >>>>
> >>>> On Tue, May 16, 2023 at 12:13:39AM +0800, Konstantin Meskhidze wrote=
:
> >>>>> Describe network access rules for TCP sockets. Add network access
> >>>>> example in the tutorial. Add kernel configuration support for netwo=
rk.
> >>>>>
> >>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.co=
m>
>
> [...]
>
> >>>>> @@ -28,20 +28,24 @@ appropriately <kernel_support>`.
> >>>>>    Landlock rules
> >>>>>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>
> >>>>> -A Landlock rule describes an action on an object.  An object is cu=
rrently a
> >>>>> -file hierarchy, and the related filesystem actions are defined wit=
h `access
> >>>>> -rights`_.  A set of rules is aggregated in a ruleset, which can th=
en restrict
> >>>>> -the thread enforcing it, and its future children.
> >>>>> +A Landlock rule describes an action on a kernel object.  Filesyste=
m
> >>>>> +objects can be defined with a file hierarchy.  Since the fourth AB=
I
> >>>>> +version, TCP ports enable to identify inbound or outbound connecti=
ons.
> >>>>> +Actions on these kernel objects are defined according to `access
> >>>>> +rights`_.  A set of rules is aggregated in a ruleset, which
> >>>>> +can then restrict the thread enforcing it, and its future children=
.
> >>>>
> >>>> I feel that this paragraph is a bit long-winded to read when the
> >>>> additional networking aspect is added on top as well.  Maybe it woul=
d
> >>>> be clearer if we spelled it out in a more structured way, splitting =
up
> >>>> the filesystem/networking aspects?
> >>>>
> >>>> Suggestion:
> >>>>
> >>>>     A Landlock rule describes an action on an object which the proce=
ss
> >>>>     intends to perform.  A set of rules is aggregated in a ruleset,
> >>>>     which can then restrict the thread enforcing it, and its future
> >>>>     children.
> >>>>
> >>>>     The two existing types of rules are:
> >>>>
> >>>>     Filesystem rules
> >>>>         For these rules, the object is a file hierarchy,
> >>>>         and the related filesystem actions are defined with
> >>>>         `filesystem access rights`.
> >>>>
> >>>>     Network rules (since ABI v4)
> >>>>         For these rules, the object is currently a TCP port,
> >>> Remote port or local port ?
> >>>
> >>      Both ports - remote or local.
> >
> > Hmm, at first I didn't think it was worth talking about remote or local=
,
> > but I now think it could be less confusing to specify a bit:
> > "For these rules, the object is the socket identified with a TCP (bind
> > or connect) port according to the related `network access rights`."
> >
> > A port is not a kernel object per see, so I tried to tweak a bit the
> > sentence. I'm not sure such detail (object vs. data) would not confuse
> > users. Any thought?
>
> Well, here is a more accurate and generic definition (using "scope"):
>
> A Landlock rule describes a set of actions intended by a task on a scope
> of objects.  A set of rules is aggregated in a ruleset, which can then
> restrict the thread enforcing it, and its future children.
>
> The two existing types of rules are:
>
> Filesystem rules
>      For these rules, the scope of objects is a file hierarchy,
>      and the related filesystem actions are defined with
>      `filesystem access rights`.
>
> Network rules (since ABI v4)
>      For these rules, the scope of objects is the sockets identified
>      with a TCP (bind or connect) port according to the related
>      `network access rights`.
>
>
> What do you think?
>
I found this is clearer to me (mention of bind/connect port).

In networking, "5-tuple" is a well-known term for connection, which is
src/dest ip, src/dest port, protocol. That is why I asked about
src/dest port.  It seems that we only support src/dest port at this
moment, right ?

Another feature we could consider is restricting a process to "no
network access, allow out-going , allow incoming", this might overlap
with seccomp, but I think it is convenient to have it in Landlock.

Adding protocol restriction is a low hanging fruit also, for example,
a process might be restricted to UDP only (for RTP packet), and
another process for TCP (for signaling) , etc.

Thanks!
-Jeff Xu

>
> >>>
> >>>>         and the related actions are defined with `network access rig=
hts`.
