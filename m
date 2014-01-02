From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/2] netfilter: CT: factorize reusable code
Date: Thu,  2 Jan 2014 10:12:55 +0100
Message-ID: <1388653976-30802-2-git-send-email-eric@regit.org>
References: <1388653976-30802-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54805 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABJNQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:13:16 -0500
In-Reply-To: <1388653976-30802-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/net/netfilter/nf_ct_set.h | 137 ++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_CT.c             | 143 +++-----------------------------------
 2 files changed, 145 insertions(+), 135 deletions(-)
 create mode 100644 include/net/netfilter/nf_ct_set.h

diff --git a/include/net/netfilter/nf_ct_set.h b/include/net/netfilter/nf_ct_set.h
new file mode 100644
index 0000000..6f7d8cb
--- /dev/null
+++ b/include/net/netfilter/nf_ct_set.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (c) 2014 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_timeout.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+
+static int
+nf_ct_set_helper(struct nf_conn *ct, const char *helper_name, u8 proto,
+		u8 family)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+
+	if (!proto) {
+		pr_info("You must specify a L4 protocol, and not use "
+			"inversions on it.\n");
+		return -ENOENT;
+	}
+
+	helper = nf_conntrack_helper_try_module_get(helper_name, family,
+						    proto);
+	if (helper == NULL) {
+		pr_info("No such helper \"%s\"\n", helper_name);
+		return -ENOENT;
+	}
+
+	help = nf_ct_helper_ext_add(ct, helper, GFP_KERNEL);
+	if (help == NULL) {
+		module_put(helper->me);
+		return -ENOMEM;
+	}
+
+	help->helper = helper;
+	return 0;
+}
+
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+static void __nf_ct_tg_timeout_put(struct ctnl_timeout *timeout)
+{
+	typeof(nf_ct_timeout_put_hook) timeout_put;
+
+	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
+	if (timeout_put)
+		timeout_put(timeout);
+}
+#endif
+
+static int
+nf_ct_set_timeout(struct nf_conn *ct, u8 proto, u8 family,
+		  const char *timeout_name)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	typeof(nf_ct_timeout_find_get_hook) timeout_find_get;
+	struct ctnl_timeout *timeout;
+	struct nf_conn_timeout *timeout_ext;
+	struct nf_conntrack_l4proto *l4proto;
+	int ret = 0;
+
+	rcu_read_lock();
+	timeout_find_get = rcu_dereference(nf_ct_timeout_find_get_hook);
+	if (timeout_find_get == NULL) {
+		ret = -ENOENT;
+		pr_info("Timeout policy base is empty\n");
+		goto out;
+	}
+
+	if (!proto) {
+		ret = -EINVAL;
+		pr_info("You must specify a L4 protocol, and not use "
+			"inversions on it.\n");
+		goto out;
+	}
+
+	timeout = timeout_find_get(timeout_name);
+	if (timeout == NULL) {
+		ret = -ENOENT;
+		pr_info("No such timeout policy \"%s\"\n", timeout_name);
+		goto out;
+	}
+
+	if (timeout->l3num != family) {
+		ret = -EINVAL;
+		pr_info("Timeout policy `%s' can only be used by L3 protocol "
+			"number %d\n", timeout_name, timeout->l3num);
+		goto err_put_timeout;
+	}
+	/* Make sure the timeout policy matches any existing protocol tracker,
+	 * otherwise default to generic.
+	 */
+	l4proto = __nf_ct_l4proto_find(family, proto);
+	if (timeout->l4proto->l4proto != l4proto->l4proto) {
+		ret = -EINVAL;
+		pr_info("Timeout policy `%s' can only be used by L4 protocol "
+			"number %d\n",
+			timeout_name, timeout->l4proto->l4proto);
+		goto err_put_timeout;
+	}
+	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
+	if (timeout_ext == NULL)
+		ret = -ENOMEM;
+
+err_put_timeout:
+	__nf_ct_tg_timeout_put(timeout);
+out:
+	rcu_read_unlock();
+	return ret;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static void nf_ct_destroy_timeout(struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	struct nf_conn_timeout *timeout_ext;
+	typeof(nf_ct_timeout_put_hook) timeout_put;
+
+	rcu_read_lock();
+	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
+
+	if (timeout_put) {
+		timeout_ext = nf_ct_timeout_find(ct);
+		if (timeout_ext)
+			timeout_put(timeout_ext->timeout);
+	}
+	rcu_read_unlock();
+#endif
+}
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 5929be6..e4190bc 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -14,11 +14,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CT.h>
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_conntrack_ecache.h>
-#include <net/netfilter/nf_conntrack_timeout.h>
-#include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_ct_set.h>
 
 static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 {
@@ -72,121 +68,13 @@ static u8 xt_ct_find_proto(const struct xt_tgchk_param *par)
 		return 0;
 }
 
