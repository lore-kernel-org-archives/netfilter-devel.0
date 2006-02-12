From: Harald Welte <laforge@netfilter.org>
Subject: [RFC] [NETFILTER] nf_conntrack: more efficient helper lookup
Date: Sun, 12 Feb 2006 19:16:48 +0100
Message-ID: <20060212181648.GH4601@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbfcI4OLZ4XW0yH2"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--VbfcI4OLZ4XW0yH2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As Patrick and I discussed about two weeks ago, the linear iteration
over the list of helpers with a full tuple compare per helper is
overkill.

Please review this suggested patch and comment, thanks.

Cheers,
	Harald


[NETFILTER] nf_conntrack: more efficient helper lookup

Instead of iterating over a linear list of helpers, we now keep a hash
table of them.  Also, we restrict helper match lookup to (l3proto, l4proto,
dstport) instead of a full-blown tuple/mask lookup.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 06d95115655ba6df96d8ad7c92a3d5e91eee39f7
tree 21a21e59e9ce5eccdbafb6026106c49691674dba
parent 904a871a628c42031c3093c2b90bde526f0f35f0
author Harald Welte <laforge@netfilter.org> Wed, 01 Feb 2006 21:29:32 +0100
committer Harald Welte <laforge@netfilter.org> Wed, 01 Feb 2006 21:29:32 +0=
100

 include/net/netfilter/nf_conntrack_helper.h |   10 ++--
 net/netfilter/nf_conntrack_core.c           |   72 +++++++++++++++++++++++=
----
 net/netfilter/nf_conntrack_ftp.c            |   12 ++---
 3 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netf=
ilter/nf_conntrack_helper.h
index 86ec817..3cca3c8 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,7 +15,7 @@ struct module;
=20
 struct nf_conntrack_helper
 {=09
-	struct list_head list; 		/* Internal use. */
+	struct hlist_node list;		/* Internal use. */
=20
 	const char *name;		/* name of the module */
 	struct module *me;		/* pointer to self */
@@ -23,10 +23,10 @@ struct nf_conntrack_helper
 					 * expected connections */
 	unsigned int timeout;		/* timeout for expecteds */
=20
-	/* Mask of things we will help (compared against server response) */
-	struct nf_conntrack_tuple tuple;
-	struct nf_conntrack_tuple mask;
-=09
+	union nf_conntrack_man_proto l4;
+	u_int8_t l4proto;
+	u_int8_t l3proto;
+
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
 	int (*help)(struct sk_buff **pskb,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack=
_core.c
index f136e0d..451e8b3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -23,6 +23,8 @@
  * 26 Jan 2006: Harald Welte <laforge@netfilter.org>
  * 	- restructure nf_conn (introduce nf_conn_help)
  * 	- redesign 'features' how they were originally intended
+ * 02 Feb 2006: Harald Welte <laforge@netfilter.org>
+ * 	- replace tuple/mask helper lookup by more efficient method
  *
  * Derived from net/ipv4/netfilter/ip_conntrack_core.c
  */
@@ -58,7 +60,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
=20
-#define NF_CONNTRACK_VERSION	"0.5.0"
+#define NF_CONNTRACK_VERSION	"0.5.1"
=20
 #if 0
 #define DEBUGP printk
@@ -75,7 +77,6 @@ void (*nf_conntrack_destroyed)(struct nf
 LIST_HEAD(nf_conntrack_expect_list);
 struct nf_conntrack_protocol **nf_ct_protos[PF_MAX];
 struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX];
-static LIST_HEAD(helpers);
 unsigned int nf_conntrack_htable_size =3D 0;
 int nf_conntrack_max;
 struct list_head *nf_conntrack_hash;
@@ -85,6 +86,11 @@ unsigned int nf_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
=20
+/* normally the number of helpers is small, so we try to save some cache */
+#define NFCT_HELPER_BUCKETS 	8
+#define NFCT_HELPER_INITVAL	0x23424223
+static struct hlist_head *helpers;
+
 static unsigned int nf_conntrack_next_id =3D 1;
 static unsigned int nf_conntrack_expect_next_id =3D 1;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
@@ -787,18 +793,31 @@ static int early_drop(struct list_head *
 	return dropped;
 }
=20
+static unsigned int helper_hashfn(const struct nf_conntrack_tuple *tuple)
+{
+	return jhash_2words(tuple->dst.protonum, tuple->src.u.all,=20
+			    NFCT_HELPER_INITVAL) % NFCT_HELPER_BUCKETS;
+}
+
 static inline int helper_cmp(const struct nf_conntrack_helper *i,
 			     const struct nf_conntrack_tuple *rtuple)
 {
-	return nf_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
+	return ((i->l4proto =3D=3D rtuple->dst.protonum)
+		&& (i->l3proto =3D=3D rtuple->src.l3num)
+		&& (i->l4.all =3D=3D rtuple->src.u.all));
 }
=20
 static struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
-	return LIST_FIND(&helpers, helper_cmp,
-			 struct nf_conntrack_helper *,
-			 tuple);
+	struct nf_conntrack_helper *h;
+	struct hlist_node *pos;
+
+	hlist_for_each_entry(h, pos, &helpers[helper_hashfn(tuple)], list)
+		if (helper_cmp(h, tuple))
+			return h;
+
+	return NULL;
 }
=20
 struct nf_conntrack_helper *
@@ -1283,9 +1302,20 @@ out:
 	return ret;
 }
