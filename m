From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [Fwd: Question with printk warnings in ip_conntrack with 2.4.20.]
Date: Thu, 5 Dec 2002 21:07:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205200756.GB11068@naboo.club.berlin.ccc.de>
References: <1038618763.22065.1.camel@rth.ninka.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Cc: netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jpiszcz <jpiszcz@lucidpixels.com>
Content-Disposition: inline
In-Reply-To: <1038618763.22065.1.camel@rth.ninka.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Nov 29 03:29:26 lucidpixels kernel: ip_conntrack: max number of expected=
=20
> connections 1 of ftp reached for 192.168.xxx.xxx->129.128.5.191, reusing
> Nov 29 03:29:30 lucidpixels kernel: ip_conntrack: max number of expected=
=20
> connections 1 of ftp reached for 192.168.xxx.xxx->129.132.7.170, reusing
> Nov 29 03:29:36 lucidpixels kernel: ip_conntrack: max number of expected=
=20
> connections 1 of ftp reached for 192.168.xxx.xxx->195.113.31.123, reusing
>=20
> These fill up my logs (kern.info) which I use for logging iptables=20
> blocked packets.

the issue is that somebody is doing something very strange to your ftp
server.  Inside an FTP session, there's always only one expectation,
since there is only one unestablished data session per control session
at any given point in time.

> Is there anyway to turn this feature off dynamically or should one just=
=20
> comment out line #970 in=20
> /usr/src/linux/net/ipv4/netfilter/ip_conntrack_core.c ?

feel free to remove the comment.  but in normal ftp protocol behaviour,
the lines above should never be printed.

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

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977IcXaXGVTD0i/8RAtvtAJ9nLCvbzdrkrNaIRldtBNqwVA8NygCfSKbX
iM8HHSXBZptNcwpsw/EAUMc=
=edML
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
