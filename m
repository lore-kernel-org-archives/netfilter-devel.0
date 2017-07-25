From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] src: netlink: Subscribe nft monitor and nft monitor
 trace to respective groups.
Date: Tue, 25 Jul 2017 10:55:00 +0530
Message-ID: <5976d630.c553650a.2e876.31e8@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37211 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdGYFZG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 01:25:06 -0400
Received: by mail-pf0-f195.google.com with SMTP id y25so4757433pfk.4
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 22:25:06 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Subscribe nft monitor only to NFNLGRP_NFTABLES and nft monitor trace
only to NFNLGRP_NFTRACE. In netlink_monitor() depending on the command
call setsockopt() once.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 src/netlink.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 9cef4c4..ccc13eb 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -3080,14 +3080,11 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
 {
 	int group;
 
-	group = NFNLGRP_NFTABLES;
-	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
-				  sizeof(int)) < 0)
-		return netlink_io_error(monhandler->ctx, monhandler->loc,
-					"Could not bind to netlink socket %s",
-					strerror(errno));
+	if (monhandler->monitor_flags == (unsigned int)-1)
+		group = NFNLGRP_NFTABLES;
+	else
+		group = NFNLGRP_NFTRACE;
 
-	group = NFNLGRP_NFTRACE;
 	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
 				  sizeof(int)) < 0)
 		return netlink_io_error(monhandler->ctx, monhandler->loc,
-- 
2.9.4

