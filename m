Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1BBC1975A
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1873206EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgCRAkh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 20:40:37 -0400
Received: from correo.us.es ([193.147.175.20]:45608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbgCRAkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1D7727F8B4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2416DA3A1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7A22DA390; Wed, 18 Mar 2020 01:39:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9CE4DA38F;
        Wed, 18 Mar 2020 01:39:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C3466426CCB9;
        Wed, 18 Mar 2020 01:39:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 26/29] netfilter: conntrack: re-visit sysctls in unprivileged namespaces
Date:   Wed, 18 Mar 2020 01:39:53 +0100
Message-Id: <20200318003956.73573-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

since commit b884fa46177659 ("netfilter: conntrack: unify sysctl handling")
conntrack no longer exposes most of its sysctls (e.g. tcp timeouts
settings) to network namespaces that are not owned by the initial user
namespace.

This patch exposes all sysctls even if the namespace is unpriviliged.

compared to a 4.19 kernel, the newly visible and writeable sysctls are:
  net.netfilter.nf_conntrack_acct
  net.netfilter.nf_conntrack_timestamp
  .. to allow to enable accouting and timestamp extensions.

  net.netfilter.nf_conntrack_events
  .. to turn off conntrack event notifications.

  net.netfilter.nf_conntrack_checksum
  .. to disable checksum validation.

  net.netfilter.nf_conntrack_log_invalid
  .. to enable logging of packets deemed invalid by conntrack.

newly visible sysctls that are only exported as read-only:

  net.netfilter.nf_conntrack_count
  .. current number of conntrack entries living in this netns.

  net.netfilter.nf_conntrack_max
  .. global upperlimit (maximum size of the table).

  net.netfilter.nf_conntrack_buckets
  .. size of the conntrack table (hash buckets).

  net.netfilter.nf_conntrack_expect_max
  .. maximum number of permitted expectations in this netns.

  net.netfilter.nf_conntrack_helper
  .. conntrack helper auto assignment.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4912069627b6..9b57330c81f8 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1054,21 +1054,18 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	nf_conntrack_standalone_init_dccp_sysctl(net, table);
 	nf_conntrack_standalone_init_gre_sysctl(net, table);
 
-	/* Don't export sysctls to unprivileged users */
+	/* Don't allow unprivileged users to alter certain sysctls */
 	if (net->user_ns != &init_user_ns) {
-		table[NF_SYSCTL_CT_MAX].procname = NULL;
-		table[NF_SYSCTL_CT_ACCT].procname = NULL;
-		table[NF_SYSCTL_CT_HELPER].procname = NULL;
-#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-		table[NF_SYSCTL_CT_TIMESTAMP].procname = NULL;
-#endif
+		table[NF_SYSCTL_CT_MAX].mode = 0444;
+		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
+		table[NF_SYSCTL_CT_HELPER].mode = 0444;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-		table[NF_SYSCTL_CT_EVENTS].procname = NULL;
+		table[NF_SYSCTL_CT_EVENTS].mode = 0444;
 #endif
-	}
-
-	if (!net_eq(&init_net, net))
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+	} else if (!net_eq(&init_net, net)) {
+		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+	}
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.sysctl_header)
-- 
2.11.0

