From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/12] netfilter: synproxy: fix conntrackd interaction
Date: Fri, 19 May 2017 10:33:48 +0200
Message-ID: <1495182833-2272-8-git-send-email-pablo@netfilter.org>
References: <1495182833-2272-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754862AbdESIeX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 04:34:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A28A91DA091
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 10:34:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91F49FF6FC
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 10:34:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 636DCFF147
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 10:34:12 +0200 (CEST)
In-Reply-To: <1495182833-2272-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Leblond <eric@regit.org>

This patch fixes the creation of connection tracking entry from
netlink when synproxy is used. It was missing the addition of
the synproxy extension.

This was causing kernel crashes when a conntrack entry created by
conntrackd was used after the switch of traffic from active node
to the passive node.

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fa752626029e..9799a50bc604 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -45,6 +45,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <net/netfilter/nf_conntrack_labels.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/nf_conntrack_synproxy.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l4proto.h>
@@ -1827,6 +1829,8 @@ ctnetlink_create_conntrack(struct net *net,
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
 	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
+	nfct_seqadj_ext_add(ct);
+	nfct_synproxy_ext_add(ct);
 
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
-- 
2.1.4

