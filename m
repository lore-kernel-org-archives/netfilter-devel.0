Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B309EC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 10:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F12924676
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 10:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLSK73 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 05:59:29 -0500
Received: from correo.us.es ([193.147.175.20]:35016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfLSK73 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 05:59:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D15CE1022A3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 11:59:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3230DA70A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 11:59:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B8DCCDA70F; Thu, 19 Dec 2019 11:59:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A603BDA70A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 11:59:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Dec 2019 11:59:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 92FF042EF42B
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 11:59:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: clean up entries on NETDEV_UNREGISTER
Date:   Thu, 19 Dec 2019 11:59:21 +0100
Message-Id: <20191219105921.344674-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call nf_flow_table_iterate_cleanup() to remove flowtable entries that
belong to the net_device that is being unregistered.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h   | 4 ++++
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 1 +
 net/netfilter/nf_flow_table_core.c      | 4 ++--
 net/netfilter/nf_flow_table_inet.c      | 1 +
 net/netfilter/nf_tables_api.c           | 1 +
 6 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f0897b3c97fb..43943567dc2e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -27,6 +27,8 @@ struct nf_flowtable_type {
 						  const struct flow_offload *flow,
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
+	void				(*cleanup)(struct nf_flowtable *ft,
+						   struct net_device *dev);
 	void				(*free)(struct nf_flowtable *ft);
 	nf_hookfn			*hook;
 	struct module			*owner;
@@ -122,6 +124,8 @@ int flow_offload_route_init(struct flow_offload *flow,
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
+				   struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index e32e41b99f0f..6f20f8034eb3 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -11,6 +11,7 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
 	.action		= nf_flow_rule_route_ipv4,
+	.cleanup	= nf_flow_table_iterate_cleanup,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index a8566ee12e83..ed93b0a6d11a 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -12,6 +12,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
 	.action		= nf_flow_rule_route_ipv6,
+	.cleanup	= nf_flow_table_iterate_cleanup,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9889d52eda82..9a7421e2b039 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -532,8 +532,8 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 		flow_offload_dead(flow);
 }
 
-static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-					  struct net_device *dev)
+void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
+				   struct net_device *dev)
 {
 	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 88bedf1ff1ae..487541cd2d09 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -49,6 +49,7 @@ static struct nf_flowtable_type flowtable_inet = {
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
 	.action		= nf_flow_rule_route_inet,
+	.cleanup	= nf_flow_table_iterate_cleanup,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 062b73a83af0..f339bd9376b6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6490,6 +6490,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			continue;
 
 		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
+		flowtable->data.type->cleanup(&flowtable->data, dev);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 		break;
-- 
2.11.0

