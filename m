From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf V2 1/2] netfilter: introduce nf_conntrack_helper_put helper function
Date: Sun,  7 May 2017 22:01:55 +0800
Message-ID: <20170507140156.16487-2-zlpnobody@163.com>
References: <20170507140156.16487-1-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:38381 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754772AbdEGVsq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2017 17:48:46 -0400
In-Reply-To: <20170507140156.16487-1-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

And convert module_put invocation to nf_conntrack_helper_put, this is
prepared for the followup patch, which will add a refcnt for cthelper,
so we can reject the deleting request when cthelper is in use.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: update nft_ct helper obj

 include/net/netfilter/nf_conntrack_helper.h | 2 ++
 net/netfilter/nf_conntrack_helper.c         | 6 ++++++
 net/netfilter/nft_ct.c                      | 4 ++--
 net/netfilter/xt_CT.c                       | 6 +++---
 net/openvswitch/conntrack.c                 | 4 ++--
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index e04fa769..c1c12411 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -79,6 +79,8 @@ struct nf_conntrack_helper *__nf_conntrack_helper_find(const char *name,
 struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
 							       u16 l3num,
 							       u8 protonum);
+void nf_conntrack_helper_put(struct nf_conntrack_helper *helper);
+
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		       u16 l3num, u16 protonum, const char *name,
 		       u16 default_port, u16 spec_port, u32 id,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 3a60efa..e17006b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -181,6 +181,12 @@ nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
 
+void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
+{
+	module_put(helper->me);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
+
 struct nf_conn_help *
 nf_ct_helper_ext_add(struct nf_conn *ct,
 		     struct nf_conntrack_helper *helper, gfp_t gfp)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a34ceb3..1678e9e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -826,9 +826,9 @@ static void nft_ct_helper_obj_destroy(struct nft_object *obj)
 	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
 
 	if (priv->helper4)
-		module_put(priv->helper4->me);
+		nf_conntrack_helper_put(priv->helper4);
 	if (priv->helper6)
-		module_put(priv->helper6->me);
+		nf_conntrack_helper_put(priv->helper6);
 }
 
 static void nft_ct_helper_obj_eval(struct nft_object *obj,
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index bb7ad82..623ef37 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -96,7 +96,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 
 	help = nf_ct_helper_ext_add(ct, helper, GFP_KERNEL);
 	if (help == NULL) {
-		module_put(helper->me);
+		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
 	}
 
@@ -263,7 +263,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 err4:
 	help = nfct_help(ct);
 	if (help)
-		module_put(help->helper->me);
+		nf_conntrack_helper_put(help->helper);
 err3:
 	nf_ct_tmpl_free(ct);
 err2:
@@ -346,7 +346,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	if (ct) {
 		help = nfct_help(ct);
 		if (help)
-			module_put(help->helper->me);
+			nf_conntrack_helper_put(help->helper);
 
 		nf_ct_netns_put(par->net, par->family);
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index bf602e3..08679eb 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1123,7 +1123,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 
 	help = nf_ct_helper_ext_add(info->ct, helper, GFP_KERNEL);
 	if (!help) {
-		module_put(helper->me);
+		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
 	}
 
@@ -1584,7 +1584,7 @@ void ovs_ct_free_action(const struct nlattr *a)
 static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info)
 {
 	if (ct_info->helper)
-		module_put(ct_info->helper->me);
+		nf_conntrack_helper_put(ct_info->helper);
 	if (ct_info->ct)
 		nf_ct_tmpl_free(ct_info->ct);
 }
-- 
2.9.3


