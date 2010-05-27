From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add nflog_snprintf_xml() to output a log in XML format
Date: Thu, 27 May 2010 15:14:46 +0200
Message-ID: <4BFE7046.7040802@netfilter.org>
References: <20100526123959.6039.31915.stgit@decadence> <alpine.LSU.2.01.1005261744390.1686@obet.zrqbmnf.qr> <4BFE5DF9.4010200@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090405010302080905090700"
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36790 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0E0NO6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 09:14:58 -0400
In-Reply-To: <4BFE5DF9.4010200@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090405010302080905090700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

New version including NFLOG_XML_TIME.

--------------090405010302080905090700
Content-Type: text/x-patch;
 name="xml-log.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xml-log.patch"

add nflog_snprintf_xml() to output a log in XML format

This patch adds a new function to output the packet in XML format.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_log/libnetfilter_log.h |   13 ++
 src/libnetfilter_log.c                      |  155 +++++++++++++++++++++++++++
 2 files changed, 168 insertions(+), 0 deletions(-)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index aa0da72..6b0d3b0 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -67,4 +67,17 @@ extern int nflog_get_gid(struct nflog_data *nfad, u_int32_t *gid);
 extern int nflog_get_seq(struct nflog_data *nfad, u_int32_t *seq);
 extern int nflog_get_seq_global(struct nflog_data *nfad, u_int32_t *seq);
 
+enum {
+	NFLOG_XML_PREFIX	= (1 << 0),
+	NFLOG_XML_HW		= (1 << 1),
+	NFLOG_XML_MARK		= (1 << 2),
+	NFLOG_XML_DEV		= (1 << 3),
+	NFLOG_XML_PHYSDEV	= (1 << 4),
+	NFLOG_XML_PAYLOAD	= (1 << 5),
+	NFLOG_XML_TIME		= (1 << 6),
+	NFLOG_XML_ALL		= ~0U,
+};
+
+extern int nflog_snprintf_xml(char *buf, size_t len, struct nflog_data *tb, int flags);
+
 #endif	/* __LIBNETFILTER_LOG_H */
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index ebb8a19..d4fc0c2 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -481,3 +481,158 @@ int nflog_get_seq_global(struct nflog_data *nfad, u_int32_t *seq)
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
+int nflog_snprintf_xml(char *buf, size_t len, struct nflog_data *tb, int flags)
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
+	if (flags & NFLOG_XML_TIME) {
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
+			size = snprintf(buf + offset, len, "\\x%02x",
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

--------------090405010302080905090700--
