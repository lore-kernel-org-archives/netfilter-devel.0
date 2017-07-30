From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v3] src: netlink: Subscribe nft monitor and nft monitor
 trace to respective groups.
Date: Sun, 30 Jul 2017 23:52:29 +0530
Message-ID: <597e23e9.544f620a.5b0f3.3ef9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35131 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754228AbdG3SWe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Jul 2017 14:22:34 -0400
Received: by mail-pg0-f68.google.com with SMTP id d193so28418179pgc.2
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Jul 2017 11:22:34 -0700 (PDT)
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

 src/netlink.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 9cef4c4..123088a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -39,6 +39,9 @@
 #include <erec.h>
 #include <iface.h>
 
+#define NFT_MONTRACE 131439
+/* This value is OR of monitor_flags for trace event and NFNLGRP_NFTABLES */
+
 const struct input_descriptor indesc_netlink = {
 	.name	= "netlink",
 	.type	= INDESC_NETLINK,
@@ -3078,21 +3081,34 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 int netlink_monitor(struct netlink_mon_handler *monhandler,
 		     struct mnl_socket *nf_sock)
 {
-	int group;
+	int group = NFNLGRP_NFTRACE, val;
 
-	group = NFNLGRP_NFTABLES;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
+	val = monhandler->monitor_flags | NFNLGRP_NFTABLES;
+	if (val == NFT_MONTRACE) {
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

