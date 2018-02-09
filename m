From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 3/9] netfilter: xt_CT: use pr ratelimiting
Date: Fri,  9 Feb 2018 15:52:01 +0100
Message-ID: <20180209145207.2097-4-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46628 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbeBIOz2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:28 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

checkpatch complains about line > 80 but this would require splitting
"literal" over two lines which is worse.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.
 net/netfilter/xt_CT.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 5a152e2acfd5..8790190c6feb 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -82,15 +82,14 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 
 	proto = xt_ct_find_proto(par);
 	if (!proto) {
-		pr_info("You must specify a L4 protocol, and not use "
-			"inversions on it.\n");
+		pr_info_ratelimited("You must specify a L4 protocol and not use inversions on it\n");
 		return -ENOENT;
 	}
 
 	helper = nf_conntrack_helper_try_module_get(helper_name, par->family,
 						    proto);
 	if (helper == NULL) {
-		pr_info("No such helper \"%s\"\n", helper_name);
+		pr_info_ratelimited("No such helper \"%s\"\n", helper_name);
 		return -ENOENT;
 	}
 
@@ -124,6 +123,7 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	const struct nf_conntrack_l4proto *l4proto;
 	struct ctnl_timeout *timeout;
 	struct nf_conn_timeout *timeout_ext;
+	const char *errmsg = NULL;
 	int ret = 0;
 	u8 proto;
 
@@ -131,29 +131,29 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	timeout_find_get = rcu_dereference(nf_ct_timeout_find_get_hook);
 	if (timeout_find_get == NULL) {
 		ret = -ENOENT;
-		pr_info("Timeout policy base is empty\n");
+		errmsg = "Timeout policy base is empty";
 		goto out;
 	}
 
 	proto = xt_ct_find_proto(par);
 	if (!proto) {
 		ret = -EINVAL;
-		pr_info("You must specify a L4 protocol, and not use "
-			"inversions on it.\n");
+		errmsg = "You must specify a L4 protocol and not use inversions on it";
 		goto out;
 	}
 
 	timeout = timeout_find_get(par->net, timeout_name);
 	if (timeout == NULL) {
 		ret = -ENOENT;
-		pr_info("No such timeout policy \"%s\"\n", timeout_name);
+		pr_info_ratelimited("No such timeout policy \"%s\"\n",
+				    timeout_name);
 		goto out;
 	}
 
 	if (timeout->l3num != par->family) {
 		ret = -EINVAL;
-		pr_info("Timeout policy `%s' can only be used by L3 protocol "
-			"number %d\n", timeout_name, timeout->l3num);
+		pr_info_ratelimited("Timeout policy `%s' can only be used by L%d protocol number %d\n",
+				    timeout_name, 3, timeout->l3num);
 		goto err_put_timeout;
 	}
 	/* Make sure the timeout policy matches any existing protocol tracker,
@@ -162,9 +162,8 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	l4proto = __nf_ct_l4proto_find(par->family, proto);
 	if (timeout->l4proto->l4proto != l4proto->l4proto) {
 		ret = -EINVAL;
-		pr_info("Timeout policy `%s' can only be used by L4 protocol "
-			"number %d\n",
-			timeout_name, timeout->l4proto->l4proto);
+		pr_info_ratelimited("Timeout policy `%s' can only be used by L%d protocol number %d\n",
+				    timeout_name, 4, timeout->l4proto->l4proto);
 		goto err_put_timeout;
 	}
 	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
@@ -180,6 +179,8 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	__xt_ct_tg_timeout_put(timeout);
 out:
 	rcu_read_unlock();
+	if (errmsg)
+		pr_info_ratelimited("%s\n", errmsg);
 	return ret;
 #else
 	return -EOPNOTSUPP;
-- 
2.13.6

