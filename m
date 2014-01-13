From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: improve build system
Date: Mon, 13 Jan 2014 09:56:46 +0000
Message-ID: <20140113095646.GC15457@macbook.localnet>
References: <1389604070-12068-1-git-send-email-jengelh@inai.de>
 <20140113091250.GB14601@macbook.localnet>
 <alpine.LSU.2.11.1401131035120.16954@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55611 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaAMJ5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:57:04 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401131035120.16954@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 10:47:24AM +0100, Jan Engelhardt wrote:
>=20
> On Monday 2014-01-13 10:12, Patrick McHardy wrote:
> >
> >>       build: remove unused checks
> >
> >Why aren't we instead evaluating the results?
>=20
> I don't know - I did not write those lines in the first place. A
> reasonable hypothesis is that this is just old boilerplate copied
> from somewhere else rather than actually looking for what the
> commands executed by make really need.

That was not my question. I asked why we're not evaluating *instead* of
removing them.

> Furthermore, like a lot of NF software, it is tied to Linux where the
> existence of arpa/inet.h, fcntl.h, malloc(3), and so on is
> pretty much guaranteed.
>=20
> The only point to check for absence of stdint.h is when at the same
> time, the code provides alternative ways to get what it needs (like a
> hand-crafted typedef unsigned char uint8_t) - which are not present
> either. So checking for stdint.h is rather useless.
>=20
> >>       build: rename conflicting parser.h instances
> >
> >The changelog mentions something about -I but no further explanation=
 about
> >why this change is done and the effects.
>=20
> How so? Commit says:
>=20
> 	If -I. is on the command line =E2=80=A6
>=20
> and -I. is on the command line with autoconf (more precisely,
> -I${srcdir} -I${builddir} -I${path_to_config_h} is).
>=20
> 	=E2=80=A6 #include <parser.h> becomes (=3Dmatches) ./parser.h
> 	instead of ../include/parser.h.
>=20
> Basically you never ever want to have a header with the same include
> path. Even #include <regex.h> is prone to ambiguity if you had
> -I/usr/include/boost (which you should not of course, but people
> do all kinds of weird things sometimes), suddenly matching
> /usr/include/boost/regex.h instead of /usr/include/regex.h.
>=20
> It's all about distributions, and it takes a regular packager to know=
=2E

Jan, the changelog simply needs a description what is wrong, why it
is wrong and what is changed. You can't expect people to know what
parameters autoconf uses on the command line and I guess you know that.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
