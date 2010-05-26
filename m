From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] add nfq_snprintf_xml() to output a packet in XML format
Date: Wed, 26 May 2010 14:39:53 +0200
Message-ID: <20100526123953.6016.65536.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: eleblond@edenwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab0EZMkE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 08:40:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new function to output the packet in XML format.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_queue/libnetfilter_queue.h |   11 ++
 src/libnetfilter_queue.c                        |  109 +++++++++++++++++++++++
 2 files changed, 120 insertions(+), 0 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 88a9b8c..165ace5 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -106,6 +106,17 @@ extern struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad);
 /* return -1 if problem, length otherwise */
 extern int nfq_get_payload(struct nfq_data *nfad, char **data);
 
+enum {
+	NFQ_XML_HW	= (1 << 0),
+	NFQ_XML_MARK	= (1 << 1),
+	NFQ_XML_DEV	= (1 << 2),
+	NFQ_XML_PHYSDEV	= (1 << 3),
+	NFQ_XML_PAYLOAD	= (1 << 4),
+	NFQ_XML_ALL	= ~0U,
+};
+
+extern int nfq_snprintf_xml(char *buf, int len, struct nfq_data *tb, int flags);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index cc19e6a..adf3114 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1011,6 +1011,115 @@ int nfq_get_payload(struct nfq_data *nfad, char **data)
 	return -1;
 }
 
+#define SNPRINTF_FAILURE(size, len, offset)			\
+do {								\
+	if (size < 0 || (unsigned int) size >= len)		\
+		return size;					\
+	offset += size;						\
+	len -= size;						\
+} while (0)
+
+int nfq_snprintf_xml(char *buf, int len, struct nfq_data *tb, int flags)
+{
+	struct nfqnl_msg_packet_hdr *ph;
+	struct nfqnl_msg_packet_hw *hwph;
+	u_int32_t mark, ifi;
+	int size, offset = 0, ret;
+	char *data;
+
+	size = snprintf(buf + offset, len, "<pkt>");
+	SNPRINTF_FAILURE(size, len, offset);
+
+	ph = nfq_get_msg_packet_hdr(tb);
+	if (ph) {
+		size = snprintf(buf + offset, len,
+				"<hook>%u</hook><id>%u</id>",
+				ph->hook, ntohl(ph->packet_id));
+		SNPRINTF_FAILURE(size, len, offset);
+
+		hwph = nfq_get_packet_hw(tb);
+		if (hwph && (flags & NFQ_XML_HW)) {
+			int i, hlen = ntohs(hwph->hw_addrlen);
+
+			size = snprintf(buf + offset, len, "<hw><proto>0x%04x"
+							   "</proto>",
+					ntohs(ph->hw_protocol));
+			SNPRINTF_FAILURE(size, len, offset);
+
+			size = snprintf(buf + offset, len, "<src>");
+			SNPRINTF_FAILURE(size, len, offset);
+
+			for (i=0; i<hlen-1; i++) {
+				size = snprintf(buf + offset, len, "%02x:",
+						ntohs(ph->hw_protocol));
+				SNPRINTF_FAILURE(size, len, offset);
+			}
+
+			size = snprintf(buf + offset, len, "</src></hw>");
+			SNPRINTF_FAILURE(size, len, offset);
+		} else if (flags & NFQ_XML_HW) {
+			size = snprintf(buf + offset, len, "<hw><proto>0x%04x"
+						    "</proto></hw>",
+				 ntohs(ph->hw_protocol));
+			SNPRINTF_FAILURE(size, len, offset);
+		}
+	}
+
+	mark = nfq_get_nfmark(tb);
+	if (mark && (flags & NFQ_XML_MARK)) {
+		size = snprintf(buf + offset, len, "<mark>%u</mark>", mark);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nfq_get_indev(tb);
+	if (ifi && (flags & NFQ_XML_DEV)) {
+		size = snprintf(buf + offset, len, "<indev>%u</indev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nfq_get_outdev(tb);
+	if (ifi && (flags & NFQ_XML_DEV)) {
+		size = snprintf(buf + offset, len, "<outdev>%u</outdev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nfq_get_physindev(tb);
+	if (ifi && (flags & NFQ_XML_PHYSDEV)) {
+		size = snprintf(buf + offset, len,
+				"<physindev>%u</physindev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nfq_get_physoutdev(tb);
+	if (ifi && (flags & NFQ_XML_PHYSDEV)) {
+		size = snprintf(buf + offset, len,
+				"<physoutdev>%u</physoutdev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ret = nfq_get_payload(tb, &data);
+	if (ret >= 0 && (flags & NFQ_XML_PAYLOAD)) {
+		int i;
+
+		size = snprintf(buf + offset, len, "<payload>");
+		SNPRINTF_FAILURE(size, len, offset);
+
+		for (i=0; i<ret; i++) {
+			size = snprintf(buf + offset, len, "x%02x",
+					data[i] & 0xff);
+			SNPRINTF_FAILURE(size, len, offset);
+		}
+
+		size = snprintf(buf + offset, len, "</payload>");
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	size = snprintf(buf + offset, len, "</pkt>");
+	SNPRINTF_FAILURE(size, len, offset);
+
+	return size;
+}
+
 /**
  * @}
  */

