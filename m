From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_nat_xdmcp for rh9
Date: Sat, 8 Nov 2003 14:49:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031108134900.GO5741@sunbeam.de.gnumonks.org>
References: <Law9-F106IlhqDWg4fs0002251d@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6t10AX3Id0Ai6Vje"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joph Zeng <joph_csu@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Law9-F106IlhqDWg4fs0002251d@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6t10AX3Id0Ai6Vje
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 08, 2003 at 09:31:59PM +0800, Joph Zeng wrote:
> hello harald,
>=20
>  sorry for bother you again.
>  I have download the xdmcp helper CVS 1.1 version, and, I successfully=20
> compiled it on my NAT box (TurboLinux workstation 8.0, with kernel=20
> 2.4.18-0.10smp,gcc 2.96), but when i want to insert this module, it told=
=20
> me:
>=20
> # insmod ip_nat_xdmcp
> /lib/modules/2.4.18-0.10smp/kernel/net/ipv4/netfilter/ip_nat_xdmcp.o:=20
> unresolved symbol ip_xdmcp_lock
> hint: you are trying to load a module without a GPL compatible license an=
d=20
> it has unresolved symbols. Contact the module supplier for assistance, on=
ly=20
> they can help you.

you need ip_conntrack_xdmcp in order to run ip_nat_xdmcp.


>  Thanks in advance.
>=20
> Joph
> 2003.11.8
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--6t10AX3Id0Ai6Vje
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/rPRMXaXGVTD0i/8RAjsYAKCfm8aZhv33fA5w/D/V1kBL5FbCZACZAQHt
MdMbViYc0zXvcoOWrsCoGeE=
=hhZe
-----END PGP SIGNATURE-----

--6t10AX3Id0Ai6Vje--
