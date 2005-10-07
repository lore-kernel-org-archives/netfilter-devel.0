From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Fri, 7 Oct 2005 05:42:26 +0200
Message-ID: <20051007034224.GB5953@rama>
References: <1128536584.9868.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1128536584.9868.1.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks,

On Thu, Oct 06, 2005 at 04:23:03AM +1000, Rusty Russell wrote:
> Status: Tested on 2.6.14-rc3-git3
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (authored)

JFYI, here's an incremental (yet untested) patch that adds support to
reinitialize the random seed when reisizing

[NETFILTER] Re-seed the random value when reallocating conntrack hash

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 19426ea52220bc2ebb5500aab4bb2124d1c0b5be
tree 8502b4a7038db9f8158c5ad9c895ff7203778146
parent 46fa7468794cfeeb083ecbc4ad189e887bd55900
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 05:40:14 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 05:40:14 +0=
200

 net/ipv4/netfilter/ip_conntrack_core.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip=
_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -50,7 +50,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
=20
-#define IP_CONNTRACK_VERSION	"2.3"
+#define IP_CONNTRACK_VERSION	"2.4"
=20
 #if 0
 #define DEBUGP printk
@@ -148,19 +148,20 @@ DEFINE_PER_CPU(struct ip_conntrack_stat,
 static int ip_conntrack_hash_rnd_initted;
 static unsigned int ip_conntrack_hash_rnd;
=20
-static u32 __hash_conntrack(const struct ip_conntrack_tuple *tuple,
-			    unsigned int size)
+static u_int32_t __hash_conntrack(const struct ip_conntrack_tuple *tuple,
+			    unsigned int size, unsigned int rnd)
 {
 	return (jhash_3words(tuple->src.ip,
 	                     (tuple->dst.ip ^ tuple->dst.protonum),
 	                     (tuple->src.u.all | (tuple->dst.u.all << 16)),
-	                     ip_conntrack_hash_rnd) % size);
+	                     rnd) % size);
 }
=20
 static u_int32_t
 hash_conntrack(const struct ip_conntrack_tuple *tuple)
 {
-	return __hash_conntrack(tuple, ip_conntrack_htable_size);
+	return __hash_conntrack(tuple, ip_conntrack_htable_size,
+				ip_conntrack_hash_rnd);
 }
=20
 int
@@ -1408,6 +1409,7 @@ int set_hashsize(const char *val, struct
 {
 	int i, bucket, hashsize, vmalloced;
 	int old_vmalloced, old_size;
+	int rnd;
 	struct list_head *hash, *old_hash;
 	struct ip_conntrack_tuple_hash *h;
=20
@@ -1423,13 +1425,17 @@ int set_hashsize(const char *val, struct
 	if (!hash)
 		return -ENOMEM;
=20
+	/* We have to rehash for the new table anyway, so we also can=20
+	 * use a new random seed */
+	get_random_bytes(&rnd, 4);
+
 	write_lock_bh(&ip_conntrack_lock);
 	for (i =3D 0; i < ip_conntrack_htable_size; i++) {
 		while (!list_empty(&ip_conntrack_hash[i])) {
 			h =3D list_entry(ip_conntrack_hash[i].next,
 				       struct ip_conntrack_tuple_hash, list);
 			list_del(&h->list);
-			bucket =3D __hash_conntrack(&h->tuple, hashsize);
+			bucket =3D __hash_conntrack(&h->tuple, hashsize, rnd);
 			list_add_tail(&h->list, &hash[bucket]);
 		}
 	}
@@ -1440,6 +1446,7 @@ int set_hashsize(const char *val, struct
 	ip_conntrack_htable_size =3D hashsize;
 	ip_conntrack_vmalloc =3D vmalloced;
 	ip_conntrack_hash =3D hash;
+	ip_conntrack_hash_rnd =3D rnd;
 	write_unlock_bh(&ip_conntrack_lock);
=20
 	free_conntrack_hash(old_hash, old_vmalloced, old_size);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRe6gXaXGVTD0i/8RAqW0AJ0WwuSyxwoI8uYVGxQklNKO1VRw+gCeIyBo
RzVYds5bjW6QuKoFH7pu3Vs=
=UGiB
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
