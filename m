From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] src: netlink: Subscribe nft monitor and nft monitor trace to respective groups.
Date: Wed,  2 Aug 2017 14:15:10 +0200
Message-ID: <1501676110-9173-2-git-send-email-pablo@netfilter.org>
References: <1501676110-9173-1-git-send-email-pablo@netfilter.org>
Cc: rvarsha016@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753129AbdHBMP3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 08:15:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0731D25E5
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2017 14:15:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92D7E1B3D3B
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2017 14:15:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7FFA01B3D3C
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2017 14:15:12 +0200 (CEST)
In-Reply-To: <1501676110-9173-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Varsha Rao <rvarsha016@gmail.com>

Subscribe nft monitor to both NFNLGRP_NFTABLES and NFNLGRP_NFTRACE.
nft monitor trace subscribes only to NFNLGRP_NFTRACE. Other event
reporting options to only NFNLGRP_NFTABLES.

Joint work with Pablo Neira.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 9cef4c48f805..c1f194e9b008 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -3080,22 +3080,26 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
 {
 	int group;
 
-	group = NFNLGRP_NFTABLES;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
-					"Could not bind to netlink socket %s",
-					strerror(errno));
-
-	group = NFNLGRP_NFTRACE;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
-					"Could not bind to netlink socket %s",
-					strerror(errno));
-
-	return mnl_nft_event_listener(nf_sock, netlink_events_cb,
-				      monhandler);
+	if (monhandler->monitor_flags & (1 << NFT_MSG_TRACE)) {
+		group = NFNLGRP_NFTRACE;
+		if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP,
+					  &group, sizeof(int)) < 0)
+			return netlink_io_error(monhandler->ctx,
+						monhandler->loc,
+						"Could not bind to netlink socket %s",
+						strerror(errno));
+	}
+	if (monhandler->monitor_flags & ~(1 << NFT_MSG_TRACE)) {
+		group = NFNLGRP_NFTABLES;
+		if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP,
+					  &group, sizeof(int)) < 0)
+			return netlink_io_error(monhandler->ctx,
+						monhandler->loc,
+						"Could not bind to netlink socket %s",
+						strerror(errno));
+	}
+
+	return mnl_nft_event_listener(nf_sock, netlink_events_cb, monhandler);
 }
 
 bool netlink_batch_supported(struct mnl_socket *nf_sock)
-- 
2.1.4

