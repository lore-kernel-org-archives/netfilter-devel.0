From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH 7/8] ipfix: print ipfix message
Date: Sat, 8 Mar 2014 10:17:17 +0900
Message-ID: <20140308011715.GH4415@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36872 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaCHBR1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:17:27 -0500
Received: by mail-pd0-f172.google.com with SMTP id p10so4756418pdj.3
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:17:26 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id np9sm31295151pbc.31.2014.03.07.17.17.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:17:25 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

by messy ipfix_fprintf_ functions.
---
 output/ulogd_output_IPFIX.c | 226 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 226 insertions(+)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 92db5c0..7d1a9bf 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -31,6 +31,7 @@
 #include <stdbool.h>
 #include <unistd.h>
 #include <string.h>
+#include <time.h>
 #include <errno.h>
 
 #include <sys/types.h>
@@ -152,6 +153,8 @@ struct ipfix_instance {
 #define ULOGD_IPFIX_TEMPL_BASE 1024
 static u_int16_t next_template_id = ULOGD_IPFIX_TEMPL_BASE;
 
+static int ipfix_fprintf_header(FILE *fd, const struct ipfix_msg_hdr *hdr);
+
 /* Build the IPFIX template from the input keys */
 struct ulogd_ipfix_template *
 build_template_for_bitmask(struct ulogd_pluginstance *upi,
@@ -374,6 +377,7 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ulogd_ipfix_template *template;
+	struct ipfix_msg_hdr *ipfix_msg;
 	unsigned int i;
 	bool need_template = false;
 
@@ -416,6 +420,15 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 		template->until_template = template_per_ce(upi->config_kset).u.value;
 	}
 
+	ipfix_msg = build_ipfix_msg(upi, template, need_template);
+	if (ipfix_msg == NULL)
+		return ULOGD_IRET_ERR;
+
+	ipfix_msg->export_time = htonl((u_int32_t)(time(NULL)));
+	ipfix_fprintf_header(stdout, ipfix_msg);
+	fprintf(stdout, "\n");
+
+	free(ipfix_msg);
 	return ULOGD_IRET_OK;
 }
 
@@ -614,3 +627,216 @@ void init(void)
 {
 	ulogd_register_plugin(&ipfix_plugin);
 }
