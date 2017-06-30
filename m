From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 3/3] include: Remove __exit macro definition.
Date: Fri, 30 Jun 2017 14:58:05 +0530
Message-ID: <90f68a721415bb1574e4107f08eafd2e8e191737.1498814530.git.rvarsha016@gmail.com>
References: <cover.1498814530.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34349 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdF3J2L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2017 05:28:11 -0400
Received: by mail-pf0-f195.google.com with SMTP id c24so1825820pfe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 02:28:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1498814530.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add nft_exit function, which calls _exit functions in main.c file.
Remove __exit macro definition as libnftables library will be created
soon. Rename realm_table_exit() function to avoid ambiguity as
realm_table_rt_exit() and realm_table_meta_exit() in rt.c and meta.c
files.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/nftables.h |  9 +++++++++
 include/utils.h    |  1 -
 src/ct.c           |  2 +-
 src/datatype.c     |  2 +-
 src/main.c         | 11 +++++++++++
 src/meta.c         |  4 ++--
 src/netlink.c      |  2 +-
 src/rt.c           |  2 +-
 8 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index b188b9e..5d1a783 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -117,6 +117,7 @@ struct parser_state;
 
 int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
 	    struct list_head *msgs);
+
 void ct_label_table_init(void);
 void mark_table_init(void);
 void gmp_init(void);
@@ -127,4 +128,12 @@ void realm_table_meta_init(void);
 void xt_init(void);
 void nft_init(void);
 
+void ct_label_table_exit(void);
+void mark_table_exit(void);
+void realm_table_meta_exit(void);
+void devgroup_table_exit(void);
+void netlink_close_sock(void);
+void realm_table_rt_exit(void);
+void nft_exit(void);
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/utils.h b/include/utils.h
index 0c3341b..0605eee 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -32,7 +32,6 @@
 #define __gmp_fmtstring(x, y)
 #endif
 
-#define __exit			__attribute__((destructor))
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
 
diff --git a/src/ct.c b/src/ct.c
index 25efc70..d64f467 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -210,7 +210,7 @@ void ct_label_table_init(void)
 	ct_label_tbl = rt_symbol_table_init(CONNLABEL_CONF);
 }
 
-static void __exit ct_label_table_exit(void)
+void ct_label_table_exit(void)
 {
 	rt_symbol_table_free(ct_label_tbl);
 }
diff --git a/src/datatype.c b/src/datatype.c
index 4f74c06..0d5ba51 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -722,7 +722,7 @@ void mark_table_init(void)
 	mark_tbl = rt_symbol_table_init("/etc/iproute2/rt_marks");
 }
 
-static void __exit mark_table_exit(void)
+void mark_table_exit(void)
 {
 	rt_symbol_table_free(mark_tbl);
 }
diff --git a/src/main.c b/src/main.c
index 301bce0..5da8bee 100644
--- a/src/main.c
+++ b/src/main.c
@@ -276,6 +276,16 @@ void nft_init(void)
 #endif
 }
 
+void nft_exit(void)
+{
+	netlink_close_sock();
+	ct_label_table_exit();
+	realm_table_rt_exit();
+	devgroup_table_exit();
+	realm_table_meta_exit();
+	mark_table_exit();
+}
+
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -412,6 +422,7 @@ out:
 	xfree(buf);
 	cache_release();
 	iface_cache_release();
+	nft_exit();
 
 	return rc;
 }
diff --git a/src/meta.c b/src/meta.c
index 4fb26d5..9c80893 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -42,7 +42,7 @@ void realm_table_meta_init(void)
 	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
 
-static void __exit realm_table_exit(void)
+void realm_table_meta_exit(void)
 {
 	rt_symbol_table_free(realm_tbl);
 }
@@ -338,7 +338,7 @@ void devgroup_table_init(void)
 	devgroup_tbl = rt_symbol_table_init("/etc/iproute2/group");
 }
 
-static void __exit devgroup_table_exit(void)
+void devgroup_table_exit(void)
 {
 	rt_symbol_table_free(devgroup_tbl);
 }
diff --git a/src/netlink.c b/src/netlink.c
index 3993aa1..6d466c0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -67,7 +67,7 @@ void netlink_open_sock(void)
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 }
 
-static void __exit netlink_close_sock(void)
+void netlink_close_sock(void)
 {
 	if (nf_sock)
 		mnl_socket_close(nf_sock);
diff --git a/src/rt.c b/src/rt.c
index 5f57cf0..cd2d5a4 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -29,7 +29,7 @@ void realm_table_rt_init(void)
 	realm_tbl = rt_symbol_table_init("/etc/iproute2/rt_realms");
 }
 
-static void __exit realm_table_exit(void)
+void realm_table_rt_exit(void)
 {
 	rt_symbol_table_free(realm_tbl);
 }
-- 
2.9.4

