From: Harald Welte <laforge@netfilter.org>
Subject: Re: ALGs
Date: Tue, 3 Jun 2003 12:26:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030603102651.GR11468@sunbeam.de.gnumonks.org>
References: <Sea2-F69azjnVaKEh4L0005a6ca@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Sea2-F69azjnVaKEh4L0005a6ca@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2003 at 11:08:42AM +0000, Ricky Foo wrote:
> Hi guys,
>=20
> I am new to this list. Currently, I need to develop a ALG for netbios but=
 i=20
> can't seems to find the source-code anywhere in the kernel directory. Can=
=20
> anybody lend a helping hand?=20

for examples see:
/usr/src/linux/net/ipv4/netfilter/ip_{conntrack,nat}_{ftp,irc}.c
/usr/src/linux/include/linux/netfilter_ipv4/ip_{conntrack,nat}_{ftp,irc}.h

please also note the newnat-summary.txt from CVS and the outdated
netfilter hacking howto - as well as lots of other conntrack/NAT helper
modules in patch-o-matic.

> Hopefully I can contribute the code back when I am finished since
> there aren't any ALG for netbios if I am not wrong.

No, there are none.  We're always happy about contributions.

> Thanks.
>    Ricky

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+3HfrXaXGVTD0i/8RAhQ+AJ4x+4T27mR1gHNCIHP/HtTqW0pnGwCglG7n
dl8EPTWaDfI6GWI9dnh4lcA=
=fU/d
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
