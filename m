From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH/RFC] core/netfilter.c: possible use of freed skb
Date: Wed, 30 Jul 2003 16:06:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030730140626.GB4553@sunbeam.de.gnumonks.org>
References: <200307271655.15937.bdschuym@pandora.be> <20030727155030.2ce4e22e.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030727155030.2ce4e22e.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2003 at 03:50:30PM -0700, David S. Miller wrote:

> This patch looks OK to me, can I get an ACK from the
> netfilter folks?

Dave, the patch looks fine to me.

Sorry for the delay, still catching up with everything that was lost
while I was at OLS.

Please apply!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/J9DiXaXGVTD0i/8RAilZAKCZzhbp4qusg/36SG5iOgoF+ap6kQCdHHb3
7Q6wAnoBVq4ulJCoJecsP3U=
=Ww++
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
