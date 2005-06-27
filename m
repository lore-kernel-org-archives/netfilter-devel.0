From: Harald Welte <laforge@netfilter.org>
Subject: Re: Iptables snapshot compile failure with 2.6.12 headers: - please
	disregard
Date: Mon, 27 Jun 2005 11:13:42 +0200
Message-ID: <20050627091342.GF19928@sunbeam.de.gnumonks.org>
References: <008901c57ab9$e6946330$5001010a@bluereef.local>
	<07f301c57acb$19aaa250$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wl4gXchqb9PBRcq/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
Content-Disposition: inline
In-Reply-To: <07f301c57acb$19aaa250$5001010a@bluereef.local>
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


--wl4gXchqb9PBRcq/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2005 at 01:48:37PM +1000, Andrew Hall wrote:

> It's the ipsec patches that cause the failure, and Tom's patch fixes this=
=20
> so there's no longer a problem.

sorry, which particular "tom's patch" are your referring to?

was that already included (to mainline kernel, p-o-m, iptables)?  Is
ther anything we still need to do about this issue?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wl4gXchqb9PBRcq/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv8NGXaXGVTD0i/8RAhwVAJ9wWsPT/9uHZZVqFGA1eRGaZVwJ4wCgsUlv
Q1xrf//0lLNQks4dND1+iX4=
=BEWp
-----END PGP SIGNATURE-----

--wl4gXchqb9PBRcq/--
