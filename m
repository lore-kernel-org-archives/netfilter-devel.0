From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_nat_xdmcp for rh9
Date: Fri, 17 Oct 2003 09:29:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031017072908.GI21521@sunbeam.de.gnumonks.org>
References: <Law9-F99nLLW94lJ7tU000039f5@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joph Zeng <joph_csu@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Law9-F99nLLW94lJ7tU000039f5@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2003 at 09:29:59PM +0800, Joph Zeng wrote:
> hello,laforge:
>=20
> I want to connect a X-server through a linux box with redhat 9.0 installe=
d=20
> on it. I have successed make it with Turbolinux 7(kernel 2.4.18,gcc 2.9)=
=20
> and a ip_nat_xdmcp module I download somewhere. with the redhat 9 (kernel=
=20
> 2.4.20,gcc 3.2), I can not compile the module metioned above, and I do no=
t=20
> know how to use the ip_nat_xdmcp module in netfilter's CVS.

the module is inherently insecure and should not be used.  I did never
find the time to complete my re-work of that module.  It is not
officially distributed and just in CVS for exactly this reason
> Any help and advise will be great appliciated.

btw: http://netfilter.org/contact.html

> Joph
> 2003.10.16

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/j5pEXaXGVTD0i/8RAh31AJ4tzd40crU2DUT8jgWwq64n2IOg3wCdEH6e
ZzBbecSNumSiQHcVpMfhTw8=
=8i4y
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
