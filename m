From: Harald Welte <laforge@netfilter.org>
Subject: Re: [BUG] Netfilter in Linux 2.6.1
Date: Tue, 27 Jan 2004 12:00:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127110019.GH11761@sunbeam.de.gnumonks.org>
References: <20040123160319.GA2733@schottelius.org> <20040123114205.014be03b.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Cc: Nico Schottelius <nico-linux-net@schottelius.org>,
	linux-net@vger.kernel.org, gregor@tecmafia.de,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20040123114205.014be03b.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2004 at 11:42:05AM -0800, David S. Miller wrote:
> On Fri, 23 Jan 2004 17:03:19 +0100
> Nico Schottelius <nico-linux-net@schottelius.org> wrote:
>=20
> > Is that right?
> >=20
> > This looks for me like bug in netfilter...
>=20
> Netfilter first sees the pre-encrypted SSH TCP packets before they are
> encapsulated in ESP, and thus your rules say to drop those.
>=20
> That's just how things work currently.

JFYI: We're currently discussing how to proceed with this issue on
netfilter-devel (Thread started at
http://lists.netfilter.org/pipermail/netfilter-devel/2004-January/013879.ht=
ml)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFkTDXaXGVTD0i/8RArS9AJ9out+GO5iEJXRQFEski3XyGRPI+gCbBM41
APjOapnCHcNMnGF9kiFrZiU=
=s4oW
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
