From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Bug]: (some) ICMP replies marked as invalid.
Date: Sat, 31 May 2003 19:10:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531171002.GX29312@sunbeam.de.gnumonks.org>
References: <3ED3D5F3.4080605@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WQ40utMgiyDduspJ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3ED3D5F3.4080605@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WQ40utMgiyDduspJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2003 at 11:17:39PM +0200, Anders Fugmann wrote:
> Hi,
>=20
> The rule:
> 	iptables -I OUTPUT -m state --state INVALID -j DROP
> (all other chains empty with policy accept), results in ICMP replies to
> tracetoute being dropped.
>=20
> Is dropping invalid packets on the output chain not recommended, or is=20
> the code determining if a packet is invalid broken?

since this is a bug report, please put it into bugzilla.netfilter.org.

thanks a lot.

> Regards
> Anders Fugmann

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WQ40utMgiyDduspJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2OHqXaXGVTD0i/8RAiKAAKCSs+gjJkqW6CCXlbPGQ7GBEoAeOgCfW9/r
HEvScuXeGaTaqVDzS+jtSyc=
=SF9I
-----END PGP SIGNATURE-----

--WQ40utMgiyDduspJ--
