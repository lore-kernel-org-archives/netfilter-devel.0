From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] (no subject)
Date: Fri, 28 Mar 2003 12:58:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030328115850.GU25471@sunbeam.de.gnumonks.org>
References: <004701c2f502$8da118c0$5b01aa0a@Dec0y>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7S+EREVcBHk3zUG"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dec0y <anti_decoy@sina.com>
Content-Disposition: inline
In-Reply-To: <004701c2f502$8da118c0$5b01aa0a@Dec0y>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--p7S+EREVcBHk3zUG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2003 at 04:18:02PM +0800, Dec0y wrote:
> Hi!
>=20
> Can  REDIRECT be realized in FORWARD?!

Pleae read http://www.netfilter.org/contact.html

you seem to be misunderstanding about everything in netfilter
architecture. =20

FORWARD is a chain of the 'filter' table. =20
REDIRECT is a target in the 'nat' table.

So the answer is: no way.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--p7S+EREVcBHk3zUG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hDj6XaXGVTD0i/8RAqEmAKCIUWl8GpKfr9dvY3DDNm7lLYTIMQCgiHSh
i/dd9nuPK9KbYi+6EyUUxvU=
=mH0D
-----END PGP SIGNATURE-----

--p7S+EREVcBHk3zUG--
