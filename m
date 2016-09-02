From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another
 memory barrier
Date: Fri, 2 Sep 2016 14:17:50 +0800
Message-ID: <20160902061750.GE28226@tardis.cn.ibm.com>
References: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
 <20160901153039.GN6721@arm.com>
 <20160901164126.GZ10153@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Cc: Will Deacon <will.deacon@arm.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160901164126.GZ10153@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Manfred,

On Thu, Sep 01, 2016 at 06:41:26PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 01, 2016 at 04:30:39PM +0100, Will Deacon wrote:
> > On Thu, Sep 01, 2016 at 05:27:52PM +0200, Manfred Spraul wrote:
> > > Since spin_unlock_wait() is defined as equivalent to spin_lock();
> > > spin_unlock(), the memory barrier before spin_unlock_wait() is
> > > also not required.
>=20

As Peter said below, ACQUIRE+RELEASE is not a barrier.

What we rely here is that spin_unlock_wait() could pair with another
LOCK or UNLOCK(as spin_unlock_wait() acts as spin_lock();
spin_unlock()). And once paired, we could have the necessary order
guarantee between the code preceding or following unlock_wait() and the
code in the lock critical sections.

Regards,
Boqun

> Note that ACQUIRE+RELEASE isn't a barrier.
>=20
> Both are semi-permeable and things can cross in the middle, like:
>=20
>=20
> 	x =3D 1;
> 	LOCK
> 	UNLOCK
> 	r =3D y;
>=20
> can (validly) get re-ordered like:
>=20
> 	LOCK
> 	r =3D y;
> 	x =3D 1;
> 	UNLOCK
>=20
> So if you want things ordered, as I think you do, I think the smp_mb()
> is still needed.
>=20
> RELEASE + ACQUIRE otoh, that is a load-store barrier (but not
> transitive).

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXyRmKAAoJEEl56MO1B/q4OuUH/3nz/rabC8YMrdXsw8hWM5GE
/dIkgghh1w18nq8I5NG3EmJnFbita+/FG34hR9gMCMrQSol/4NZn+uyx6lC9PUJG
5PzwqYmCkdMXONBWkcOJGe6haad7czE53niLVn0U2OaIOmjnne8zPqSAdB3L/iC6
FvKc7zQta5ji7RDkVFilFuasmBqEcNR1LDrWeJoyqrVpwAKWh3mP+nx+pqgB51lZ
JgQ0CVCNX7pDuaT6EG9Hj9GqHCKwf99Xq7pNuPI06fNfqv0eyvd2/xZdVFRQKl5G
F/XK90yIDdirjF/9XWRxH0it6CmX6I8xN3heWH/ESy/PqDZ8UJPUq7iZ3gyWvWg=
=morP
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
