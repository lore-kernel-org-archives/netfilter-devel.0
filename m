From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 1/2] netfilter: introduce nf_conntrack_helper_put helper function
Date: Sun,  9 Apr 2017 16:22:13 +0800
Message-ID: <1491726134-23686-2-git-send-email-zlpnobody@163.com>
References: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:43423 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751817AbdDIIXA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Apr 2017 04:23:00 -0400
In-Reply-To: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

And convert module_put invocation to nf_conntrack_helper_put, this is
prepared for the later patch, which will add a refcnt for cthelper.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 2 ++
 net/netfilter/nf_conntrack_helper.c         | 6 ++++++
 net/netfilter/xt_CT.c                       | 6 +++---
 net/openvswitch/conntrack.c                 | 4 ++--
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 1eaac1f..65e1dcf 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -58,6 +58,8 @@ struct nf_conntrack_helper *__nf_conntrack_helper_find(const char *name,
 struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
 							       u16 l3num,
 							       u8 protonum);
+void nf_conntrack_helper_put(struct nf_conntrack_helper *helper);
+
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		       u16 l3num, u16 protonum, const char *name,
 		       u16 default_port, u16 spec_port, u32 id,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..5275e9a 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -172,6 +172,12 @@ nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
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
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 841cfba..2db42ca 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -95,7 +95,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 
 	help = nf_ct_helper_ext_add(ct, helper, GFP_KERNEL);
 	if (help == NULL) {
-		module_put(helper->me);
+		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
 	}
 
@@ -260,7 +260,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 err4:
 	help = nfct_help(ct);
 	if (help)
-		module_put(help->helper->me);
+		nf_conntrack_helper_put(help->helper);
 err3:
 	nf_ct_tmpl_free(ct);
 err2:
@@ -343,7 +343,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	if (ct && !nf_ct_is_untracked(ct)) {
 		help = nfct_help(ct);
 		if (help)
-			module_put(help->helper->me);
+			nf_conntrack_helper_put(help->helper);
 
 		nf_ct_netns_put(par->net, par->family);
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 7b2c2fc..fd861d9 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1084,7 +1084,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 
 	help = nf_ct_helper_ext_add(info->ct, helper, GFP_KERNEL);
 	if (!help) {
-		module_put(helper->me);
+		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
 	}
 
@@ -1534,7 +1534,7 @@ void ovs_ct_free_action(const struct nlattr *a)
 static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info)
 {
 	if (ct_info->helper)
-		module_put(ct_info->helper->me);
+		nf_conntrack_helper_put(ct_info->helper);
 	if (ct_info->ct)
 		nf_ct_tmpl_free(ct_info->ct);
 }
-- 
2.5.5


