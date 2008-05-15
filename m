From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 3/4] Partially fill connection timestamp when
	hash  is not used.
Date: Thu, 15 May 2008 16:25:11 +0200
Message-ID: <20080515142511.GL3442@khasse.inl.fr>
References: <1210805679-11813-4-git-send-email-eric@inl.fr> <482C4205.4080907@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CEUtFxTsmBsHRLs3"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:49221 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbYEOOZN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 10:25:13 -0400
Content-Disposition: inline
In-Reply-To: <482C4205.4080907@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 15 at 16:00:37 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Ulogd2 maintain a hash table containing timestamp information on a conn=
ection.
> >=20
> > This patch computes START or STOP timestamp depending on the type of
> > the received message even if the has is not used.
>=20
> No objections with 1/4 and 2/4. The fix included in 4/4 is already fixed
> in the patchset that I just sent to the ML. We can rework 3/4 on top of
> my patches as this is the easiest way to fix the patch clashing IMO.

I agree, I will rework my patch tonight and give a run to your
impressive patchset.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--CEUtFxTsmBsHRLs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFILEfGnxA7CdMWjzIRAhP7AJ9C25TqPdpa2cT8UYIQmQsIT7cG9QCfbQRe
uF4TVWFxEXfuO59Av5W/cbs=
=bJh6
-----END PGP SIGNATURE-----

--CEUtFxTsmBsHRLs3--
