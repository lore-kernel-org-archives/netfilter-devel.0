From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Wed, 29 Feb 2012 00:54:56 +0100
Message-ID: <20120228235456.GA30286@1984>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
 <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
 <CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
 <alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
 <CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
 <20120224175420.GA11587@1984>
 <CAFntDkz4QtCrgHNFNp6Bn1dGco3HCWthYaFLN_-bUVb2q0wPjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Darren Willis <djw@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32819 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab2B1Xy7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:54:59 -0500
Content-Disposition: inline
In-Reply-To: <CAFntDkz4QtCrgHNFNp6Bn1dGco3HCWthYaFLN_-bUVb2q0wPjQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 27, 2012 at 01:18:58PM +0900, Darren Willis wrote:
> > 1) In the last Netfilter workshop, we decided that we're targeting
> > towards explicit helper configuration via iptables, ie. something
> > like:
> >
> > ip6tables -I OUTPUT -t raw -s $SRC -d $DST \
> > =A0 =A0 =A0 =A0-p udp --dport 547 -j CT --helper dhcpv6
> >
> > According to your report, this is exactly what distributors don't
> > want to do.
>=20
> Interesting. Well, my impression is that distributions don't wan't to
> add rules, but if they can't avoid it, they'll just have to cope.
> Is this changeover coming in the immediate future?

Yes. I'd like to send a patch for RFC to the mailing list any time
soon. I'll include you in the CC.

> > 2) The helper infrastructure is allowing us to filter broadcast
> > traffic but I think that it's =A0been designed for a different purp=
ose.
> > I know, we don't have any better by now. But in the meanwhile, we'r=
e
> > adding specific helpers to support each broadcast protocol.
>=20
> Agreed, while I think for now this helper is fine, I think it'd be
> nice to have a more generic multicast/broadcast helper, although it'd
> still need to have specific protocols baked into it to work (maybe
> netbios, dhcpv6, mDNS, LLMNR, SSDP, neighbour discovery, other
> things).

This is exactly what scares me. I don't like the idea of bloating the
kernel with lots of helpers for each single protocol.

I'm currently working on one user-space helper infrastructure. We can
use that infrastructure to implement this helper and many others.

I've got the patch in one branch of my kernel tree, it's still
experimental stuff, but I expect to have it done soon.

Would you be OK with we make this (and other helpers that will surely
follow up) in user-space?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
