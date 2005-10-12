From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 08:43:46 +0200
Message-ID: <20051012064345.GE4237@rama.de.gnumonks.org>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
	<20051011104446.GJ4290@rama>
	<20051011175457.GC13415@rama.de.gnumonks.org>
	<434C3485.2000700@frankengul.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?S=E9bastien?= Bernard <seb@frankengul.org>
Content-Disposition: inline
In-Reply-To: <434C3485.2000700@frankengul.org>
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


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 11:54:13PM +0200, S=E9bastien Bernard wrote:
> Harald Welte a =E9crit :
> On sparc64, cpu_possible_map does not exist.

strange, I guess this should be fixed in the sparc code then.  Maybe I
was just missing some includes...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDTLChXaXGVTD0i/8RAgNrAJ9TiHF6ezwabpHQlNTqTdG051NfLwCdGP5U
0e5EdW2cVQSnV9yHfz9lg7c=
=wbhJ
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
