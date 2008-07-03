From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Patches solving the same issue!?
Date: Thu, 03 Jul 2008 13:17:16 +0200
Message-ID: <1215083836.26474.67.camel@enterprise.ims-firmen.de>
References: <1215021635-28691-1-git-send-email-jacob@internet24.de>
	 <1215021635-28691-2-git-send-email-jacob@internet24.de>
	 <1215032251.9467.11.camel@localhost.localdomain>
	 <20080702214736.GA13134@internet24.de>
	 <Pine.LNX.4.64.0807031224330.3656@tyr.diku.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OFwvRH4vduo6M6Rl5232"
Cc: netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:53271 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYGCMB0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:01:26 -0400
In-Reply-To: <Pine.LNX.4.64.0807031224330.3656@tyr.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-OFwvRH4vduo6M6Rl5232
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 12:53 +0200, Jesper Dangaard Brouer wrote:
> Thats also what the chain_index code depends upon (although I have build=20
> in a safe guard that sorts them if they are not).  There is also a safe=20
> guard for the offset binary search, but that simply reverts to the old=20
> (_slow_) search scheme.

I see, so that's no problem either =3D>

 if (strcmp(c->name, ctail->name) > 0 ||
                    iptcc_is_builtin(ctail))
                        list_add_tail(&c->list, &h->chains);
                else {
                        iptc_insert_chain(h, c);/* Was not sorted */
                        h->sorted_offsets =3D 0;

The skip-list-like search infrastructure is also quite nice and
integrates well with the current code, once one understands what it does
anyway. So there is really no reason as to why my patch should be
preferred over yours ;-)


     Regards,
          Thomas

--=-OFwvRH4vduo6M6Rl5232
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIbLU8gF9cFv867HwRAnQSAJwLCTMPIhRT2t34p2xRDtTSerpyOQCfWRY+
jubwc9BKNn2Qc/3HuDwETF4=
=fCK5
-----END PGP SIGNATURE-----

--=-OFwvRH4vduo6M6Rl5232--

