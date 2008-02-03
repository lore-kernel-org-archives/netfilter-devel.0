From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 02/34] [Resend] Do not propagate one conntrack event
	via  2 messages
Date: Sun, 3 Feb 2008 12:53:09 +0100
Message-ID: <20080203115309.GB25411@bayen.regit.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <12019874692227-git-send-email-eric@inl.fr> <877ihmmluc.fsf@kruemel.eitzenberger.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:35224 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758836AbYBCLxN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:53:13 -0500
Content-Disposition: inline
In-Reply-To: <877ihmmluc.fsf@kruemel.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sunday, 2008 February  3 at 10:27:07 +0100, Holger Eitzenberger wrote:
> Eric Leblond <eric@inl.fr> writes:
>=20
> > Ulogd2 was propagating through a stack 2 message for one single conntra=
ck event.
> > This patch provides a fall back to on message per event. It also uses a=
n enum to improve
> > code readability instead of direct access to array via numerical index.
>=20
> Hi Eric,
>=20
> this one would clash with the changes I did.=20

Yes that's the only point where our respective work clash.

> I'll check what you do
> did there.  In the meantime can you please check
>=20
>  [ULOGD 15/15] NFCT: rework and let it scale
>=20
> from my last patchset?  I'll happily change that code to keep the
> output key compatibility.

As long as you maintain output key compatibility, I'm fine with it.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHpaslnxA7CdMWjzIRAnNvAJ0YRl+XzABr1Li1o0Q8j++b1XsqAQCfT+4K
vSSiQqRYcuqIqYTHrWY90mE=
=K6fw
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
