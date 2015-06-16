From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: Matching MLD with ip6tables
Date: Tue, 16 Jun 2015 16:52:58 +0200
Message-ID: <20150616145258.GA2421@odroid>
References: <20150501025612.GB2465@odroid>
 <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr>
 <20150616054551.GB14231@odroid>
 <alpine.LSU.2.20.1506160912570.21227@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.passe0815.de ([188.40.49.9]:55889 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbbFPOxM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 10:53:12 -0400
Received: from mail.passe0815.de (localhost [127.0.0.1])
	by mail.passe0815.de (Postfix) with ESMTP id 095E45866CF
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 16:53:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1506160912570.21227@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 09:17:26AM +0200, Jan Engelhardt wrote:
> On Tuesday 2015-06-16 07:45, Linus L=C3=BCssing wrote:
>=20
> >On Fri, May 01, 2015 at 08:33:03AM +0200, Jan Engelhardt wrote:
> >> -p matches the first non-extension header. For the
> >> exthdrs, there is e.g. -m hbh.
> >
> >Just to check, I guess ebtables is behaving similarly?
>=20
> Since Ethernet does not define any "Extension Headers",
> -p matches the one and only Protocol field there is,
> and it will be IPv6 if you say -p ipv6.

Was more wondering whether ebtables's "--ip6-proto"
behaves similar to ip6tables "--protocol" ;). But okay :).

>=20
>=20
> >And "-p IPv6 --ip6-proto 0" will *not* match packets with a
> >hop-by-hop header?
>=20
> That's a hard one, because the userspace tools were once written with=
=20
> the assumption that 0 means "ANY". And then IANA used that value. D'o=
h.

Urgh :D. Anyways, I think I could verify in the kernel code that
ebtables and ip6tables behave similar, ebtables too seems to skip
any extension header by calling ipv6_skip_exthdr():

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/ne=
t/bridge/netfilter/ebt_ip6.c#n63

Cheers, Linus
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
