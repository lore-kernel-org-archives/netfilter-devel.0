From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] for several issues
Date: Sat, 27 Mar 2004 23:38:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1080427101.26265.30.camel@tux.rsn.bth.se>
References: <405992CD.1040707@eurodev.net>
	 <20040327211205.GB26945@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y5VNxki+9Tb5KIZicaP/"
Cc: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040327211205.GB26945@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Y5VNxki+9Tb5KIZicaP/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-03-27 at 22:12, Harald Welte wrote:

> > c) ip_ct_refresh lock issue. The conntrack table is write_lock'ed to=20
> > refresh a non-confirmed conntrack but this is not needed since it's not=
=20
> > inserted yet, so I consider that this lock is not needed. Actually=20
> > playing with nfsim tells me that this condition only happens when a new=
=20
> > conntrack is created, and this conntrack is not inserted yet.
>=20
> Yes.  But isn't this optimization based on the assumption that
> 'is_confirmed()' is an atomic operation?  What if it gets confirmed on a
> second cpu, after is_confirmed() was called and before we refresh?
>=20
> Am I missing something?

How did the second cpu get hold of our connection-entry that hasn't been
inserted into the hashtable yet? :)

I have a patch that makes ip_ct_refresh() lockfree. I just need to
SMP-test it a bit more before I post it. It gives a fairly large
performance increase even on UP kernels since it removes the call to
local_bh_enable().
And on SMP it sort of removes the only real serializing we have in
conntrack for packets belonging to an existing connection. (we should go
with something like the timer-handling patch Patrick Schaaf posted a
long time ago (Subject: [PATCH][WORKSFORME] make add_timer rare) but
this simple patch is a good first start)

> You seem to be digging quite deep into the internals of
> netfilter/iptables/ip_conntrack.  That's very welcome, we always need
> more people who understand the complex code.  Would be nice to receive
> more of your insights and optimizations.

Yes we certainly do.

--=20
/Martin

--=-Y5VNxki+9Tb5KIZicaP/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAZgJdWm2vlfa207ERAuGuAKC6ABd5cZsXyQWJy8wJfcjp2rlCgwCeJqTA
8C1N2zwEsjd7ex9p1teArBw=
=4+1L
-----END PGP SIGNATURE-----

--=-Y5VNxki+9Tb5KIZicaP/--
