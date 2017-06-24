From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] include: Remove __init macro definition.
Date: Sat, 24 Jun 2017 10:11:13 +0530
Message-ID: <594ded6f.8681620a.7fa76.8b66@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32885 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdFXElU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Jun 2017 00:41:20 -0400
Received: by mail-pg0-f68.google.com with SMTP id u62so8410246pgb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 21:41:20 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add nft_init function, which calls _init functions in main.c file.
Remove __init macro definition as libnftables library will be created
soon. Rename realm_table_init() function to avoid ambiguity as
realm_table_rt_init() and realm_table_meta_init() in rt.c and meta.c
files.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/nftables.h | 16 +++++++++++++++-
 include/utils.h    |  1 -
 src/ct.c           |  4 ++--
 src/datatype.c     |  2 +-
 src/exthdr.c       |  2 +-
 src/fib.c          |  2 +-
 src/gmputil.c      |  2 +-
 src/main.c         | 20 ++++++++++++++++++++
 src/meta.c         |  6 +++---
 src/netlink.c      |  2 +-
 src/proto.c        |  2 +-
 src/rt.c           |  4 ++--
 src/xt.c           |  2 +-
 13 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 9e10be0..442462d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -112,5 +112,19 @@ struct parser_state;
 
 int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
 	     struct output_ctx *octx);
-
+void ct_label_table_init(void);
+void ct_init(void);
+void mark_table_init(void);
+void exthdr_init(void);
+void fib_init(void);
+void gmp_init(void);
+void realm_table_rt_init(void);
+void devgroup_table_init(void);
+void meta_init(void);
+void netlink_open_sock(void);
+void proto_init(void);
+void realm_table_meta_init(void);
+void rt_init(void);
+void xt_init(void);
+void nft_init(void);
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/utils.h b/include/utils.h
index 3199388..0c3341b 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -32,7 +32,6 @@
 #define __gmp_fmtstring(x, y)
 #endif
 
-#define __init			__attribute__((constructor))
 #define __exit			__attribute__((destructor))
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
diff --git a/src/ct.c b/src/ct.c
index c705750..6916f06 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -205,7 +205,7 @@ static const struct datatype ct_label_type = {
 	.parse		= ct_label_type_parse,
 };
 
-static void __init ct_label_table_init(void)
+void ct_label_table_init(void)
 {
 	ct_label_tbl = rt_symbol_table_init(CONNLABEL_CONF);
 }
@@ -486,7 +486,7 @@ struct stmt *notrack_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &notrack_stmt_ops);
 }
 
-static void __init ct_init(void)
+void ct_init(void)
 {
 	datatype_register(&ct_state_type);
 	datatype_register(&ct_dir_type);
diff --git a/src/datatype.c b/src/datatype.c
index 899e9c0..7a2419b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -704,7 +704,7 @@ void rt_symbol_table_free(struct symbol_table *tbl)
 }
 
 static struct symbol_table *mark_tbl;
-static void __init mark_table_init(void)
+void mark_table_init(void)
 {
 	mark_tbl = rt_symbol_table_init("/etc/iproute2/rt_marks");
 }
diff --git a/src/exthdr.c b/src/exthdr.c
index f31deea..e7c5487 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -344,7 +344,7 @@ const struct exthdr_desc exthdr_mh = {
 	},
 };
 
-static void __init exthdr_init(void)
+void exthdr_init(void)
 {
 	datatype_register(&mh_type_type);
 }
diff --git a/src/fib.c b/src/fib.c
index 28d2b1d..96bfa96 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -142,7 +142,7 @@ struct expr *fib_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void __init fib_init(void)
+void fib_init(void)
 {
 	datatype_register(&fib_addr_type);
 }
diff --git a/src/gmputil.c b/src/gmputil.c
index c763792..844ea61 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -207,7 +207,7 @@ static void *gmp_xrealloc(void *ptr, size_t old_size, size_t new_size)
 	return xrealloc(ptr, new_size);
 }
 
-static void __init gmp_init(void)
+void gmp_init(void)
 {
 	mp_set_memory_functions(xmalloc, gmp_xrealloc, NULL);
 }
diff --git a/src/main.c b/src/main.c
index 918ad4b..53f650f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -255,6 +255,25 @@ err1:
 	return ret;
 }
 
+void nft_init(void)
+{
+	mark_table_init();
+	proto_init();
+	exthdr_init();
+	fib_init();
+	realm_table_rt_init();
+	devgroup_table_init();
+	meta_init();
+	realm_table_meta_init();
+	rt_init();
+	ct_label_table_init();
+	ct_init();
+	netlink_open_sock();
+	gmp_init();
+#ifdef HAVE_LIBXTABLES
+	xt_init();
+#endif
+}
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -265,6 +284,7 @@ int main(int argc, char * const *argv)
 	bool interactive = false;
 	int i, val, rc = NFT_EXIT_SUCCESS;
 
+	nft_init();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
diff --git a/src/meta.c b/src/meta.c
index a303318..a7e8a19 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -37,7 +37,7 @@
 #include <iface.h>
 
 static struct symbol_table *realm_tbl;
-static void __init realm_table_init(void)
+void realm_table_meta_init(void)
 {
 	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
@@ -356,7 +356,7 @@ static const struct datatype pkttype_type = {
 };
 
 static struct symbol_table *devgroup_tbl;
-static void __init devgroup_table_init(void)
+void devgroup_table_init(void)
 {
 	devgroup_tbl = rt_symbol_table_init("/etc/iproute2/group");
 }
@@ -621,7 +621,7 @@ struct stmt *meta_stmt_alloc(const struct location *loc, enum nft_meta_keys key,
 	return stmt;
 }
 
-static void __init meta_init(void)
+void meta_init(void)
 {
 	datatype_register(&ifindex_type);
 	datatype_register(&realm_type);
diff --git a/src/netlink.c b/src/netlink.c
index 880502c..3993aa1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -61,7 +61,7 @@ static struct mnl_socket *nfsock_open(void)
 	return s;
 }
 
-static void __init netlink_open_sock(void)
+void netlink_open_sock(void)
 {
 	nf_sock = nfsock_open();
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
diff --git a/src/proto.c b/src/proto.c
index 64d0632..7e67ecc 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -961,7 +961,7 @@ const struct proto_desc proto_netdev = {
 	},
 };
 
-static void __init proto_init(void)
+void proto_init(void)
 {
 	datatype_register(&icmp_type_type);
 	datatype_register(&tcp_flag_type);
diff --git a/src/rt.c b/src/rt.c
index eb5f9c3..263d36f 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -24,7 +24,7 @@
 #include <rule.h>
 
 static struct symbol_table *realm_tbl;
-static void __init realm_table_init(void)
+void realm_table_rt_init(void)
 {
 	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
@@ -135,7 +135,7 @@ void rt_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	}
 }
 
-static void __init rt_init(void)
+void rt_init(void)
 {
 	datatype_register(&realm_type);
 }
diff --git a/src/xt.c b/src/xt.c
index e24b0af..9680f8e 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -351,7 +351,7 @@ static struct xtables_globals xt_nft_globals = {
 	.compat_rev		= nft_xt_compatible_revision,
 };
 
-static void __init xt_init(void)
+void xt_init(void)
 {
 	/* Default to IPv4, but this changes in runtime */
 	xtables_init_all(&xt_nft_globals, NFPROTO_IPV4);
-- 
2.9.4

