From: Harald Welte <laforge@netfilter.org>
Subject: Re: problems with libnetfilter_conntrack / cntl_test
Date: Thu, 17 Nov 2005 13:49:09 +0100
Message-ID: <20051117124909.GA14201@sunbeam.de.gnumonks.org>
References: <200511161439.04498.pluto@agmk.net>
	<200511161809.25277.pluto@agmk.net> <437BDF1B.1050107@eurodev.net>
	<200511170421.43664.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Content-Disposition: inline
In-Reply-To: <200511170421.43664.pluto@agmk.net>
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


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17, 2005 at 04:21:43AM +0100, Pawe=C5=82 Sikora wrote:

> sorry for the noise, /me is brainless :)
> `modprobe ip_conntrack_netlink` solved problem.

the autoloading of ip_conntrack_netlink was only introduced in the
2.6.15 series.  2.6.14[.y] doesn't have it, sorry.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDfHxFXaXGVTD0i/8RAoI/AJ9H9RTJyXkmInEXouPF9G++bhWcqwCgrMZg
fTDq/qnyqXoJDTV1Zb9n4Fk=
=mZ72
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
