From: Harald Welte <laforge@gnumonks.org>
Subject: Re: IP Tables.
Date: Wed, 26 May 2004 09:52:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040526075207.GY1128@sunbeam.de.gnumonks.org>
References: <5F2ACC96AE8D6E459758C549A8DEF22018D99F@svr-mail02.corp.telesym.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PdAWLd+WEPmMbsbx"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Prakash <KishoreP@telesym.com>
Content-Disposition: inline
In-Reply-To: <5F2ACC96AE8D6E459758C549A8DEF22018D99F@svr-mail02.corp.telesym.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--PdAWLd+WEPmMbsbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2004 at 01:41:17PM -0700, Kishore Prakash wrote:
> Can I configure Iptables to have other kind of NAT behavior ?
>=20
> Like Port Restricted, IP Restricted, Full Cone NAT..

no way.  We are very proud to implement the most sophisticated / most
perfect version of nat - only to be found in advanced high-end solutions.

With regard to STUN: I think it's broken by design.  Especially since
most of the home user / end user WLAN and DSL routers are based on linux
and iptables - and thus don't work with this strange protocol.

> Regards,
> Kishore Prakash.
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--PdAWLd+WEPmMbsbx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAtEynXaXGVTD0i/8RAoHLAKCmWiwLnSzWK7GC1GXyJE1lk0f1SQCgmX7q
FV2rjH2XPmOxdZ8A6oKHhsg=
=bhWf
-----END PGP SIGNATURE-----

--PdAWLd+WEPmMbsbx--
