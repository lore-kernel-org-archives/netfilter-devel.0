From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH, RFC] possible use of freed skbuff in netfilter.c
Date: Tue, 29 Apr 2003 16:51:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429145129.GG684@naboo.intranet.astaro.de>
References: <200304251957.18012.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JkW1gnuWHDypiMFO"
Cc: "David S. Miller" <davem@redhat.com>,
	Rusty Russel <rusty@rustcorp.com.au>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200304251957.18012.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JkW1gnuWHDypiMFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2003 at 07:57:17PM +0200, Bart De Schuymer wrote:
> Hello Dave,
>=20
> When dev_put'ing bridge devices in netfilter.c::reinject the skb can alre=
ady=20
> be freed. The patch below fixes this by delaying the freeing of the skb a=
=20
> bit. AFAIK, calling kfree_skb outside the read_lock causes no problems.
> Could someone of the netfilter core team approve or disapprove this chang=
e?
> This is bug 86 of the netfilter bugtracking system.

I'm fine with this fix, please apply (if it isn't already).

> cheers,
> Bart

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JkW1gnuWHDypiMFO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rpFxXaXGVTD0i/8RAjvoAKCTKFs0iClaFuDSmAYWzukWb1ecoACgkGcE
TBbnSLWYRvG4JVCuPNyIZI0=
=+vHz
-----END PGP SIGNATURE-----

--JkW1gnuWHDypiMFO--
