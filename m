From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to observe the changes made in the code
Date: Sun, 27 Apr 2003 14:43:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427124339.GZ990@sunbeam.de.gnumonks.org>
References: <676ee6cd29.6cd29676ee@teleline.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wHYmV+hLPeNaasdK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
Content-Disposition: inline
In-Reply-To: <676ee6cd29.6cd29676ee@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wHYmV+hLPeNaasdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2003 at 06:56:46PM +0200, ISLERO77@telefonica.net wrote:
>=20
> Hi, I have no many experience with Linux, and I'm trying to make some=20
> changes in an existent match, concretely in ipt_multiport, so I'm modifyi=
ng=20
> the ipt_multiport.c file. Now, when I make any simple change in the code=
=20
> I'm compiling the kernel and I'm losing a lot of time. My question is if =
it's=20
> any other way to observe the results of the changes made in the code.=20

rmmod ipt_multiport
make modules SUBDIRS=3Dnet/ipv4/netfilter
insmod net/ipv4/netfilter/ipt_multiport.o

> Thanks a lot.=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wHYmV+hLPeNaasdK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9B7XaXGVTD0i/8RApijAJ40C+iUD68sjz+29SO/SQp9VKNXFwCfSZuY
o19NMxhaVV8AUuFS8mv4gk4=
=5vXI
-----END PGP SIGNATURE-----

--wHYmV+hLPeNaasdK--
