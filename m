From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp-conntrack-nat kernel patch
Date: Mon, 24 Nov 2003 11:02:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031124100236.GC4888@obroa-skai.de.gnumonks.org>
References: <WorldClient-F200311231448.AA48350041@compaenveendam.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart Hofstede <bhofstede@compaenveendam.nl>
Content-Disposition: inline
In-Reply-To: <WorldClient-F200311231448.AA48350041@compaenveendam.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 23, 2003 at 02:48:35PM +0100, Bart Hofstede wrote:
> Hello,
>=20
> I Found your PPTP Netfilter patch at www.netfilter.org. And it was just=
=20
> wat i'm looking for.

> In the documantation of the patch ik found out that this code has=20
> limitations.
>=20
> Note that this code currently has limitations
> - can only NAT connections from PNS to PAC
> - doesnt' support multiple calls within one session
> - you have to recompile your iptables userspace program since some=20
>   structure sizes change
>=20
> I dont understand this. What does this mean?

> I'am looking for solution with the this ability:

this are exactly the two cases that are supported. (DNAT and SNAT of a
single-call-per-session client->server)

> Greetings,
> Bart Hofstede

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/wdc7XaXGVTD0i/8RAtHvAJ9NRRueZ2X+HL56+VWKYULn9v307QCfWkAC
YVnYPbsy3KbktW93wB1YwNQ=
=LQGL
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
