From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 16:40:59 +0900 (JST)
Message-ID: <200901230741.n0N7f0bx012043@toshiba.co.jp>
References: <200811050444.mA54i7XU020102@toshiba.co.jp>
	<20081105133508.67b25090@hiperon.ws.hirg>
	<1232581287.16003.47.camel@ice-age>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Marek.Szuba@if.pw.edu.pl, yasuyuki.kozakai@toshiba.co.jp,
	kaber@trash.net, netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:33833 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZAWIJy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:09:54 -0500
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id n0N7l5dZ002848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 16:47:06 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id n0N7f1Ku024497
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 16:41:01 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id n0N7f11d016844
	for netfilter-devel@vger.kernel.org; Fri, 23 Jan 2009 16:41:01 +0900 (JST)
Received: from mx12.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id n0N7f0j7025349
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 16:41:00 +0900 (JST)
In-Reply-To: <1232581287.16003.47.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi, Eric,

How about just using NOTRACK target ?

-- Yasuyuki Kozakai

=46rom: Eric Leblond <eric@inl.fr>
Date: Thu, 22 Jan 2009 00:41:27 +0100

> Hi,
>=20
> Le mercredi 05 novembre 2008 =E0 13:35 +0100, Marek Szuba a =E9crit :
> > On Wed, 05 Nov 2008 13:44:05 +0900 (JST)
> > Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:
> >=20
> > > In short: nf_conntrack_proto_icmpv6.c does not help for protocols
> > > using their messages. conntrack helper is better.
> > So what you are suggesting is, someone needs to write such a helper
> > module. Correct?
>=20
> I'm reopening this thread because Victor Stinner (in CC) has opened a
> similar bug in bugzilla:
> http://bugzilla.netfilter.org/show_bug.cgi?id=3D567
> Pablo has then pointed out this discussion.
>=20
> I don't think that we have to handle these part of ICMPv6 protocol wi=
th
> a connection tracking helper. For example, here's the trace of the
> exchange which are needed to obtain a "public" IPv6 address on my set=
up:
>=20
> 15:14:42.377744 IP6 fe80::a00:27ff:feb3:e26c > ff02::2: ICMP6, router=
 solicitation, length 16
> 15:14:42.405725 IP6 fe80::207:cbff:fe90:f8d1 > ff02::1: ICMP6, router=
 advertisement, length 104
> 15:14:43.401395 IP6 :: > ff02::1:ffb3:e26c: ICMP6, neighbor solicitat=
ion, who has 2a01:e35:1394:5bd0:a00:27ff:feb3:e26c, length 24
> 15:14:46.628300 IP6 fe80::a00:27ff:feb3:e26c > ff02::16: HBH ICMP6, m=
ulticast listener report v2, 1 group record(s), length 28
>=20
> If we only analyse the first two, we see we can't easily invert the
> tuple of the connection: we don't know which address will answer and =
the
> destination address of the packet are changing. But as pointed by
> Yasuyuki the main point is not here, we need to accept the router
> advertisement to be able to detect changes in the routing. In fact,
> theses protocols are stateless and should be considered as such.
>=20
> IMHO, the main issue here is to tag the packets as INVALID. They are
> valid even we can't track them. I thus propose a patchset which adds =
the
> capability to avoid connection tracking the packets of these protocol=
s.
> A sysctl flag can be set to activate this feature.
>=20
> With this patchset, the concerned packet don't get blocked by the
> INVALID rule and are not seen by the conntrack. They can be cleanly
> filtered in the ruleset.
>=20
> Patchset statistics:
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   35 ++++++++++++++=
+++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
