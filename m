From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] iptables segfault on -D
Date: Fri, 04 Feb 2005 08:36:32 +0100
Message-ID: <1107502592.1111.1.camel@tux.rsn.bth.se>
References: <20050204005537.GA25682@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Nj5o0XiNoVO4prqASBkV"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050204005537.GA25682@linuxace.com>
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


--=-Nj5o0XiNoVO4prqASBkV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-02-03 at 16:55 -0800, Phil Oester wrote:
> Using latest 1.3.0-rc1 snapshot, a rule delete causes a segfault:
>=20
> # iptables -A foo -p tcp --dport 1234  =20
> # iptables -D foo -p tcp --dport 1234
> Segmentation fault
>=20
> Problem is caused by a superfluous memset which memsets a greater-
> than-malloced area.  Patch below.

Yes this memset() is bogus, patch applied. And I removed the other
memset() that was added at the same time in order to stop valgrind from
complaining, that needs more investigation as to why valgrind is
complaining.

Thanks

--=20
/Martin

--=-Nj5o0XiNoVO4prqASBkV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCAyYAWm2vlfa207ERAilbAKCmmk/RBm5SJYg+wgkLJqfC6nyAmwCgkbyi
gKP1GeIrDdy8wWj8vb8TrtU=
=V2ya
-----END PGP SIGNATURE-----

--=-Nj5o0XiNoVO4prqASBkV--
