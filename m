From: Harald Welte <laforge@netfilter.org>
Subject: Re: ICMP DNAT bug fix no longer applies?
Date: Sun, 27 Apr 2003 15:21:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427132129.GO990@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0304241412470.24242-100000@localhost> <Pine.LNX.4.44.0304241539121.12543-100000@deneb.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+0pH9m6FYzpAKDUB"
Cc: Chris Wilson <chris@netservers.co.uk>,
	netfilter-devel@lists.netfilter.org,
	John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philippe Biondi <biondi@cartel-securite.fr>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304241539121.12543-100000@deneb.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+0pH9m6FYzpAKDUB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 03:42:11PM +0200, Philippe Biondi wrote:
> AFAIK, this patch was too intrusive into the IP layer of the linux kernel
> to be included.

yup.

> But I've seen this some times ago :
>=20
> Summary of changes from v2.4.21-pre5 to v2.4.21-pre6
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> [...]
>=20
> <laforge@netfilter.org>:
>   o [NETFILTER]: fix NAT ICMP reply translation of inner packet
> [...]
>=20
>=20
> I see that as the so long waited fix. Harald, do you confirm that ?

It is a fix two two or more related ICMP bugs.  And it should also fix
the old DNAT information leak.

Would be happy if anyboudy could explicitly test and verify that.

> Philippe Biondi <biondi@ cartel-securite.fr> Cartel S=E9curit=E9

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+0pH9m6FYzpAKDUB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9lZXaXGVTD0i/8RAi5lAJ4twSZ3A+y0vKPSeqhGyXxLHNeXwQCgs1c4
7BNyIjn8Xdfgk0YLi31mrW8=
=iyDn
-----END PGP SIGNATURE-----

--+0pH9m6FYzpAKDUB--
