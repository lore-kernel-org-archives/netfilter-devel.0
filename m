From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: iptables not working on 2.6.16-rc1-mm2
Date: Wed, 25 Jan 2006 20:49:14 +0100
Message-ID: <20060125194914.GA7617@zion.homelinux.com>
References: <20060125193627.GA6967@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20060125193627.GA6967@zion.homelinux.com>
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


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Sorry to reply to my own post, but I found some lines in the logs:

Jan 25 20:16:54 zion kernel: iptables: loop hook 1 pos 0 00000022.
Jan 25 20:16:54 zion last message repeated 4 times
Jan 25 20:16:54 zion kernel: iptables: loop hook 0 pos 0 00000021.
Jan 25 20:16:55 zion kernel: iptables: loop hook 1 pos 0 00000022.
Jan 25 20:16:55 zion last message repeated 15 times


kind regards,

Sven

--=20
Linux zion.homelinux.com 2.6.16-rc1-mm2_25 #25 Wed Jan 25 18:23:52 CET 2006=
 i686 athlon i386 GNU/Linux
 20:47:12 up 32 min,  2 users,  load average: 0.06, 0.21, 0.24

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD19Y6o4FAdB2PneQRAnSxAJ9UxCociHdnwPDSQJvafLnGdJsgbQCfeWrX
PUEbMbWN7QVdRY/TLXbFe6s=
=Ht71
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
