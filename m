From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the ida tree
Date: Wed, 18 Jul 2018 16:54:06 +1000
Message-ID: <20180718165406.6f262266@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g/JeRb=JJkWClj_fS6cOuos"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varsha Rao <rvarsha016@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/g/JeRb=JJkWClj_fS6cOuos
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the ida tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

net/netfilter/nf_tables_api.c: In function 'nf_tables_set_alloc_name':
net/netfilter/nf_tables_api.c:3014:8: error: implicit declaration of functi=
on 'ida_get_new_above'; did you mean 'idr_get_next_ul'? [-Werror=3Dimplicit=
-function-declaration]
    n =3D ida_get_new_above(&inuse, tmp, &id);
        ^~~~~~~~~~~~~~~~~
        idr_get_next_ul

Caused by commit

  3f2668c1e101 ("ida: Remove old API")

interacting with commit

  9679150a0bd5 ("netfilter: nf_tables: Use id allocation")

from the netfilter-next tree.

I took a guess and applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Jul 2018 16:42:26 +1000
Subject: [PATCH] ida: merge fix for ida_get_new_above() removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/netfilter/nf_tables_api.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b7b5fbcda8dd..151b89174979 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2995,7 +2995,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *c=
tx, struct nft_set *set,
 {
 	const struct nft_set *i;
 	const char *p;
-	unsigned int n =3D 0, id =3D 0;
+	int id =3D 0;
 	DEFINE_IDA(inuse);
=20
 	p =3D strchr(name, '%');
@@ -3011,22 +3011,22 @@ static int nf_tables_set_alloc_name(struct nft_ctx =
*ctx, struct nft_set *set,
 			if (!sscanf(i->name, name, &tmp))
 				continue;
=20
-			n =3D ida_get_new_above(&inuse, tmp, &id);
-			if (n < 0) {
-				if (n =3D=3D -EAGAIN)
+			id =3D ida_alloc_min(&inuse, tmp, GFP_KERNEL);
+			if (id < 0) {
+				if (id =3D=3D -EAGAIN)
 					return -ENOMEM;
=20
-				return n;
+				return id;
 			}
 		}
=20
-		n =3D ida_get_new_above(&inuse, 0, &id);
+		id =3D ida_alloc(&inuse, GFP_KERNEL);
 		ida_destroy(&inuse);
=20
-		if (n < 0) {
-			if (n =3D=3D -EAGAIN)
+		if (id < 0) {
+			if (id =3D=3D -EAGAIN)
 				return -ENOMEM;
-			return n;
+			return id;
 		}
=20
 	}

--=20
Cheers,
Stephen Rothwell

--Sig_/g/JeRb=JJkWClj_fS6cOuos
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltO5A4ACgkQAVBC80lX
0GxYLwgAi8GHzgBSZNAP+pjRXGhrfF977sexbevOQDEYzzo4QEcHHf8X6q3oO57K
VGdBTB8fYLTb2Mn5MW++a6++NLKPUFl9YORxTBwmUvtioIjkZybUvgGpzPgaG+xC
QTG7tL5wtQoMZOwO8OgLhhxxAGNDR8jyZa+kvPPDAHRhYCKRir8HGh7hse/ZCUdv
DiIysMlgIawjcNCJw4jkvD1XD21vO+IXQElz3ofy+87owKO2T9kAZcSy+3bjY4Qv
yTg5Uj/nlOMZBgjPKPIZg+XbdxUIP6vImK4O8+UFk9pfarrPXKQTOGMapIn0tWIl
IcFbu8wvblmap9UQtL+iKAEMPt2ZTg==
=DMq5
-----END PGP SIGNATURE-----

--Sig_/g/JeRb=JJkWClj_fS6cOuos--
