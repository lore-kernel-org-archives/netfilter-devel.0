From: Harald Welte <laforge@netfilter.org>
Subject: Re: [FUN] New target: passive OS fingerprinting.
Date: Wed, 26 Nov 2003 20:44:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126194454.GC3740@obroa-skai.de.gnumonks.org>
References: <20031124101806.GI4888@obroa-skai.de.gnumonks.org> <20031124230108.752aab76.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <20031124230108.752aab76.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2003 at 11:01:08PM +0300, Evgeniy Polyakov wrote:
> On Mon, 24 Nov 2003 11:18:06 +0100
> Harald Welte <laforge@netfilter.org> wrote:
>=20
> Hi, Harald.
>=20
> > You could maybe add a '--log' option to the match or whatever... but I
> > really don't think it's a good idea to have the same code replicated
> > as match and as target.
>=20
> Here is patch.

Ok, I'll apply it to CVS.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xQK1XaXGVTD0i/8RAuB8AJwOLj1F27IYqXksSsqut4TQs/UpMQCfXDIT
zd0Ssy58ID7E3mlAVt7Z48Q=
=w7Pi
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
