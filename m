From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 1/2] Cleanup ctstat
Date: Sun, 19 Sep 2004 14:41:23 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095597683.8380.10.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-JkDDVv1O/uCq8Zf2bZma"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-JkDDVv1O/uCq8Zf2bZma
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick

Here's the first of two patches based on Pablo Neiras patch.

This patch simply adds a macro to increase the statistics.
And it changes icmp_error to error in struct ip_conntrack_stat in order
to adopt to the tcp-windowtracking changes.

Please submit for 2.6

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

diff -x '*.orig' -urNp linux-2.6.9-rc1-bk16.orig/include/linux/netfilter_ip=
v4/ip_conntrack.h linux-2.6.9-rc1-bk16/include/linux/netfilter_ipv4/ip_conn=
track.h
--- linux-2.6.9-rc1-bk16.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2=
004-09-10 11:33:31.000000000 +0200
+++ linux-2.6.9-rc1-bk16/include/linux/netfilter_ipv4/ip_conntrack.h	2004-0=
9-11 13:27:01.000000000 +0200
@@ -306,12 +306,13 @@ struct ip_conntrack_stat
 	unsigned int insert_failed;
 	unsigned int drop;
 	unsigned int early_drop;
-	unsigned int icmp_error;
+	unsigned int error;
 	unsigned int expect_new;
 	unsigned int expect_create;
 	unsigned int expect_delete;
 };
=20
+#define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count+=
+)
=20
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
diff -x '*.orig' -urNp linux-2.6.9-rc1-bk16.orig/net/ipv4/netfilter/ip_conn=
track_core.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.9-rc1-bk16.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-0=
9-10 11:33:32.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-11 =
13:28:41.000000000 +0200
@@ -185,7 +185,7 @@ destroy_expect(struct ip_conntrack_expec
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
=20
 	kmem_cache_free(ip_conntrack_expect_cachep, exp);
-	__get_cpu_var(ip_conntrack_stat).expect_delete++;
+	CONNTRACK_STAT_INC(expect_delete);
 }
=20
 inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
@@ -354,14 +354,14 @@ destroy_conntrack(struct nf_conntrack *n
 	DEBUGP("destroy_conntrack: returning ct=3D%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
-	__get_cpu_var(ip_conntrack_stat).delete++;
+	CONNTRACK_STAT_INC(delete);
 }
=20
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct ip_conntrack *ct =3D (void *)ul_conntrack;
=20
-	__get_cpu_var(ip_conntrack_stat).delete_list++;
+	CONNTRACK_STAT_INC(delete_list);
=20
 	WRITE_LOCK(&ip_conntrack_lock);
 	clean_from_lists(ct);
@@ -491,12 +491,12 @@ __ip_conntrack_confirm(struct nf_ct_info
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
-	 	__get_cpu_var(ip_conntrack_stat).insert++;
+		CONNTRACK_STAT_INC(insert);
 		return NF_ACCEPT;
 	}
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
-	__get_cpu_var(ip_conntrack_stat).insert_failed++;
+	CONNTRACK_STAT_INC(insert_failed);
 	return NF_DROP;
 }
=20
@@ -540,7 +540,7 @@ static int early_drop(struct list_head *
 	if (del_timer(&h->ctrack->timeout)) {
 		death_by_timeout((unsigned long)h->ctrack);
 		dropped =3D 1;
-		__get_cpu_var(ip_conntrack_stat).early_drop++;
+		CONNTRACK_STAT_INC(early_drop);
 	}
 	ip_conntrack_put(h->ctrack);
 	return dropped;
@@ -670,13 +670,13 @@ init_conntrack(const struct ip_conntrack
 		if (expected->expectfn)
 			expected->expectfn(conntrack);
 =09
-		__get_cpu_var(ip_conntrack_stat).expect_new++;
+		CONNTRACK_STAT_INC(expect_new);
=20
 		goto ret;
 	} else  {
 		conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
=20
-		__get_cpu_var(ip_conntrack_stat).new++;
+		CONNTRACK_STAT_INC(new);
 	}
=20
 end:	atomic_inc(&ip_conntrack_count);
@@ -780,7 +780,7 @@ unsigned int ip_conntrack_in(unsigned in
=20
 	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct) {
-		__get_cpu_var(ip_conntrack_stat).ignore++;
+		CONNTRACK_STAT_INC(ignore);
 		return NF_ACCEPT;
 	}
=20
@@ -791,19 +791,20 @@ unsigned int ip_conntrack_in(unsigned in
 	 * core what to do with the packet. */
 	if (proto->error !=3D NULL=20
 	    && (ret =3D proto->error(*pskb, &ctinfo, hooknum)) <=3D 0) {
-		__get_cpu_var(ip_conntrack_stat).icmp_error++;
+		CONNTRACK_STAT_INC(error);
+		CONNTRACK_STAT_INC(invalid);
 		return -ret;
 	}
=20
 	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))=
 {
 		/* Not valid part of a connection */
-		__get_cpu_var(ip_conntrack_stat).invalid++;
+		CONNTRACK_STAT_INC(invalid);
 		return NF_ACCEPT;
 	}
=20
 	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
-		__get_cpu_var(ip_conntrack_stat).drop++;
+		CONNTRACK_STAT_INC(drop);
 		return NF_DROP;
 	}
=20
@@ -815,7 +816,7 @@ unsigned int ip_conntrack_in(unsigned in
 		 * the netfilter core what to do*/
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct =3D NULL;
-		__get_cpu_var(ip_conntrack_stat).invalid++;
+		CONNTRACK_STAT_INC(invalid);
 		return -ret;
 	}
=20
@@ -823,7 +824,7 @@ unsigned int ip_conntrack_in(unsigned in
 		ret =3D ct->helper->help(*pskb, ct, ctinfo);
 		if (ret =3D=3D -1) {
 			/* Invalid */
-			__get_cpu_var(ip_conntrack_stat).invalid++;
+			CONNTRACK_STAT_INC(invalid);
 			nf_conntrack_put((*pskb)->nfct);
 			(*pskb)->nfct =3D NULL;
 			return NF_ACCEPT;
@@ -1027,7 +1028,7 @@ out:	ip_conntrack_expect_insert(expect,=20
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
-	__get_cpu_var(ip_conntrack_stat).expect_create++;
+	CONNTRACK_STAT_INC(expect_create);
=20
 	return ret;
 }
diff -x '*.orig' -urNp linux-2.6.9-rc1-bk16.orig/net/ipv4/netfilter/ip_conn=
track_standalone.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_sta=
ndalone.c
--- linux-2.6.9-rc1-bk16.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	=
2004-09-10 11:33:32.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-=
09-11 13:27:01.000000000 +0200
@@ -340,7 +340,7 @@ static int ct_cpu_seq_show(struct seq_fi
 		   st->insert_failed,
 		   st->drop,
 		   st->early_drop,
-		   st->icmp_error,
+		   st->error,
=20
 		   st->expect_new,
 		   st->expect_create,


--=20
/Martin

--=-JkDDVv1O/uCq8Zf2bZma
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBTX5yWm2vlfa207ERAiEjAKCi7StgebaXMs6S7AiYRK3+0ALRyACfR+Qo
Btc/dFzZGec2vTST7zzhUzg=
=qYGk
-----END PGP SIGNATURE-----

--=-JkDDVv1O/uCq8Zf2bZma--
