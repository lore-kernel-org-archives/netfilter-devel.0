From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK] convert nfmark and conntrack mark to 32bit
	in nf_conntrack
Date: Mon, 8 Aug 2005 22:03:21 +0200
Message-ID: <20050808200321.GU25303@rama.de.gnumonks.org>
References: <200508080840.j788ekQd011697@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aHjqRFB8NC1b71K"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508080840.j788ekQd011697@toshiba.co.jp>
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


--9aHjqRFB8NC1b71K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 08, 2005 at 05:40:46PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi, Harald,
>=20
> This patch follows ip_conntrack change that converts nfmark and conntrack=
-mark
> to be 32bits even on 64bit architectures, as discussed at netconf'05.

thanks, applied

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9aHjqRFB8NC1b71K
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC97qJXaXGVTD0i/8RAm0TAJ4tUXdF9+1RIWF0SAXi2SH13iYyUACgg5bt
vrAgEpcXs0ZGWzbN/BxGej8=
=Eh/W
-----END PGP SIGNATURE-----

--9aHjqRFB8NC1b71K--
