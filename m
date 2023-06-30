Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E5EEB64DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jun 2023 04:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjF3ETr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Jun 2023 00:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjF3ETZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2023 00:19:25 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F341E3A81
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:18:58 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1b049163c93so1075195fac.3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688098737; x=1690690737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJQcmcCmC4ImolALTo4qMWAT7KrVj4+73eh5DMYWeTU=;
        b=OPdZJBj5YZy6d9sSqx+lzIZA+yoLBjTonFLSzFUk8VHTv9VlS+Q6SiB+i5t/FweoC8
         os/C+obhqRnPFri+ulXZGxqsDGKhT0pLqwOVWNvls/i+wD1vQO3O+J0ANkPLwMD80vVi
         8qkFLOYVQkDKXmFQlL4RQTQP+Ki9oWXdpyc/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688098737; x=1690690737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJQcmcCmC4ImolALTo4qMWAT7KrVj4+73eh5DMYWeTU=;
        b=eOccKdlGBdqRhuzJGvZNwU0AzHt2ySOe5eaWLvgkIEmIShdLrfSsCrZNJiJ3WM21CH
         fmrSXppyxG9O8xSTC3DUih9kRbWZj593cgr1WwV5IqefC2N0NuvGueUPe0QBybBkvFSx
         aYErihgf+AgSVBYBEUvzjTYcjgYmTMmm1edBdVKo+og1Fv3LDE1kxnMyLDWqaIm3Spc5
         fkgtPjwCyRYn9ZOVF3Y5L1yjmS2CWsu8qUZyhtoI5ebfOO1+2Br/kChDtbGsFhWuPLNR
         1I7My5ay1rzVhxfbOsdQ6Cc9NrqwyInrAUl62BgKYA9MoG+rCRMx5JVCUgHZ6XDXqUaz
         JqKg==
X-Gm-Message-State: ABy/qLY78YQwB7ezCosCaNILGgmI6e4vyPMCDEftqlEEcctUh2rBsvND
        mboXfGUKENXay3Qn/2Ff8xDAub9mIN8tHooF3ALZEA==
X-Google-Smtp-Source: APBJJlGrvWJCbtwr3qSo/1PDAsYBOJq8X5AF4bEuJ5u6iT8N+Kpx8PlFx1aqwKaWa0D60ycMM7XcNb0hd73Z9dONb64=
X-Received: by 2002:a05:6870:e9b:b0:1a3:16af:56d8 with SMTP id
 mm27-20020a0568700e9b00b001a316af56d8mr1992770oab.12.1688098737224; Thu, 29
 Jun 2023 21:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net> <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
 <ZJvy2SViorgc+cZI@google.com> <CABi2SkX-dzUO6NnbyqfrAg7Bbn+Ne=Xi1qC1XMrzHqVEVucQ0Q@mail.gmail.com>
 <43e8acb2-d696-c001-b54b-d2b7cf244de7@digikod.net> <CABi2SkV1Q-cvMScEtcsHbgNRuGc39eJo6KT=GwUxsWPpFGSR4A@mail.gmail.com>
 <b4440d19-93b9-e234-007b-4fc4f987550b@digikod.net>
In-Reply-To: <b4440d19-93b9-e234-007b-4fc4f987550b@digikod.net>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Thu, 29 Jun 2023 21:18:45 -0700
Message-ID: <CABi2SkVbD8p0AHhvKLXPh-bQSNAk__8_ONxpE+8hisoZxF-h6g@mail.gmail.com>
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

