From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Wed, 12 Apr 2006 10:38:36 +0200
Message-ID: <20060412083835.GN31616@sunbeam.de.gnumonks.org>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rpGc+ACYPE+RMC+Z"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44381584.4020109@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--rpGc+ACYPE+RMC+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 08, 2006 at 09:56:52PM +0200, Patrick McHardy wrote:
> I don't have any principle objections against merging this (if
> there are no objections from others), a couple of comments
> on the patch though.

Well, if we merge it for ip_conntrack, we _have_ to also merge it into
nf_conntrack for consistency reasons.

> +#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT) ||
> defined(CONFIG_NF_CT_FIXED_TIMEOUT)
> +    /* Connection has fixed timeout. */
> +	IPS_FIXED_TIMEOUT_BIT =3D 10,
> +	IPS_FIXED_TIMEOUT =3D (1 << IPS_FIXED_TIMEOUT_BIT),
> +#endif
>=20
> Probably not worth adding a config option for this.

not for the bit, but in general we would need one, otherwise we have an
(extremely large) timer entry per conntrack...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rpGc+ACYPE+RMC+Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPLyLXaXGVTD0i/8RAulWAKCwuKmgrNyuWm0C/QNRDOviF/crGQCeMu35
e4fK+x0SHcuY5LkdtMZclZw=
=J3Sb
-----END PGP SIGNATURE-----

--rpGc+ACYPE+RMC+Z--
