From: Nikolai Malykh <nmalykh@ieee.org>
Subject: hashlimit match errors and patches
Date: Fri, 04 Feb 2005 23:40:38 +0300
Message-ID: <4203DDC6.6090709@ieee.org>
Reply-To: nmalykh@ieee.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080502080205020000060702"
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------080502080205020000060702
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

1. Incorrect parameters handling in libipt_hashlimit make impossible to 
save rule without error because --hashlimit-mode saved as --mode

Patch for this error in attachment

2. Incorrect parameter in jhash_3words() - port numbers not hashed in result
3. Incorrect parameter value in hashlimit_match() - matching packet = 
burst +1 instead burst

Patch for this errors in attachment


PS. Sorry for my English it's not my native.

-- 
Nikolai Malykh
nmalykh@ieee.org

phone +7 (812) 449 0770
ICQ UIN 30741141

--------------080502080205020000060702
Content-Type: text/plain;
 name="libipt_hashlimit.patch"
Content-Disposition: inline;
 filename="libipt_hashlimit.patch"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by
	Lhotze.bilim-systems.net id j14KecFD024886

--- /usr/src/iptables-1.3.0rc1/extensions/libipt_hashlimit.c	2005-01-04 1=
3:38:34.000000000 +0300
+++ libipt_hashlimit.c	2005-01-24 21:23:50.000000000 +0300
@@ -7,6 +7,8 @@
  * Based on ipt_limit.c by
  * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Herv=E9 Eychenne    <rv@wallfire.org>
+ *=20
+ * Error corections by nmalykh@bilim.com (22.01.2005)
  */
=20
 #include <stdio.h>
@@ -294,7 +296,7 @@
 		fputs("dstip", stdout);
 		prevmode =3D 1;
 	}
-	if (r->cfg.mode & IPT_HASHLIMIT_HASH_SPT) {
+	if (r->cfg.mode & IPT_HASHLIMIT_HASH_DPT) {
 		if (prevmode)
 			putchar(separator);
 		fputs("dstport", stdout);
@@ -334,8 +336,10 @@
 	if (r->cfg.burst !=3D IPT_HASHLIMIT_BURST)
 		printf("--hashlimit-burst %u ", r->cfg.burst);
=20
-	fputs("--mode ", stdout);
+	fputs("--hashlimit-mode ", stdout);
 	print_mode(r, ',');
+=09
+	printf("--hashlimit-name %s ", r->name);
=20
 	if (r->cfg.size)
 		printf("--hashlimit-htable-size %u ", r->cfg.size);

--------------080502080205020000060702
Content-Type: text/plain;
 name="ipt_hashlimit.patch"
Content-Disposition: inline;
 filename="ipt_hashlimit.patch"
Content-Transfer-Encoding: 7bit

--- ipt_hashlimit.c	2004-12-25 00:34:57.000000000 +0300
+++ /usr/src/linux/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-04 23:19:17.848878277 +0300
@@ -97,7 +97,7 @@
 	struct list_head hash[0];	/* hashtable itself */
 };
 
-DECLARE_RWLOCK(hashlimit_lock);		/* protects htables list */
+static DECLARE_RWLOCK(hashlimit_lock);		/* protects htables list */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
 
@@ -112,7 +112,7 @@
 static inline u_int32_t
 hash_dst(const struct ipt_hashlimit_htable *ht, const struct dsthash_dst *dst)
 {
-	return (jhash_3words(dst->dst_ip, (dst->dst_port<<16 & dst->src_port), 
+	return (jhash_3words(dst->dst_ip, (u32)((u32)dst->dst_port<<16 | dst->src_port), 
 			     dst->src_ip, ht->rnd) % ht->cfg.size);
 }
 
@@ -413,7 +413,6 @@
 			ports[0] = ports[1] = 0;
 			break;
 	}
-
 	return 0;
 }
 
@@ -471,7 +470,7 @@
 
 		dh->rateinfo.prev = jiffies;
 		dh->rateinfo.credit = user2credits(hinfo->cfg.avg * 
-							hinfo->cfg.burst);
+							(hinfo->cfg.burst-1));
 		dh->rateinfo.credit_cap = user2credits(hinfo->cfg.avg * 
 							hinfo->cfg.burst);
 		dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
@@ -480,6 +479,7 @@
 		return 1;
 	}
 
+//	unsigned long now = jiffies;
 	/* update expiration timeout */
 	dh->expires = now + MS2JIFFIES(hinfo->cfg.expire);
 
@@ -608,6 +608,9 @@
 	/* recalculate to show accurate numbers */
 	rateinfo_recalc(ent, jiffies);
 
+//	ent->rateinfo.credit += (jiffies - xchg(&ent->rateinfo.prev, jiffies)) 
+//					* CREDITS_PER_JIFFY;
+
 	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
 			(ent->expires - jiffies)/HZ,
 			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
@@ -668,11 +671,9 @@
 		goto cleanup_nothing;
 	}
 
-	/* FIXME: do we really want HWCACHE_ALIGN since our objects are
-	 * quite small ? */
 	hashlimit_cachep = kmem_cache_create("ipt_hashlimit",
 					    sizeof(struct dsthash_ent), 0,
-					    SLAB_HWCACHE_ALIGN, NULL, NULL);
+					    0, NULL, NULL);
 	if (!hashlimit_cachep) {
 		printk(KERN_ERR "Unable to create ipt_hashlimit slab cache\n");
 		ret = -ENOMEM;

--------------080502080205020000060702--
