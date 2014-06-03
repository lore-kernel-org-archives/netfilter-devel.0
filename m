From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 06/12] ipfix: decide whether prepending template by
 send times
Date: Tue, 3 Jun 2014 19:10:33 +0900
Message-ID: <20140603101033.GG24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42305 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaFCKKj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:10:39 -0400
Received: by mail-pd0-f172.google.com with SMTP id fp1so4500397pdb.31
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:10:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

specified in config file and kept it until_template in struct ulogd_ipfix_template

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 352b5a7..f9e23bb 100644
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
+		{
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
@@ -355,7 +364,8 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ulogd_ipfix_template *template;
-	unsigned int total_size, i;
+	unsigned int i;
+	bool need_template = false;
 
 	/* FIXME: it would be more cache efficient if the IS_VALID
 	 * flags would be a separate bitmask outside of the array.
@@ -388,16 +398,12 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
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
1.9.1

