From: Harald Welte <laforge@gnumonks.org>
Subject: Re: libiptc: the question about struct ipt_entry
Date: Tue, 22 Oct 2002 17:24:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022152452.GC6419@naboo.club.berlin.ccc.de>
References: <LLEJLJOMFGPFJFEGAKBJOENPCCAA.luoqiang@ict.ac.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: luoqiang <luoqiang@ict.ac.cn>
Content-Disposition: inline
In-Reply-To: <LLEJLJOMFGPFJFEGAKBJOENPCCAA.luoqiang@ict.ac.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2002 at 05:27:20PM +0800, luoqiang wrote:
> Hi, all
>=20
>     I use libiptc to control the rule, but I have some questions about ip=
t_entry now.
>     For example, I use "iptables -t nat -A PREROUTING -p udp --sport 5000=
 -j DNAT --to 10.10.5.9:5000"
> to form a ipt_entry.
>     1.  I found that  the total size of match in this ipt_entryt  is
>     44, but it only include a ipt_entry_match and a  ipt_udp, and
>     sizeof(ipt_entry_match)+sizeof(ipt_udp) =3D 32 + 10 =3D42, why 2 bytes
>     difference?

It's padding to a 32bit boundary (42 is not a multiple of 4)

>     2.  For target in this example, the total size is 52, 32 of which
>     is the sizeof struct ipt_entry_target, I don't know what struct
>     should be for the other 20 bytes, which is pointed  by
>     target->data. and I think it should store the information about "
>     --to 10.10.5.9:5000". Some one can tell me what struct it is ?

struct ip_nat_multi_range, and again maybe some padding at the end.

>  Thanks!
> luoqiang

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9tW3EXaXGVTD0i/8RAsZDAJ9MnCKxSof9GMW2iTEI5SWbela6qgCgh5dk
+EXhaoRGCO1waPW2ctiPSYM=
=Qayo
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
