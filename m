From: Harald Welte <laforge@gnumonks.org>
Subject: Re: problem ULOG when high loaded
Date: Wed, 9 Oct 2002 16:56:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009165633.X13233@sunbeam.de.gnumonks.org>
References: <CKEGJOPDOMNNFIGIMICAOEFACBAA.caster@postech.ac.kr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bDDjztrZmyyMv72E"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "wizard" <caster@postech.ac.kr>
Content-Disposition: inline
In-Reply-To: <CKEGJOPDOMNNFIGIMICAOEFACBAA.caster@postech.ac.kr>; from caster@postech.ac.kr on Mon, Oct 07, 2002 at 06:11:40PM +0900
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bDDjztrZmyyMv72E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2002 at 06:11:40PM +0900, wizard wrote:
> Hi, netfilter developers~
>=20
>  I have a Question about ULOG ..
>=20
>  if my linuxbox works on 50000 forwarding packet per second, and try to l=
og all packet ,
>=20
>  is it possible..?

This of course depends on=20

a) your hardware
b) what kind of logging software (and logging output format) you use in=20
   userspace
c) how much of the packet needs to be copied to userspace.

I have users who've positively reported logging a 100MBit connection at
full wire speed [with real-world packets, _not_ 64bytes].

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--bDDjztrZmyyMv72E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9pEOgXaXGVTD0i/8RAjOOAJ0SoW8w6mZr8Yz+eKk+ffWwk4FAuQCfXPJa
IfEoRotfYyqdujRlDRvUwAs=
=PzW8
-----END PGP SIGNATURE-----

--bDDjztrZmyyMv72E--
