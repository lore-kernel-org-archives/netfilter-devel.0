From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 commit
Date: Sat, 18 Apr 2009 13:43:57 +0200
Message-ID: <49E9BCFD.80102@netfilter.org>
References: <49E85F6D.9030008@netfilter.org> <1240053470.10215.16.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45270 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbZDRLoI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 07:44:08 -0400
In-Reply-To: <1240053470.10215.16.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le vendredi 17 avril 2009 =E0 12:52 +0200, Pablo Neira Ayuso a =E9cri=
t :
>> Hi Eric, Pierre,
>>
>> Please, could you justify the need for commit
>> 0ff525cb0506b2c043bc9df6d7e7b486c865bc38?
>>
>> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Dulogd2.git;a=3Dcommi=
t;h=3D0ff525cb0506b2c043bc9df6d7e7b486c865bc38
>>
>> I don't think that it's a good idea to support external compilation =
of
>> ulogd2 modules. We should promote people to push forward things to m=
ainline.
>=20
> I clearly agree with the goal of promoting people to push forward thi=
ngs
> to mainline but it has to be done by openness and reactivity of
> mainteners, not by technical means.
>=20
> But let looks at the diffstat of this commit:
>  include/Makefile.am       |    1 +
>  include/ulogd/Makefile.am |    3 +--
>  include/ulogd/ulogd.h     |    2 ++
>  3 files changed, 4 insertions(+), 2 deletions(-)
>=20
> That's really not a big work for anyone to arrive to the same result.=
 An
> other point is that compiling outside of tree require you to maintain
> your own build system which is quiet boring.
>=20
> Thus, using git to maintain you own forked branch is the easiest way =
to
> keep your work hidden and/or non public.
>=20
> IMHO, this patch does not change anything about external contribution=
=2E

1) Looking at my ulogd2 installation, this exports a lot of header file=
s
for external use:

$ ls /usr/include/ulogd/
common.h    hash.h            jhash.h      linux_rbtree.h  timer.h
conffile.h  ipfix_protocol.h  linuxlist.h  slist.h         ulogd.h

Sorry, but this is a bit nasty. If this patch aims to allow compiling
external ulogd2 module,  please make public only the basic functions
(register, unregister, ...) in one header public file called ulogd.h or
something like that. But not exporting all those jhash.h, linux_rbtree.=
h
and so on.

2) Related to the previous point, if we make public some API, we'll hav=
e
to get attached to them to ensure backward compatibility. If we support
external modules, we'll have to engage to not changing the exported API=
,
otherwise people may complain about breakages of their external modules=
=2E
All those files that you have exported means quite a lot APIs that we'l=
l
have to get attached to.

3) I particularly don't want people mixing proprietary external modules
with our GPL code. So, if we export some API, it would be nice if we
have some mechanism to make the user of this functions to explicitly
agree that it's external module is GPL, something like the Linux kernel
macros or something.

I have my concerns with regards to this patch from both the technical
approach and the new policy that it introduces.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
