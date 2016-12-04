From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: fix build failure with CONNTRACK=n NF_DEFRAG=y
Date: Sun,  4 Dec 2016 23:37:22 +0100
Message-ID: <1480891042-6731-1-git-send-email-fw@strlen.de>
References: <201612050556.WPB56g03%fengguang.wu@intel.com>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34944 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751230AbcLDWh1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 17:37:27 -0500
In-Reply-To: <201612050556.WPB56g03%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

conntrack depends on defrag support, but not vice versa, so we cannot
place defrag_ipv4/6 into netns->ct:

net/ipv4/netfilter/nf_defrag_ipv4.c:110:9: error: 'struct net' has no member named 'ct'

Move it into net->nf.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, if you prefer to squash I have no objections.

 include/net/netns/conntrack.h             |  2 --
 include/net/netns/netfilter.h             |  6 ++++++
 net/ipv4/netfilter/nf_defrag_ipv4.c       | 10 +++++-----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c | 10 +++++-----
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 2a6af004e2f8..cf799fc3fdec 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -124,8 +124,6 @@ struct netns_ct {
 	int			sysctl_acct;
 	int			sysctl_auto_assign_helper;
 	bool			auto_assign_helper_warned;
-	bool			defrag_ipv4;
-	bool			defrag_ipv6;
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 58487b1cc99a..cea396b53a60 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -17,5 +17,11 @@ struct netns_nf {
 	struct ctl_table_header *nf_log_dir_header;
 #endif
 	struct nf_hook_entry __rcu *hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
+	bool			defrag_ipv4;
+#endif
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
+	bool			defrag_ipv6;
+#endif
 };
 #endif
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 8f72e4f172be..49bd6a54404f 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -107,10 +107,10 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 
 static void __net_exit defrag4_net_exit(struct net *net)
 {
-	if (net->ct.defrag_ipv4) {
+	if (net->nf.defrag_ipv4) {
 		nf_unregister_net_hooks(net, ipv4_defrag_ops,
 					ARRAY_SIZE(ipv4_defrag_ops));
-		net->ct.defrag_ipv4 = false;
+		net->nf.defrag_ipv4 = false;
 	}
 }
 
@@ -134,17 +134,17 @@ int nf_defrag_ipv4_enable(struct net *net)
 
 	might_sleep();
 
-	if (net->ct.defrag_ipv4)
+	if (net->nf.defrag_ipv4)
 		return 0;
 
 	mutex_lock(&defrag4_mutex);
-	if (net->ct.defrag_ipv4)
+	if (net->nf.defrag_ipv4)
 		goto out_unlock;
 
 	err = nf_register_net_hooks(net, ipv4_defrag_ops,
 				    ARRAY_SIZE(ipv4_defrag_ops));
 	if (err == 0)
-		net->ct.defrag_ipv4 = true;
+		net->nf.defrag_ipv4 = true;
 
  out_unlock:
 	mutex_unlock(&defrag4_mutex);
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index b6ad889b165b..8e0bdd058787 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -91,10 +91,10 @@ static struct nf_hook_ops ipv6_defrag_ops[] = {
 
 static void __net_exit defrag6_net_exit(struct net *net)
 {
-	if (net->ct.defrag_ipv6) {
+	if (net->nf.defrag_ipv6) {
 		nf_unregister_net_hooks(net, ipv6_defrag_ops,
 					ARRAY_SIZE(ipv6_defrag_ops));
-		net->ct.defrag_ipv6 = false;
+		net->nf.defrag_ipv6 = false;
 	}
 }
 
@@ -136,17 +136,17 @@ int nf_defrag_ipv6_enable(struct net *net)
 
 	might_sleep();
 
-	if (net->ct.defrag_ipv6)
+	if (net->nf.defrag_ipv6)
 		return 0;
 
 	mutex_lock(&defrag6_mutex);
-	if (net->ct.defrag_ipv6)
+	if (net->nf.defrag_ipv6)
 		goto out_unlock;
 
 	err = nf_register_net_hooks(net, ipv6_defrag_ops,
 				    ARRAY_SIZE(ipv6_defrag_ops));
 	if (err == 0)
-		net->ct.defrag_ipv6 = true;
+		net->nf.defrag_ipv6 = true;
 
  out_unlock:
 	mutex_unlock(&defrag6_mutex);
-- 
2.7.3

