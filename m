From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug in rpc conntrack modules
Date: Tue, 29 Apr 2003 16:55:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429145550.GH684@naboo.intranet.astaro.de>
References: <1051483678.5944.223.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
Cc: Marcelo Barbosa Lima <marcelo.lima@dcc.unicamp.br>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051483678.5944.223.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 12:47:58AM +0200, Martin Josefsson wrote:
> Hi Marcelo.

Hi Martin.  Please note that I don't expect Marcelo to comment on your
email.  He has written this code about three years ago and I assume he
has abandoned the code (which is perfectly fine, every author has the
right to do so).

As the comment on top of ip_conntrack_rpc_tcp.c indicates, rusty did
some porting, I merged it with newnat (IIRC), and Ian.Latter finally
re-worked it again.  He probably is the one most familiar with the code
now.

> I've just found a small bug in how you handle the name member of
> struct ip_conntrack_helper rpc_helpers
>=20
> You use one piece of memory which you overwrite for each port.
> The struct only holds a pointer to the string, not a copy of it.
> Please look at how other helpers do.
>=20
> If you send me a patch against patch-o-matic I'll commit it.

Martin, you'll have to fix it by yourself (or I will have to do it).

Please add a bug to bugzilla, accept it and mark it as FIXED just for
keeping track of those issues.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rpJ2XaXGVTD0i/8RAsy8AKCogL4gbMCMhr2/4lKdt33AXJuevgCeIhWN
sy/8Yo6WDYRjlpFqIuZRoa0=
=KO2+
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--
