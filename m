From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 2/3] include: Remove __init macro definition.
Date: Fri, 30 Jun 2017 14:57:12 +0530
Message-ID: <252529ca943916a9b9473b7a443460a6559dc8d2.1498814530.git.rvarsha016@gmail.com>
References: <cover.1498814530.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34206 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdF3J1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2017 05:27:22 -0400
Received: by mail-pg0-f67.google.com with SMTP id j186so14806833pge.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 02:27:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1498814530.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add nft_init function, which calls _init functions in main.c file.
Remove __init macro definition as libnftables library will be created
soon. Rename realm_table_init() function to avoid ambiguity as
realm_table_rt_init() and realm_table_meta_init() in rt.c and meta.c
files.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/nftables.h |  9 +++++++++
 include/utils.h    |  1 -
 src/ct.c           |  2 +-
 src/datatype.c     |  2 +-
 src/gmputil.c      |  2 +-
 src/main.c         | 15 +++++++++++++++
 src/meta.c         |  4 ++--
 src/netlink.c      |  2 +-
 src/rt.c           |  2 +-
 src/xt.c           |  2 +-
 10 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 26fd344..b188b9e 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -117,5 +117,14 @@ struct parser_state;
 
 int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
 	    struct list_head *msgs);
+void ct_label_table_init(void);
+void mark_table_init(void);
+void gmp_init(void);
+void realm_table_rt_init(void);
+void devgroup_table_init(void);
+void netlink_open_sock(void);
+void realm_table_meta_init(void);
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
index 9b7140b..25efc70 100644
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
diff --git a/src/datatype.c b/src/datatype.c
index b3c8f66..4f74c06 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -717,7 +717,7 @@ void rt_symbol_table_free(struct symbol_table *tbl)
 }
 
 static struct symbol_table *mark_tbl;
-static void __init mark_table_init(void)
+void mark_table_init(void)
 {
 	mark_tbl = rt_symbol_table_init("/etc/iproute2/rt_marks");
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
index 7fbf00a..301bce0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -262,6 +262,20 @@ err1:
 	return ret;
 }
 
+void nft_init(void)
+{
+        mark_table_init();
+        realm_table_rt_init();
+        devgroup_table_init();
+        realm_table_meta_init();
+        ct_label_table_init();
+        netlink_open_sock();
+        gmp_init();
+#ifdef HAVE_LIBXTABLES
+         xt_init();
+#endif
+}
+
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -272,6 +286,7 @@ int main(int argc, char * const *argv)
 	bool interactive = false;
 	int i, val, rc = NFT_EXIT_SUCCESS;
 
+	nft_init();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
diff --git a/src/meta.c b/src/meta.c
index e9334b8..4fb26d5 100644
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
@@ -333,7 +333,7 @@ const struct datatype pkttype_type = {
 };
 
 static struct symbol_table *devgroup_tbl;
-static void __init devgroup_table_init(void)
+void devgroup_table_init(void)
 {
 	devgroup_tbl = rt_symbol_table_init("/etc/iproute2/group");
 }
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
diff --git a/src/rt.c b/src/rt.c
index 530ebe6..5f57cf0 100644
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

