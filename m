From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH 6/8] ipfix: decide whether prepending template by send times
Date: Sat, 8 Mar 2014 10:15:36 +0900
Message-ID: <20140308011534.GG4415@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50171 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaCHBPp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:15:45 -0500
Received: by mail-pb0-f53.google.com with SMTP id rp16so4875580pbb.40
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:15:44 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id lh13sm17122451pab.4.2014.03.07.17.15.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:15:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

specified in config file and kept it until_template in struct
ulogd_ipfix_template

---
 output/ulogd_output_IPFIX.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index c950fe2..92db5c0 100644
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
@@ -365,7 +374,8 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ulogd_ipfix_template *template;
-	unsigned int total_size, i;
+	unsigned int i;
+	bool need_template = false;
 
 	/* FIXME: it would be more cache efficient if the IS_VALID
 	 * flags would be a separate bitmask outside of the array.
@@ -398,16 +408,12 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
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

