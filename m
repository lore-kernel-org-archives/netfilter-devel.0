From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic fingerprint loading.
Date: Mon, 22 Sep 2003 15:51:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030922135151.GM31401@sunbeam.de.gnumonks.org>
References: <20030922171921.009b2133.johnpol@2ka.mipt.ru> <20030922173231.5bd6a7ae.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wAI/bQb0EMvlZCHl"
Cc: netfilter-devel@lists.netfilter.org, quaker@ondraszek.eu.org,
	solt@dns.toxicfilms.tv
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <20030922173231.5bd6a7ae.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wAI/bQb0EMvlZCHl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2003 at 05:32:31PM +0400, Evgeniy Polyakov wrote:
> >=20
> > All rules are added to linked list(with proper locking) without any
> > check, if this rule already exists.
>=20
> Attached patch fixes some locking problem when flushing rules.
> Please apply on top of previous.

can you please send patches against patch-o-matic?  (i.e. patches
against patches) Otherwise it is very difficult for me to integrate your
changes.

> Yep.
> 	Evgeniy Polyakov

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wAI/bQb0EMvlZCHl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bv53XaXGVTD0i/8RAjjJAJ0REK8FjaL2hLQyimCPmspZCbTfWACgsBzm
sv1bd4AGqy/0IPMdLohNR2Q=
=x25+
-----END PGP SIGNATURE-----

--wAI/bQb0EMvlZCHl--
