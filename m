From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the netfilter-next tree with the net
 tree
Date: Wed, 18 Jul 2018 11:28:53 +1000
Message-ID: <20180718112853.6abca6f2@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V_RE9HVP16QSLnzQbLQwU91"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/V_RE9HVP16QSLnzQbLQwU91
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  include/net/netfilter/nf_tables_core.h

between commit:

  e240cd0df481 ("netfilter: nf_tables: place all set backends in one single=
 module")

from the net tree and commit:

  da8f7d227adc ("netfilter: nf_tables: handle meta/lookup with direct call")

from the netfilter-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/net/netfilter/nf_tables_core.h
index a05134507e7b,0096f65096b5..000000000000
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@@ -65,10 -65,11 +65,17 @@@ extern const struct nft_expr_ops nft_pa
  extern struct static_key_false nft_counters_enabled;
  extern struct static_key_false nft_trace_enabled;
 =20
 +extern struct nft_set_type nft_set_rhash_type;
 +extern struct nft_set_type nft_set_hash_type;
 +extern struct nft_set_type nft_set_hash_fast_type;
 +extern struct nft_set_type nft_set_rbtree_type;
 +extern struct nft_set_type nft_set_bitmap_type;
 +
+ struct nft_expr;
+ struct nft_regs;
+ struct nft_pktinfo;
+ void nft_meta_get_eval(const struct nft_expr *expr,
+ 		       struct nft_regs *regs, const struct nft_pktinfo *pkt);
+ void nft_lookup_eval(const struct nft_expr *expr,
+ 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
  #endif /* _NET_NF_TABLES_CORE_H */

--Sig_/V_RE9HVP16QSLnzQbLQwU91
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltOl9UACgkQAVBC80lX
0GxjeQf9HZlBEGIbKTOJvj/a0hjYbtv/ZWRp0NK40hBOwvIeG4piq571ogqHmeFU
Mh/FPPluqhV5VH53EOCKCzSsaJ3ASBAar6O8PninCeQtp0+ZpA4M2ICtkwzSyStt
odzN7ekGVAJZ/aIdMQXq8hJRuBgEXA9a+UrF4sFxEjge5tnA2Kko16ZoDaRx75Yb
pW2Sk8ZhAZW0KntVFBb2gbx2sxujvbyEq8kMbG82KRhq3oioGo/5qCCmm2avy4X0
QwEGB0K4t4G5nf71fHb7ziRWfdtGeOaHWfwWACrwuvZxRL/iNmWWilAs+5WBfL0A
VmOu0ZsNwp6rth9u5iqBWx9s4DJqeA==
=d2fY
-----END PGP SIGNATURE-----

--Sig_/V_RE9HVP16QSLnzQbLQwU91--
