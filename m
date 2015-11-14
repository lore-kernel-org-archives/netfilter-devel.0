From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH -stable,3.4.y] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get
Date: Sat, 14 Nov 2015 17:30:19 +0000
Message-ID: <1447522219.17039.6.camel@decadent.org.uk>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
	 <1446813886-5632-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VfP/pSm/8F2VBB5XlofZ"
Cc: stable@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Cyrill Gorcunov <gorcunov@openvz.org>,
	Ani Sinha <ani@arista.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1446813886-5632-3-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--=-VfP/pSm/8F2VBB5XlofZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-11-06 at 13:44 +0100, Pablo Neira Ayuso wrote:
> From: Andrey Vagin <avagin@openvz.org>
>=20
> [ upstream commit 6aec24dfd7548dba0134f60f28f58580f07c540b ]

The correct commit hash is=C2=A0c6825c0976fa7893692e0e43b09740b419b23c09.

This was applied upstream in 3.14 and also in the 3.12-longterm branch,
but no others. =C2=A0If it's applicable to 3.4 then it should also be
applicable to 3.10, right?

It also seems to be applicable to 3.2, and even to 2.6.32 (but without
the comparison of zones).

Ben.

> Lets look at destroy_conntrack:
>=20
> hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
> ...
> nf_conntrack_free(ct)
> 	> kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
>=20
> net->ct.nf_conntrack_cachep is created with SLAB_DESTROY_BY_RCU.
>=20
> The hash is protected by rcu, so readers look up conntracks without
> locks.
> A conntrack is removed from the hash, but in this moment a few readers
> still can use the conntrack. Then this conntrack is released and another
> thread creates conntrack with the same address and the equal tuple.
> After this a reader starts to validate the conntrack:
> * It's not dying, because a new conntrack was created
> * nf_ct_tuple_equal() returns true.
>=20
> But this conntrack is not initialized yet, so it can not be used by two
> threads concurrently. In this case BUG_ON may be triggered from
> nf_nat_setup_info().
>=20
> Florian Westphal suggested to check the confirm bit too. I think it's
> right.
>=20
> task 1> 	> 	> 	> task 2> 	> 	> 	> task 3
> 	> 	> 	> nf_conntrack_find_get
> 	> 	> 	> =C2=A0____nf_conntrack_find
> destroy_conntrack
> =C2=A0hlist_nulls_del_rcu
> =C2=A0nf_conntrack_free
> =C2=A0kmem_cache_free
> 	> 	> 	> 	> 	> 	> __nf_conntrack_alloc
> 	> 	> 	> 	> 	> 	> =C2=A0kmem_cache_alloc
> 	> 	> 	> 	> 	> 	> =C2=A0memset(&ct->tuplehash[IP_CT_DIR_MAX],
> 	> 	> 	> =C2=A0if (nf_ct_is_dying(ct))
> 	> 	> 	> =C2=A0if (!nf_ct_tuple_equal()
>=20
> I'm not sure, that I have ever seen this race condition in a real life.
> Currently we are investigating a bug, which is reproduced on a few nodes.
> In our case one conntrack is initialized from a few tasks concurrently,
> we don't have any other explanation for this.
>=20
> <2>[46267.083061] kernel BUG at net/ipv4/netfilter/nf_nat_core.c:322!
> ...
> <4>[46267.083951] RIP: 0010:[]=C2=A0=C2=A0[] nf_nat_setup_info+0x564/0x59=
0 [nf_nat]
> ...
> <4>[46267.085549] Call Trace:
> <4>[46267.085622]=C2=A0=C2=A0[] alloc_null_binding+0x5b/0xa0 [iptable_nat=
]
> <4>[46267.085697]=C2=A0=C2=A0[] nf_nat_rule_find+0x5c/0x80 [iptable_nat]
> <4>[46267.085770]=C2=A0=C2=A0[] nf_nat_fn+0x111/0x260 [iptable_nat]
> <4>[46267.085843]=C2=A0=C2=A0[] nf_nat_out+0x48/0xd0 [iptable_nat]
> <4>[46267.085919]=C2=A0=C2=A0[] nf_iterate+0x69/0xb0
> <4>[46267.085991]=C2=A0=C2=A0[] ? ip_finish_output+0x0/0x2f0
> <4>[46267.086063]=C2=A0=C2=A0[] nf_hook_slow+0x74/0x110
> <4>[46267.086133]=C2=A0=C2=A0[] ? ip_finish_output+0x0/0x2f0
> <4>[46267.086207]=C2=A0=C2=A0[] ? dst_output+0x0/0x20
> <4>[46267.086277]=C2=A0=C2=A0[] ip_output+0xa4/0xc0
> <4>[46267.086346]=C2=A0=C2=A0[] raw_sendmsg+0x8b4/0x910
> <4>[46267.086419]=C2=A0=C2=A0[] inet_sendmsg+0x4a/0xb0
> <4>[46267.086491]=C2=A0=C2=A0[] ? sock_update_classid+0x3a/0x50
> <4>[46267.086562]=C2=A0=C2=A0[] sock_sendmsg+0x117/0x140
> <4>[46267.086638]=C2=A0=C2=A0[] ? _spin_unlock_bh+0x1b/0x20
> <4>[46267.086712]=C2=A0=C2=A0[] ? autoremove_wake_function+0x0/0x40
> <4>[46267.086785]=C2=A0=C2=A0[] ? do_ip_setsockopt+0x90/0xd80
> <4>[46267.086858]=C2=A0=C2=A0[] ? call_function_interrupt+0xe/0x20
> <4>[46267.086936]=C2=A0=C2=A0[] ? ub_slab_ptr+0x20/0x90
> <4>[46267.087006]=C2=A0=C2=A0[] ? ub_slab_ptr+0x20/0x90
> <4>[46267.087081]=C2=A0=C2=A0[] ? kmem_cache_alloc+0xd8/0x1e0
> <4>[46267.087151]=C2=A0=C2=A0[] sys_sendto+0x139/0x190
> <4>[46267.087229]=C2=A0=C2=A0[] ? sock_setsockopt+0x16d/0x6f0
> <4>[46267.087303]=C2=A0=C2=A0[] ? audit_syscall_entry+0x1d7/0x200
> <4>[46267.087378]=C2=A0=C2=A0[] ? __audit_syscall_exit+0x265/0x290
> <4>[46267.087454]=C2=A0=C2=A0[] ? compat_sys_setsockopt+0x75/0x210
> <4>[46267.087531]=C2=A0=C2=A0[] compat_sys_socketcall+0x13f/0x210
> <4>[46267.087607]=C2=A0=C2=A0[] ia32_sysret+0x0/0x5
> <4>[46267.087676] Code: 91 20 e2 01 75 29 48 89 de 4c 89 f7 e8 56 fa ff f=
f 85 c0 0f 84 68 fc ff ff 0f b6 4d c6 41 8b 45 00 e9 4d fb ff ff e8 7c 19 e=
9 e0 <0f> 0b eb fe f6 05 17 91 20 e2 80 74 ce 80 3d 5f 2e 00 00 00 74
> <1>[46267.088023] RIP=C2=A0=C2=A0[] nf_nat_setup_info+0x564/0x590
>=20
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Ani Sinha <ani@arista.com>
> Tested-by: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
> ---
> =C2=A0net/netfilter/nf_conntrack_core.c | 21 +++++++++++++++++----
> =C2=A01 file changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
> index 9a171b2..71935fc 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -309,6 +309,21 @@ static void death_by_timeout(unsigned long ul_conntr=
ack)
> =C2=A0> 	> nf_ct_put(ct);
> =C2=A0}
> =C2=A0
> +static inline bool
> +nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
> +> 	> 	> 	> const struct nf_conntrack_tuple *tuple,
> +> 	> 	> 	> u16 zone)
> +{
> +> 	> struct nf_conn *ct =3D nf_ct_tuplehash_to_ctrack(h);
> +
> +> 	> /* A conntrack can be recreated with the equal tuple,
> +> 	> =C2=A0* so we need to check that the conntrack is confirmed
> +> 	> =C2=A0*/
> +> 	> return nf_ct_tuple_equal(tuple, &h->tuple) &&
> +> 	> 	> nf_ct_zone(ct) =3D=3D zone &&
> +> 	> 	> nf_ct_is_confirmed(ct);
> +}
> +
> =C2=A0/*
> =C2=A0 * Warning :
> =C2=A0 * - Caller must take a reference on returned object
> @@ -330,8 +345,7 @@ ____nf_conntrack_find(struct net *net, u16 zone,
> =C2=A0> 	> local_bh_disable();
> =C2=A0begin:
> =C2=A0> 	> hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[bucket], hn=
node) {
> -> 	> 	> if (nf_ct_tuple_equal(tuple, &h->tuple) &&
> -> 	> 	> =C2=A0=C2=A0=C2=A0=C2=A0nf_ct_zone(nf_ct_tuplehash_to_ctrack(h))=
 =3D=3D zone) {
> +> 	> 	> if (nf_ct_key_equal(h, tuple, zone)) {
> =C2=A0> 	> 	> 	> NF_CT_STAT_INC(net, found);
> =C2=A0> 	> 	> 	> local_bh_enable();
> =C2=A0> 	> 	> 	> return h;
> @@ -378,8 +392,7 @@ begin:
> =C2=A0> 	> 	> 	> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!atomic_inc_not_zero(&ct->=
ct_general.use)))
> =C2=A0> 	> 	> 	> h =3D NULL;
> =C2=A0> 	> 	> else {
> -> 	> 	> 	> if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple) ||
> -> 	> 	> 	> 	> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0nf_ct_zone(ct) !=3D zone)) {
> +> 	> 	> 	> if (unlikely(!nf_ct_key_equal(h, tuple, zone))) {
> =C2=A0> 	> 	> 	> 	> nf_ct_put(ct);
> =C2=A0> 	> 	> 	> 	> goto begin;
> =C2=A0> 	> 	> 	> }
--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n
--=-VfP/pSm/8F2VBB5XlofZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVkdvq+e/yOyVhhEJAQoytQ//cI8K/Nelwj/6TOi+S4AGSUJQhsj4Igk6
7uUxfNQCfv8B/09mnEbpjaG3SfsgWkUSuQuUuIqih58syoMTM9ljR8zOEpSbpyJS
H2Iu4FvIfsBzUNVVrIhJRDwW5XIll0wmvcL7xAs01eOe7u1OJ05IFiEqbdRlPF9+
5GkbKw+dwbGMcikkcmNO1ZsEQqTo3IVDmZnLeN/sK3CmrivmVj7S0lgZ/+gnh/NN
RB9Uw+9RtMuF3C9TLBvaTg0NoXJWrHoxZzX6Fbc/i8pgYmUvXPWtXC6MNVcxQXt2
1zH5Mkk83si6xXNoyd9HNO3mp+GfuF2wNcXA2onsRBGEqC3DDBm4VNnjtS+oJ587
xDMrDxh6D4htyWls8I4BSnXw90OLlg6CrXgw0l+yTqhKinHIT7JdhO9CcvNpzaXI
l+1rIYOoO+s1LFRZwVKW/sFjssTXilqC7PP16cDbzuk5/RVXlcEZHhZRPQ283rhf
ZQ0z0ytZFatPXjKzAeyXZ7QvjSlrMPkdHAyxsH+Pckjg6J3ELDGqAwZlQKucQse4
AxnMVARjD+35P1Paz+kcTzXGXqZbQ6i4ds6DedoMCE7fv/UtPDx9boTR5wKIRMLe
2or1q6zwdYJhyf758ZOJ3gjsfxnPvM9IAfUKLUucZJddS8Buzh1J/E950kLWJ1TE
dkK6dGR9TSs=
=tsNu
-----END PGP SIGNATURE-----

--=-VfP/pSm/8F2VBB5XlofZ--