-static int
-xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
-		 const struct xt_tgchk_param *par)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conn_help *help;
-	u8 proto;
-
-	proto = xt_ct_find_proto(par);
-	if (!proto) {
-		pr_info("You must specify a L4 protocol, and not use "
-			"inversions on it.\n");
-		return -ENOENT;
-	}
-
-	helper = nf_conntrack_helper_try_module_get(helper_name, par->family,
-						    proto);
-	if (helper == NULL) {
-		pr_info("No such helper \"%s\"\n", helper_name);
-		return -ENOENT;
-	}
-
-	help = nf_ct_helper_ext_add(ct, helper, GFP_KERNEL);
-	if (help == NULL) {
-		module_put(helper->me);
-		return -ENOMEM;
-	}
-
-	help->helper = helper;
-	return 0;
-}
-
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-static void __xt_ct_tg_timeout_put(struct ctnl_timeout *timeout)
-{
-	typeof(nf_ct_timeout_put_hook) timeout_put;
-
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
-	if (timeout_put)
-		timeout_put(timeout);
-}
-#endif
-
-static int
-xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
-		  const char *timeout_name)
-{
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	typeof(nf_ct_timeout_find_get_hook) timeout_find_get;
-	struct ctnl_timeout *timeout;
-	struct nf_conn_timeout *timeout_ext;
-	struct nf_conntrack_l4proto *l4proto;
-	int ret = 0;
-	u8 proto;
-
-	rcu_read_lock();
-	timeout_find_get = rcu_dereference(nf_ct_timeout_find_get_hook);
-	if (timeout_find_get == NULL) {
-		ret = -ENOENT;
-		pr_info("Timeout policy base is empty\n");
-		goto out;
-	}
-
-	proto = xt_ct_find_proto(par);
-	if (!proto) {
-		ret = -EINVAL;
-		pr_info("You must specify a L4 protocol, and not use "
-			"inversions on it.\n");
-		goto out;
-	}
-
-	timeout = timeout_find_get(timeout_name);
-	if (timeout == NULL) {
-		ret = -ENOENT;
-		pr_info("No such timeout policy \"%s\"\n", timeout_name);
-		goto out;
-	}
-
-	if (timeout->l3num != par->family) {
-		ret = -EINVAL;
-		pr_info("Timeout policy `%s' can only be used by L3 protocol "
-			"number %d\n", timeout_name, timeout->l3num);
-		goto err_put_timeout;
-	}
-	/* Make sure the timeout policy matches any existing protocol tracker,
-	 * otherwise default to generic.
-	 */
-	l4proto = __nf_ct_l4proto_find(par->family, proto);
-	if (timeout->l4proto->l4proto != l4proto->l4proto) {
-		ret = -EINVAL;
-		pr_info("Timeout policy `%s' can only be used by L4 protocol "
-			"number %d\n",
-			timeout_name, timeout->l4proto->l4proto);
-		goto err_put_timeout;
-	}
-	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
-	if (timeout_ext == NULL)
-		ret = -ENOMEM;
-
-err_put_timeout:
-	__xt_ct_tg_timeout_put(timeout);
-out:
-	rcu_read_unlock();
-	return ret;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
 static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
 	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
 	int ret = -EOPNOTSUPP;
+	u8 proto = 0;
 
 	if (info->flags & XT_CT_NOTRACK) {
 		ct = NULL;
@@ -217,13 +105,16 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	}
 
 	if (info->helper[0]) {
-		ret = xt_ct_set_helper(ct, info->helper, par);
+		proto = xt_ct_find_proto(par);
+		ret = nf_ct_set_helper(ct, info->helper, proto, par->family);
 		if (ret < 0)
 			goto err3;
 	}
 
 	if (info->timeout[0]) {
-		ret = xt_ct_set_timeout(ct, par, info->timeout);
+		if (!proto)
+			proto = xt_ct_find_proto(par);
+		ret = nf_ct_set_timeout(ct, proto, par->family, info->timeout);
 		if (ret < 0)
 			goto err3;
 	}
@@ -291,24 +182,6 @@ static int xt_ct_tg_check_v2(const struct xt_tgchk_param *par)
 	return xt_ct_tg_check(par, par->targinfo);
 }
 
-static void xt_ct_destroy_timeout(struct nf_conn *ct)
-{
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	struct nf_conn_timeout *timeout_ext;
-	typeof(nf_ct_timeout_put_hook) timeout_put;
-
-	rcu_read_lock();
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
-
-	if (timeout_put) {
-		timeout_ext = nf_ct_timeout_find(ct);
-		if (timeout_ext)
-			timeout_put(timeout_ext->timeout);
-	}
-	rcu_read_unlock();
-#endif
-}
-
 static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 			     struct xt_ct_target_info_v1 *info)
 {
@@ -322,7 +195,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 
 		nf_ct_l3proto_module_put(par->family);
 
-		xt_ct_destroy_timeout(ct);
+		nf_ct_destroy_timeout(ct);
 		nf_ct_put(info->ct);
 	}
 }
-- 
1.8.5.2

