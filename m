Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E4C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFCF20781
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406247AbgFYS0z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:26:55 -0400
Received: from correo.us.es ([193.147.175.20]:33522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406217AbgFYS0u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69B44FC604
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D8B2DA84F
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 531F1DA84B; Thu, 25 Jun 2020 20:26:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1898BDA789;
        Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DCCDD42EE38F;
        Thu, 25 Jun 2020 20:26:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/7] netfilter: ip6tables: Add a .pre_exit hook in all ip6table_foo.c.
Date:   Thu, 25 Jun 2020 20:26:34 +0200
Message-Id: <20200625182635.1958-7-pablo@netfilter.org>
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

Using new helpers ip6t_unregister_table_pre_exit() and
ip6t_unregister_table_exit().

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6table_filter.c   | 10 +++++++++-
 net/ipv6/netfilter/ip6table_mangle.c   | 10 +++++++++-
 net/ipv6/netfilter/ip6table_nat.c      | 10 ++++++++--
 net/ipv6/netfilter/ip6table_raw.c      | 10 +++++++++-
 net/ipv6/netfilter/ip6table_security.c | 10 +++++++++-
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 32667f5d5a33..88337b51ffbf 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -73,16 +73,24 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit ip6table_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_filter)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_filter,
+					       filter_ops);
+}
+
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_filter)
 		return;
-	ip6t_unregister_table(net, net->ipv6.ip6table_filter, filter_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_filter);
 	net->ipv6.ip6table_filter = NULL;
 }
 
 static struct pernet_operations ip6table_filter_net_ops = {
 	.init = ip6table_filter_net_init,
+	.pre_exit = ip6table_filter_net_pre_exit,
 	.exit = ip6table_filter_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 070afb97fa2b..1a2748611e00 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -93,16 +93,24 @@ static int __net_init ip6table_mangle_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_mangle_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_mangle)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_mangle,
+					       mangle_ops);
+}
+
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_mangle)
 		return;
 
-	ip6t_unregister_table(net, net->ipv6.ip6table_mangle, mangle_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_mangle);
 	net->ipv6.ip6table_mangle = NULL;
 }
 
 static struct pernet_operations ip6table_mangle_net_ops = {
+	.pre_exit = ip6table_mangle_net_pre_exit,
 	.exit = ip6table_mangle_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 0f4875952efc..0a23265e3caa 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -114,16 +114,22 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_nat_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_nat)
+		ip6t_nat_unregister_lookups(net);
+}
+
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_nat)
 		return;
-	ip6t_nat_unregister_lookups(net);
-	ip6t_unregister_table(net, net->ipv6.ip6table_nat, NULL);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_nat);
 	net->ipv6.ip6table_nat = NULL;
 }
 
 static struct pernet_operations ip6table_nat_net_ops = {
+	.pre_exit = ip6table_nat_net_pre_exit,
 	.exit	= ip6table_nat_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index a22100b1cf2c..8f9e742226f7 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -66,15 +66,23 @@ static int __net_init ip6table_raw_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_raw_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_raw)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_raw,
+					       rawtable_ops);
+}
+
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_raw)
 		return;
-	ip6t_unregister_table(net, net->ipv6.ip6table_raw, rawtable_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_raw);
 	net->ipv6.ip6table_raw = NULL;
 }
 
 static struct pernet_operations ip6table_raw_net_ops = {
+	.pre_exit = ip6table_raw_net_pre_exit,
 	.exit = ip6table_raw_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index a74335fe2bd9..5e8c48fed032 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -61,15 +61,23 @@ static int __net_init ip6table_security_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_security_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_security)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_security,
+					       sectbl_ops);
+}
+
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_security)
 		return;
-	ip6t_unregister_table(net, net->ipv6.ip6table_security, sectbl_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_security);
 	net->ipv6.ip6table_security = NULL;
 }
 
 static struct pernet_operations ip6table_security_net_ops = {
+	.pre_exit = ip6table_security_net_pre_exit,
 	.exit = ip6table_security_net_exit,
 };
 
-- 
2.20.1

