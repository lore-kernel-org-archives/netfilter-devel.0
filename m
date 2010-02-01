From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: CONFIG_COMPAT redux
Date: Mon, 1 Feb 2010 21:43:00 +0200
Message-ID: <20100201194259.GA21315@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46516 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0BATnG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:43:06 -0500
Received: by mail-fx0-f220.google.com with SMTP id 20so4637957fxm.21
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Feb 2010 11:43:05 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ifdef out
	struct nf_sockopt_ops::compat_set
	struct nf_sockopt_ops::compat_get
	struct xt_match::compat_from_user
	struct xt_match::compat_to_user
	struct xt_match::compatsize
to make structures smaller on COMPAT=n kernels.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/netfilter.h          |    9 ++++++---
 include/linux/netfilter/x_tables.h |   12 ++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -114,15 +114,17 @@ struct nf_sockopt_ops {
 	int set_optmin;
 	int set_optmax;
 	int (*set)(struct sock *sk, int optval, void __user *user, unsigned int len);
+#ifdef CONFIG_COMPAT
 	int (*compat_set)(struct sock *sk, int optval,
 			void __user *user, unsigned int len);
-
+#endif
 	int get_optmin;
 	int get_optmax;
 	int (*get)(struct sock *sk, int optval, void __user *user, int *len);
+#ifdef CONFIG_COMPAT
 	int (*compat_get)(struct sock *sk, int optval,
 			void __user *user, int *len);
-
+#endif
 	/* Use the module struct to lock set/get code in place */
 	struct module *owner;
 };
@@ -222,11 +224,12 @@ int nf_setsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
 		  unsigned int len);
 int nf_getsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
 		  int *len);
-
+#ifdef CONFIG_COMPAT
 int compat_nf_setsockopt(struct sock *sk, u_int8_t pf, int optval,
 		char __user *opt, unsigned int len);
 int compat_nf_getsockopt(struct sock *sk, u_int8_t pf, int optval,
 		char __user *opt, int *len);
+#endif
 
 /* Call this before modifying an existing packet: ensures it is
    modifiable and linear to the point you care about (writable_len).
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -283,11 +283,11 @@ struct xt_match {
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
-
+#ifdef CONFIG_COMPAT
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
 	int (*compat_to_user)(void __user *dst, void *src);
-
+#endif
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
@@ -296,7 +296,9 @@ struct xt_match {
 
 	const char *table;
 	unsigned int matchsize;
+#ifdef CONFIG_COMPAT
 	unsigned int compatsize;
+#endif
 	unsigned int hooks;
 	unsigned short proto;
 
@@ -323,17 +325,19 @@ struct xt_target {
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_tgdtor_param *);
-
+#ifdef CONFIG_COMPAT
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
 	int (*compat_to_user)(void __user *dst, void *src);
-
+#endif
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
 	const char *table;
 	unsigned int targetsize;
+#ifdef CONFIG_COMPAT
 	unsigned int compatsize;
+#endif
 	unsigned int hooks;
 	unsigned short proto;
 
