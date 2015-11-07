From: Jarno Rajahalme <jrajahalme@nicira.com>
Subject: [RFC PATCH net-next v2 1/8] netfilter: Remove IP_CT_NEW_REPLY definition.
Date: Fri,  6 Nov 2015 16:06:01 -0800
Message-ID: <1446854768-38299-2-git-send-email-jrajahalme@nicira.com>
References: <1446854768-38299-1-git-send-email-jrajahalme@nicira.com>
Cc: netfilter-devel@vger.kernel.org, dev@openvswitch.org,
	jrajahalme@nicira.com
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33010 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbbKGAGR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 19:06:17 -0500
Received: by pabfh17 with SMTP id fh17so137161554pab.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2015 16:06:16 -0800 (PST)
In-Reply-To: <1446854768-38299-1-git-send-email-jrajahalme@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the definition of IP_CT_NEW_REPLY from the kernel as it does
not make sense.  This allows the definition of IP_CT_NUMBER to be
simplified as well.

Signed-off-by: Jarno Rajahalme <jrajahalme@nicira.com>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 12 +++++++++---
 net/openvswitch/conntrack.c                        |  2 --
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 319f471..2f067cf 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -20,9 +20,15 @@ enum ip_conntrack_info {
 
 	IP_CT_ESTABLISHED_REPLY = IP_CT_ESTABLISHED + IP_CT_IS_REPLY,
 	IP_CT_RELATED_REPLY = IP_CT_RELATED + IP_CT_IS_REPLY,
-	IP_CT_NEW_REPLY = IP_CT_NEW + IP_CT_IS_REPLY,	
-	/* Number of distinct IP_CT types (no NEW in reply dirn). */
-	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1
+	/* No NEW in reply direction. */
+
+	/* Number of distinct IP_CT types. */
+	IP_CT_NUMBER
+
+	/* only for userspace compatibility */
+#ifndef __KERNEL__
+	IP_CT_NEW_REPLY = IP_CT_NUMBER;
+#endif
 };
 
 #define NF_CT_STATE_INVALID_BIT			(1 << 0)
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c2cc111..a28a819 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -73,7 +73,6 @@ static u8 ovs_ct_get_state(enum ip_conntrack_info ctinfo)
 	switch (ctinfo) {
 	case IP_CT_ESTABLISHED_REPLY:
 	case IP_CT_RELATED_REPLY:
-	case IP_CT_NEW_REPLY:
 		ct_state |= OVS_CS_F_REPLY_DIR;
 		break;
 	default:
@@ -90,7 +89,6 @@ static u8 ovs_ct_get_state(enum ip_conntrack_info ctinfo)
 		ct_state |= OVS_CS_F_RELATED;
 		break;
 	case IP_CT_NEW:
-	case IP_CT_NEW_REPLY:
 		ct_state |= OVS_CS_F_NEW;
 		break;
 	default:
-- 
2.1.4

