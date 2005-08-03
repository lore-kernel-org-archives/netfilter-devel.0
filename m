From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] nf_conntrack port of expectation refcounting
Date: Wed, 3 Aug 2005 23:39:07 +0200
Message-ID: <20050803213907.GB3819@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Cc: Patrick McHardy <kaber@trash.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
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


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi! I've just committed the following patch to the nf_conntrack branch
of my netfilter-2.6.14 tree:

[NETFILTER] port conntrack_expect race fix to nf_conntrack

If a connection tracking helper tells us to expect a connection, and
we're already expecting that connection, we simply free the one they
gave us and return success.

The problem is that NAT helpers (eg. FTP) have to allocate the
expectation first (to see what port is available) then rewrite the
packet.  If that rewrite fails, they try to remove the expectation,
but it was freed in ip_conntrack_expect_related.

This is one example of a larger problem: having registered the
expectation, the pointer is no longer ours to use.  Reference counting
is needed for ctnetlink anyway, so introduce it now.

To have a single "put" path, we need to grab the reference to the
connection on creation, rather than open-coding it in the caller.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit cf6a8dbe61996377481615f99bc55fe0bf8d138c
tree 8903e7453a9cb6cbbe3df5aafe17014f3d23f2e1
parent c911fa4cf2d2ba954eeeb81c486a3c856afd22ba
author Harald Welte <laforge@netfilter.org> Mi, 03 Aug 2005 22:53:20 +0200
committer Harald Welte <laforge@netfilter.org> Mi, 03 Aug 2005 22:53:20 +02=
00

 include/linux/netfilter/nf_conntrack.h        |    3 ++
 include/linux/netfilter/nf_conntrack_helper.h |    7 +++-
 net/netfilter/nf_conntrack_core.c             |   40 +++++++++++----------=
----
 net/netfilter/nf_conntrack_ftp.c              |   14 ++++-----
 net/netfilter/nf_conntrack_standalone.c       |    2 +
 5 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilt=
er/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -136,6 +136,9 @@ struct nf_conntrack_expect
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
=20
+	/* Usage count. */
+	atomic_t use;
+
 #ifdef CONFIG_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
diff --git a/include/linux/netfilter/nf_conntrack_helper.h b/include/linux/=
netfilter/nf_conntrack_helper.h
--- a/include/linux/netfilter/nf_conntrack_helper.h
+++ b/include/linux/netfilter/nf_conntrack_helper.h
@@ -39,9 +39,10 @@ extern int nf_conntrack_helper_register(
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
=20
 /* Allocate space for an expectation: this is mandatory before calling
-   nf_conntrack_expect_related. */
-extern struct nf_conntrack_expect *nf_conntrack_expect_alloc(void);
-extern void nf_conntrack_expect_free(struct nf_conntrack_expect *exp);
+   nf_conntrack_expect_related.  You will have to call put afterwards. */
+extern struct nf_conntrack_expect *
+nf_conntrack_expect_alloc(struct nf_conn *master);
+extern void nf_conntrack_expect_put(struct nf_conntrack_expect *exp);
=20
 /* Add an expected connection: can have more than one per connection */
 extern int nf_conntrack_expect_related(struct nf_conntrack_expect *exp);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack=
_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -441,19 +441,12 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 }
=20
 /* nf_conntrack_expect helper functions */
-static void destroy_expect(struct nf_conntrack_expect *exp)
-{
-	nf_ct_put(exp->master);
-	NF_CT_ASSERT(!timer_pending(&exp->timeout));
-	kmem_cache_free(nf_conntrack_expect_cachep, exp);
-	NF_CT_STAT_INC(expect_delete);
-}
-
 static void unlink_expect(struct nf_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
+	NF_CT_ASSERT(!timer_pending(&exp_timeout));
 	list_del(&exp->list);
-	/* Logically in destroy_expect, but we hold the lock here. */
+	NF_CT_STAT_INC(expect_delete);
 	exp->master->expecting--;
 }
=20
@@ -464,7 +457,7 @@ static void expectation_timed_out(unsign
 	write_lock_bh(&nf_conntrack_lock);
 	unlink_expect(exp);
 	write_unlock_bh(&nf_conntrack_lock);
-	destroy_expect(exp);
+	nf_conntrack_expect_put(exp);
 }
