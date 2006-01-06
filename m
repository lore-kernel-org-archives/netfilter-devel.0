From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] nfsim: Support more netfilter modules
Date: Fri, 6 Jan 2006 15:40:48 +0100
Message-ID: <20060106144048.GE4898@sunbeam.de.gnumonks.org>
References: <439ED1C5.7070103@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ttstOt8yZ7/btESf"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <439ED1C5.7070103@ingate.com>
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


--ttstOt8yZ7/btESf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2005 at 02:51:01PM +0100, Marcus Sundberg wrote:
> Hi,
>=20
> this patch adds nfsim support for building most of the netfilter stuff
> in 2.6.15. The things still not compiling are CONFIG_IP_NF_CONNTRACK_NETL=
INK
> and CONFIG_IP_NF_MATCH_STRING

thanks, applied.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ttstOt8yZ7/btESf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD4DBQFDvoFwXaXGVTD0i/8RAqy4AJd32j2ZUxgWN7byP8k3RdF9Zwu3AJ908TIO
41UsSHgzaX9CFi4lQEVAeA==
=HUyB
-----END PGP SIGNATURE-----

--ttstOt8yZ7/btESf--
