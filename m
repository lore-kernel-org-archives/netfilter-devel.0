Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5016DC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E9652080C
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406230AbgFYS0t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:26:49 -0400
Received: from correo.us.es ([193.147.175.20]:33512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406196AbgFYS0s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D13ECFC5F7
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C34C4DA859
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE957DA801; Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75E04DA853;
        Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4B0F242EE38F;
        Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/7] netfilter: iptables: Split ipt_unregister_table() into pre_exit and exit helpers.
Date:   Thu, 25 Jun 2020 20:26:31 +0200
Message-Id: <20200625182635.1958-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200625182635.1958-1-pablo@netfilter.org>
References: <20200625182635.1958-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: David Wilder <dwilder@us.ibm.com>

The pre_exit will un-register the underlying hook and .exit will do the
table freeing. The netns core does an unconditional synchronize_rcu after
the pre_exit hooks insuring no packets are in flight that have picked up
the pointer before completing the un-register.

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4/ip_tables.h |  6 ++++++
 net/ipv4/netfilter/ip_tables.c           | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index b394bd4f68a3..c4676d6feeff 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -25,6 +25,12 @@
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *ops, struct xt_table **res);
+
+void ipt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+		       const struct nf_hook_ops *ops);
+
+void ipt_unregister_table_exit(struct net *net, struct xt_table *table);
+
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops);
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c2670eaa74e6..5bf9fa06aee0 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1797,11 +1797,22 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 	return ret;
 }
 
+void ipt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				   const struct nf_hook_ops *ops)
+{
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+
+void ipt_unregister_table_exit(struct net *net, struct xt_table *table)
+{
+	__ipt_unregister_table(net, table);
+}
+
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops)
 {
 	if (ops)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		ipt_unregister_table_pre_exit(net, table, ops);
 	__ipt_unregister_table(net, table);
 }
 
@@ -1958,6 +1969,8 @@ static void __exit ip_tables_fini(void)
 
 EXPORT_SYMBOL(ipt_register_table);
 EXPORT_SYMBOL(ipt_unregister_table);
+EXPORT_SYMBOL(ipt_unregister_table_pre_exit);
+EXPORT_SYMBOL(ipt_unregister_table_exit);
 EXPORT_SYMBOL(ipt_do_table);
 module_init(ip_tables_init);
 module_exit(ip_tables_fini);
-- 
2.20.1

