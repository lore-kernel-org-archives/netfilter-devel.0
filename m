From: Harald Welte <laforge@netfilter.org>
Subject: Re: linux-2.6 and iptables compiled against 2.4 problems
Date: Fri, 5 Sep 2003 13:52:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905115207.GB665@obroa-skai.de.gnumonks.org>
References: <20030831150403.3472842d.mpol@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcel Pol <mpol@gmx.net>
Content-Disposition: inline
In-Reply-To: <20030831150403.3472842d.mpol@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 31, 2003 at 03:04:03PM +0200, Marcel Pol wrote:

> The problem is that when a distribution like Mandrake ships both a 2.4 an=
d a
> 2.6 kernel, it will have a broken iptables for linux-2.6. Linux-2.4 is st=
ill
> the main kernel, and that's the one which is used to compile iptables, wh=
ile
> the latest 1.2.8 release doesn't compile against linux-2.6.

1.2.8 doesn't compile against 2.6 ? which 2.6 are you talking about?
Why doesn't it compile?  What error messages do you get?

In any case the solution would be to release a new iptables (1.2.9)

> Marcel Pol

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WHjnXaXGVTD0i/8RAlBTAJsEyCDA3bJo2HCPF3rekYb7SqNCagCgh3Dm
wSIyQemqFln6qy1TDE2v+bE=
=aMlM
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
