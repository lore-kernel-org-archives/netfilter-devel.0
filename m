From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v2] src: netlink: Subscribe nft monitor and nft monitor
 trace to respective groups.
Date: Fri, 28 Jul 2017 10:55:21 +0530
Message-ID: <597acac5.1dc8620a.5a708.5f17@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37339 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbdG1FZ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2017 01:25:27 -0400
Received: by mail-pf0-f195.google.com with SMTP id y25so12459504pfk.4
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 22:25:26 -0700 (PDT)
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

 src/netlink.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 9cef4c4..f7069fd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -3078,21 +3078,34 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 int netlink_monitor(struct netlink_mon_handler *monhandler,
 		     struct mnl_socket *nf_sock)
 {
-	int group;
-
-	group = NFNLGRP_NFTABLES;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
+	int group = NFNLGRP_NFTRACE, val;
+
+	val = monhandler->monitor_flags | NFNLGRP_NFTABLES;
+	if (val == 131439) {
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
+		if (val < 0) {
+			if (mnl_socket_setsockopt(nf_sock,
+						NETLINK_ADD_MEMBERSHIP, &group,
+						sizeof(int)) < 0)
+				return netlink_io_error(monhandler->ctx,
+						monhandler->loc,
+						"Could not bind to netlink socket %s",
+						strerror(errno));
+		}
+		group = NFNLGRP_NFTABLES;
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

