From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables and sets
Date: Wed, 22 Jan 2014 15:26:01 +0000
Message-ID: <20140122152600.GB14817@macbook.localnet>
References: <CAJO99T=OERsyTy91n=DJSceSdfxUeQVSO5JJtpMwuPyKh6MicQ@mail.gmail.com>
 <20140122144423.GA14025@macbook.localnet>
 <CAJO99T=HBk7_PJG8+SmkqA7NUDuWBvujGckBJ=R_wn0i-7MOsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50672 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaAVP0F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:26:05 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99T=HBk7_PJG8+SmkqA7NUDuWBvujGckBJ=R_wn0i-7MOsA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ please don't drop CCs ]

On Wed, Jan 22, 2014 at 04:09:15PM +0100, Bj=F8rnar Ness wrote:
> 2014/1/22 Patrick McHardy <kaber@trash.net>:
> > On Wed, Jan 22, 2014 at 03:09:30PM +0100, Bj=F8rnar Ness wrote:
> >> Is it planned (or already implemented) support for multiple value =
vmaps?
> >> for example {type uid, type ipv4 : verdict}
> >
> > We support so called concatenations, basically multiple types glued
> > together. You can use those for exact matches. However the kernel s=
ide
> > is missing a few bits so far.
> >
> > Basically:
> >
> > nft add map uidmap { type uid . ipv4_address : verdict; }
> > nft filter input uid . ip saddr @uidmap
> > nft add element uidmap { root . localhost : drop }
>=20
> Ok, I see.. this sortoff works, any plans to change from concat to
> multiple types?

Why? It is multiple types. The thing is if you do multidimensional
lookups things get a lot more inefficient. For the purpose of
equality (or membership) it doesn't make any difference.

> > The combination doesn't make too much sense of course.
> >
> >> Also, using iptables I am doing something like this
> >>
> >> -A INPUT -j BLOCK
> >> -A BLOCK -m set --match-set ignorelist src -j RETURN
> >> -A BLOCK -m set --match-set blocklist src -j DROP
> >>
> >> ..to make sure ips listed in ignorelist does not get blocked..
> >>
> >> How would I do the same using nft?
> >
> > nft add set ignorelist { type ipv4_address; }
> > nft add set blocklist { type ipv4_address; }
> >
> > nft filter input jump block
> > nft filter block ip saddr @ignorelist return
> > nft filter block ip saddr @blocklist drop
>=20
> Could this be done in cleaner way with nft, for example
>=20
> nft filter input ip saddr @ignorelist jump_over_next_rule_or_to_label
> nft filter input ip saddr @blocklist drop
> nft filter input add label jumplabel

I guess we have different opinions what constitutes cleaner.
We don't support jumps to rules, but it should be possible
quite easily to change the code to support:

nft filter input ip saddr !@ignorelist ip saddr @blocklist drop

to put this into a single rule.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
