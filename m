From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix correct_cache() in libiptc.c
Date: Sat, 5 Jul 2003 19:14:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030705171403.GG7073@sunbeam.de.gnumonks.org>
References: <1057411145.12437.128.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rVMVguMjBJz39qo3"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1057411145.12437.128.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rVMVguMjBJz39qo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 05, 2003 at 03:19:05PM +0200, Martin Josefsson wrote:
> Hi Harald,
>=20
> I got a report on irc that iptables -X didn't work like it used to.
> Seems related to your libiptc work... you touched it last, you get to
> check all new patches against it :)

Yes, as stated on the mailinglist, I even expect it to still be broken a
bit.

Expect it to break even more in the future, I'm currently working on an
almost total reimplementation of the whole library.   The ruleset load
time ist still unbearable.

> # ./iptables -N HELLO
> # ./iptables -N world
> # ./iptables -X
> Deleting chain: FORWARD
> Deleting chain: OUTPUT
> Deleting chain: HELLO
> #
>=20
> That's not right.

ouch. I didn't test chain deletion as well as insertion/creation.
Believe me, I was happy that something was working again at all ;)

> Ok this is weird.
>=20
> If you add more printf's you see that TC_DELETE_CHAIN() gets called for
> the HELLO chain and find_label() finds it and then delete_rules() is
> called. delete_rules() calls correct_cache() which thinks it should
> delete the chain called world instead.
> And then TC_DELETE_CHAIN() is called for the world chain and now
> cache_num_chains has been decremented by one so it doesn't find the
> world chain which is last.

well spotted.

> --- userspace/libiptc/libiptc.c.orig	2003-06-28 18:30:40.000000000 +0200
> +++ userspace/libiptc/libiptc.c	2003-07-04 22:15:54.000000000 +0200
> @@ -471,15 +471,15 @@
> =20
>  		if (delta < 0) {
>  			/* take care about deleted chains */
> -			if (cc->start_off >=3D offset+delta
> -			    && cc->end_off <=3D offset) {
> +			if (cc->start_off > offset
> +			    && cc->end_off < offset-delta) {
>  				/* this chain is within the deleted range,
>  				 * let's remove it from the cache */
>  				void *start;
>  				unsigned int size;
> =20
>  				h->cache_num_chains--;
> -				if (i+1 >=3D h->cache_num_chains)
> +				if (i =3D=3D h->cache_num_chains)
>  					continue;
>  				start =3D &h->cache_chain_heads[i+1];
>  				size =3D (h->cache_num_chains-i)
>=20
>=20
> Now it selects the correct chain to delete.
> And the off-by-one bug causes it to do nothing when it comes to the
> second-last chain which is wrong, it should do the memory-copies for all
> deleted chains except when it's the last chain that's beeing deleted.

true.

> I'm not sure if my new limits in the first if-statement are 100%
> correct. I don't know the code that well, and honestly I never want to,
> I got enough exposure for several lifetimes last night. The code is
> absolutely horrible...

*agreed*.  I vote for presenting Rusty with an award for obfuscated code
at the workshop ;) =20

> I have one more thing I want you to look at, once again in
> correct_cache()...
>=20
>                 if (cc->start_off > offset)
>                         cc->start_off +=3D delta;
>=20
>                 if (cc->end_off >=3D offset)
>                         cc->end_off +=3D delta;
>=20
> Shouldn't that really be moved up into the part where chains are deleted
> and turned into an unconditional loop that adds delta (which is
> negative) for all moved chains? What if several chains are deleted at
> once? Currently that isn't done but correct_cache() implies that it
> supports it because it doesn't stop looking for deleted chains after the
> first one is found.

Oh well, I undestand.  This was a mistake.  correct_cache() was first
written for inserting entries, and the additional code part for rule
deletion turns out to be broken in several ways.

I'm going to apply your patch now, and then deal with this issue.

Let's hope this is the last thing I have to do in the old libiptc.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rVMVguMjBJz39qo3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/BwdbXaXGVTD0i/8RAqtoAJ4rFKWAYi9DqXV7w3+o0nukrBdIawCeJxVD
0DiCwit23TRqR5Fqe1nVZEs=
=Wcrt
-----END PGP SIGNATURE-----

--rVMVguMjBJz39qo3--
