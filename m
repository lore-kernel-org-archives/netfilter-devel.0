From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 05/12] ipfix: add function for ipfix message creation
Date: Tue, 3 Jun 2014 19:09:27 +0900
Message-ID: <20140603100927.GF24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60653 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaFCKJe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:09:34 -0400
Received: by mail-pd0-f174.google.com with SMTP id r10so4481916pdi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:09:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function creates ipfix message, template and data part but not scope.
Header sequence is kept by struct ipfix_instance, domain id is specified
by config file. The returned value has no export time so caller set this
and free the value after using it.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/ulogd/ipfix_protocol.h |  8 ++++-
 output/ulogd_output_IPFIX.c    | 71 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index 5d7e46a..266897e 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -15,7 +15,13 @@ struct ipfix_msg_hdr {
 	u_int16_t	length;
 	u_int32_t	export_time;
 	u_int32_t	seq;
-	u_int32_t	source_id;
+	u_int32_t	domain_id;
+};
+
+/* Section 3.3.2 */
+struct ipfix_set_hdr {
+	u_int16_t       set_id;
+	u_int16_t       length;
 };
 
 /* Section 3.4.1 */
diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 49efb54..352b5a7 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -28,6 +28,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
@@ -84,7 +85,7 @@ struct sctp_sndrcvinfo {
 #define IPFIX_DEFAULT_TCPUDP_PORT	4739
 
 static struct config_keyset ipfix_kset = {
-	.num_ces = 3,
+	.num_ces = 4,
 	.ces = {
 		{
 			.key 	 = "host",
@@ -103,12 +104,19 @@ static struct config_keyset ipfix_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u	= { .string = "udp" },
 		},
+		{
+			.key	 = "domain_id",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
 	},
 };
 
 #define host_ce(x)	(x->ces[0])
 #define port_ce(x)	(x->ces[1])
 #define proto_ce(x)	(x->ces[2])
+#define domain_ce(x)	(x->ces[3])
 
 struct ipfix_template {
 	struct ipfix_templ_rec_hdr hdr;
@@ -130,6 +138,7 @@ struct ipfix_instance {
 
 	struct llist_head template_list;
 	struct nfct_bitmask *valid_bitmask;	/* bitmask of valid keys */
+	u_int32_t seq;
 };
 
 #define ULOGD_IPFIX_TEMPL_BASE 1024
@@ -282,6 +291,66 @@ static int put_data_records(struct ulogd_pluginstance *upi,
 	return len;
 }
 
+static struct ipfix_msg_hdr *build_ipfix_msg(struct ulogd_pluginstance *upi,
+					     struct ulogd_ipfix_template *template,
+					     bool need_template)
+{
+	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
+	u_int16_t tmpl_len;
+	struct ipfix_msg_hdr *msg_hdr;
+	struct ipfix_templ_rec_hdr *tmpl_hdr;
+	struct ipfix_set_hdr *data_hdr, *tmpl_set_hdr;
+	void *buf;
+	int msglen, ret;
+
+	msglen = sizeof(struct ipfix_msg_hdr) + sizeof(struct ipfix_set_hdr)
+		+ template->data_length;
+	if (need_template)
+		msglen = msglen + sizeof(struct ipfix_set_hdr)
+			+ (template->tmpl_cur - (void *)&template->tmpl);
+	buf = malloc(msglen);
+	if (buf == NULL)
+		return NULL;
+	memset(buf, 0, msglen);
+
+	/* ipfix msg header */
+	msg_hdr = buf;
+	msg_hdr->version = htons(10);
+	msg_hdr->length = htons(msglen);
+	msg_hdr->seq = htonl(ii->seq++);
+	msg_hdr->domain_id = htonl(domain_ce(upi->config_kset).u.value);
+	if (need_template) {
+		/* put set header and template records */
+		tmpl_set_hdr = buf + sizeof(*msg_hdr);
+		tmpl_set_hdr->set_id = htons(2);
+		tmpl_len = template->tmpl_cur - (void *)&template->tmpl;
+		tmpl_set_hdr->length = htons(sizeof(*tmpl_set_hdr) + tmpl_len);
+		tmpl_hdr = (void *)tmpl_set_hdr + sizeof(*tmpl_set_hdr);
+		memcpy((void *)tmpl_hdr, (void *)&template->tmpl, tmpl_len);
+		data_hdr = (void *)tmpl_hdr + tmpl_len;
+	} else {
+		data_hdr = buf + sizeof(*msg_hdr);
+	}
+
+	/* put set header and data records */
+	data_hdr->set_id = template->tmpl.hdr.templ_id; /* already ordered */
+	data_hdr->length = htons(sizeof(*data_hdr) + template->data_length);
+	ret = put_data_records(upi, template, (void *)data_hdr + sizeof(*data_hdr));
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR, "could not build ipfix dataset");
+		goto free_buf;
+	} else if (ret > msglen) {
+		ulogd_log(ULOGD_ERROR, "overflowed on building ipfix dataset");
+		goto free_buf;
+	}
+
+	return msg_hdr;
+
+free_buf:
+	free(buf);
+	return NULL;
+}
+
 static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-- 
1.9.1