=20
 /* If an expectation for this connection is found, it gets delete from
@@ -502,7 +495,7 @@ static void remove_expectations(struct n
 	list_for_each_entry_safe(i, tmp, &nf_conntrack_expect_list, list) {
 		if (i->master =3D=3D ct && del_timer(&i->timeout)) {
 			unlink_expect(i);
-			destroy_expect(i);
+			nf_conntrack_expect_put(i);
  		}
 	}
 }
@@ -873,7 +866,7 @@ init_conntrack(const struct nf_conntrack
 	if (exp) {
 		if (exp->expectfn)
 			exp->expectfn(conntrack, exp);
-		destroy_expect(exp);
+		nf_conntrack_expect_put(exp);
 	}
=20
 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
@@ -1063,14 +1056,14 @@ void nf_conntrack_unexpect_related(struc
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			unlink_expect(i);
 			write_unlock_bh(&nf_conntrack_lock);
-			destroy_expect(i);
+			nf_conntrack_expect_put(i);
 			return;
 		}
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 }
=20
-struct nf_conntrack_expect *nf_conntrack_expect_alloc(void)
+struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
=20
@@ -1079,18 +1072,23 @@ struct nf_conntrack_expect *nf_conntrack
 		DEBUGP("expect_related: OOM allocating expect\n");
 		return NULL;
 	}
-	new->master =3D NULL;
+	new->master =3D me;
+	atomic_inc(&new->master->ct_general.use);
+	atomic_set(&new->use, 1);
 	return new;
 }
=20
-void nf_conntrack_expect_free(struct nf_conntrack_expect *expect)
+void nf_conntrack_expect_put(struct nf_conntrack_expect *exp)
 {
-	kmem_cache_free(nf_conntrack_expect_cachep, expect);
+	if (atomic_dec_and_test(&exp->use)) {
+		nf_ct_put(exp->master);
+		kmem_cache_free(nf_conntrack_expect_cachep, exp);
+	}
 }
=20
 static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)
 {
-	atomic_inc(&exp->master->ct_general.use);
+	atomic_inc(&exp->use);
 	exp->master->expecting++;
 	list_add(&exp->list, &nf_conntrack_expect_list);
=20
@@ -1112,7 +1110,7 @@ static void evict_oldest_expect(struct n
 		if (i->master =3D=3D master) {
 			if (del_timer(&i->timeout)) {
 				unlink_expect(i);
-				destroy_expect(i);
+				nf_conntrack_expect_put(i);
 			}
 			break;
 		}
@@ -1144,8 +1142,6 @@ int nf_conntrack_expect_related(struct n
 			/* Refresh timer: if it's dying, ignore.. */
 			if (refresh_timer(i)) {
 				ret =3D 0;
-				/* We don't need the one they've given us. */
-				nf_conntrack_expect_free(expect);
 				goto out;
 			}
 		} else if (expect_clash(i, expect)) {
@@ -1228,7 +1224,7 @@ void nf_conntrack_helper_unregister(stru
 	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
 		if (exp->master->helper =3D=3D me && del_timer(&exp->timeout)) {
 			unlink_expect(exp);
-			destroy_expect(exp);
+			nf_conntrack_expect_put(exp);
 		}
 	}
=20
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_=
ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -525,7 +525,7 @@ static int help(struct sk_buff **pskb,
 	       (int)matchlen, fb_ptr + matchoff,
 	       matchlen, ntohl(th->seq) + matchoff);
=20
-	exp =3D nf_conntrack_expect_alloc();
+	exp =3D nf_conntrack_expect_alloc(ct);
 	if (exp =3D=3D NULL) {
 		ret =3D NF_DROP;
 		goto out;
@@ -561,8 +561,7 @@ static int help(struct sk_buff **pskb,
 		   networks, or the packet filter itself). */
 		if (!loose) {
 			ret =3D NF_ACCEPT;
-			nf_conntrack_expect_free(exp);
-			goto out_update_nl;
+			goto out_put_expect;
 		}
 		memcpy(&exp->tuple.dst.u3, &cmd.u3.all,
 		       sizeof(exp->tuple.dst.u3));
@@ -593,7 +592,6 @@ static int help(struct sk_buff **pskb,
 	}
=20
 	exp->expectfn =3D NULL;
-	exp->master =3D ct;
=20
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
@@ -602,13 +600,15 @@ static int help(struct sk_buff **pskb,
 				      matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
-		if (nf_conntrack_expect_related(exp) !=3D 0) {
-			nf_conntrack_expect_free(exp);
+		if (nf_conntrack_expect_related(exp) !=3D 0)
 			ret =3D NF_DROP;
-		} else
+		else
 			ret =3D NF_ACCEPT;
 	}
=20
+out_put_expect:
+	nf_conntrack_expect_put(exp);
+
 out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_con=
ntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -850,7 +850,7 @@ EXPORT_SYMBOL(nf_ct_protos);
 EXPORT_SYMBOL(nf_ct_find_proto);
 EXPORT_SYMBOL(nf_ct_l3protos);
 EXPORT_SYMBOL(nf_conntrack_expect_alloc);
-EXPORT_SYMBOL(nf_conntrack_expect_free);
+EXPORT_SYMBOL(nf_conntrack_expect_put);
 EXPORT_SYMBOL(nf_conntrack_expect_related);
 EXPORT_SYMBOL(nf_conntrack_unexpect_related);
 EXPORT_SYMBOL(nf_conntrack_tuple_taken);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC8Tl6XaXGVTD0i/8RAsidAJ9le4LklxAMJfh74r9iQmN8i5OkFgCePM3e
muLagk01JL7H1eH8Bc/W//I=
=KC9F
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
