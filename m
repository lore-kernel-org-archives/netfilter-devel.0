From: Eric Leblond <eric@regit.org>
Subject: [PATCH] netfilter: synproxy: fix conntrackd interaction
Date: Thu, 11 May 2017 15:22:55 +0200
Message-ID: <20170511132255.13805-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, brouer@redhat.com,
        Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:51378 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932212AbdEKODs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2017 10:03:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the creation of connection tracking entry from
netlink when synproxy is used. It was missing the addition of
the synproxy extension.

This was causing kernel crashes when a conntrack entry created by
conntrackd was used after the switch of traffic from active node
to the passive node.
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dcf561b5c97a..1a127677ffe1 100644
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
@@ -1828,6 +1830,8 @@ ctnetlink_create_conntrack(struct net *net,
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
 	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
+	nfct_seqadj_ext_add(ct);
+	nfct_synproxy_ext_add(ct);
 
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
-- 
2.11.0

