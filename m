From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add nfq_snprintf_xml() to output a packet in XML format
Date: Thu, 27 May 2010 15:14:13 +0200
Message-ID: <4BFE7025.6000908@netfilter.org>
References: <20100526123953.6016.65536.stgit@decadence> <alpine.LSU.2.01.1005261740270.1686@obet.zrqbmnf.qr> <4BFE5C7F.2030400@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060503030504050709090503"
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36727 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0E0NOW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 09:14:22 -0400
In-Reply-To: <4BFE5C7F.2030400@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060503030504050709090503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

New version of this patch including NFQ_XML_TIME.

--------------060503030504050709090503
Content-Type: text/x-patch;
 name="xml.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xml.patch"

add nfq_snprintf_xml() to output a packet in XML format

This patch adds a new function to output the packet in XML format.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_queue/libnetfilter_queue.h |   12 ++
 src/libnetfilter_queue.c                        |  151 +++++++++++++++++++++++
 2 files changed, 163 insertions(+), 0 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 88a9b8c..c33a134 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -106,6 +106,18 @@ extern struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad);
 /* return -1 if problem, length otherwise */
 extern int nfq_get_payload(struct nfq_data *nfad, char **data);
 
+enum {
+	NFQ_XML_HW	= (1 << 0),
+	NFQ_XML_MARK	= (1 << 1),
+	NFQ_XML_DEV	= (1 << 2),
+	NFQ_XML_PHYSDEV	= (1 << 3),
+	NFQ_XML_PAYLOAD	= (1 << 4),
+	NFQ_XML_TIME	= (1 << 5),
+	NFQ_XML_ALL	= ~0U,
+};
+
+extern int nfq_snprintf_xml(char *buf, size_t len, struct nfq_data *tb, int flags);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index cc19e6a..e16a0f7 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1011,6 +1011,157 @@ int nfq_get_payload(struct nfq_data *nfad, char **data)
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
+int nfq_snprintf_xml(char *buf, size_t len, struct nfq_data *tb, int flags)
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
+	if (flags & NFQ_XML_TIME) {
+		time_t t;
+		struct tm tm;
+
+		t = time(NULL);
+		if (localtime_r(&t, &tm) == NULL)
+			return -1;
+
+		size = snprintf(buf + offset, len, "<when>");
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf + offset, len,
+				"<hour>%d</hour>", tm.tm_hour);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf + offset,
+				len, "<min>%02d</min>", tm.tm_min);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf + offset,
+				len, "<sec>%02d</sec>", tm.tm_sec);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf + offset, len, "<wday>%d</wday>",
+				tm.tm_wday + 1);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf+offset, len, "<day>%d</day>", tm.tm_mday);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf+offset, len, "<month>%d</month>",
+				tm.tm_mon + 1);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf+offset, len, "<year>%d</year>",
+				1900 + tm.tm_year);
+		SNPRINTF_FAILURE(size, len, offset);
+
+		size = snprintf(buf+offset, len, "</when>");
+		SNPRINTF_FAILURE(size, len, offset);
+	}
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
+			size = snprintf(buf + offset, len, "\\x%02x",
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

--------------060503030504050709090503--
