From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPP2P 0.7 update (POM-ng patch included)
Date: Tue, 4 Jan 2005 11:41:08 +0100
Message-ID: <20050104104108.GU11370@sunbeam.de.gnumonks.org>
References: <41CB587A.4000402@studserv.uni-leipzig.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1rohIOZGhsaeEmnk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eicke Friedrich <mai97bwf@studserv.uni-leipzig.de>
Content-Disposition: inline
In-Reply-To: <41CB587A.4000402@studserv.uni-leipzig.de>
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


--1rohIOZGhsaeEmnk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 24, 2004 at 12:44:58AM +0100, Eicke Friedrich wrote:
> Hi,
>=20
> IPP2P 0.7 has been released. It offers a couple of new features including:
> -UDP filtering support for some P2P networks
> -improved SoulSeek filter
> -Ares/AresLite matching support
> -debug option to print matchinfo into kernel log

you forgot to mention that you reimplemented udp and tcp protocol
matching.  I disagree.  Why was this required?

> -iptables -A FORWARD -p tcp -m ipp2p --edk --kazaa --dc --gnu --bit --app=
le -j DROP
> +iptables -A FORWARD -m ipp2p --edk --kazaa --tcp --udp  -j DROP

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1rohIOZGhsaeEmnk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB2nLEXaXGVTD0i/8RAlAgAJ43UvMy28tgA1NeYi6W2R/GHUFhfwCdEFHt
ASRloEHCRfg+NPAB26VxAZ0=
=N+ww
-----END PGP SIGNATURE-----

--1rohIOZGhsaeEmnk--
