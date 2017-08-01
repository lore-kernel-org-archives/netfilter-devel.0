From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v4] src: netlink: Subscribe nft monitor and nft monitor
 trace to respective groups.
Date: Tue, 1 Aug 2017 10:05:47 +0530
Message-ID: <59800527.99c6620a.87df6.2375@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36320 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdHAEfw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2017 00:35:52 -0400
Received: by mail-pg0-f66.google.com with SMTP id y129so762989pgy.3
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 21:35:52 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Subscribe nft monitor to both NFNLGRP_NFTABLES and NFNLGRP_NFTRACE.
nft monitor trace subscribes only to NFNLGRP_NFTRACE. Other event
reporting options to only NFNLGRP_NFTABLES.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v1:
- Subscribe nft monitor to only _NFTABLES.
- Subsribe nft monitor trace to only _NFTRACE.

Changes in v2:
- Subsribe nft monitor to both _NFTABLES and _NFTRACE.
- Subscribe other events to _NFTABLES.
- Modified commit message.

Changes in v3:
- Define constant NFT_MONTRACE.

Changes in v4:
- Remove constant NFT_MONTRACE.
- Add new if condition.

 src/netlink.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 9cef4c4..ef58afe 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -3078,21 +3078,33 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 int netlink_monitor(struct netlink_mon_handler *monhandler,
 		     struct mnl_socket *nf_sock)
 {
-	int group;
+	int group = NFNLGRP_NFTABLES;
+
+	if (monhandler->monitor_flags & (1 << NFT_MSG_TRACE)) {
+		if ((1 << monhandler->monitor_flags) < 0) {
+			if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP,
+					&group, sizeof(int)) < 0)
+				return netlink_io_error(monhandler->ctx,
+						monhandler->loc,
+						"Could not bind to netlink socket %s",
+						strerror(errno));
+		}
 
-	group = NFNLGRP_NFTABLES;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
+		group = NFNLGRP_NFTRACE;
+		if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP,
+					&group, sizeof(int)) < 0)
+			return netlink_io_error(monhandler->ctx,
+					monhandler->loc,
 					"Could not bind to netlink socket %s",
 					strerror(errno));
-
-	group = NFNLGRP_NFTRACE;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
+	} else {
+		if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP,
+					&group, sizeof(int)) < 0)
+			return netlink_io_error(monhandler->ctx,
+					monhandler->loc,
 					"Could not bind to netlink socket %s",
 					strerror(errno));
+	}
 
 	return mnl_nft_event_listener(nf_sock, netlink_events_cb,
 				      monhandler);
-- 
2.9.4

