From: Harald Welte <laforge@netfilter.org>
Subject: Re: NetFilter unclean modue in 2.6.x kernels
Date: Mon, 24 Jan 2005 09:57:04 +0100
Message-ID: <20050124085704.GA14460@sunbeam.de.gnumonks.org>
References: <200501220013.56429.sov.rbsec@gmail.com>
	<20050121233328.GU14460@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80FmgzPrdF8O9k7o"
Cc: "Oleg V. Sapon" <sov.rbsec@gmail.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--80FmgzPrdF8O9k7o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jozsef!

On Mon, Jan 24, 2005 at 09:40:51AM +0100, Jozsef Kadlecsik wrote:
> I also ported the unclean patch to 2.6 some time ago. The main reason I
> did not post it was the slightly modified API.
>
> [...]
>=20
> If there are plans to submit the unclean match into the kernel, I think
> something like my port should be considered.

No, I think we're pretty sure that we don't want to have it in the
kernel again.

> Jozsef
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--80FmgzPrdF8O9k7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB9LhgXaXGVTD0i/8RAqYSAJ4r3h/5aHC0SWM8+ORuGwI0BxmZ7QCfTogn
QWpYXnmjaVbrjYfSOE7effk=
=iVEM
-----END PGP SIGNATURE-----

--80FmgzPrdF8O9k7o--
