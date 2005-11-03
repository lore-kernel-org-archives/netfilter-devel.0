From: Harald Welte <laforge@netfilter.org>
Subject: Re: Unknown Attribute 5/conntrack -L
Date: Thu, 3 Nov 2005 19:06:42 +0100
Message-ID: <20051103180642.GF905@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>
	<43662D1E.4000308@eurodev.net>
	<Pine.LNX.4.62.0510311544350.31123@bizon.gios.gov.pl>
	<200510311902.j9VJ28fq026612@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rgf3q3z9SdmXC6oT"
Cc: pablo@eurodev.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200510311902.j9VJ28fq026612@toshiba.co.jp>
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


--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 01, 2005 at 04:02:07AM +0900, Yasuyuki KOZAKAI wrote:

> I'm not sure it's the reason of oops, but at least attached patch fixes
> double free after netlink_unicast(). Krzysztof, could you try this ?

thanks yasyuki.  I'll submit this to mainline, since it is a bugfix,
even if it doesn't fix the problem that was reported originally.=20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Rgf3q3z9SdmXC6oT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDalGyXaXGVTD0i/8RAlSSAJ9+S15YkIljTDy/3j4ODd/r1N9lDgCfYyac
9SGedI1TkeVsQtDSNQ9IJHk=
=LNox
-----END PGP SIGNATURE-----

--Rgf3q3z9SdmXC6oT--
