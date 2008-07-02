From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Patches solving the same issue!?
Date: Wed, 2 Jul 2008 23:47:36 +0200
Message-ID: <20080702214736.GA13134@internet24.de>
References: <1215021635-28691-1-git-send-email-jacob@internet24.de> <1215021635-28691-2-git-send-email-jacob@internet24.de> <1215032251.9467.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Cc: Thomas Jacob <jacob@internet24.de>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jesper Dangaard Brouer <jdb@comx.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:39571 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882AbYGBVri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:47:38 -0400
Content-Disposition: inline
In-Reply-To: <1215032251.9467.11.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Oops, sorry about that, I did notice your initial
set of speed up patches (that's why I was enthusiastically playing
around with large rule sets and became aware of the issue
in the first place), but evidently I didn't follow the
related thread very closely.

I am not familiar enough with the iptables code to decide
whether or not chains are always sorted by name in the kernel,
and thus will be sorted if you read them back, but if that's
the case, of course your method is better, as long as that's
always the case...

To be honest, I didn't really understand the chain_index code ;)

  =20
On Wed, Jul 02, 2008 at 10:57:31PM +0200, Jesper Dangaard Brouer wrote:
>=20
> I can see from the list that Thomas Jacob <jacob@internet24.de>, and I
> have just posted patches solving the same issue.
>=20
> I promised Patrick that I would work on this issue, and I did.
>=20
> Its running on our production servers, and I planned to release the
> patch today as it has proven stable on production.  I guess Thomas was
> just slightly faster than me ;-)
>=20
> It was actually already released in the CPAN module IPTables::libiptc
> (ver.0.08 released 2008-06-16).
>=20
>=20
> We both use binary search, but with two slightly different approaches.
>=20
> - My patch uses the existing data structure, and the existing
>   algorithm for binary searching.
>=20
> - Thomas builds a new data structure and implements a new binary
>   search algorithm.
>=20
> I must give Thomas that this binary search algo (taken from wikipedia)
> is much more compact than the existing one.
>=20
> Guess I cannot judge what patch is the best, as I'm biased...
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIa/d4gF9cFv867HwRAkL9AJ4/w2aig41WWXYq4/zYbgRES5voqQCfa5oo
lfLcaWzAsk4Qxbl8xCNSM+c=
=P7Gd
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
