From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables and SPI...
Date: Fri, 31 Oct 2003 15:47:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031031144745.GG21066@sunbeam.de.gnumonks.org>
References: <Law10-F124Y6YHkidcD0000000d@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dimitri borjac <dimitri_borjac@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Law10-F124Y6YHkidcD0000000d@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2003 at 04:44:51PM +0000, dimitri borjac wrote:
> Hi!
> i sent this question to the user list but maybe you would have more preci=
se=20
> answers ...
>=20
> I'd like to know if it's possible to use the current version of iptables =
in=20
> order to NAT different VPN established between different NATted hosts and=
 1=20
> remote gateway (the same gateway for all of them) ?  Such a NAT would be=
=20
> made by watching both addresses, ports and SPIs...

I don't really understand what you want to achieve.  Please try to
explain this in more detail.

> In other words :  is it possible for iptables to go and check the SPI fie=
ld
> in the ESP Header of the IPsec packet in ESP tunnel mode ?

are you talking about freeswan or the 2.6 kenel ipsec implementation?
Is your iptables running on one end of a tunnel or just enroute your ESP
tunnel?  Are you using UDP ESP encapsulation mode (nat-traversal)?

> Hope i make me clear enough :)

no, unfortunately not.  Or I'm too stupid, sorry.

> Dimo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/onYRXaXGVTD0i/8RAr6JAKCr5f3iqsBrM/6dqsfxf6RuAlFa/QCfTvZY
mFPUogHtl/I0caA/JqEM/wA=
=mm7p
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