On Thu, Jun 29, 2023 at 4:07=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
>
> On 29/06/2023 05:18, Jeff Xu wrote:
> > resend.
> >
> > On Wed, Jun 28, 2023 at 12:29=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@=
digikod.net> wrote:
> >>
> >>
> >> On 28/06/2023 19:03, Jeff Xu wrote:
> >>> Hello,
> >>>
> >>> Thanks for writing up the example for an incoming TCP connection ! It
> >>> helps with the context.
> >>>
> >>> Since I'm late to this thread, one thing I want to ask:  all the APIs
> >>> proposed so far are at the process level, we don't have any API that
> >>> applies restriction to socket fd itself, right ? this is what I
> >>> thought, but I would like to get confirmation.
> >>
> >> Restriction are applied to actions, not to already existing/opened FDs=
.
> >> We could add a way to restrict opened FDs, but I don't think this is t=
he
> >> right approach because sandboxing is a deliberate action from a proces=
s,
> >> and it should already take care of its FDs.
> >>
> >>
> >>>
> >>> On Wed, Jun 28, 2023 at 2:09=E2=80=AFAM G=C3=BCnther Noack <gnoack@go=
ogle.com> wrote:
> >>>>
> >>>> Hello!
> >>>>
> >>>> On Mon, Jun 26, 2023 at 05:29:34PM +0200, Micka=C3=ABl Sala=C3=BCn w=
rote:
> >>>>> Here is a design to be able to only allow a set of network protocol=
s and
> >>>>> deny everything else. This would be complementary to Konstantin's p=
atch
> >>>>> series which addresses fine-grained access control.
> >>>>>
> >>>>> First, I want to remind that Landlock follows an allowed list appro=
ach with
> >>>>> a set of (growing) supported actions (for compatibility reasons), w=
hich is
> >>>>> kind of an allow-list-on-a-deny-list. But with this proposal, we wa=
nt to be
> >>>>> able to deny everything, which means: supported, not supported, kno=
wn and
> >>>>> unknown protocols.
> >>>>>
> >>>>> We could add a new "handled_access_socket" field to the landlock_ru=
leset
> >>>>> struct, which could contain a LANDLOCK_ACCESS_SOCKET_CREATE flag.
> >>>>>
> >>>>> If this field is set, users could add a new type of rules:
> >>>>> struct landlock_socket_attr {
> >>>>>       __u64 allowed_access;
> >>>>>       int domain; // see socket(2)
> >>>>>       int type; // see socket(2)
> >>>>> }
> >>>>>
> >>>>> The allowed_access field would only contain LANDLOCK_ACCESS_SOCKET_=
CREATE at
> >>>>> first, but it could grow with other actions (which cannot be handle=
d with
> >>>>> seccomp):
> >>>>> - use: walk through all opened FDs and mark them as allowed or deni=
ed
> >>>>> - receive: hook on received FDs
> >>>>> - send: hook on sent FDs
> >>>>>
> >>>>> We might also use the same approach for non-socket objects that can=
 be
> >>>>> identified with some meaningful properties.
> >>>>>
> >>>>> What do you think?
> >>>>
> >>>> This sounds like a good plan to me - it would make it possible to re=
strict new
> >>>> socket creation using protocols that were not intended to be used, a=
nd I also
> >>>> think it would fit the Landlock model nicely.
> >>>>
> >>>> Small remark on the side: The security_socket_create() hook does not=
 only get
