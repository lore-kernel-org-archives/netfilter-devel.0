From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] add nflog_snprintf_xml() to output a log in XML format
Date: Wed, 26 May 2010 14:39:59 +0200
Message-ID: <20100526123959.6039.31915.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: eleblond@edenwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42305 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab0EZMkE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 08:40:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new function to output the packet in XML format.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_log/libnetfilter_log.h |   12 +++
 src/libnetfilter_log.c                      |  113 +++++++++++++++++++++++++++
 2 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index aa0da72..365b19d 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -67,4 +67,16 @@ extern int nflog_get_gid(struct nflog_data *nfad, u_int32_t *gid);
 extern int nflog_get_seq(struct nflog_data *nfad, u_int32_t *seq);
 extern int nflog_get_seq_global(struct nflog_data *nfad, u_int32_t *seq);
 
+enum {
+        NFLOG_XML_PREFIX	= (1 << 0),
+        NFLOG_XML_HW		= (1 << 1),
+        NFLOG_XML_MARK		= (1 << 2),
+        NFLOG_XML_DEV		= (1 << 3),
+        NFLOG_XML_PHYSDEV	= (1 << 4),
+        NFLOG_XML_PAYLOAD	= (1 << 5),
+        NFLOG_XML_ALL		= ~0U,
+};
+
+extern int nflog_snprintf_xml(char *buf, int len, struct nflog_data *tb, int flags);
+
 #endif	/* __LIBNETFILTER_LOG_H */
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index ebb8a19..6978814 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -481,3 +481,116 @@ int nflog_get_seq_global(struct nflog_data *nfad, u_int32_t *seq)
 	*seq = ntohl(nfnl_get_data(nfad->nfa, NFULA_SEQ_GLOBAL, u_int32_t));
 	return 0;
 }
+
+#define SNPRINTF_FAILURE(size, len, offset)			\
+do {								\
+	if (size < 0 || (unsigned int) size >= len)		\
+		return size;					\
+	offset += size;						\
+	len -= size;						\
+} while (0)
+
+int nflog_snprintf_xml(char *buf, int len, struct nflog_data *tb, int flags)
+{
+	struct nfulnl_msg_packet_hdr *ph;
+	struct nfulnl_msg_packet_hw *hwph;
+	u_int32_t mark, ifi;
+	int size, offset = 0, ret;
+	char *data;
+
+	size = snprintf(buf + offset, len, "<log>");
+	SNPRINTF_FAILURE(size, len, offset);
+
+	data = nflog_get_prefix(tb);
+	if (data && (flags & NFLOG_XML_PREFIX)) {
+		size = snprintf(buf + offset, len, "<prefix>%s</prefix>", data);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ph = nflog_get_msg_packet_hdr(tb);
+	if (ph) {
+		size = snprintf(buf + offset, len, "<hook>%u</hook>", ph->hook);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		hwph = nflog_get_packet_hw(tb);
+		if (hwph && (flags & NFLOG_XML_HW)) {
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
+		} else if (flags & NFLOG_XML_HW) {
+			size = snprintf(buf + offset, len, "<hw><proto>0x%04x"
+						    "</proto></hw>",
+				 ntohs(ph->hw_protocol));
+			SNPRINTF_FAILURE(size, len, offset);
+		}
+	}
+
+	mark = nflog_get_nfmark(tb);
+	if (mark && (flags & NFLOG_XML_MARK)) {
+		size = snprintf(buf + offset, len, "<mark>%u</mark>", mark);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nflog_get_indev(tb);
+	if (ifi && (flags & NFLOG_XML_DEV)) {
+		size = snprintf(buf + offset, len, "<indev>%u</indev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nflog_get_outdev(tb);
+	if (ifi && (flags & NFLOG_XML_DEV)) {
+		size = snprintf(buf + offset, len, "<outdev>%u</outdev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nflog_get_physindev(tb);
+	if (ifi && (flags & NFLOG_XML_PHYSDEV)) {
+		size = snprintf(buf + offset, len,
+				"<physindev>%u</physindev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ifi = nflog_get_physoutdev(tb);
+	if (ifi && (flags & NFLOG_XML_PHYSDEV)) {
+		size = snprintf(buf + offset, len,
+				"<physoutdev>%u</physoutdev>", ifi);
+		SNPRINTF_FAILURE(size, len, offset);
+	}
+
+	ret = nflog_get_payload(tb, &data);
+	if (ret >= 0 && (flags & NFLOG_XML_PAYLOAD)) {
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
+	size = snprintf(buf + offset, len, "</log>");
+	SNPRINTF_FAILURE(size, len, offset);
+
+	return size;
+}