=20
+static void helper2tuple(struct nf_conntrack_tuple *fake_tuple,
+			 const struct nf_conntrack_helper *me)
+{
+	memset(fake_tuple, 0, sizeof(*fake_tuple));
+	fake_tuple->src.l3num =3D me->l3proto;
+	fake_tuple->dst.protonum =3D me->l4proto;
+	fake_tuple->dst.u.all =3D me->l4.all;
+}
+
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
 	int ret;
+	struct nf_conntrack_tuple fake_tuple;
+
 	BUG_ON(me->timeout =3D=3D 0);
=20
 	ret =3D nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
@@ -1296,8 +1326,11 @@ int nf_conntrack_helper_register(struct=20
 		printk(KERN_ERR "nf_conntrack_helper_reigster: Unable to create slab cac=
he for conntracks\n");
 		return ret;
 	}
+
+	helper2tuple(&fake_tuple, me);
+
 	write_lock_bh(&nf_conntrack_lock);
-	list_prepend(&helpers, me);
+	hlist_add_head(&me->list, &helpers[helper_hashfn(&fake_tuple)]);
 	write_unlock_bh(&nf_conntrack_lock);
=20
 	return 0;
@@ -1306,11 +1339,16 @@ int nf_conntrack_helper_register(struct=20
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name)
 {
-	struct nf_conntrack_helper *h;
+	unsigned int i;
=20
-	list_for_each_entry(h, &helpers, list) {
-		if (!strcmp(h->name, name))
-			return h;
+	for (i =3D 0; i < NFCT_HELPER_BUCKETS; i++) {
+		struct nf_conntrack_helper *h;
+		struct hlist_node *pos;
+
+		hlist_for_each_entry(h, pos, &helpers[i], list) {
+			if (!strcmp(h->name, name))
+				return h;
+		}
 	}
=20
 	return NULL;
@@ -1333,10 +1371,13 @@ void nf_conntrack_helper_unregister(stru
 {
 	unsigned int i;
 	struct nf_conntrack_expect *exp, *tmp;
+	struct nf_conntrack_tuple fake_tuple;
+
+	helper2tuple(&fake_tuple, me);
=20
 	/* Need write lock here, to delete helper. */
 	write_lock_bh(&nf_conntrack_lock);
-	LIST_DELETE(&helpers, me);
+	hlist_del(&me->list);
=20
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
@@ -1694,6 +1735,11 @@ int __init nf_conntrack_init(void)
 		goto err_free_conntrack_slab;
 	}
=20
+	helpers =3D kmalloc(sizeof(struct hlist_head) * NFCT_HELPER_BUCKETS,
+			  GFP_KERNEL);
+	if (!helpers)
+		goto err_free_expect_slab;
+
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&nf_conntrack_lock);
         for (i =3D 0; i < PF_MAX; i++)
@@ -1708,6 +1754,8 @@ int __init nf_conntrack_init(void)
=20
 	return ret;
=20
+err_free_expect_slab:
+	kmem_cache_destroy(nf_conntrack_expect_cachep);
 err_free_conntrack_slab:
 	nf_conntrack_unregister_cache(NF_CT_F_BASIC);
 err_free_hash:
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_=
ftp.c
index 280c5c2..daff4d3 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -659,13 +659,11 @@ static int __init init(void)
 	for (i =3D 0; i < ports_c; i++) {
 		memset(&ftp[i], 0, sizeof(struct nf_conntrack_helper));
=20
-		ftp[i][0].tuple.src.l3num =3D PF_INET;
-		ftp[i][1].tuple.src.l3num =3D PF_INET6;
+		ftp[i][0].l3proto =3D PF_INET;
+		ftp[i][1].l3proto =3D PF_INET6;
 		for (j =3D 0; j < 2; j++) {
-			ftp[i][j].tuple.src.u.tcp.port =3D htons(ports[i]);
-			ftp[i][j].tuple.dst.protonum =3D IPPROTO_TCP;
-			ftp[i][j].mask.src.u.tcp.port =3D 0xFFFF;
-			ftp[i][j].mask.dst.protonum =3D 0xFF;
+			ftp[i][j].l4.tcp.port =3D htons(ports[i]);
+			ftp[i][j].l4proto =3D IPPROTO_TCP;
 			ftp[i][j].max_expected =3D 1;
 			ftp[i][j].timeout =3D 5 * 60;	/* 5 Minutes */
 			ftp[i][j].me =3D THIS_MODULE;
@@ -684,7 +682,7 @@ static int __init init(void)
 			if (ret) {
 				printk("nf_ct_ftp: failed to register helper "
 				       " for pf: %d port: %d\n",
-					ftp[i][j].tuple.src.l3num, ports[i]);
+					ftp[i][j].l3proto, ports[i]);
 				fini();
 				return ret;
 			}
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VbfcI4OLZ4XW0yH2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD73uQXaXGVTD0i/8RAoj9AJwKSY3SSmV/JUQZpVuR8k/mgOT67QCeORrU
+Mgfj5zOQDQnAVim3J1kIqs=
=XMXT
-----END PGP SIGNATURE-----

--VbfcI4OLZ4XW0yH2--
