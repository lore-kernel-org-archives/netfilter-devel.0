From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and optimization
Date: Tue, 6 Jul 2004 12:35:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040706103544.GU32707@sunbeam2>
References: <200406240404.NAA01264@toshiba.co.jp> <40DABA52.9070700@trash.net> <19040125165321.GA4640@obroa-skai.de.gnumonks.org> <40EA7CE7.2000502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibvzjYYg+QDzMCy1"
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40EA7CE7.2000502@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ibvzjYYg+QDzMCy1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 06, 2004 at 12:20:23PM +0200, Patrick McHardy wrote:
> skb_copy_bits is taking about twice as much cycles as tcp_match
> and 20% of total cycles.

Well, I am convinced ;)

> Regards
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ibvzjYYg+QDzMCy1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA6oCAXaXGVTD0i/8RAs6nAJwPpzHXlMxJV7P3D/U/vO6ADW5OzACeMjGE
hr6/yqiA0T/57eSYEfjxkaE=
=M98P
-----END PGP SIGNATURE-----

--ibvzjYYg+QDzMCy1--
