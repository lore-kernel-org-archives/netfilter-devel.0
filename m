From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RFC] Additional TCP Flags in the tcp module.
Date: Wed, 7 May 2003 16:58:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030507145852.GM6702@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.51.0305071216370.14343@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aznLbwQ42o7LEaqN"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0305071216370.14343@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aznLbwQ42o7LEaqN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2003 at 12:27:55PM +0200, Maciej Soltysiak wrote:
> Hi,
>=20
> I was wondering if it would be of any use to add ECE and CWR flags
> to libipt_tcp.c for matching.
>=20
> It would be a trivial patch and extension, but would it be useful, could
> it be harmful?

Not sure whether it would be useful. But I don't think that there is any
danger associated with it (other than people use it in a wrong way, but
then that's their problem).

However, we already have an ecn match, that matches IP and TCP flags...

"ECN match v%s options\n"
"[!] --ecn-tcp-cwr              Match CWR bit of TCP header\n"
"[!] --ecn-tcp-ece              Match ECE bit of TCP header\n"
"[!] --ecn-ip-ect [0..3]        Match ECN codepoint in IPv4 header\n",

> Regards,
> Maciej
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--aznLbwQ42o7LEaqN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+uR8sXaXGVTD0i/8RAsw9AJ9rJXPp9rZcyx7sT7LsUq4dVbkt9wCaA+Yx
BZHHjuUanWYUB84E5AYr6U0=
=W9Ew
-----END PGP SIGNATURE-----

--aznLbwQ42o7LEaqN--
