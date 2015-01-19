From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 1/7] include: cache copy of Linux header
 uapi/linux/netfilter_bridge/ebt_802_3.h
Date: Mon, 19 Jan 2015 14:27:36 +0100
Message-ID: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:48762 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751433AbbASN1q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:27:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cache a copy of Linux header uapi/linux/netfilter_bridge/ebt_802_3.h
which contains the struct ebt_802_3_info definition.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/linux/netfilter_bridge/ebt_802_3.h |   63 ++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 include/linux/netfilter_bridge/ebt_802_3.h

diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
new file mode 100644
index 0000000..f37522a
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_802_3.h
@@ -0,0 +1,63 @@
+#ifndef _UAPI__LINUX_BRIDGE_EBT_802_3_H
+#define _UAPI__LINUX_BRIDGE_EBT_802_3_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define EBT_802_3_SAP 0x01
+#define EBT_802_3_TYPE 0x02
+
+#define EBT_802_3_MATCH "802_3"
+
+/*
+ * If frame has DSAP/SSAP value 0xaa you must check the SNAP type
+ * to discover what kind of packet we're carrying. 
+ */
+#define CHECK_TYPE 0xaa
+
+/*
+ * Control field may be one or two bytes.  If the first byte has
+ * the value 0x03 then the entire length is one byte, otherwise it is two.
+ * One byte controls are used in Unnumbered Information frames.
+ * Two byte controls are used in Numbered Information frames.
+ */
+#define IS_UI 0x03
+
+#define EBT_802_3_MASK (EBT_802_3_SAP | EBT_802_3_TYPE | EBT_802_3)
+
+/* ui has one byte ctrl, ni has two */
+struct hdr_ui {
+	__u8 dsap;
+	__u8 ssap;
+	__u8 ctrl;
+	__u8 orig[3];
+	__be16 type;
+};
+
+struct hdr_ni {
+	__u8 dsap;
+	__u8 ssap;
+	__be16 ctrl;
+	__u8  orig[3];
+	__be16 type;
+};
+
+struct ebt_802_3_hdr {
+	__u8  daddr[ETH_ALEN];
+	__u8  saddr[ETH_ALEN];
+	__be16 len;
+	union {
+		struct hdr_ui ui;
+		struct hdr_ni ni;
+	} llc;
+};
+
+
+struct ebt_802_3_info {
+	__u8  sap;
+	__be16 type;
+	__u8  bitmask;
+	__u8  invflags;
+};
+
+#endif /* _UAPI__LINUX_BRIDGE_EBT_802_3_H */

