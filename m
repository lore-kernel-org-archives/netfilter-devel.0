From: Harald Welte <laforge@netfilter.org>
Subject: Re: READ_LOCK?
Date: Tue, 6 Jan 2004 20:09:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040106190908.GE934@obroa-skai.de.gnumonks.org>
References: <E1Ad25t-00083p-3R@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhaoyao <zhaoyao@harbournetworks.com>
Content-Disposition: inline
In-Reply-To: <E1Ad25t-00083p-3R@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2004 at 02:53:03PM +0800, zhaoyao wrote:
> netfilter-devel,hello!
> In init_conntrack, why will READ_LOCK or WRITE_LOCK, we'are already in
> bh, why lock it again?

ip_conntrack is part of netfilter, which in turn is part of the 2.4.x
and 2.6.x kernel.  Both 2.4 and 2.6 kernel series don't have a 'bottom
half' for the network stack anymore.  Instead, softirq's are used.
Softirq's are fully parallelized, i.e. they can run on any number of
cpu's simultaneously.

> ????????????????????2004-01-04

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+wfUXaXGVTD0i/8RAubgAJ9necTbIg0ZP83Sl8CaEzrKGMbgewCgqIfe
3jSItYEUm8aI7VAOlX6kHXs=
=Aqcg
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
