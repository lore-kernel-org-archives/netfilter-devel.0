From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 8/8] ipfix: build headers with template
Date: Wed, 26 Mar 2014 21:30:34 +0900
Message-ID: <20140326123033.GI24689@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <1395600620.23474.18.camel@ice-age2.regit.org>
 <20140326121122.GA24689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39388 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaCZMal (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:30:41 -0400
Received: by mail-pd0-f176.google.com with SMTP id r10so1800140pdi.7
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 05:30:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140326121122.GA24689@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Based on assumption that we send only two types packet, one has template
set and data set, another has data set only. Theses templates including
message header, set header and template records are put in struct
ulogd_ipfix_template as struct ipfix_msg_hdr.

Another assumption is that we can send only one dataset, cannot send
muliple datasets at onece. It's better to not include dataset buffer,
alloc it each time and use gather sendmsg to send multiple set with pre-
allocated headers.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 228 +++++++++++++++++++++++++++-----------------
 1 file changed, 141 insertions(+), 87 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index ffb8e6e..13f388f 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -126,18 +126,13 @@ static struct config_keyset ipfix_kset = {
 #define domain_ce(x)	(x->ces[3])
 #define template_per_ce(x)	(x->ces[4])
 
-struct ipfix_template {
-	struct ipfix_templ_rec_hdr hdr;
-	char buf[0];
-};
-
 struct ulogd_ipfix_template {
 	struct llist_head list;
 	struct nfct_bitmask *bitmask;
-	unsigned int data_length;	/* length of the DATA */
-	void *tmpl_cur;			/* cursor into current template position */
-	struct ipfix_template tmpl;
-	int until_template;			/* decide if it's time to retransmit our template */
+	int until_template;		/* decide if it's time to retransmit our template */
+	int tmpl_data_msg_len, data_only_msg_len;
+	struct ipfix_msg_hdr *tmpl_data_msg;	/* include records, set header of template, data */
+	struct ipfix_msg_hdr *data_only_msg;	/* include records, set header of data */
 };
 
 struct ipfix_instance {
@@ -155,36 +150,15 @@ static u_int16_t next_template_id = ULOGD_IPFIX_TEMPL_BASE;
 
 static int ipfix_fprintf_header(FILE *fd, const struct ipfix_msg_hdr *hdr);
 
-/* Build the IPFIX template from the input keys */
 struct ulogd_ipfix_template *
-build_template_for_bitmask(struct ulogd_pluginstance *upi,
+alloc_ulogd_ipfix_template(struct ulogd_pluginstance *upi,
 			   struct nfct_bitmask *bm)
 {
 	struct ulogd_ipfix_template *tmpl;
-	unsigned int i, j;
-	int size = sizeof(struct ulogd_ipfix_template)
-		   + (upi->input.num_keys * sizeof(struct ipfix_vendor_field));
-
-	tmpl = malloc(size);
-	if (!tmpl)
-		return NULL;
-	memset(tmpl, 0, size);
-
-	tmpl->bitmask = nfct_bitmask_clone(bm);
-	if (!tmpl->bitmask) {
-		free(tmpl);
-		return NULL;
-	}
-
-	/* initialize template header */
-	tmpl->tmpl.hdr.templ_id = htons(next_template_id++);
-
-	tmpl->tmpl_cur = tmpl->tmpl.buf;
-
-	tmpl->data_length = 0;
-	tmpl->until_template = template_per_ce(upi->config_kset).u.value;
+	unsigned int i;
+	int tmpl_len = 0, data_len = 0;
 
-	for (i = 0, j = 0; i < upi->input.num_keys; i++) {
+	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = &upi->input.keys[i];
 		int length = ulogd_key_size(key);
 
@@ -204,27 +178,130 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 			continue;
 		}
 
+		if (key->ipfix.vendor == IPFIX_VENDOR_IETF)
+			tmpl_len += sizeof(struct ipfix_ietf_field);
+		else
+			tmpl_len += sizeof(struct ipfix_vendor_field);
+
+		data_len += length;
+	}
+
+	tmpl = calloc(sizeof(struct ulogd_ipfix_template), 1);
+	if (tmpl == NULL)
+		return NULL;
+
+	tmpl->bitmask = nfct_bitmask_clone(bm);
+	if (!tmpl->bitmask)
+		goto free_tmpl;
+
+	tmpl->data_only_msg_len = sizeof(struct ipfix_msg_hdr)
+		+ sizeof(struct ipfix_set_hdr) + data_len;
+	tmpl->tmpl_data_msg_len = tmpl->data_only_msg_len
+		+ sizeof(struct ipfix_templ_rec_hdr)
+		+ sizeof(struct ipfix_set_hdr) + tmpl_len;
+
+	tmpl->tmpl_data_msg = malloc(tmpl->tmpl_data_msg_len);
+	if (tmpl->tmpl_data_msg == NULL)
+		goto free_bitmask;
+	memset(tmpl->tmpl_data_msg, 0, tmpl->tmpl_data_msg_len);
+
+	tmpl->data_only_msg = malloc(tmpl->data_only_msg_len);
+	if (tmpl->data_only_msg == NULL)
+		goto free_tmpl_data_msg;
+	memset(tmpl->data_only_msg, 0, tmpl->data_only_msg_len);
+
+	return tmpl;
+
+free_tmpl_data_msg:
+	free(tmpl->tmpl_data_msg);
+free_bitmask:
+	free(tmpl->bitmask);
+free_tmpl:
+	free(tmpl);
+
+	return NULL;
+}
+
+/* Build the IPFIX template from the input keys */
+struct ulogd_ipfix_template *
+build_template_for_bitmask(struct ulogd_pluginstance *upi,
+			   struct nfct_bitmask *bm)
+{
+	struct ulogd_ipfix_template *tmpl;
+	struct ipfix_msg_hdr *msg_hdr;
+	struct ipfix_templ_rec_hdr *tmpl_hdr;
+	struct ipfix_set_hdr *set_hdr;
+	unsigned int i, field_count;
+	void *ptr;
+
+	tmpl = alloc_ulogd_ipfix_template(upi, bm);
+	if (tmpl == NULL)
+		return NULL;
+
+	tmpl->until_template = template_per_ce(upi->config_kset).u.value;
+
+	/* build template records */
+	ptr = (void *)tmpl->tmpl_data_msg + sizeof(struct ipfix_msg_hdr)
+		+ sizeof(struct ipfix_set_hdr) + sizeof(struct ipfix_templ_rec_hdr);
+	for (i = 0, field_count = 0; i < upi->input.num_keys; i++) {
+		struct ulogd_key *key = &upi->input.keys[i];
+		int length = ulogd_key_size(key);
+
+		if (!(key->u.source->flags & ULOGD_RETF_VALID))
+			continue;
+		if (length < 0 || length > 0xfffe)
+			continue;
+		if (key->ipfix.field_id == 0)
+			continue;
+	
 		if (key->ipfix.vendor == IPFIX_VENDOR_IETF) {
-			struct ipfix_ietf_field *field = 
-				(struct ipfix_ietf_field *) tmpl->tmpl_cur;
+			struct ipfix_ietf_field *field = (struct ipfix_ietf_field *)ptr;
 
 			field->type = htons(key->ipfix.field_id);
 			field->length = htons(length);
-			tmpl->tmpl_cur += sizeof(*field);
+			ptr += sizeof(*field);
 		} else {
-			struct ipfix_vendor_field *field =
-				(struct ipfix_vendor_field *) tmpl->tmpl_cur;
+			struct ipfix_vendor_field *field =(struct ipfix_vendor_field *)ptr;
 
 			field->type = htons(key->ipfix.field_id | 0x8000);
-			field->enterprise_num = htonl(key->ipfix.vendor);
 			field->length = htons(length);
-			tmpl->tmpl_cur += sizeof(*field);
+			field->enterprise_num = htonl(key->ipfix.vendor);
+			ptr += sizeof(*field);
 		}
-		tmpl->data_length += length;
-		j++;
+		field_count++;
 	}
 
-	tmpl->tmpl.hdr.field_count = htons(j);
+	/** initialize ipfix message header with template and data */
+	msg_hdr = tmpl->tmpl_data_msg;
+	msg_hdr->version = htons(10);
+	msg_hdr->length = htons(tmpl->tmpl_data_msg_len);
+	msg_hdr->domain_id = htonl(domain_ce(upi->config_kset).u.value);
+
+	/* initialize template set header */
+	set_hdr = (void *)msg_hdr + sizeof(*msg_hdr);
+	set_hdr->set_id = htons(2);
+	set_hdr->length = htons(tmpl->tmpl_data_msg_len - tmpl->data_only_msg_len);
+
+	/* initialize template record header */
+	tmpl_hdr = (void *)set_hdr + sizeof(*set_hdr);
+	tmpl_hdr->templ_id = htons(next_template_id++);
+	tmpl_hdr->field_count = htons(field_count);
+
+	/* initialize data set header */
+	set_hdr = ptr;
+	set_hdr->set_id = tmpl_hdr->templ_id;
+	set_hdr->length = htons(tmpl->data_only_msg_len - sizeof(struct ipfix_msg_hdr));
+
+	/** initialize ipfix message header with data only */
+	msg_hdr = tmpl->data_only_msg;
+	msg_hdr->version = htons(10);
+	msg_hdr->length = htons(tmpl->data_only_msg_len);
+	msg_hdr->domain_id = htonl(domain_ce(upi->config_kset).u.value);
+
+	/* initialize data set header */
+	set_hdr = (void *)msg_hdr + sizeof(*msg_hdr);
+	set_hdr->set_id = tmpl_hdr->templ_id;
+	set_hdr->length = htons(tmpl->data_only_msg_len - sizeof(struct ipfix_msg_hdr));
 
 	return tmpl;
 }
@@ -321,59 +398,36 @@ static struct ipfix_msg_hdr *build_ipfix_msg(struct ulogd_pluginstance *upi,
 					     bool need_template)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-	u_int16_t tmpl_len;
 	struct ipfix_msg_hdr *msg_hdr;
-	struct ipfix_templ_rec_hdr *tmpl_hdr;
-	struct ipfix_set_hdr *data_hdr, *tmpl_set_hdr;
-	void *buf;
-	int msglen, ret;
-
-	msglen = sizeof(struct ipfix_msg_hdr) + sizeof(struct ipfix_set_hdr)
-		+ template->data_length;
-	if (need_template)
-		msglen = msglen + sizeof(struct ipfix_set_hdr)
-			+ (template->tmpl_cur - (void *)&template->tmpl);
-	buf = malloc(msglen);
-	if (buf == NULL)
-		return NULL;
-	memset(buf, 0, msglen);
+	void *data_records;
+	int ret, data_len;
 
-	/* ipfix msg header */
-	msg_hdr = buf;
-	msg_hdr->version = htons(10);
-	msg_hdr->length = htons(msglen);
-	msg_hdr->seq = htonl(ii->seq++);
-	msg_hdr->domain_id = htonl(domain_ce(upi->config_kset).u.value);
 	if (need_template) {
-		/* put set header and template records */
-		tmpl_set_hdr = buf + sizeof(*msg_hdr);
-		tmpl_set_hdr->set_id = htons(2);
-		tmpl_len = template->tmpl_cur - (void *)&template->tmpl;
-		tmpl_set_hdr->length = htons(sizeof(*tmpl_set_hdr) + tmpl_len);
-		tmpl_hdr = (void *)tmpl_set_hdr + sizeof(*tmpl_set_hdr);
-		memcpy((void *)tmpl_hdr, (void *)&template->tmpl, tmpl_len);
-		data_hdr = (void *)tmpl_hdr + tmpl_len;
+		int tmpl_len = template->tmpl_data_msg_len - template->data_only_msg_len;
+		msg_hdr = template->tmpl_data_msg;
+		data_records = (void *)msg_hdr + sizeof(struct ipfix_msg_hdr)
+			+ tmpl_len + sizeof(struct ipfix_set_hdr);
 	} else {
-		data_hdr = buf + sizeof(*msg_hdr);
+		msg_hdr = template->data_only_msg;
+		data_records = (void *)msg_hdr + sizeof(struct ipfix_msg_hdr)
+			+ sizeof(struct ipfix_set_hdr);
 	}
+	msg_hdr->seq = htonl(ii->seq++);
+
+	data_len = template->data_only_msg_len - sizeof(struct ipfix_msg_hdr)
+		- sizeof(struct ipfix_set_hdr);
+	memset(data_records, 0, data_len);
 
-	/* put set header and data records */
-	data_hdr->set_id = template->tmpl.hdr.templ_id; /* already ordered */
-	data_hdr->length = htons(sizeof(*data_hdr) + template->data_length);
-	ret = put_data_records(upi, template, (void *)data_hdr + sizeof(*data_hdr));
+	ret = put_data_records(upi, template, data_records);
 	if (ret < 0) {
 		ulogd_log(ULOGD_ERROR, "could not build ipfix dataset");
-		goto free_buf;
-	} else if (ret > msglen) {
+		return NULL;
+	} else if (ret > data_len) {
 		ulogd_log(ULOGD_ERROR, "overflowed on building ipfix dataset");
-		goto free_buf;
+		return NULL;
 	}
 
 	return msg_hdr;
-
-free_buf:
-	free(buf);
-	return NULL;
 }
 
 static int output_ipfix(struct ulogd_pluginstance *upi)
@@ -418,10 +472,11 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 		need_template = true;
 	}
 	
-	if (template->until_template-- == 0) {
+	if (template->until_template == 0) {
 		need_template = true;
 		template->until_template = template_per_ce(upi->config_kset).u.value;
 	}
+	template->until_template--;
 
 	ipfix_msg = build_ipfix_msg(upi, template, need_template);
 	if (ipfix_msg == NULL)
@@ -431,7 +486,6 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 	ipfix_fprintf_header(stdout, ipfix_msg);
 	fprintf(stdout, "\n");
 
-	free(ipfix_msg);
 	return ULOGD_IRET_OK;
 }
 
-- 
1.8.5.3

