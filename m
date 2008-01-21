From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/2] [NETFILTER]: xt_socket: allow matching UID/GID ranges
Date: Tue, 22 Jan 2008 00:23:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801220023270.25080@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47916 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763135AbYAUXXp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:23:45 -0500
In-Reply-To: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2dee4f29f447ed446610b9a8e6e8385ce721e457
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Jan 20 13:15:08 2008 +0100

    [NETFILTER]: xt_socket: allow matching UID/GID ranges
    
    Range matching makes it possible to reduce the number of rules
    required for some setups.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
index 5d7abb0..70913d9 100644
--- a/include/linux/netfilter/xt_socket.h
+++ b/include/linux/netfilter/xt_socket.h
@@ -8,8 +8,8 @@ enum {
 };
 
 struct xt_socket_mtinfo {
-	u_int32_t uid;
-	u_int32_t gid;
+	u_int32_t uid_min, uid_max;
+	u_int32_t gid_min, gid_max;
 	u_int8_t match, invert;
 };
 
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index de5116f..07d681c 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -102,12 +102,14 @@ socket_mt(const struct sk_buff *skb, const struct net_device *in,
 		       (XT_SOCKET_UID | XT_SOCKET_GID)) == 0;
 
 	if (info->match & XT_SOCKET_UID)
-		if ((filp->f_uid != info->uid) ^
+		if ((filp->f_uid >= info->uid_min &&
+		    filp->f_uid <= info->uid_max) ^
 		    !!(info->invert & XT_SOCKET_UID))
 			return false;
 
 	if (info->match & XT_SOCKET_GID)
-		if ((filp->f_gid != info->gid) ^
+		if ((filp->f_gid >= info->gid_min &&
+		    filp->f_gid <= info->gid_max) ^
 		    !!(info->invert & XT_SOCKET_GID))
 			return false;
 
