From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter-next tree
Date: Wed, 18 Jul 2018 11:50:37 +1000
Message-ID: <20180718115037.256e2663@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vB09U+DYDOWAEmP._QtNFib"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/vB09U+DYDOWAEmP._QtNFib
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/netfilter/nft_tproxy.c: In function 'nft_tproxy_eval_v4':
net/netfilter/nft_tproxy.c:48:48: warning: passing argument 3 of 'nf_tproxy=
_get_sock_v4' makes integer from pointer without a cast [-Wint-conversion]
  sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, hp, iph->protocol,
                                                ^~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: expected 'u8 {aka const unsig=
ned char}' but argument is of type 'struct udphdr *'
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:50:20: warning: passing argument 8 of 'nf_tproxy=
_get_sock_v4' makes pointer from integer without a cast [-Wint-conversion]
        hp->source, hp->dest,
                    ^~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: expected 'const struct net_de=
vice *' but argument is of type '__be16 {aka short unsigned int}'
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:51:8: error: incompatible type for argument 9 of=
 'nf_tproxy_get_sock_v4'
        skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
        ^~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: expected 'const enum nf_tprox=
y_lookup_t' but argument is of type 'struct net_device *'
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:48:7: error: too many arguments to function 'nf_=
tproxy_get_sock_v4'
  sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, hp, iph->protocol,
       ^~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: declared here
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:69:49: warning: passing argument 3 of 'nf_tproxy=
_get_sock_v4' makes integer from pointer without a cast [-Wint-conversion]
   sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, hp, iph->protocol,
                                                 ^~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: expected 'u8 {aka const unsig=
ned char}' but argument is of type 'struct udphdr *'
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:71:21: warning: passing argument 8 of 'nf_tproxy=
_get_sock_v4' makes pointer from integer without a cast [-Wint-conversion]
         hp->source, tport,
                     ^~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: expected 'const struct net_de=
vice *' but argument is of type '__be16 {aka short unsigned int}'
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:72:9: error: incompatible type for argument 9 of=
 'nf_tproxy_get_sock_v4'
         skb->dev, NF_TPROXY_LOOKUP_LISTENER);
         ^~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: expected 'const enum nf_tprox=
y_lookup_t' but argument is of type 'struct net_device *'
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:69:8: error: too many arguments to function 'nf_=
tproxy_get_sock_v4'
   sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, hp, iph->protocol,
        ^~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:75:1: note: declared here
 nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c: In function 'nft_tproxy_eval_v6':
net/netfilter/nft_tproxy.c:111:55: warning: passing argument 4 of 'nf_tprox=
y_get_sock_v6' makes integer from pointer without a cast [-Wint-conversion]
  sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp, l4proto,
                                                       ^~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'u8 {aka const unsi=
gned char}' but argument is of type 'struct udphdr *'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:111:59: warning: passing argument 5 of 'nf_tprox=
y_get_sock_v6' makes pointer from integer without a cast [-Wint-conversion]
  sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp, l4proto,
                                                           ^~~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'const struct in6_a=
ddr *' but argument is of type 'int'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:112:21: warning: passing argument 7 of 'nf_tprox=
y_get_sock_v6' makes integer from pointer without a cast [-Wint-conversion]
        &iph->saddr, &iph->daddr,
                     ^
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected '__be16 {aka const =
short unsigned int}' but argument is of type 'const struct in6_addr *'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:113:20: warning: passing argument 9 of 'nf_tprox=
y_get_sock_v6' makes pointer from integer without a cast [-Wint-conversion]
        hp->source, hp->dest,
                    ^~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'const struct net_d=
evice *' but argument is of type '__be16 {aka short unsigned int}'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:114:8: error: incompatible type for argument 10 =
of 'nf_tproxy_get_sock_v6'
        nft_in(pkt), NF_TPROXY_LOOKUP_ESTABLISHED);
        ^~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'const enum nf_tpro=
xy_lookup_t' but argument is of type 'const struct net_device *'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:111:7: error: too many arguments to function 'nf=
_tproxy_get_sock_v6'
  sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp, l4proto,
       ^~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: declared here
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:137:56: warning: passing argument 4 of 'nf_tprox=
y_get_sock_v6' makes integer from pointer without a cast [-Wint-conversion]
   sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp,
                                                        ^~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'u8 {aka const unsi=
gned char}' but argument is of type 'struct udphdr *'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:138:9: warning: passing argument 5 of 'nf_tproxy=
_get_sock_v6' makes pointer from integer without a cast [-Wint-conversion]
         l4proto, &iph->saddr, &taddr,
         ^~~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'const struct in6_a=
