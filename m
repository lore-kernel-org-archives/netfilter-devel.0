From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2.4.23 masquerading broken?
Date: Sat, 10 Jan 2004 22:59:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040110215954.GC20706@sunbeam.de.gnumonks.org>
References: <20031202165653.GJ615@gaast.net> <3FCCCB02.5070203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Cc: Wilmer van der Gaast <lintux@lintux.cx>, linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3FCCCB02.5070203@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2003 at 06:25:22PM +0100, Patrick McHardy wrote:
> Wilmer van der Gaast wrote:
>=20
> >For security reasons, I upgraded to 2.4.23 last night. Now, suddenly, IP
> >masquerading seems to be broken. When I use SNAT instead of
> >masquerading, everything works.
> >
> >Unfortunately, I think it's hard to reproduce the problem. Right after
> >booting .23 for the first time, everything seemed to be okay. The
> >problems started just an hour ago, after having the server running for
> >fifteen hours without any problems.
> >
> >Unfortunately there's not much more information I can provide. I can
> >attach my iptables/rule/route file and keep my machine running in case
> >anyone needs/wants more information. For now I'll just stick with SNAT.
> >It works good enough for me.

This seems to be the same as=20
http://www.ussg.iu.edu/hypermail/linux/kernel/0312.0/0465.html
and https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D144

I've committed the proposed fix (from #144) into patch-o-matic/pending.

Comments?

> Patrick

Patrick,=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAAHXaXaXGVTD0i/8RApnTAJ9BPiyzvYufU5wLgQy4FzBhrZoafgCgsZS9
3KIOH6AlBZsrCsM/GbQBOHc=
=JRqR
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
