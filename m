From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 01/09]: Add if_vlan.h
Date: Fri, 18 Jan 2008 17:55:48 +0100 (MET)
Message-ID: <20080118165515.13385.3747.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42958 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761631AbYARQzt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:49 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 057316c354252ef6273f6deb4fe4232c02e4d141
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 16:15:53 2008 +0100

    [LIBNL]: Add if_vlan.h
    
    vlan support needs VLAN_FLAG_REORDER_HDR, which is not available in
    older if_vlan.h versions. Add the current version from the kernel.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
new file mode 100644
index 0000000..a1dbeec
--- /dev/null
+++ b/include/linux/if_vlan.h
@@ -0,0 +1,61 @@
+/*
+ * VLAN		An implementation of 802.1Q VLAN tagging.
+ *
+ * Authors:	Ben Greear <greearb@candelatech.com>
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ */
+
+#ifndef _LINUX_IF_VLAN_H_
+#define _LINUX_IF_VLAN_H_
+
+
+/* VLAN IOCTLs are found in sockios.h */
+
+/* Passed in vlan_ioctl_args structure to determine behaviour. */
+enum vlan_ioctl_cmds {
+	ADD_VLAN_CMD,
+	DEL_VLAN_CMD,
+	SET_VLAN_INGRESS_PRIORITY_CMD,
+	SET_VLAN_EGRESS_PRIORITY_CMD,
+	GET_VLAN_INGRESS_PRIORITY_CMD,
+	GET_VLAN_EGRESS_PRIORITY_CMD,
+	SET_VLAN_NAME_TYPE_CMD,
+	SET_VLAN_FLAG_CMD,
+	GET_VLAN_REALDEV_NAME_CMD, /* If this works, you know it's a VLAN device, btw */
+	GET_VLAN_VID_CMD /* Get the VID of this VLAN (specified by name) */
+};
+
+enum vlan_flags {
+	VLAN_FLAG_REORDER_HDR	= 0x1,
+};
+
+enum vlan_name_types {
+	VLAN_NAME_TYPE_PLUS_VID, /* Name will look like:  vlan0005 */
+	VLAN_NAME_TYPE_RAW_PLUS_VID, /* name will look like:  eth1.0005 */
+	VLAN_NAME_TYPE_PLUS_VID_NO_PAD, /* Name will look like:  vlan5 */
+	VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD, /* Name will look like:  eth0.5 */
+	VLAN_NAME_TYPE_HIGHEST
+};
+
+struct vlan_ioctl_args {
+	int cmd; /* Should be one of the vlan_ioctl_cmds enum above. */
+	char device1[24];
+
+        union {
+		char device2[24];
+		int VID;
+		unsigned int skb_priority;
+		unsigned int name_type;
+		unsigned int bind_type;
+		unsigned int flag; /* Matches vlan_dev_info flags */
+        } u;
+
+	short vlan_qos;
+};
+
+#endif /* !(_LINUX_IF_VLAN_H_) */