+
+static int ipfix_fprintf_ietf_field(FILE *fd, const struct ipfix_ietf_field *field, int len);
+static int ipfix_fprintf_vendor_field(FILE *fd, const struct ipfix_vendor_field *field, int len);
+
+static int ipfix_fprintf_ietf_field(FILE *fd, const struct ipfix_ietf_field *field,
+				    int len)
+{
+	int ret;
+	void *ptr;
+
+	if (len < (int)sizeof(*field)) {
+		fprintf(fd, "ERROR ietf field: too short buflen for IETF field: %d\n", len);
+		return -1;
+	}
+
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|0 Information Emement id: %5d |            Field Length: %5d |\n",
+		ntohs(field->type), ntohs(field->length));
+
+	len -= sizeof(*field);
+	if (len == 0)
+		return sizeof(*field);
+
+	ptr = (void *)field + sizeof(*field);
+	if (*(u_int8_t *)ptr & 0x80)
+		ret = ipfix_fprintf_vendor_field(fd, ptr, len);
+	else
+		ret = ipfix_fprintf_ietf_field(fd, ptr, len);
+
+	if (ret == -1)
+		return -1;
+	return ret + sizeof(*field);
+}
+
+static int ipfix_fprintf_vendor_field(FILE *fd, const struct ipfix_vendor_field *field,
+				      int len)
+{
+	int ret;
+	void *ptr;
+
+	if (len < (int)sizeof(*field)) {
+		fprintf(fd, "ERROR vendor field: too short buflen for vendor field: %d\n", len);
+		return -1;
+	}
+
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|1 Information Emement id: %5d |            Field Length: %5d |\n",
+		ntohs(field->type) & 0x7fff, ntohs(field->length));
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|               Enterprise Number: %10d                     |\n",
+		ntohl(field->enterprise_num));
+
+	len -= sizeof(*field);
+	if (len == 0)
+		return sizeof(*field);
+
+	ptr = (void *)field + sizeof(*field);
+	if (*(u_int8_t *)ptr & 0x80) /* vendor */
+		ret = ipfix_fprintf_vendor_field(fd, ptr, len);
+	else /* ietf */
+		ret = ipfix_fprintf_ietf_field(fd, ptr, len);
+
+	if (ret == -1)
+		return -1;
+	return ret + sizeof(*field);
+}
+
+static int ipfix_fprintf_data_records(FILE *fd, const void *data, int len)
+{
+	int i;
+
+	fprintf(fd, "+-----------------------------------------------------------------+\n");
+	/* don't say messy...*/
+	for (i = 0; i < len; i += 4) {
+		switch (len - i - 4) {
+		case -3:
+			fprintf(fd, "|          0x%02x                                                   |\n",
+				*(u_int8_t *)(data + i));
+			break;
+		case -2:
+			fprintf(fd, "|          0x%02x          0x%02x                                     |\n",
+				*(u_int8_t *)(data + i), *(u_int8_t *)(data + i + 1));
+			break;
+		case -1:
+			fprintf(fd, "|          0x%02x          0x%02x          0x%02x                       |\n",
+				*(u_int8_t *)(data + i), *(u_int8_t *)(data + i + 1), *(u_int8_t *)(data + i + 2));
+			break;
+		default:
+			fprintf(fd, "|          0x%02x          0x%02x          0x%02x          0x%02x         |\n",
+				*(u_int8_t *)(data + i), *(u_int8_t *)(data + i + 1),
+				*(u_int8_t *)(data + i + 2), *(u_int8_t *)(data + i + 3));
+			break;
+		}
+	}
+	return len;
+}
+
+static int ipfix_fprintf_template_records(FILE *fd, const struct ipfix_templ_rec_hdr *hdr,
+					  int len)
+{
+	int ret;
+	void *field;
+
+	if (len < (int)sizeof(*hdr)) {
+		fprintf(fd, "ERROR template records: too short buflen for template record: %d\n", len);
+		return -1;
+	}
+
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|             Template ID: %5d |             Field Count: %5d |\n",
+		ntohs(hdr->templ_id), ntohs(hdr->field_count));
+
+	len -= sizeof(*hdr);
+	if (len == 0)
+		return sizeof(*hdr);
+
+	field = (void *)hdr + sizeof(*hdr);
+	if (*(u_int8_t *)field & 0x80)
+		ret = ipfix_fprintf_vendor_field(fd, field, len);
+	else
+		ret = ipfix_fprintf_ietf_field(fd, field, len);
+
+	if (ret == -1)
+		return -1;
+	return ret + sizeof(*hdr);
+}
+
+static int ipfix_fprintf_set_header(FILE *fd, const struct ipfix_set_hdr *hdr, int len)
+{
+	int ret, setlen, total_len;
+	void *ptr;
+
+	if (len < (int)sizeof(*hdr)) {
+		fprintf(fd, "ERROR set header: too short buflen for set header: %d\n", len);
+		return -1;
+	}
+	setlen = ntohs(hdr->length);
+	if (len < setlen) {
+		fprintf(fd, "ERROR set header: buflen: %d is smaller than set length field: %d\n", len, setlen);
+		/* return -1; */
+	}
+	if (setlen < (int)sizeof(*hdr)) {
+		fprintf(fd, "ERROR set header: too short set length field: %d\n", setlen);
+		return -1;
+	}
+
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|                  Set ID: %5d |                  Length: %5d |\n",
+		ntohs(hdr->set_id), setlen);
+
+	setlen -= sizeof(*hdr);
+	ptr = (void *)hdr + sizeof(*hdr);
+	total_len = sizeof(*hdr);
+
+	switch (ntohs(hdr->set_id)) {
+	case 2:
+		ret = ipfix_fprintf_template_records(fd, ptr, setlen);
+		break;
+	case 3:
+		/* XXX: ret = ipfix_fprintf_options_template_records(fd, ptr, setlen); */
+		fprintf(fd, "ERROR: options template is not implemented yet, sorry");
+		ret = setlen;
+		break;
+	default:
+		ret = ipfix_fprintf_data_records(fd, ptr, setlen);
+		break;
+	}
+
+	if (ret == -1 || ret != setlen)
+		return -1;
+
+	fprintf(fd, "+-----------------------------------------------------------------+\n");
+	return total_len + ret;
+}
+
+static int ipfix_fprintf_header(FILE *fd, const struct ipfix_msg_hdr *hdr)
+{
+	int ret, len;
+	char outstr[20];
+	void *ptr;
+	time_t t = (time_t)(ntohl(hdr->export_time));
+	struct tm *tmp = localtime(&t);
+
+	/* XXX: tmp == NULL and strftime == 0 */
+	strftime(outstr, sizeof(outstr), "%F %T", tmp);
+
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|          Version Number: %5d |                  Length: %5d |\n",
+		ntohs(hdr->version), ntohs(hdr->length));
+	fprintf(fd, "+--------------------------------+--------------------------------+\n");
+	fprintf(fd, "|                     Exoprt Time: %10d                     |\t%s\n",
+		ntohl(hdr->export_time), outstr);
+	fprintf(fd, "+-----------------------------------------------------------------+\n");
+	fprintf(fd, "|                 Sequence Number: %10d                     |\n",
+		ntohl(hdr->seq));
+	fprintf(fd, "+-----------------------------------------------------------------+\n");
+	fprintf(fd, "|           Observation Domain ID: %10d                     |\n",
+		ntohl(hdr->domain_id));
+	fprintf(fd, "+-----------------------------------------------------------------+\n");
+
+	len = ntohs(hdr->length) - sizeof(*hdr);
+	ptr = (void *)hdr + sizeof(*hdr);
+
+	while (len > 0) {
+		ret = ipfix_fprintf_set_header(fd, ptr, len);
+		if (ret == -1)
+			return -1;
+		len -= ret;
+		ptr += ret;
+	}
+
+	return ntohs(hdr->length) - len;
+}
-- 
1.8.5.3

