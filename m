From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 1/7] Add label option to NFLOG input plugin.
Date: Sun, 27 Apr 2008 10:44:03 +0200
Message-ID: <20080427084403.GB9479@bayen.regit.org>
References: <4805E566.7010902@netfilter.org> <1208352161448-git-send-email-eric@inl.fr> <48142AE7.5020701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:42844 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYD0IoG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:44:06 -0400
Content-Disposition: inline
In-Reply-To: <48142AE7.5020701@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sunday, 2008 April 27 at  9:27:35 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > @@ -78,6 +78,13 @@ static struct config_keyset libulog_kset =3D {
> >  			.options =3D CONFIG_OPT_NONE,
> >  			.u.value =3D 0,
> >  		},
> > +		{
> > +			.key	 =3D "label",
> > +			.type	 =3D CONFIG_TYPE_INT,
> > +			.options =3D CONFIG_OPT_NONE,
> > +			.u.value =3D 0,
> > +		},
> > +
> >  	}
> >  };
>=20
> Wouldn't it better if we use a string instead of an integer? Thus, this
> will really work as labeler.

We already have the log prefix for a string label usage. I think it will
brought confusion to have both a string log prefix and a string label.
Furthermore, the goal of the label is to be able to classify packets and
an integer will be faster (in the database), stricter (to avoid
confusion) and smaller (to store) than a string.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIFDzSnxA7CdMWjzIRAuVpAJ9KDnc3+/jq3YpMnixoltKcMfSpFgCfY1kf
V+7A+G+k4zY96OlOpV7JTTM=
=eshi
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
