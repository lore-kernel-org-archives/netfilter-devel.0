From: Harald Welte <laforge@netfilter.org>
Subject: Re: [2.4 patch] netfilter Configure.help cleanup
Date: Fri, 25 Jul 2003 22:50:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205024.GA3244@sunbeam.de.gnumonks.org>
References: <20030717201304.GL1407@fs.tum.de> <20030718012910.0D5BB2C5A9@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JhY86nTAwD/oWhC3"
Cc: Adrian Bunk <bunk@fs.tum.de>,
	Marcelo Tosatti <marcelo@conectiva.com.br>,
	"David S. Miller" <davem@redhat.com>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	linux-net@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030718012910.0D5BB2C5A9@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JhY86nTAwD/oWhC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2003 at 11:06:49AM +1000, Rusty Russell wrote:
> In message <20030717201304.GL1407@fs.tum.de> you write:
>
> > the patch below does the following changes to the netfilter entries in
> > Configure.help in 2.4.22-pre2:
> > - order similar to net/ipv4/netfilter/Config.in
> > - remove useless short descriptions above CONFIG_*
> > - added CONFIG_IP_NF_MATCH_RECENT entry (stolen from 2.5)
>=20
> Sorry Adrian, I think this is overzealous.
>=20
> Please just add the CONFIG_IP_NF_MATCH_RECENT entry.  Remember,
> "stable" means "boring". 8)

I will submit the RECENT entry to davem with my next set of patches.

Does everybody else have an ordered Configure.help?  if yes, I'd accept
the patch to comply with common practice.  If not, I would just say: who
cares about the order, it's processed by {old,menu,x}config anyway.

> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JhY86nTAwD/oWhC3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZgQXaXGVTD0i/8RArFrAJ912q2rrMA9hpwko3PQ6UDagd1H5wCgi5Jk
s5GFci4ROPUR5mfpwrZTN1E=
=6uEt
-----END PGP SIGNATURE-----

--JhY86nTAwD/oWhC3--
