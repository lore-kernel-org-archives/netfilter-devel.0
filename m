From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptable_nat module slows/hoses my Redhat 9.0 box
Date: Fri, 12 Dec 2003 08:13:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031212071301.GP15606@sunbeam.de.gnumonks.org>
References: <EFBADA8C200C2B418DA39734FD15475B0B20EF@skat.sky.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UeXZ3FjlYZvuln/G"
Cc: "'netfilter@lists.netfilter.org'" <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>
Content-Disposition: inline
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B20EF@skat.sky.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UeXZ3FjlYZvuln/G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2003 at 09:47:25PM -0800, Kishore Dharmavaram wrote:
> Hi All,
>=20
> I find that after inserting "iptable_nat" module on my RH9.0(2.4.20-19.9)
> box, session-setup(ip_conntrack)  performance gets very bad.=20

yes, that's true.  I think we cannot state often enogh: DO NOT load
iptable_nat if you don't need nat. =20

> I am wondering why "iptable_nat" is slowing doing the box so much when I
> don't have any NAT rules defined.

NAT is inherently complex.  and in order to support any kind of nat,
every connection (even the non-nat'ed ones) need to be placed in two
additional hash tables. =20

If you just use conntrack, a single hash table is sufficient..=20

> Do you guys know of any netfilter patches made to address/fix this issue?.

There is no way to 'address' this issue other than not using NAT.

> Thanks,
> Kishore

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UeXZ3FjlYZvuln/G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2Wp9XaXGVTD0i/8RAiHDAJwNEXdKKKh1I32f/lhB+yyloYzg4QCeJTBW
RrxugLK0LDm8InSC15ZKsKY=
=aZRa
-----END PGP SIGNATURE-----

--UeXZ3FjlYZvuln/G--
