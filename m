From: Harald Welte <laforge@netfilter.org>
Subject: Re: sending event to user space
Date: Thu, 4 Dec 2003 17:19:08 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204114908.GD7680@obroa-skai.de.gnumonks.org>
References: <3FCDF1EB.1070803@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pablo neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <3FCDF1EB.1070803@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2003 at 03:23:17PM +0100, pablo neira wrote:
> Hi list!
>=20
> I programmed a dummy module for netfilter which tries to match a packet=
=20
> and if it does, it will do nothing (NF_ACCEPT) but I would want it to=20
> send an event to a program in user space to do something, how can I do th=
at?

That is not really netfilter related at all.  You could create a /proc
file and write something to it, you could use netlink sockets, you could
use any means that the kernel provides for communication with userspace
processes...
=20
> Thanks!
> Pablo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/zx9KXaXGVTD0i/8RAvncAJ9K4ywgDPh6CkD3tosl/tjDMNh88gCeLEkE
7z/8OMQFlgLpArkjXpxfZi4=
=JDjR
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
