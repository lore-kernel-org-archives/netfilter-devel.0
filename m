Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24D6C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0E920781
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406269AbgFYS1A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:27:00 -0400
Received: from correo.us.es ([193.147.175.20]:33518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404488AbgFYS0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54DF5FC5E8
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 449E7DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3A3F8DA84F; Thu, 25 Jun 2020 20:26:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08EE6DA73D;
        Thu, 25 Jun 2020 20:26:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D1C8E42EE395;
        Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/7] netfilter: iptables: Add a .pre_exit hook in all iptable_foo.c.
Date:   Thu, 25 Jun 2020 20:26:32 +0200
Message-Id: <20200625182635.1958-5-pablo@netfilter.org>
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

Using new helpers ipt_unregister_table_pre_exit() and
ipt_unregister_table_exit().

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/iptable_filter.c   | 10 +++++++++-
 net/ipv4/netfilter/iptable_mangle.c   | 10 +++++++++-
 net/ipv4/netfilter/iptable_nat.c      | 10 ++++++++--
 net/ipv4/netfilter/iptable_raw.c      | 10 +++++++++-
 net/ipv4/netfilter/iptable_security.c | 11 +++++++++--
 5 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 9d54b4017e50..8f7bc1ee7453 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -72,16 +72,24 @@ static int __net_init iptable_filter_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit iptable_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_filter)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_filter,
+					      filter_ops);
+}
+
 static void __net_exit iptable_filter_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_filter)
 		return;
-	ipt_unregister_table(net, net->ipv4.iptable_filter, filter_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_filter);
 	net->ipv4.iptable_filter = NULL;
 }
 
 static struct pernet_operations iptable_filter_net_ops = {
 	.init = iptable_filter_net_init,
+	.pre_exit = iptable_filter_net_pre_exit,
 	.exit = iptable_filter_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index bb9266ea3785..f703a717ab1d 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -100,15 +100,23 @@ static int __net_init iptable_mangle_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_mangle)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_mangle,
+					      mangle_ops);
+}
+
 static void __net_exit iptable_mangle_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_mangle)
 		return;
-	ipt_unregister_table(net, net->ipv4.iptable_mangle, mangle_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_mangle);
 	net->ipv4.iptable_mangle = NULL;
 }
 
 static struct pernet_operations iptable_mangle_net_ops = {
+	.pre_exit = iptable_mangle_net_pre_exit,
 	.exit = iptable_mangle_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index ad33687b7444..b0143b109f25 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -113,16 +113,22 @@ static int __net_init iptable_nat_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_nat_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.nat_table)
+		ipt_nat_unregister_lookups(net);
+}
+
 static void __net_exit iptable_nat_net_exit(struct net *net)
 {
 	if (!net->ipv4.nat_table)
 		return;
-	ipt_nat_unregister_lookups(net);
-	ipt_unregister_table(net, net->ipv4.nat_table, NULL);
+	ipt_unregister_table_exit(net, net->ipv4.nat_table);
 	net->ipv4.nat_table = NULL;
 }
 
 static struct pernet_operations iptable_nat_net_ops = {
+	.pre_exit = iptable_nat_net_pre_exit,
 	.exit	= iptable_nat_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 69697eb4bfc6..9abfe6bf2cb9 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -67,15 +67,23 @@ static int __net_init iptable_raw_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_raw_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_raw)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_raw,
+					      rawtable_ops);
+}
+
 static void __net_exit iptable_raw_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_raw)
 		return;
-	ipt_unregister_table(net, net->ipv4.iptable_raw, rawtable_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_raw);
 	net->ipv4.iptable_raw = NULL;
 }
 
 static struct pernet_operations iptable_raw_net_ops = {
+	.pre_exit = iptable_raw_net_pre_exit,
 	.exit = iptable_raw_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index ac633c1db97e..415c1975d770 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -62,16 +62,23 @@ static int __net_init iptable_security_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_security_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_security)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_security,
+					      sectbl_ops);
+}
+
 static void __net_exit iptable_security_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_security)
 		return;
-
-	ipt_unregister_table(net, net->ipv4.iptable_security, sectbl_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_security);
 	net->ipv4.iptable_security = NULL;
 }
 
 static struct pernet_operations iptable_security_net_ops = {
+	.pre_exit = iptable_security_net_pre_exit,
 	.exit = iptable_security_net_exit,
 };
 
-- 
2.20.1

