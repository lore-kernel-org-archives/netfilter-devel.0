From: Harald Welte <laforge@gnumonks.org>
Subject: Re: libipulog comments
Date: Sat, 11 Jan 2003 20:55:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030111195512.GG24488@naboo.de.gnumonks.org>
References: <3E193700.5040003@fokus.gmd.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Cc: ulogd@lists.gnumonks.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sebastian Zander <zander@fokus.gmd.de>
Content-Disposition: inline
In-Reply-To: <3E193700.5040003@fokus.gmd.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 08:57:52AM +0100, Sebastian Zander wrote:
> Hi Harald,
>=20
> I have a some suggestions and a possible bug for libipulog.
>=20
> 1) Could you make ipulog_strerror() non-static so someone else
>    can use it? iptc_sterror is also non-static AFAIK.

Oh, it seems like you are using some very old version of libipulog.
I'm sorry, I should never have put it into the 'iptables' package in the
first place.

Please see the 'ulogd' package for the latest version of libipulog
(http://www.gnumonks.org/projects/ulogd) and:

cvs :pserver:cvs@cvs.gnumonks.org:/cvsroot ulogd

> 2) It would be cool if there is the option of setting the socket
>    receive buffer to a higher value than default because for high
>    speeds the default value is too small. I have a patch for an old
>    libipulog and can send it to you if you think this could go in.

yes, this is definitely a good idea. Please see if your patch applies to
the later libipulog versions (see above).

> 3) I think there is a bug in libipulog as in iptables 1.2.7a in the
>    ipulog_get_packet() function. The function seems to not always return
>    NULL when its supposed to do. I made a patch ages ago and thought
>    this was fixed but when I tried the new version it did not work.
>    I think the problem was when you have multi and non-multi messages.
>    But have a look at the patch.

It was fixed, but as stated, unfortunately there was an old libipulog in
the iptables package.

I will remove it from the upcoming iptables-1.2.8 version.

> Thanx for your time.

Thanks for your contributions.

> Cheers,
> Sebastian

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+IHagXaXGVTD0i/8RAv53AJ9jnKxStNxLBv2b5nkRBCp7+g3uLwCfdt5r
AC3ssjSl+uxoltXpAune5Qg=
=tjpF
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
