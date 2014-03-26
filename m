From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 6/8] ipfix: decide whether prepending template by send
 times
Date: Wed, 26 Mar 2014 21:26:40 +0900
Message-ID: <20140326122639.GG24689@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <1395600620.23474.18.camel@ice-age2.regit.org>
 <20140326121122.GA24689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33810 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaCZM0r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:26:47 -0400
Received: by mail-pd0-f176.google.com with SMTP id r10so1804389pdi.21
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 05:26:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140326121122.GA24689@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

specified in config file and kept it until_template in struct ulogd_ipfix_template

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 8246ed3..9e8f140 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -85,7 +85,7 @@ struct sctp_sndrcvinfo {
 #define IPFIX_DEFAULT_TCPUDP_PORT	4739
 
 static struct config_keyset ipfix_kset = {
-	.num_ces = 4,
+	.num_ces = 5,
 	.ces = {
 		{
 			.key 	 = "host",
@@ -110,6 +110,12 @@ static struct config_keyset ipfix_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+ 		{
+			.key	 = "send_template_per",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 16,
+		},
 	},
 };
 
@@ -117,6 +123,7 @@ static struct config_keyset ipfix_kset = {
 #define port_ce(x)	(x->ces[1])
 #define proto_ce(x)	(x->ces[2])
 #define domain_ce(x)	(x->ces[3])
+#define template_per_ce(x)	(x->ces[4])
 
 struct ipfix_template {
 	struct ipfix_templ_rec_hdr hdr;
@@ -129,6 +136,7 @@ struct ulogd_ipfix_template {
 	unsigned int data_length;	/* length of the DATA */
 	void *tmpl_cur;			/* cursor into current template position */
 	struct ipfix_template tmpl;
+	int until_template;			/* decide if it's time to retransmit our template */
 };
 
 struct ipfix_instance {
@@ -171,6 +179,7 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 	tmpl->tmpl_cur = tmpl->tmpl.buf;
 
 	tmpl->data_length = 0;
+	tmpl->until_template = template_per_ce(upi->config_kset).u.value;
 
 	for (i = 0, j = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = &upi->input.keys[i];
@@ -368,7 +377,8 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ulogd_ipfix_template *template;
-	unsigned int total_size, i;
+	unsigned int i;
+	bool need_template = false;
 
 	/* FIXME: it would be more cache efficient if the IS_VALID
 	 * flags would be a separate bitmask outside of the array.
@@ -401,16 +411,12 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 			return ULOGD_IRET_ERR;
 		}
 		llist_add(&template->list, &ii->template_list);
+		need_template = true;
 	}
 	
-	total_size = template->data_length;
-
-	/* decide if it's time to retransmit our template and (optionally)
-	 * prepend it into the to-be-sent IPFIX message */
-	if (0 /* FIXME */) {
-		/* add size of template */
-		//total_size += (template->tmpl_cur - (void *)&template->tmpl);
-		total_size += sizeof(template->tmpl);
+	if (template->until_template-- == 0) {
+		need_template = true;
+		template->until_template = template_per_ce(upi->config_kset).u.value;
 	}
 
 	return ULOGD_IRET_OK;
-- 
1.8.5.3

