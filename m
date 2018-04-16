From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter tree
Date: Tue, 17 Apr 2018 09:28:59 +1000
Message-ID: <20180417092859.358573be@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xGmb.tbd_m2j/9+ca6DNz7="; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/xGmb.tbd_m2j/9+ca6DNz7=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/netfilter/nf_conntrack_extend.c: In function 'nf_ct_ext_
add':
net/netfilter/nf_conntrack_extend.c:74:2: error: implicit declaration of fu=
nction 'kmemleak_not_leak' [-Werror=3Dimplicit-function-declaration]
  kmemleak_not_leak(old);
  ^~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Caused by commit

  114aa35d06d4 ("netfilter: conntrack: silent a memory leak warning")

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 17 Apr 2018 09:26:49 +1000
Subject: [PATCH] netfilter: conntrack: include kmemleak.h for
 kmemleak_not_leak()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/netfilter/nf_conntrack_extend.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntra=
ck_extend.c
index bd71a828ebde..277bbfe26478 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -9,6 +9,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
+#include <linux/kmemleak.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
--=20
2.16.3

--=20
Cheers,
Stephen Rothwell

--Sig_/xGmb.tbd_m2j/9+ca6DNz7=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrVMbsACgkQAVBC80lX
0GxZ7wf/WOhRUi85MTU9MkKgs5QnmbKMxPMN1AMN4JHpCtFH8GhZrOJoHKBeRnI8
nNlcCHW0P5tN8IzoDdUgvxX41g4IQc/doujuktE8nozsH5EbeshN3n5BT3BAssYK
/5pnMNrpziCsxdFJnAQ99gsWAc1NScAsfcqxvH5JnnW5Tk//QPNcC3cDM3XGja0n
QAH8JVSclPcnKZfcfbYpp3CFOacvF87WnsV0AgsMdUj8bGC8gR0gAv9Hiq0LFUwX
FVwMmvBwrsQKozYxhZgACzJXdxWDwjLsKez5jjVnSbtAjnIBECQRUs2SJh8L/2Tj
y2zMopyfzkNUHeu18vUnD/lZeTJ0JA==
=bv6w
-----END PGP SIGNATURE-----

--Sig_/xGmb.tbd_m2j/9+ca6DNz7=--
