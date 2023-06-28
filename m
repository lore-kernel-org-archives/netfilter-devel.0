Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DF0EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jun 2023 02:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjF1Cd3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 22:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjF1Cd2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 22:33:28 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC17211C
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2023 19:33:26 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1aa291b3fc9so4810445fac.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2023 19:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687919605; x=1690511605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZEkydroC7/HuNPolsZB7qabjiLuOesTh39J0lN183Y=;
        b=VaUM7D39hki7XjDsVhwOa+/TRT0EGf3v8wuoe6HYiIjXgvVuWcuBJZpSu/0AmHM6QA
         uWbLWCzghZSzUe6KP9GZiSe2ylUn0nGj1nx1xF/D5DyM6MBfOBzHfE9AsASBzzns6ohL
         2WttYHLzUkDc3wnEgnhWu4F/Rd3+00vxW6RIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687919605; x=1690511605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZEkydroC7/HuNPolsZB7qabjiLuOesTh39J0lN183Y=;
        b=jHT81i7TdwWVUJRKKfKjja9dPRFVFnQuH3Le5o6nYP/rxRS7xSok0Ie+Zfzl8YN5aL
         5YvUkrp3T5a5k1nniGtUPhMwoq4iNFRoc9Bxb7djd3Qm+eAHp6tFIpBDJwlj3IMQVJ3v
         gnlGrZmB/fS7UGQIqX6nJIPFNcYveZbjH2+lftU9h3QYZLFtYIv/PzqLBjyU4q7Abgpb
         mIWonTTwsX3tnQnlbxmCWdFwi8Qcb0MJW+wDNapbcgyuzz88BzqSfYjCfPX5JhiZL00Y
         erVlmbCejW9y+8wGANSfaSj8M1MmiufOKJ898wvkRJujBCKwZ0cZ8T4Qs4klxrYiUcc2
         zQZA==
X-Gm-Message-State: AC+VfDxLMQGXYogcPwA0ePEslmH5xID3uoFSIn8GpF6j5+t+5ix/nGwN
        H/galScHVnrQOoDKU1saoZEPyoeDFqahvDQ3Ru2nig==
X-Google-Smtp-Source: ACHHUZ7zenNbR6LikBflr69fuYucxFdlMh5c/vr9IpNUz6ebaWq5uznpeYc4h6AeSiFucNDFes8x6IoQHQz02vvjK9Q=
X-Received: by 2002:a05:6870:a2c5:b0:1b0:6539:40fa with SMTP id
 w5-20020a056870a2c500b001b0653940famr2449080oak.19.1687919605735; Tue, 27 Jun
 2023 19:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net> <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
In-Reply-To: <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Tue, 27 Jun 2023 19:33:14 -0700
Message-ID: <CABi2SkXgTv8Bz62hwkymz2msvNXZQUWM1acT-_Lcq2=Mb-BD6w@mail.gmail.com>
Subject: Re: [PATCH v9 00/12] Network support for Landlock - allowed list of protocols
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>,
        willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, Jeff Xu <jeffxu@google.com>,
        Jorge Lucangeli Obes <jorgelo@chromium.org>,
        Allen Webb <allenwebb@google.com>,
        Dmitry Torokhov <dtor@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 26, 2023 at 8:29=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> Reviving G=C3=BCnther's suggestion to deny a set of network protocols:
>
> On 14/03/2023 14:28, Micka=C3=ABl Sala=C3=BCn wrote:
> >
> > On 13/03/2023 18:16, Konstantin Meskhidze (A) wrote:
> >>
> >>
> >> 2/24/2023 1:17 AM, G=C3=BCnther Noack =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>
> [...]
>
> >>>
> >>> * Given the list of obscure network protocols listed in the socket(2)
> >>>      man page, I find it slightly weird to have rules for the use of =
TCP,
> >>>      but to leave less prominent protocols unrestricted.
> >>>
> >>>      For example, a process with an enabled Landlock network ruleset =
may
> >>>      connect only to certain TCP ports, but at the same time it can
> >>>      happily use Bluetooth/CAN bus/DECnet/IPX or other protocols?
> >>
> >>         We also have started a discussion about UDP protocol, but it's
> >> more complicated since UDP sockets does not establish connections
> >> between each other. There is a performance problem on the first place =
here.
> >>
> >> I'm not familiar with Bluetooth/CAN bus/DECnet/IPX but let's discuss i=
t.
> >> Any ideas here?
> >
> > All these protocols should be handled one way or another someday. ;)
> >
> >
> >>
> >>>
> >>>      I'm mentioning these more obscure protocols, because I doubt tha=
t
> >>>      Landlock will grow more sophisticated support for them anytime s=
oon,
> >>>      so maybe the best option would be to just make it possible to
> >>>      disable these?  Is that also part of the plan?
> >>>
> >>>      (I think there would be a lot of value in restricting network
> >>>      access, even when it's done very broadly.  There are many progra=
ms
> >>>      that don't need network at all, and among those that do need
> >>>      network, most only require IP networking.
> >
> > Indeed, protocols that nobody care to make Landlock supports them will
> > probably not have fine-grained control. We could extend the ruleset
> > attributes to disable the use (i.e. not only the creation of new relate=
d
> > sockets/resources) of network protocol families, in a way that would
> > make sandboxes simulate a kernel without such protocol support. In this
> > case, this should be an allowed list of protocols, and everything not i=
n
> > that list should be denied. This approach could be used for other kerne=
l
> > features (unrelated to network).
> >
> >
> >>>
> >>>      Btw, the argument for more broad disabling of network access was
> >>>      already made at https://cr.yp.to/unix/disablenetwork.html in the
> >>>      past.)
> >
> > This is interesting but scoped to a single use case. As specified at th=
e
> > beginning of this linked page, there must be exceptions, not only with
> > AF_UNIX but also for (the newer) AF_VSOCK, and probably future ones.
> > This is why I don't think a binary approach is a good one for Linux.
> > Users should be able to specify what they need, and block the rest.
>
> Here is a design to be able to only allow a set of network protocols and
> deny everything else. This would be complementary to Konstantin's patch
> series which addresses fine-grained access control.
>
> First, I want to remind that Landlock follows an allowed list approach
> with a set of (growing) supported actions (for compatibility reasons),
> which is kind of an allow-list-on-a-deny-list. But with this proposal,
> we want to be able to deny everything, which means: supported, not
> supported, known and unknown protocols.
>
I think this makes sense.  ChomeOS can use it at the process level:
disable network, allow VSOCK only, allow TCP only, etc.

> We could add a new "handled_access_socket" field to the landlock_ruleset
> struct, which could contain a LANDLOCK_ACCESS_SOCKET_CREATE flag.
>
> If this field is set, users could add a new type of rules:
> struct landlock_socket_attr {
>      __u64 allowed_access;
>      int domain; // see socket(2)
>      int type; // see socket(2)
> }
>
Do you want to add "int protocol" ? which is the third parameter of socket(=
2)
According to protocols(5), the protocols are defined in:
https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

It is part of IPv4/IPV6 header:
https://www.rfc-editor.org/rfc/rfc791.html#section-3.1
https://www.rfc-editor.org/rfc/rfc8200.html#section-3

> The allowed_access field would only contain
> LANDLOCK_ACCESS_SOCKET_CREATE at first, but it could grow with other
> actions (which cannot be handled with seccomp):
> - use: walk through all opened FDs and mark them as allowed or denied
> - receive: hook on received FDs
> - send: hook on sent FDs
>
also bind, connect, accept.

> We might also use the same approach for non-socket objects that can be
> identified with some meaningful properties.
>
> What do you think?

-Jeff
