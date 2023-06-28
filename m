Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9DCEB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jun 2023 21:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjF1V5i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jun 2023 17:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjF1V5T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2023 17:57:19 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B64213D
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2023 14:56:59 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-5633b7e5f90so12417eaf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2023 14:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687989419; x=1690581419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVNaY1PkrDCLUbKLctmii1e+XYZxv3OOcSq6XrzK1MM=;
        b=hvTbu8TIovKcYE3p7tIvCkJOS+A8l9AAVTGwVE4icy0bcAt6IRvcx/bo4zV5sC3Wcv
         NSUOw8OHQncjcaeIbkKsDpB5uVKK8Z97lDzGSBzBWJY5GBlmV+/Qyv2gOZQW6HLigVxx
         s479svxgY//DEJP8ODxrPYatrrI0SlwOvWqvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687989419; x=1690581419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVNaY1PkrDCLUbKLctmii1e+XYZxv3OOcSq6XrzK1MM=;
        b=JHQs9xbfnKoey47jjWCBTXD2Y+2Dy0lU/CFuLtRVqRS0ruqjXKbgyGH0J1+s8Oy8BF
         iKrQpethDEbjPyjtTnQ986VpEP0k98CzLJ24fRTYIlFnCBsKbYoogF0me0R/9i1ylt5p
         Rsjp9yimaiy9kaqMaDvjcmrENoZvZocxZkEnLFNsUVSWS/M5HjdRjVl+/68k9xQWedW8
         F/c9MgWhk5XTmjsDYoJWjkR0V3VJS1vFjC9HmHK5e5yPtprbnM2FfmbvzWRWv1EdNffx
         osNrLzFgr6MN6sfs9rDPDBPwGlLU5vLR6bVWKpr4fIHgTKiuYm5rNwt/NTP0JPss3cSI
         cPNQ==
X-Gm-Message-State: AC+VfDyjquOZsBotxIHAE4z2b6DBT8RY6BVfIx4rm5NxkQ+iB49AbX9M
        5GdzY1NRZI4p+GRiat+na1b+288A/NWzOXXzTjzuXg==
X-Google-Smtp-Source: ACHHUZ43sp8ZFu5BzqH28HI8+C9YFLmuV9a8GJJMI6fP+Qnf+nFbusxqHK2wBEW1XAmdFa5ESrWpV8+kCJY5Ld+FhC8=
X-Received: by 2002:a4a:a581:0:b0:565:8648:9cf1 with SMTP id
 d1-20020a4aa581000000b0056586489cf1mr4692412oom.0.1687989418853; Wed, 28 Jun
 2023 14:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net> <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
 <CABi2SkXgTv8Bz62hwkymz2msvNXZQUWM1acT-_Lcq2=Mb-BD6w@mail.gmail.com> <a6318388-e28a-e96f-b1ae-51948c13de4d@digikod.net>
In-Reply-To: <a6318388-e28a-e96f-b1ae-51948c13de4d@digikod.net>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Wed, 28 Jun 2023 14:56:48 -0700
Message-ID: <CABi2SkVWU=Wxb2y3fP702twyHBD3kVoySPGSz2X22VckvcHeXw@mail.gmail.com>
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

On Wed, Jun 28, 2023 at 12:03=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
>
>
> On 28/06/2023 04:33, Jeff Xu wrote:
> > On Mon, Jun 26, 2023 at 8:29=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> >>
> >> Reviving G=C3=BCnther's suggestion to deny a set of network protocols:
> >>
> >> On 14/03/2023 14:28, Micka=C3=ABl Sala=C3=BCn wrote:
> >>>
> >>> On 13/03/2023 18:16, Konstantin Meskhidze (A) wrote:
> >>>>
> >>>>
> >>>> 2/24/2023 1:17 AM, G=C3=BCnther Noack =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> >>
> >> [...]
> >>
> >>>>>
> >>>>> * Given the list of obscure network protocols listed in the socket(=
2)
> >>>>>       man page, I find it slightly weird to have rules for the use =
of TCP,
> >>>>>       but to leave less prominent protocols unrestricted.
> >>>>>
> >>>>>       For example, a process with an enabled Landlock network rules=
et may
> >>>>>       connect only to certain TCP ports, but at the same time it ca=
n
> >>>>>       happily use Bluetooth/CAN bus/DECnet/IPX or other protocols?
> >>>>
> >>>>          We also have started a discussion about UDP protocol, but i=
t's
> >>>> more complicated since UDP sockets does not establish connections
> >>>> between each other. There is a performance problem on the first plac=
e here.
> >>>>
> >>>> I'm not familiar with Bluetooth/CAN bus/DECnet/IPX but let's discuss=
 it.
