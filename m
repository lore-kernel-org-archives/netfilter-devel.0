From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 14/18] Netfilter:  Conntrack Hash Allocation using
	__get_free_pages
Date: Fri, 07 Jan 2005 22:26:46 +0100
Message-ID: <1105133206.1087.46.camel@tux.rsn.bth.se>
References: <1104896182.20582.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-0qeeSr7DBHPCMj1lvQU2"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1104896182.20582.81.camel@localhost.localdomain>
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


--=-0qeeSr7DBHPCMj1lvQU2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-01-05 at 14:36 +1100, Rusty Russell wrote:

Hi Rusty

> Here is a patch for 2.4 that just makes it use get_free_pages to
> test the TLB theory. Another obvious improvement would be to not
> use list_heads for the hash table buckets - a single pointer would
> likely suffice and it would cut the hash table in half, saving
> cache, TLB and memory.

Here's a patch that recalculates the number of buckets after the table
has been allocated with get_free_pages. Otherwise we are wasting memory.
But it doesn't increase ip_conntrack_max under normal conditions (only
if it becomes smaller than the bucket count and that only happens on
machines with little memory), it should result in shorter collision
lists.

But the patch might increase cache pressure since we have more buckets.
No benchmarks have been performed, in fact only tested with nfsim.

--- linux-2.6.10-bk050106/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-06=
 18:03:05.000000000 +0100
+++ linux-2.6.10-bk050106/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-07=
 22:14:44.000000000 +0100
@@ -1349,7 +1349,7 @@
 int __init ip_conntrack_init(void)
 {
 	unsigned int i;
-	int ret;
+	int order, ret;
=20
 	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
 	 * machine has 256 buckets.  >=3D 1GB machines have 8192 buckets. */
@@ -1366,11 +1366,6 @@
 	}
 	ip_conntrack_max =3D 8 * ip_conntrack_htable_size;
=20
-	printk("ip_conntrack version %s (%u buckets, %d max)"
-	       " - %Zd bytes per conntrack\n", IP_CONNTRACK_VERSION,
-	       ip_conntrack_htable_size, ip_conntrack_max,
-	       sizeof(struct ip_conntrack));
-
 	ret =3D nf_register_sockopt(&so_getorigdst);
 	if (ret !=3D 0) {
 		printk(KERN_ERR "Unable to register netfilter socket option\n");
@@ -1381,19 +1376,26 @@
 	   uses list_head.  it would be much nicer to caches to use a
 	   single pointer list head here. */
 	ip_conntrack_vmalloc =3D 0;=20
-	ip_conntrack_hash=20
-		=3D(void*)__get_free_pages(GFP_KERNEL,=20
-					 get_order(sizeof(struct list_head)
-						   *ip_conntrack_htable_size));
-	if (!ip_conntrack_hash) {=20
+
+	order =3D get_order(sizeof(struct list_head) * ip_conntrack_htable_size);
+
+	ip_conntrack_hash =3D (void *)__get_free_pages(GFP_KERNEL, order);
+	if (ip_conntrack_hash) {
+		/* Recalculate hashtable size based on order. */
+		ip_conntrack_htable_size =3D ((1U << order) << PAGE_SHIFT)
+						/ sizeof(struct list_head);
+		if (ip_conntrack_max < ip_conntrack_htable_size)
+			ip_conntrack_max =3D ip_conntrack_htable_size;
+	} else {=20
 		ip_conntrack_vmalloc =3D 1;
 		printk(KERN_WARNING "ip_conntrack: falling back to vmalloc.\n");
 		ip_conntrack_hash =3D vmalloc(sizeof(struct list_head)
 					    * ip_conntrack_htable_size);
-	}
-	if (!ip_conntrack_hash) {
-		printk(KERN_ERR "Unable to create ip_conntrack_hash\n");
-		goto err_unreg_sockopt;
+
+		if (!ip_conntrack_hash) {
+			printk(KERN_ERR "Unable to create ip_conntrack_hash\n");
+			goto err_unreg_sockopt;
+		}
 	}
=20
 	ip_conntrack_cachep =3D kmem_cache_create("ip_conntrack",
@@ -1434,6 +1436,11 @@
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
=20
+	printk("ip_conntrack version %s (%u buckets, %d max)"
+	       " - %Zd bytes per conntrack\n", IP_CONNTRACK_VERSION,
+	       ip_conntrack_htable_size, ip_conntrack_max,
+	       sizeof(struct ip_conntrack));
+
 	return ret;
=20
 err_free_conntrack_slab:

--=20
/Martin

--=-0qeeSr7DBHPCMj1lvQU2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB3v6VWm2vlfa207ERAotTAJ4lJWwXp36x8RzlTn7eaX6ZnOjXeQCfWA/N
hCjqDgyy1M8ZC/wdp5wCdm8=
=B8EG
-----END PGP SIGNATURE-----

--=-0qeeSr7DBHPCMj1lvQU2--
