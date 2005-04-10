From: Harald Welte <laforge@netfilter.org>
Subject: Re: ICMP error handling in CLUSTERIP
Date: Sun, 10 Apr 2005 22:58:42 +0200
Message-ID: <20050410205842.GY9155@sunbeam.de.gnumonks.org>
References: <000001c53a8c$d5910290$aa28abc1@Vagabond>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q2eHRNFhq9YPz0FN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Stieglecker <a.stieglecker@gmx.net>
Content-Disposition: inline
In-Reply-To: <000001c53a8c$d5910290$aa28abc1@Vagabond>
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


--Q2eHRNFhq9YPz0FN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 06, 2005 at 11:41:39AM +0200, Alexander Stieglecker wrote:
> /* special case: ICMP error handling. conntrack distinguishes between
>  * error messages (RELATED) and information requests (see below) */
> if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP
>     && (ctinfo =3D=3D IP_CT_RELATED=20
> 	|| ctinfo =3D=3D IP_CT_IS_REPLY+IP_CT_IS_REPLY))
> 	return IPT_CONTINUE;
>=20
> IP_CT_IS_REPLY+IP_CT_IS_REPLY equals six which is greater than IP_CT_NUMB=
ER.
> Shouldn't it be something like IP_CT_IS_RELATED+IP_CT_IS_REPLY?

good catch.  Committing to svn now, patch for mainline added to my set
of pending patches.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Q2eHRNFhq9YPz0FN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWZOCXaXGVTD0i/8RAsuXAKCnuQsmG+z+W/zUd0kyp0IUPo/UBgCePe7G
HVCGNJqzXjo9+A3CLTH5sS0=
=o3IO
-----END PGP SIGNATURE-----

--Q2eHRNFhq9YPz0FN--
