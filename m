From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: named vmaps
Date: Tue, 25 Nov 2014 19:07:07 +0100
Message-ID: <20141125180707.GA8164@salvia>
References: <CAJO99T=5z-AC=YzOVTYH3++6kf74fXqSu=Q15Jqhb3bVYQ-mLw@mail.gmail.com>
 <20141124115522.GA27521@salvia>
 <CAJO99Tkv_rRE8Jd+=DzVSmWiFMUT2hgtLWR9VUxmZkivrod34w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50926 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaKYSE7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:04:59 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99Tkv_rRE8Jd+=DzVSmWiFMUT2hgtLWR9VUxmZkivrod34w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 08:03:16PM +0100, Bj=F8rnar Ness wrote:
> 2014-11-24 12:55 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Fri, Nov 21, 2014 at 09:22:00AM +0100, Bj=F8rnar Ness wrote:
> >> Is support for named vmaps removed from nft? Running kernel 3.18.0=
-rc5
> >> [ ... ]
> >
> > I have updated the documentation:
> >
> > http://wiki.nftables.org/wiki-nftables/index.php/Dictionaries
> >
> > Please, let me know if you find any mistake on it. Thanks.
>=20
> This works, thanks Pablo!
>=20
> A few comments, tho:
>=20
> Is it possible/planned to make counters work with sets/vmaps?
>=20
> nft add rule filter input ip saddr vmap @my_vmap counter
>
> will not work since it counts too late (never)

vmap is terminal, nft should spot an error with that rule.

What would you like to achieve with that 'counter'? Count packets that
are look up in the set/vmap?

> Is the following planned:
> 1) individual element counters
> 2) comments for elements
> 3) element timeout

Those can be implemented, yes.

> Also, negative set/vmap lookup does not seem to work, I would like th=
e
> following functionality
>=20
> nft insert rule filter forward ip saddr !@ignorelist ip saddr @blockl=
ist drop

Negative set lookup is relatively easy to implement, we'll have this
soon.

Negative vmap lookup, I don't see at this moment how this can be
useful.

Thanks for testing.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