> >>>> invoked as a result of socket(2), but also as a part of accept(2) - =
so this
> >>>> approach might already prevent new connections very effectively.
> >>>>
> >>> That is an interesting aspect that might be worth discussing more.
> >>> seccomp is per syscall, landlock doesn't necessarily follow the same,
> >>> another design is to add more logic in Landlock, e.g.
> >>> LANDLOCK_ACCESS_SOCKET_PROTOCOL which will apply to all of the socket
> >>> calls (socket/bind/listen/accept/connect). App dev might feel it is
> >>> easier to use.
> >>
> >> seccomp restricts the use of the syscall interface, whereas Landlock
> >> restricts the use of kernel objects (i.e. the semantic).
> >>
> >> We need to find a good tradeoff between a lot of access rights and a f=
ew
> >> grouping different actions. This should make sense from a developer
> >> point of view according to its knowledge and use of the kernel
> >> interfaces (potential wrapped with high level libraries), but also to
> >> the semantic of the sandbox and the security guarantees we want to pro=
vide.
> >>
> >> We should also keep in mind that high level Landlock libraries can tak=
e
> >> care of potential coarse-grained use of restrictions.
> >>
> >>
> >>>
> >>>> Spelling out some scenarios, so that we are sure that we are on the =
same page:
> >>>>
> >>>> A)
> >>>>
> >>>> A program that does not need networking could specify a ruleset wher=
e
> >>>> LANDLOCK_ACCESS_SOCKET_CREATE is handled, and simply not permit anyt=
hing.
> >>>>
> >>>> B)
> >>>>
> >>>> A program that runs a TCP server could specify a ruleset where
> >>>> LANDLOCK_NET_BIND_TCP, LANDLOCK_NET_CONNECT_TCP and
> >>>> LANDLOCK_ACCESS_SOCKET_CREATE are handled, and where the following r=
ules are added:
> >>>>
> >>>>     /* From Konstantin's patch set */
> >>>>     struct landlock_net_service_attr bind_attr =3D {
> >>>>       .allowed_access =3D LANDLOCK_NET_BIND_TCP,
> >>>>       .port =3D 8080,
> >>>>     };
> >>>>
> >>>>     /* From Micka=C3=ABl's proposal */
> >>>>     struct landlock_socket_attr sock_inet_attr =3D {
> >>>>       .allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> >>>>       .domain =3D AF_INET,
> >>>>       .type =3D SOCK_STREAM,
> >>>>     }
> >>>>
> >>>>     struct landlock_socket_attr sock_inet6_attr =3D {
> >>>>       .allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> >>>>       .domain =3D AF_INET6,
> >>>>        .type =3D SOCK_STREAM,
> >>>>     }
> >>>>
> >>>> That should then be enough to bind and listen on ports, whereas outg=
oing
> >>>> connections with TCP and anything using other network protocols woul=
d not be
> >>>> permitted.
> >>>>
> >>> TCP server is an interesting case. From a security perspective, a
> >>> process cares if it is acting as a server or client in TCP, a server
> >>> might only want to accept an incoming TCP connection, never initiate
> >>> an outgoing TCP connection, and a client is the opposite.
> >>>
> >>> Processes can restrict outgoing/incoming TCP connection by seccomp fo=
r
> >>> accept(2) or connect(2),  though I feel Landlock can do this more
> >>> naturally for app dev, and at per-protocol level.  seccomp doesn't
> >>> provide per-protocol granularity.
> >>
> >> Right, seccomp cannot filter TCP ports.
> >>
> >>>
> >>> For bind(2), iirc, it can be used for a server to assign dst port of
> >>> incoming TCP connection, also by a client to assign a src port of an
> >>> outgoing TCP connection. LANDLOCK_NET_BIND_TCP will apply to both
> >>> cases, right ? this might not be a problem, just something to keep
> >>> note.
> >>
> >> Good point. I think it is in line with the rule definition: to allow t=
o
> >> bind on a specific port. However, if clients want to set the source po=
rt
> >> to a (legitimate) value, then that would be an issue because we cannot
> >> allow a whole range of ports (e.g., >=3D 1024). I'm not sure if this
> >> practice would be deemed "legitimate" though. Do you know client
> >> applications using bind?
> >>
> >> Konstantin, we should have a test for this case anyway.
>
> Thinking more about TCP clients binding sockets, a
> LANDLOCK_ACCESS_NET_LISTEN_TCP would be more useful than
> LANDLOCK_ACCESS_NET_BIND_TCP, but being able to limit the scope of
> "bindable" ports is also valuable to forbid a malicious sandboxed
> process to impersonate a legitimate server process. This also means that
> it might be interesting to be able to handle port ranges.
>
> We already have a LANDLOCK_ACCESS_NET_BIND_TCP implementation and
> related tests, so I think we should proceed with that. The next
> network-related patch series should implement this
> LANDLOCK_ACCESS_NET_LISTEN_TCP access right though, which should not be
> difficult thanks to the framework implemented with current patch series.
>
> Konstantin, would you like to develop the TCP listening access control
> once this patch series land?
>
>
> >>>> (Alternatively, it could bind() the socket early, *then enable Landl=
ock* and
> >>>> leave out the rule for BIND_TCP, only permitting SOCKET_CREATE for I=
Pv4 and
> >>>> IPv6, so that listen() and accept() work on the already-bound socket=
.)
> >>>>
> >>> For this approach, LANDLOCK_ACCESS_SOCKET_PROTOCOL is a better name,
> >>> so dev is fully aware it is not just applied to socket create.
> >>
> >> I don't get the semantic of LANDLOCK_ACCESS_SOCKET_PROTOCOL. What does
> >> PROTOCOL mean?
> >>
> > I meant checking family + type of socket, and apply to all of
> > socket(2),bind(2),accept(2),connect(2),listen(2), maybe
> > send(2)/recv(2) too.
>
> OK, that would be kind of similar to the LANDLOCK_ACCESS_SOCKET_USE
> description. However, I think this kind of global approach has several
> issues:
> - This covers a lot of different aspects and would increase the cost of
> development/testing/review.
True.

> - Whereas it wraps different actions, it will not let user space have a
> fine-grained access control on these, which could be useful for some use
> cases.
Make sense.

> - I don't see the point of restricting accept(2) if we can already
> restrict bind(2) and listen(2). accept(2) could be useful to identify
> the remote peer but I'm not convinced this would make sense, and if it
> would, then this can be postponed until we have a way to identify peers.

I was thinking about a case that the socket was created/bind/listen in
another process, then passed into the current process,

For example:
Process A has :
LANDLOCK_ACCESS_SOCKET_CREATE (family =3D f1, type =3D t1)
socket s1 is created in process A with family =3D f1, type =3D t1, and
bind/listen to port p1.

