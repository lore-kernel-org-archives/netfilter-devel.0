From: Saku Ytti <saku@ytti.fi>
Subject: Re: ipv6 conntrack status?
Date: Thu, 2 Mar 2006 19:58:54 +0200
Message-ID: <20060302175854.GA741@mx.ytti.net>
References: <20060225111316.GA13280@mx.ytti.net>
	<200603021741.k22Hf8Hr013260@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200603021741.k22Hf8Hr013260@toshiba.co.jp>
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


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (2006-03-03 02:41 +0900), Yasuyuki KOZAKAI wrote:

> You can use nf_conntrack_ipv6 in mainline kernel, not ip6_conntrack.
> To build it, please disable IP_NF_CONNTRACK, enable NF_CONNTRACK and
> NF_CONNTRACK_IPV6. NF_CONNTRACK is in the menu "Core Netfilter Configurat=
ion",
> and NF_CONNTRACK_IPV6 in the menu "IPv6: Netfilter Configuration
> (EXPERIMENTAL)".

Indeed menuconfig hides the new conntrack if old one is chosen,
as was my case.

Thanks!

--=20
  ++ytti

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEBzJeUz2yXMoHaDsRAi1eAJ9dPJGwwE2MuUwU3Mz08mGoqhv9TwCdGWZL
gpXrTCw+5ts31Za6HH7KKGk=
=Tnfc
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
