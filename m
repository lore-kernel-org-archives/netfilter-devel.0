From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 4/13] ipfix: some cleanups
Date: Mon, 28 Apr 2014 20:46:55 +0900
Message-ID: <20140428114655.GE12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63746 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaD1LrB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:47:01 -0400
Received: by mail-pd0-f179.google.com with SMTP id y10so673944pdj.24
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:47:01 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id xx4sm34504860pbb.51.2014.04.28.04.46.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:47:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

remove unused variables.
use unsigned int to supress gcc warning.
change struct field name from total_length to data_length.
make same bitmask key.
change tmpl_cur to void * to calc size.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 333d532..7ba8712 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -105,8 +105,8 @@ struct ipfix_template {
 struct ulogd_ipfix_template {
 	struct llist_head list;
 	struct nfct_bitmask *bitmask;
-	unsigned int total_length;	/* length of the DATA */
-	char *tmpl_cur;		/* cursor into current template position */
+	unsigned int data_length;	/* length of the DATA */
+	void *tmpl_cur;			/* cursor into current template position */
 	struct ipfix_template tmpl;
 };
 
@@ -116,13 +116,7 @@ struct ipfix_instance {
 	int sock_proto;	/* protocol (IPPROTO_*) */
 
 	struct llist_head template_list;
-
-	struct ipfix_template *tmpl;
-	unsigned int tmpl_len;
-
 	struct nfct_bitmask *valid_bitmask;	/* bitmask of valid keys */
-
-	unsigned int total_length;	/* total size of all data elements */
 };
 
 #define ULOGD_IPFIX_TEMPL_BASE 1024
@@ -133,8 +127,6 @@ struct ulogd_ipfix_template *
 build_template_for_bitmask(struct ulogd_pluginstance *upi,
 			   struct nfct_bitmask *bm)
 {
-	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-	struct ipfix_templ_rec_hdr *rhdr;
 	struct ulogd_ipfix_template *tmpl;
 	unsigned int i, j;
 	int size = sizeof(struct ulogd_ipfix_template)
@@ -156,7 +148,7 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 
 	tmpl->tmpl_cur = tmpl->tmpl.buf;
 
-	tmpl->total_length = 0;
+	tmpl->data_length = 0;
 
 	for (i = 0, j = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = &upi->input.keys[i];
@@ -194,7 +186,7 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 			field->length = htons(length);
 			tmpl->tmpl_cur += sizeof(*field);
 		}
-		tmpl->total_length += length;
+		tmpl->data_length += length;
 		j++;
 	}
 
@@ -224,8 +216,7 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
 	struct ulogd_ipfix_template *template;
-	unsigned int total_size;
-	int i;
+	unsigned int total_size, i;
 
 	/* FIXME: it would be more cache efficient if the IS_VALID
 	 * flags would be a separate bitmask outside of the array.
@@ -235,10 +226,17 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 	nfct_bitmask_clear(ii->valid_bitmask);
 
 	for (i = 0; i < upi->input.num_keys; i++) {
-		struct ulogd_key *key = upi->input.keys[i].u.source;
+		struct ulogd_key *key = &upi->input.keys[i];
+		int length = ulogd_key_size(key);
 
-		if (key->flags & ULOGD_RETF_VALID)
-			nfct_bitmask_set_bit(ii->valid_bitmask, i);
+		if (length < 0 || length > 0xfffe)
+			continue;
+		if (!(key->u.source->flags & ULOGD_RETF_VALID))
+			continue;
+		if (key->ipfix.field_id == 0)
+			continue;
+
+		nfct_bitmask_set_bit(ii->valid_bitmask, i);
 	}
 	
 	/* lookup template ID for this bitmask */
@@ -253,7 +251,7 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 		llist_add(&template->list, &ii->template_list);
 	}
 	
-	total_size = template->total_length;
+	total_size = template->data_length;
 
 	/* decide if it's time to retransmit our template and (optionally)
 	 * prepend it into the to-be-sent IPFIX message */
@@ -382,8 +380,6 @@ static int stop_ipfix(struct ulogd_pluginstance *pi)
 
 static void signal_handler_ipfix(struct ulogd_pluginstance *pi, int signal)
 {
-	struct ipfix_instance *li = (struct ipfix_instance *) &pi->private;
-
 	switch (signal) {
 	case SIGHUP:
 		ulogd_log(ULOGD_NOTICE, "ipfix: reopening connection\n");
-- 
1.9.1

