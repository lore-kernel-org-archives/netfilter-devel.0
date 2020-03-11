Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5A8C0044D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 19:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EABC72072F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 19:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgCKTwJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 15:52:09 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54740 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731030AbgCKTwJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 15:52:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jC7Oh-0006EV-Fv; Wed, 11 Mar 2020 20:52:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/1] netfilter: conntrack: re-visit sysctls in unprivileged namespaces
Date:   Wed, 11 Mar 2020 20:52:01 +0100
Message-Id: <20200311195201.18738-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
 net/netfilter/nf_conntrack_standalone.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 410809c669e1..954f2bedec16 100644
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
2.24.1

