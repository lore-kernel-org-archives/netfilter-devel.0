From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: ipt_CLUSTERIP: deprecate it in favour of xt_cluster
Date: Mon,  2 Mar 2015 14:40:39 +0100
Message-ID: <1425303640-20564-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42283 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbbCBNhJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 08:37:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_cluster supersedes ipt_CLUSTERIP since it can be also used in
gateway configurations (not only from the backend side).

ipt_CLUSTER is also known to leak the netdev that it uses on
device removal, which requires a rather large fix to workaround
the problem: http://patchwork.ozlabs.org/patch/358629/

So let's deprecate this so we can probably kill code this in the
future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/x_tables.h       |    1 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index c24060e..4d6597a 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -9,6 +9,7 @@ struct ebt_table;
 struct netns_xt {
 	struct list_head tables[NFPROTO_NUMPROTO];
 	bool notrack_deprecated_warning;
+	bool clusterip_deprecated_warning;
 #if defined(CONFIG_BRIDGE_NF_EBTABLES) || \
     defined(CONFIG_BRIDGE_NF_EBTABLES_MODULE)
 	struct ebt_table *broute_table;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index a287e02..e69a6d8 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -423,6 +423,13 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
+
+	if (!par->net->xt.clusterip_deprecated_warning) {
+		pr_info("ipt_CLUSTERIP is deprecated and it will removed soon, "
+			"use xt_cluster instead\n");
+		par->net->xt.clusterip_deprecated_warning = true;
+	}
+
 	return ret;
 }
 
-- 
1.7.10.4

