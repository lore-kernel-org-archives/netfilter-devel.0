From: Harald Welte <laforge@netfilter.org>
Subject: Re: ipt_ulog.h versus ebt_ulog.h
Date: Fri, 21 Oct 2005 14:42:23 +0200
Message-ID: <20051021124223.GR27778@sunbeam.de.gnumonks.org>
References: <dj519g$ke6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ngshnjhd05HsCES+"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <dj519g$ke6$1@sea.gmane.org>
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


--ngshnjhd05HsCES+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 19, 2005 at 09:49:01AM +0100, Amin Azez wrote:
> Is there a strong reason why ebt_ulog.h log structure has
>=20
>        char physindev[IFNAMSIZ];
>        char physoutdev[IFNAMSIZ];
>=20
> and ipt_ulog.h structure does not support physdev?

it's historical, and we can't change it without hurting compatibility.

Since with 2.6.14, both ebt_ulog and ipt_ULOG are deprecated by
nfnetlink_log, I don't think it's worth fixing this up.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ngshnjhd05HsCES+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDWOIvXaXGVTD0i/8RAuQ1AJ4j9bqz6BXMhRq8rlLRSZL509f8sQCcDuQk
LNiGsv/z7gqhNp4IoTHCLrQ=
=2Mxd
-----END PGP SIGNATURE-----

--ngshnjhd05HsCES+--