socket s1 is passed to process B
Process B has:
LANDLOCK_ACCESS_SOCKET_CREATE (family =3Df1, type =3D t2) (note the type
is different than A)
LANDLOCK_ACCESS_NET_{CONNECT,BIND}_TCP (port =3D p2)

However, those rules in B don't restrict process B from using
accept(s1), s1 is another type.

In accept(2), struct sockaddr contains sa_family_t (AF_xx)  but no
type, which is strange to me, the API should either include both, or
none (accept whatever it is already in socket fd, which is set during
creation time).

looking into accept(2) implementation: it calls: sock->ops->accept
iiuc, sock->ops is set during socket(2), allowing each protocol to
have its own implementation.

When we consider a> our intention to restrict family + type of socket,
with b> socket can be passed between processes,
there can be a need to harden the check (family + type) for all of
bind/listen/accept/connect. Otherwise, there is still a possibility
that the process to accept a socket of different type unintentionally.

This means:
LANDLOCK_ACCESS_SOCKET_ATTR_CREATE (family =3Df1, type =3D t2)
LANDLOCK_ACCESS_SOCKET_ATTR_BIND (family =3Df1, type =3D t2)
LANDLOCK_ACCESS_SOCKET_ATTR_ACCEPT (family =3Df1, type =3D t2)
LANDLOCK_ACCESS_SOCKET_ATTR_ LISTEN (family =3Df1, type =3D t2)
LANDLOCK_ACCESS_SOCKET_ATTR_CONNECT (family =3Df1, type =3D t2)
Note: this checks family+type only, not port.
The check is applied to all protocols, so not specific to TCP/UDP

> - For performance reasons, we should avoid restricting
> send/recv/read/write but instead only restrict the control plane: object
> creation and configuration.
>
Performance is a valid concern.

As example of server, usually the main process listens/accepts incoming
connections, and forked processes do send/recv, the main process can
be viewed as a control plane, and send/recv can be viewed as a data
plane. It makes sense that we start with the control plane.

We might like to keep a note that by not restricting send/recv, a
socket can be created OOP, then passed into current process and call
send/recv, so the network is not fully disabled by landlock alone
(still need seccomp)

Things might get more complicated, say: a forked process is intended
to send/recv UDP, but was confused and got a TCP socket from
OOP, etc. This is not different than accept(2) case above. There might
be an opportunity for Landlock to harden this when we design for
data-plane.

> I'm not convinced that being able to control all kind of socket bind,
> listen and connect actions might be worth implementing instead of a
> fine-grained access control for the main protocols (TCP, UDP, unix and
> vsock maybe), with the related tests and guarantees.
>
> However, this landlock_socket_attr struct could have an allowed_access
> field that could contain LANDLOCK_ACCESS_NET_{CONNECT,LISTEN,BIND}_TCP
> rights (which would just not be constrained by any port, except if a
> landlock_net_port_attr rule matches). It would then make sense to rename
> LANDLOCK_ACCESS_SOCKET_CREATE to LANDLOCK_ACCESS_NET_CREATE_SOCKET. This
> right would not be accepted in a landlock_net_port_attr.allowed_access
> though.
>
I'm not sure if my view is fully explained. I don't mean to control
all kinds of socket bind/listen/connect actions.
My view is:
1> have a rule to check family + type, to make sure the process is
using the socket type they intend to use, such as
LANDLOCK_ACCESS_SOCKET_ATTR_{CREATE|CONNECT|BIND|ACCEPT|LISTEN}, as
discussed in accept(2) case.
2> have protocol specific rules, such as LANDLOCK_ACCESS_NET_{CONNECT,BIND}=
_TCP.
So bind(2) will be checked by both 1 and 2.

As example of TCP server, the process will use:
LANDLOCK_ACCESS_SOCKET_ATTR_{CREATE|BIND|ACCEPT|LISTEN}
LANDLOCK_ACCESS_NET_{BIND}_TCP

> >
> > s/LANDLOCK_ACCESS_SOCKET_CREATE/LANDLOCK_ACCESS_SOCKET_TYPE.
> >
> > This implies the kernel will check on socket fd's property (family +
> > type) at those calls, this applies to
> > a - the socket fd is created within the process, after landlock is appl=
ied.
> > b - created in process prior to landlock is applied.
> > c - created out of process then passed into this process,
>
> OK, these are the same rules as for LANDLOCK_ACCESS_NET_{CONNECT,BIND}_TC=
P.

I don't mean this to be _TCP specific, this is still the family + type
discussion above.
