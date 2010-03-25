From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/12] netfilter: xtables: shorten up return clause
Date: Thu, 25 Mar 2010 17:04:24 +0100
Message-ID: <1269533065-22318-13-git-send-email-jengelh@medozas.de>
References: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41701 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0CYQEp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:04:45 -0400
In-Reply-To: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The return value of nf_ct_l3proto_get can directly be returned even in
the case of success.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    7 ++-----
 net/netfilter/xt_CONNSECMARK.c     |    6 ++----
 net/netfilter/xt_connbytes.c       |    7 ++-----
 net/netfilter/xt_connmark.c        |   12 ++++--------
 net/netfilter/xt_conntrack.c       |    6 ++----
 net/netfilter/xt_state.c           |    6 ++----
 6 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1faf5fa..5d70c43 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -403,13 +403,10 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	cipinfo->config = config;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 /* drop reference count of cluster config when rule is deleted */
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 105a62e..e953e30 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -107,12 +107,10 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 	}
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-	return 0;
+	return ret;
 }
 
 static void connsecmark_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 2ff332e..ff738a5 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -109,13 +109,10 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 static void connbytes_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 71e38a1..ae10154 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -79,12 +79,10 @@ static int connmark_tg_check(const struct xt_tgchk_param *par)
 	int ret;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-	return 0;
+	return ret;
 }
 
 static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
@@ -111,12 +109,10 @@ static int connmark_mt_check(const struct xt_mtchk_param *par)
 	int ret;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-	return 0;
+	return ret;
 }
 
 static void connmark_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index e0bcf8d..3348706 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -211,12 +211,10 @@ static int conntrack_mt_check(const struct xt_mtchk_param *par)
 	int ret;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-	return 0;
+	return ret;
 }
 
 static void conntrack_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 2b75230..be00d7b 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -42,12 +42,10 @@ static int state_mt_check(const struct xt_mtchk_param *par)
 	int ret;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
-	if (ret < 0) {
+	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return ret;
-	}
-	return 0;
+	return ret;
 }
 
 static void state_mt_destroy(const struct xt_mtdtor_param *par)
-- 
1.7.0.2