ddr *' but argument is of type 'int'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:138:31: warning: passing argument 7 of 'nf_tprox=
y_get_sock_v6' makes integer from pointer without a cast [-Wint-conversion]
         l4proto, &iph->saddr, &taddr,
                               ^
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected '__be16 {aka const =
short unsigned int}' but argument is of type 'struct in6_addr *'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:139:21: warning: passing argument 9 of 'nf_tprox=
y_get_sock_v6' makes pointer from integer without a cast [-Wint-conversion]
         hp->source, tport,
                     ^~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'const struct net_d=
evice *' but argument is of type '__be16 {aka short unsigned int}'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:140:9: error: incompatible type for argument 10 =
of 'nf_tproxy_get_sock_v6'
         nft_in(pkt), NF_TPROXY_LOOKUP_LISTENER);
         ^~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: expected 'const enum nf_tpro=
xy_lookup_t' but argument is of type 'const struct net_device *'
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~
net/netfilter/nft_tproxy.c:137:8: error: too many arguments to function 'nf=
_tproxy_get_sock_v6'
   sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp,
        ^~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nft_tproxy.c:6:0:
include/net/netfilter/nf_tproxy.h:114:1: note: declared here
 nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 ^~~~~~~~~~~~~~~~~~~~~

Caused by commit

  08668354bdbf ("netfilter: Add native tproxy support for nf_tables")

interacting with commit

  5711b4e89319 ("netfilter: nf_tproxy: fix possible non-linear access to tr=
ansport header")

from the net tree.

I have applied the following merge fix up patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Jul 2018 11:41:50 +1000
Subject: [PATCH] netfilter: nf_tproxy: merge fix ups for API changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/netfilter/nft_tproxy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 5ca797ea335c..23ea9396a693 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -45,7 +45,7 @@ static void nft_tproxy_eval_v4(const struct nft_expr *exp=
r,
 	 * happens if the redirect already happened and the current packet
 	 * belongs to an already established connection
 	 */
-	sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, hp, iph->protocol,
+	sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, iph->protocol,
 				   iph->saddr, iph->daddr,
 				   hp->source, hp->dest,
 				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
@@ -66,7 +66,7 @@ static void nft_tproxy_eval_v4(const struct nft_expr *exp=
r,
 	else if (!sk)
 		/* no, there's no established connection, check if
 		 * there's a listener on the redirected addr/port */
-		sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, hp, iph->protocol,
+		sk =3D nf_tproxy_get_sock_v4(nft_net(pkt), skb, iph->protocol,
 					   iph->saddr, taddr,
 					   hp->source, tport,
 					   skb->dev, NF_TPROXY_LOOKUP_LISTENER);
@@ -108,7 +108,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *e=
xpr,
 	 * happens if the redirect already happened and the current packet
 	 * belongs to an already established connection.
 	 */
-	sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp, l4proto,
+	sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, l4proto,
 				   &iph->saddr, &iph->daddr,
 				   hp->source, hp->dest,
 				   nft_in(pkt), NF_TPROXY_LOOKUP_ESTABLISHED);
@@ -134,7 +134,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *e=
xpr,
 	else if (!sk)
 		/* no there's no established connection, check if
 		 * there's a listener on the redirected addr/port */
-		sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff, hp,
+		sk =3D nf_tproxy_get_sock_v6(nft_net(pkt), skb, thoff,
 					   l4proto, &iph->saddr, &taddr,
 					   hp->source, tport,
 					   nft_in(pkt), NF_TPROXY_LOOKUP_LISTENER);
--=20
2.18.0

--=20
Cheers,
Stephen Rothwell

--Sig_/vB09U+DYDOWAEmP._QtNFib
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltOnO0ACgkQAVBC80lX
0Gy3DQf/aUaut/qCXwY3kulBMqfuDiOWPBZ9kakRDmJUOQ1ze9sZpKtM894uIRpC
vmQ0CObh4gMc6tZjxdgPoVtvaHVmFTlK99gj1uE0RO/3Irot+Mwe1FEKvm3kdyhg
vUwl3gWdCQWWONDfKbZSDXjrnL3CVLnnzZDAOnzdVcByOhGQfZ/TsOu7L0TnOuo1
za2TMh1Wp5HZMRuW6MODWh1/1RDYBkGJojm+HJvOWqHHMSBOHaciVTmm4xidx131
or7WDSD3TWdlGgZFNinZc7ZIXHlKkHR6G9ETazzbUIyqYQsWkBc2jfbZPe+zV++2
zD5RE6i621byP8LtxjriYtl5JijGTQ==
=sSJ8
-----END PGP SIGNATURE-----

--Sig_/vB09U+DYDOWAEmP._QtNFib--
