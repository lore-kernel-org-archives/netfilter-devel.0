From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptable_nat module slows/hoses my Redhat 9.0 box
Date: Sat, 13 Dec 2003 09:47:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031213084713.GD8950@obroa-skai.de.gnumonks.org>
References: <EFBADA8C200C2B418DA39734FD15475B0B20F1@skat.sky.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Cc: 'Jan Kaastrup' <jka@protego.dk>, netfilter@lists.netfilter.org,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>
Content-Disposition: inline
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B20F1@skat.sky.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2003 at 02:53:19PM -0800, Kishore Dharmavaram wrote:
> Hello Jan & All,
>=20
> Yes I want to do that for UDP & ICMP, can you tellme how to remove statef=
ul
> inspection(connection tracking) for just ICMP and UDP protocols without
> removing NAT on ICMP and UDP packets.

since the netfilter/iptables NAT implementation is fully dynamic
stateful NAT, you cannot use any of our nat features without connection
tracking.

It is also not possible to do NAT in a safe way, if connection tracking
applies only to certain packets.  Because unless we lookup a connection
tracking entry, we don't know which NAT bindings to apply to the
particular packet.

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

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2tIRXaXGVTD0i/8RAgSNAKCftIIEema/QNw7NnVNo5sUxvfn/QCgjbEn
k98SJOnojnamabWLZL0ZhRk=
=xey6
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
