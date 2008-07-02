From: Thomas Jacob <jacob@internet24.de>
Subject: Re: [PATCH] Speed up verdict to chain_head mapping by using binary
	search
Date: Wed, 02 Jul 2008 18:07:10 +0200
Message-ID: <1215014830.26474.53.camel@enterprise.ims-firmen.de>
References: <> <1214997482-19063-1-git-send-email-jacob@internet24.de>
	 <486B9E84.4070403@trash.net>
	 <1215014004.26474.45.camel@enterprise.ims-firmen.de>
	 <486BA60C.6060708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NFpmnSv/5Afs8D73rZmx"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:51624 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbYGBQHM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:07:12 -0400
In-Reply-To: <486BA60C.6060708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-NFpmnSv/5Afs8D73rZmx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 18:00 +0200, Patrick McHardy wrote:=20
> > No, I just didn't want to write the same code twice.... that's all,
> > what do you suggest, doing that (writing the same code twice)?
>=20
> No, a macro is better than duplicating it. I was just wondering
> whether a function would also do.

Well, this function would have to deal with two unrelated types
(offsets_chunk for the first layer, chain_head for the second layer), I
don't see immediately how this could be done, any suggestions?

--=-NFpmnSv/5Afs8D73rZmx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIa6eugF9cFv867HwRAs+6AJ4h5NvtH+PfOdUX4a2yDkX0iWdFJQCfXxOy
yLKSZALmM5fQHTyEpJmiJ7E=
=4u4d
-----END PGP SIGNATURE-----

--=-NFpmnSv/5Afs8D73rZmx--

