From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Logging conntrack with ip_conntrack_destroyed
Date: Wed, 11 Jun 2003 13:52:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611115259.GF32593@sunbeam.de.gnumonks.org>
References: <20020813042705.13302.51547.Mailman@kashyyyk> <000901c32a6e$e7683040$010f430a@elitecore7>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
Content-Disposition: inline
In-Reply-To: <000901c32a6e$e7683040$010f430a@elitecore7>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2003 at 01:27:11PM +0530, Sumit Pandya wrote:
> Hi All,
>     I written a kernel module which registers hook for
> ip_conntrack_destroyed. Purpose of this module is to log finish connection
> as opposed to logging every packet of a connection provided by presently
> netfilter targets (U)LOG. The module causes kernel __OOPS__ while it issu=
es
> fileP->f_op->write. I'm using kernel 2.4.20 from kernel.org.

maybe you should accompany the sourcecode of your ipt_CONNLOG module in
order to enable us to respond in any qualified manner?

> -- Sumit

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+5xgaXaXGVTD0i/8RAuZoAJ42c5aY2FbEt5PP55U5+A1Xnnr6UQCeMz+k
DZ2L1p+mI8OHqstbTOLp5S4=
=iFxz
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