> >>>> Any ideas here?
> >>>
> >>> All these protocols should be handled one way or another someday. ;)
> >>>
> >>>
> >>>>
> >>>>>
> >>>>>       I'm mentioning these more obscure protocols, because I doubt =
that
> >>>>>       Landlock will grow more sophisticated support for them anytim=
e soon,
> >>>>>       so maybe the best option would be to just make it possible to
> >>>>>       disable these?  Is that also part of the plan?
> >>>>>
> >>>>>       (I think there would be a lot of value in restricting network
> >>>>>       access, even when it's done very broadly.  There are many pro=
grams
> >>>>>       that don't need network at all, and among those that do need
> >>>>>       network, most only require IP networking.
> >>>
> >>> Indeed, protocols that nobody care to make Landlock supports them wil=
l
> >>> probably not have fine-grained control. We could extend the ruleset
> >>> attributes to disable the use (i.e. not only the creation of new rela=
ted
> >>> sockets/resources) of network protocol families, in a way that would
> >>> make sandboxes simulate a kernel without such protocol support. In th=
is
> >>> case, this should be an allowed list of protocols, and everything not=
 in
> >>> that list should be denied. This approach could be used for other ker=
nel
> >>> features (unrelated to network).
> >>>
> >>>
> >>>>>
> >>>>>       Btw, the argument for more broad disabling of network access =
was
> >>>>>       already made at https://cr.yp.to/unix/disablenetwork.html in =
the
> >>>>>       past.)
> >>>
> >>> This is interesting but scoped to a single use case. As specified at =
the
> >>> beginning of this linked page, there must be exceptions, not only wit=
h
> >>> AF_UNIX but also for (the newer) AF_VSOCK, and probably future ones.
> >>> This is why I don't think a binary approach is a good one for Linux.
> >>> Users should be able to specify what they need, and block the rest.
> >>
> >> Here is a design to be able to only allow a set of network protocols a=
nd
> >> deny everything else. This would be complementary to Konstantin's patc=
h
> >> series which addresses fine-grained access control.
> >>
> >> First, I want to remind that Landlock follows an allowed list approach
> >> with a set of (growing) supported actions (for compatibility reasons),
> >> which is kind of an allow-list-on-a-deny-list. But with this proposal,
> >> we want to be able to deny everything, which means: supported, not
> >> supported, known and unknown protocols.
> >>
> > I think this makes sense.  ChomeOS can use it at the process level:
> > disable network, allow VSOCK only, allow TCP only, etc.
> >
> >> We could add a new "handled_access_socket" field to the landlock_rules=
et
> >> struct, which could contain a LANDLOCK_ACCESS_SOCKET_CREATE flag.
> >>
> >> If this field is set, users could add a new type of rules:
> >> struct landlock_socket_attr {
> >>       __u64 allowed_access;
> >>       int domain; // see socket(2)
>
> I guess "family" would also make sense. It's the name used in the
> kernel, the "AF" prefixes, and address_families(7). I'm not sure why
> "domain" was chosen for socket(2).
>
Agree also.

>
> >>       int type; // see socket(2)
> >> }
> >>
> > Do you want to add "int protocol" ? which is the third parameter of soc=
ket(2)
> > According to protocols(5), the protocols are defined in:
> > https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtm=
l
> >
> > It is part of IPv4/IPV6 header:
> > https://www.rfc-editor.org/rfc/rfc791.html#section-3.1
> > https://www.rfc-editor.org/rfc/rfc8200.html#section-3
>
> I understand the rationale but I'm not sure if this would be useful. Do
> you have use cases?
>
I agree this field is not commonly used, so might not be that useful.
In most cases, the protocol field will just be 0.

One case I thought of previously is building an icmp or DHCP packet
with raw socket,  but now I'm not sure what kind of support/enforce
the kernel has for the protocol field with raw socket.

We can drop this for now, if there is a clearer requirement in future,
it is easy to add a new rule.

>
> >
> >> The allowed_access field would only contain
> >> LANDLOCK_ACCESS_SOCKET_CREATE at first, but it could grow with other
> >> actions (which cannot be handled with seccomp):
> >> - use: walk through all opened FDs and mark them as allowed or denied
> >> - receive: hook on received FDs
> >> - send: hook on sent FDs
> >>
> > also bind, connect, accept.
>
> I don't think "accept" would be useful, and I'm not sure if "bind" and
> "connect" would not be redundant with LANDLOCK_ACCESS_NET_{CONNECT,BIND}_=
TCP
> Bind and connect for a datagram socket is optional, so this might lead
> to a false sense of security. If we want to support protocols other than
> TCP to restrict bind/connect, then they deserve to be controlled
> according to a port (or similar).
>
> >
> >> We might also use the same approach for non-socket objects that can be
> >> identified with some meaningful properties.
> >>
> >> What do you think?
> >
> > -Jeff
