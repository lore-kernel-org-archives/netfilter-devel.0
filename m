From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Sun, 23 May 2004 10:55:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085302540.969.51.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0405211416341.8045-100000@blackhole.kfki.hu>
	 <40AF6A60.70406@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EaxZoojb8l1LNA7yvzhA"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Philip Craig <philipc@snapgear.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40AF6A60.70406@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-EaxZoojb8l1LNA7yvzhA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-05-22 at 16:57, Patrick McHardy wrote:

> But good news, I'm currently busy shrinking struct ip_conntrack (I bet
> myself I could shrink it 30% within 24 hours). I'm already at 28% ;)
>=20
> -8bytes replacing struct ip_nat_hash by struct list_head because of two
> saved conntrack pointers
> -20bytes replacing struct nf_ct_info array by new value in struct
> sk_buff indicating relation between skb and conntrack .. maybe we could
> also put this in nfcache.
> -56bytes dynamically allocating helper data, but crashes with NAT atm
>=20
> I see 4 more bytes by using u_int16_t for initialized and num_manips in
> struct ip_nat_info, and maybe I can also squeeze masq_index in there.

Nice, I hope you succeed. We also need to rearrange struct ip_conntrack
so often updated fields aren't sharing the same cacheline as mostly read
fields. That and adding more test_bit() before we set_bit() (or
something similar) will bring down the cache-trashing we have right now,
especially on SMP.

--=20
/Martin

--=-EaxZoojb8l1LNA7yvzhA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAsGcMWm2vlfa207ERAnUUAJwL6TOD41vORrjjFbU9br7dn60lIACgnFMb
6XQ9spqFrZHJ83nik8OBs78=
=a2h2
-----END PGP SIGNATURE-----

--=-EaxZoojb8l1LNA7yvzhA--
