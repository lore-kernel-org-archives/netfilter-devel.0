Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748C4EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jun 2023 03:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjF2DTR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jun 2023 23:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjF2DTK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2023 23:19:10 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE85D271B
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2023 20:19:07 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-56584266c41so143836eaf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2023 20:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688008747; x=1690600747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APmjph+zNksYOqRT2uL1eVQxQmKXOai2Qn3Rh4F3dOg=;
        b=d7nfZxAEpGiW3h5ETdktdiyETtBL+cYJpnb4rO93t2QNnsTHfiF2tqOssKOmtMohvr
         tnyA/iNYHGBqo/0CNu0pYLyaAoRzhh94kIFlcmK0jFd7xIRM9Kl3eXFKG6mGntkGiDND
         fgrECbmmqtC/ze5d/njKeFEGxaCLyD7aF3EZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688008747; x=1690600747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APmjph+zNksYOqRT2uL1eVQxQmKXOai2Qn3Rh4F3dOg=;
        b=XWMMUwOk7bxB+HWBhlbqqze7h1zs3xLL4p7vT4+0YlOimgI14oy39TvOpSp1kkCk/h
         fDhu06lAKKMTuyTVYU/PPPSxccsXSRy3H2n7UjyBVJ4yQBMUYCHxY7s2DnVSxOQez2BI
         tn+cxC88ymre57ysyTj5wGp6OROmA08Z1RRRd52xvJqUhqp4GKMvJjLTknCBH+2Dd1Ve
         Z+1quOoJK/AGBvQTnTVY9gC3mvcYpaUnKiRCikc+cooP/E3iBdvVdFQUMMDeqmoBVlx/
         HpqVyXvUQlRa2mCBI3wUcI69W116nR2IySyPyfVs0TRj/z+qwzr7qvhtQVhNvBcGIHQ8
         QUlQ==
X-Gm-Message-State: AC+VfDyWc5u3koXgY3bpseqTqGONfSJvxG7oyBChK7qxGy6mH7rzhiXl
        sK8lV3swQ5rmfPd3ohkmq+qK5PMuR8n/LQPtBrq6VQ==
X-Google-Smtp-Source: ACHHUZ7PBhkgCUJGfmCv1eJZwo06+bK2N2WIUA5YdL+qs6O0jkUvGc0LCODjm3wF9r00YNjBPXSAMa8tITBQIDMTBJM=
X-Received: by 2002:a4a:a7c2:0:b0:563:2507:3173 with SMTP id
 n2-20020a4aa7c2000000b0056325073173mr11839201oom.5.1688008747101; Wed, 28 Jun
 2023 20:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net> <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
 <ZJvy2SViorgc+cZI@google.com> <CABi2SkX-dzUO6NnbyqfrAg7Bbn+Ne=Xi1qC1XMrzHqVEVucQ0Q@mail.gmail.com>
 <43e8acb2-d696-c001-b54b-d2b7cf244de7@digikod.net>
In-Reply-To: <43e8acb2-d696-c001-b54b-d2b7cf244de7@digikod.net>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Wed, 28 Jun 2023 20:18:56 -0700
Message-ID: <CABi2SkV1Q-cvMScEtcsHbgNRuGc39eJo6KT=GwUxsWPpFGSR4A@mail.gmail.com>
Subject: Re: [PATCH v9 00/12] Network support for Landlock - allowed list of protocols
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
        "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
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

resend.

On Wed, Jun 28, 2023 at 12:29=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
>
>
> On 28/06/2023 19:03, Jeff Xu wrote:
> > Hello,
> >
> > Thanks for writing up the example for an incoming TCP connection ! It
> > helps with the context.
> >
> > Since I'm late to this thread, one thing I want to ask:  all the APIs
> > proposed so far are at the process level, we don't have any API that
> > applies restriction to socket fd itself, right ? this is what I
> > thought, but I would like to get confirmation.
>
> Restriction are applied to actions, not to already existing/opened FDs.
> We could add a way to restrict opened FDs, but I don't think this is the
> right approach because sandboxing is a deliberate action from a process,
> and it should already take care of its FDs.
>
>
> >
> > On Wed, Jun 28, 2023 at 2:09=E2=80=AFAM G=C3=BCnther Noack <gnoack@goog=
le.com> wrote:
> >>
> >> Hello!
> >>
> >> On Mon, Jun 26, 2023 at 05:29:34PM +0200, Micka=C3=ABl Sala=C3=BCn wro=
te:
> >>> Here is a design to be able to only allow a set of network protocols =
and
> >>> deny everything else. This would be complementary to Konstantin's pat=
ch
> >>> series which addresses fine-grained access control.
> >>>
> >>> First, I want to remind that Landlock follows an allowed list approac=
h with
> >>> a set of (growing) supported actions (for compatibility reasons), whi=
ch is
> >>> kind of an allow-list-on-a-deny-list. But with this proposal, we want=
 to be
> >>> able to deny everything, which means: supported, not supported, known=
 and
> >>> unknown protocols.
> >>>
> >>> We could add a new "handled_access_socket" field to the landlock_rule=
set
> >>> struct, which could contain a LANDLOCK_ACCESS_SOCKET_CREATE flag.
> >>>
> >>> If this field is set, users could add a new type of rules:
> >>> struct landlock_socket_attr {
> >>>      __u64 allowed_access;
> >>>      int domain; // see socket(2)
> >>>      int type; // see socket(2)
> >>> }
> >>>
> >>> The allowed_access field would only contain LANDLOCK_ACCESS_SOCKET_CR=
EATE at
> >>> first, but it could grow with other actions (which cannot be handled =
with
> >>> seccomp):
> >>> - use: walk through all opened FDs and mark them as allowed or denied
> >>> - receive: hook on received FDs
> >>> - send: hook on sent FDs
> >>>
> >>> We might also use the same approach for non-socket objects that can b=
e
> >>> identified with some meaningful properties.
> >>>
> >>> What do you think?
> >>
> >> This sounds like a good plan to me - it would make it possible to rest=
rict new
> >> socket creation using protocols that were not intended to be used, and=
 I also
