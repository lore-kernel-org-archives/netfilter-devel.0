From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: the latest nf_conntrack
Date: Wed, 21 Jul 2004 23:28:24 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040722032823.GS27487@obroa-skai.de.gnumonks.org>
References: <200407010617.PAA23966@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHmdSDY+kY2au76U"
Cc: netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200407010617.PAA23966@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 01, 2004 at 03:17:43PM +0900, Yasuyuki Kozakai wrote:
>=20
> Hi, all,
>=20
> This is pom-ng style patch which enables layer 3 independent connection
> tracking (nf_conntrack). In nf_conntrack, core module is generalized so t=
hat
> other layer 3 protocols are easily implemented. In now, IPv4, IPv6, TCP, =
UDP,
> ICMP, ICMPv6 and FTP can be tracked.

Thanks, Yasuyuki.

I finally had the time for a review of your current code.  My
congratulations to your work, everything looks very clean, and I do not
have any comments at this time.

Could you please post a list of current issues / problems / questions /
=2E.. that you might have with the current nf_conntrack code?

What amount of testing has it received so far (including ftp-helper,
=2E..) ?

Is the state in patch-o-matic-ng the current state, or do you already
have some more recent changes?

I'm happy to give you CVS access to the nf_conntrack module in pom-ng,
in case you want to push some updates into our tree.

> Regards,
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eHmdSDY+kY2au76U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA/zRXXaXGVTD0i/8RAsDDAKCaprPD9tnMgwqPNGTU9l6jt5IoFwCgjjLz
a3BNjUuCAfHaH4pk7g+f9PI=
=1lrV
-----END PGP SIGNATURE-----

--eHmdSDY+kY2au76U--
