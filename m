From: Harald Welte <laforge@netfilter.org>
Subject: Re: Re: READ_LOCK?
Date: Wed, 7 Jan 2004 14:16:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040107131612.GA6629@obroa-skai.de.gnumonks.org>
References: <E1Ae2YB-0006QS-JR@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhaoyao <zhaoyao@harbournetworks.com>
Content-Disposition: inline
In-Reply-To: <E1Ae2YB-0006QS-JR@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2004 at 09:27:14AM +0800, zhaoyao wrote:
> Harald Welte,??????
>=20
> Yes,as you know in 2.4 or 2.6, bh is similar to softirq,
> WRITE_LOCK is write_lock_bh(&a)
> if u write_lock_bh(&a), obviously other cpu can't enter this critical reg=
ion,

I don't really get your point.  bh is not really that similar to
softirq.  As stated before, their properties wrt. serialization are
quite different.  the term 'bh' in spin_lock_bh is only a legacy name.
In 2.6.x it mainly deals with disabling preemption.

> but already in softirq, why lock bh again. softirq can't reenter.
> so lock bh is not useful.

As indicated in my last email, I think you are misunderstanding the
kernel contexts.  the network rx softirq _will_ run simultaneously on
multiple cpu's.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE//AacXaXGVTD0i/8RArzTAJ4tgRiuve5WxPgiD6v7g0qvoaWnnACcDCi8
ZC5UuhikfOHxvNytew7ZUSU=
=3kqK
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