> >> think it would fit the Landlock model nicely.
> >>
> >> Small remark on the side: The security_socket_create() hook does not o=
nly get
> >> invoked as a result of socket(2), but also as a part of accept(2) - so=
 this
> >> approach might already prevent new connections very effectively.
> >>
> > That is an interesting aspect that might be worth discussing more.
> > seccomp is per syscall, landlock doesn't necessarily follow the same,
> > another design is to add more logic in Landlock, e.g.
> > LANDLOCK_ACCESS_SOCKET_PROTOCOL which will apply to all of the socket
> > calls (socket/bind/listen/accept/connect). App dev might feel it is
> > easier to use.
>
> seccomp restricts the use of the syscall interface, whereas Landlock
> restricts the use of kernel objects (i.e. the semantic).
>
> We need to find a good tradeoff between a lot of access rights and a few
> grouping different actions. This should make sense from a developer
> point of view according to its knowledge and use of the kernel
> interfaces (potential wrapped with high level libraries), but also to
> the semantic of the sandbox and the security guarantees we want to provid=
e.
>
> We should also keep in mind that high level Landlock libraries can take
> care of potential coarse-grained use of restrictions.
>
>
> >
> >> Spelling out some scenarios, so that we are sure that we are on the sa=
me page:
> >>
> >> A)
> >>
> >> A program that does not need networking could specify a ruleset where
> >> LANDLOCK_ACCESS_SOCKET_CREATE is handled, and simply not permit anythi=
ng.
> >>
> >> B)
> >>
> >> A program that runs a TCP server could specify a ruleset where
> >> LANDLOCK_NET_BIND_TCP, LANDLOCK_NET_CONNECT_TCP and
> >> LANDLOCK_ACCESS_SOCKET_CREATE are handled, and where the following rul=
es are added:
> >>
> >>    /* From Konstantin's patch set */
> >>    struct landlock_net_service_attr bind_attr =3D {
> >>      .allowed_access =3D LANDLOCK_NET_BIND_TCP,
> >>      .port =3D 8080,
> >>    };
> >>
> >>    /* From Micka=C3=ABl's proposal */
> >>    struct landlock_socket_attr sock_inet_attr =3D {
> >>      .allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> >>      .domain =3D AF_INET,
> >>      .type =3D SOCK_STREAM,
> >>    }
> >>
> >>    struct landlock_socket_attr sock_inet6_attr =3D {
> >>      .allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> >>      .domain =3D AF_INET6,
> >>       .type =3D SOCK_STREAM,
> >>    }
> >>
> >> That should then be enough to bind and listen on ports, whereas outgoi=
ng
> >> connections with TCP and anything using other network protocols would =
not be
> >> permitted.
> >>
> > TCP server is an interesting case. From a security perspective, a
> > process cares if it is acting as a server or client in TCP, a server
> > might only want to accept an incoming TCP connection, never initiate
> > an outgoing TCP connection, and a client is the opposite.
> >
> > Processes can restrict outgoing/incoming TCP connection by seccomp for
> > accept(2) or connect(2),  though I feel Landlock can do this more
> > naturally for app dev, and at per-protocol level.  seccomp doesn't
> > provide per-protocol granularity.
>
> Right, seccomp cannot filter TCP ports.
>
> >
> > For bind(2), iirc, it can be used for a server to assign dst port of
> > incoming TCP connection, also by a client to assign a src port of an
> > outgoing TCP connection. LANDLOCK_NET_BIND_TCP will apply to both
> > cases, right ? this might not be a problem, just something to keep
> > note.
>
> Good point. I think it is in line with the rule definition: to allow to
> bind on a specific port. However, if clients want to set the source port
> to a (legitimate) value, then that would be an issue because we cannot
> allow a whole range of ports (e.g., >=3D 1024). I'm not sure if this
> practice would be deemed "legitimate" though. Do you know client
> applications using bind?
>
> Konstantin, we should have a test for this case anyway.
>
>
> >
> >> (Alternatively, it could bind() the socket early, *then enable Landloc=
k* and
> >> leave out the rule for BIND_TCP, only permitting SOCKET_CREATE for IPv=
4 and
> >> IPv6, so that listen() and accept() work on the already-bound socket.)
> >>
> > For this approach, LANDLOCK_ACCESS_SOCKET_PROTOCOL is a better name,
> > so dev is fully aware it is not just applied to socket create.
>
> I don't get the semantic of LANDLOCK_ACCESS_SOCKET_PROTOCOL. What does
> PROTOCOL mean?
>
I meant checking family + type of socket, and apply to all of
socket(2),bind(2),accept(2),connect(2),listen(2), maybe
send(2)/recv(2) too.

s/LANDLOCK_ACCESS_SOCKET_CREATE/LANDLOCK_ACCESS_SOCKET_TYPE.

This implies the kernel will check on socket fd's property (family +
type) at those calls, this applies to
a - the socket fd is created within the process, after landlock is applied.
b - created in process prior to landlock is applied.
c - created out of process then passed into this process,

> >
> >> Overall, this sounds like an excellent approach to me. =F0=9F=91=8D
> >>
> >> =E2=80=94G=C3=BCnther
> >>
> >> --
> >> Sent using Mutt =F0=9F=90=95 Woof Woof
> >
> > -Jeff
