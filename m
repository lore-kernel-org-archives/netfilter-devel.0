From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ICMP reject types?
Date: Wed, 2 Oct 2002 15:47:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021002154706.E13233@sunbeam.de.gnumonks.org>
References: <20021001100755.GC5609@aba.krakow.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pawe? Krawczyk <kravietz@aba.krakow.pl>
Content-Disposition: inline
In-Reply-To: <20021001100755.GC5609@aba.krakow.pl>; from kravietz@aba.krakow.pl on Tue, Oct 01, 2002 at 12:07:55PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2002 at 12:07:55PM +0200, Pawe? Krawczyk wrote:
> Maybe it's my ignorance, but I feel that REJECT target --reject-with
> option is somewhat broken - you can set icmp-net-prohibited or
> host-prohibited ICMP replies, which are discouraged and obsoleted by RFC
> 1812, but you cannot use 0/13 ICMP (Admin prohibited), which is the one
> recommended by the RFC. Can anyone comment?

please read the list archives.  The problem is that adding a new different
REJECT type is hurting binary compatibility between new iptables userspace
command and old kernel.

> Pawe? Krawczyk, Krak=F3w, Poland  http://echelon.pl/kravietz/

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mvjaXaXGVTD0i/8RAmgZAJwMj3MF1kW34RrQdrLO4ytbOFXQBwCbBw0V
Xdb7sM4ts0Rb2kqGEKC8phY=
=Ucqy
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
