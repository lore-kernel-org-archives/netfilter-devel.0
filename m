From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] ip_ct_refresh_optimization.patch
Date: 14 Sep 2002 15:34:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032010466.29595.120.camel@tux>
References: <vebs73bnx1.fsf@inigo.ingate.se>
	<1031835954.28101.82.camel@tux>  <velm64u40t.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-S4/bkPisJ1HWRwoNi7pi"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <velm64u40t.fsf@inigo.ingate.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-S4/bkPisJ1HWRwoNi7pi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2002-09-14 at 14:52, Marcus Sundberg wrote:
> Martin Josefsson <gandalf@wlug.westbo.se> writes:
>=20
> > Yes I know it's broken, I do have a newer version but I havn't committe=
d
> > it to cvs. I think Patrick Shaaf's solution is a better one and we
> > should probably go with something like that.
>=20
> Probably yes, but that's no reason to have a completely broken patch
> which can be fixed by a one-liner in CVS. It should IMHO either be
> fixed or removed asap.

I agree, honestly I had almost forgotten that these patches were in cvs
until I read your mail :)
I've committed your patch now. Thanks.

> That patch is also incorrect, but it works because it updates to
> often, not to seldom. If the new timeout is one jiffie earlier than
> the previous timeout your expression will evaluate to 0xffffffff
> and thus update the timer even though there's no need. The cast
> is useless btw, because all operands, and thus the result also, are
> already unsigned long.

I know it will update too often. And about the "bogus" cast, I usually
like explicit casts like that when I think it helps codereadabilty.

As a fun thing you can add a printk() in ip_ct_refesh() and compare the
results without this timer-optimization and with it. I did that when I
first looked at this, it was quite horrible to see a timer get deleted
and a new added with the exact same timeout over and over again.

Have you performed any benchmarks/profiles with and without this
optimization?

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-S4/bkPisJ1HWRwoNi7pi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA9gzrhWm2vlfa207ERAkgpAKCLgWi5IHG84FRBVd3lZCg3zHN2WACffXHj
U6Jxfxmha3h9N4BRA7aeox8=
=lJBa
-----END PGP SIGNATURE-----

--=-S4/bkPisJ1HWRwoNi7pi--
