From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_ULOG delays packets caught by filter
Date: Thu, 22 Jul 2004 20:03:35 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040723000335.GV27487@obroa-skai.de.gnumonks.org>
References: <20040720001021.GA4226@wonderland>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4dIe/AmYstFUGHTF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ruby joker <ruby.joker@op.pl>
Content-Disposition: inline
In-Reply-To: <20040720001021.GA4226@wonderland>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4dIe/AmYstFUGHTF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 20, 2004 at 02:10:21AM +0200, ruby joker wrote:
> Hi!
>=20
> I want once again bring your attention to ipt_ULOG problem I described
> in my previous post [1]. There was no response, still I think problem
> is too serious to leave it. Christopher J. Oliver's case [2] shows
> the similar behaviour. Maybe bug is hard to notice but it decrease
> ulog reliability.

I am well aware of this problem, and I do by no means consider it as
important as to push it into 2.6.8-rc2.  The patch is pending for 2.6.9

> Regards,
> rj
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4dIe/AmYstFUGHTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAFXWXaXGVTD0i/8RAtm8AKCqy8zqgjREp6g9RFIeYgd9qoR9ugCgprkx
uca99npjOIwCXu8nzRp2hoM=
=Q9ZY
-----END PGP SIGNATURE-----

--4dIe/AmYstFUGHTF--
