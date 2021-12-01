Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE569C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351722AbhLARhT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351953AbhLARgc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:32 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE04BC06175A
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:10 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so373430wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EycMT9YqvBnyagFfj0ikXVnkXIH3mk6XPHp8pqe+Wvc=;
        b=hm2+cNM0AKxVZpaILVVRAlHphw4tiSLMciue7MGVy8wfS515Hux0TU0H9rantEDJl/
         924nhlXycEqTJb3BF3290khcmBo8U8MgzJ/l1V7knQI059Tf8TcoV/w+ZiCWBZkuAdjh
         VaR9+jgIMbn63X6PrnTg7d2+a9MZTQZN1GCem2Hl8Ed4YKUVwd4cYhiMXwvf/DI2SbZz
         vLXJ+H+ODpm7q/p6Vh4l3gTCHM/9fyhhBtXAA4qEOIgeyVXfX7AXruFDplmpj0GbeXP0
         oNZswBTrZWlhw0p9FY99Oyqr1p3nbKszm7k8fmIAFNO7ENI9FqF1gAW5AAfSCqUT27DT
         dTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EycMT9YqvBnyagFfj0ikXVnkXIH3mk6XPHp8pqe+Wvc=;
        b=J+JN0v3s9+1A4CEUOr3yCNaE+mJnfKUnvTHT/aaqNbAVUvKjRHlVTOsWPBEfmtKxvM
         Kbe80qnoKMk3m7cWATkztmZtorllVzkhy8RpuzBY+yGyqOHFnkWsI6rU5qBqpq24+O97
         zWKeuCM6znWoTXH/MbJElZj4BM/HP4At/HSOC7wMinP9cLgSKsDD87fHtdiJ9Ve6eoek
         knkHOfLKgWq8jUaYr1jnAnGoCQ0Q925kpXOYKJyf9UxwYrhuxxMDA5R57w3ysos/7g4Y
         Ai2JEnn90ELGeb0lDg7O2UnCRKIpbSCeJQqmQ+/yZU4kpGlCkOtbQvBj+dggYwQTLjA6
         xuXA==
X-Gm-Message-State: AOAM532xAJT+IsXd3KITsJUOSVxcrDFp/s7pmKpj7K0Ob5tbqqxRw3Mp
        Z1vtv/VDewQYF7nvwpAtuj3/IhqIuMjvnA==
X-Google-Smtp-Source: ABdhPJz3P9nyGFP97AGTaeehKroQG+bCIRNzMUFCBlJf5WqNwtgBcEePax8dqU4Ggg3jIiYQBtiWaw==
X-Received: by 2002:a1c:a905:: with SMTP id s5mr8930727wme.150.1638379988879;
        Wed, 01 Dec 2021 09:33:08 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:08 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 4/6] conntrack: use libmnl for updating conntrack table
Date:   Wed,  1 Dec 2021 18:32:51 +0100
Message-Id: <20211201173253.33432-5-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
References: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to update the conntrack
table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 248 ++++++++++++++++++++++++++++--------------------
 1 file changed, 143 insertions(+), 105 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 0949f6a..327ca55 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -68,10 +68,13 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
-static struct nfct_mnl_socket {
+struct nfct_mnl_socket {
 	struct mnl_socket	*mnl;
 	uint32_t		portid;
-} sock;
+};
+
+static struct nfct_mnl_socket sock;
+static struct nfct_mnl_socket modifier_sock;
 
 struct u32_mask {
 	uint32_t value;
@@ -2073,33 +2076,6 @@ done:
 	return NFCT_CB_CONTINUE;
 }
 
-static int print_cb(enum nf_conntrack_msg_type type,
-		    struct nf_conntrack *ct,
-		    void *data)
-{
-	char buf[1024];
-	unsigned int op_type = NFCT_O_DEFAULT;
-	unsigned int op_flags = 0;
-
-	if (output_mask & _O_SAVE) {
-		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
-		goto done;
-	}
-
-	if (output_mask & _O_XML)
-		op_type = NFCT_O_XML;
-	if (output_mask & _O_EXT)
-		op_flags = NFCT_OF_SHOW_LAYER3;
-	if (output_mask & _O_ID)
-		op_flags |= NFCT_OF_ID;
-
-	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
-done:
-	printf("%s\n", buf);
-
-	return NFCT_CB_CONTINUE;
-}
-
 static void copy_mark(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
 		      const struct nf_conntrack *ct,
 		      const struct u32_mask *m)
@@ -2190,73 +2166,6 @@ static void copy_label(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
 	}
 }
 
-static int update_cb(enum nf_conntrack_msg_type type,
-		     struct nf_conntrack *ct,
-		     void *data)
-{
-	struct ct_cmd *cmd = data;
-	struct nf_conntrack *obj = cmd->tmpl.ct, *tmp;
-	int res;
-
-	if (filter_nat(cmd, ct) ||
-	    filter_label(ct, cur_tmpl) ||
-	    filter_network(cmd, ct))
-		return NFCT_CB_CONTINUE;
-
-	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
-	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
-	    	return NFCT_CB_CONTINUE;
-
-	if (cmd->options & CT_OPT_TUPLE_ORIG &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
-		return NFCT_CB_CONTINUE;
-	if (cmd->options & CT_OPT_TUPLE_REPL &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_REPL))
-		return NFCT_CB_CONTINUE;
-
-	tmp = nfct_new();
-	if (tmp == NULL)
-		exit_error(OTHER_PROBLEM, "out of memory");
-
-	nfct_copy(tmp, ct, NFCT_CP_ORIG);
-	nfct_copy(tmp, obj, NFCT_CP_META);
-	copy_mark(cmd, tmp, ct, &cur_tmpl->mark);
-	copy_status(cmd, tmp, ct);
-	copy_label(cmd, tmp, ct, cur_tmpl);
-
-	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
-	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
-		nfct_destroy(tmp);
-		return NFCT_CB_CONTINUE;
-	}
-
-	res = nfct_query(ith, NFCT_Q_UPDATE, tmp);
-	if (res < 0)
-		fprintf(stderr,
-			   "Operation failed: %s\n",
-			   err2str(errno, CT_UPDATE));
-	nfct_callback_register(ith, NFCT_T_ALL, print_cb, NULL);
-
-	res = nfct_query(ith, NFCT_Q_GET, tmp);
-	if (res < 0) {
-		nfct_destroy(tmp);
-		/* the entry has vanish in middle of the update */
-		if (errno == ENOENT) {
-			nfct_callback_unregister(ith);
-			return NFCT_CB_CONTINUE;
-		}
-		exit_error(OTHER_PROBLEM,
-			   "Operation failed: %s",
-			   err2str(errno, CT_UPDATE));
-	}
-	nfct_destroy(tmp);
-	nfct_callback_unregister(ith);
-
-	counter++;
-
-	return NFCT_CB_CONTINUE;
-}
-
 static int dump_exp_cb(enum nf_conntrack_msg_type type,
 		      struct nf_expect *exp,
 		      void *data)
@@ -2519,6 +2428,29 @@ nfct_mnl_create(struct nfct_mnl_socket *socket,
 		      NULL, NULL);
 }
 
+static int
+nfct_mnl_update(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
+{
+	return nfct_mnl_call(socket, subsys, type,
+		      NLM_F_REQUEST|NLM_F_ACK,
+		      ct, 0,
+		      NULL,
+		      NULL, NULL);
+}
+
+static int
+nfct_mnl_print(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, const struct nf_conntrack *ct,
+	      mnl_cb_t cb)
+{
+	return nfct_mnl_call(socket, subsys, type,
+		      NLM_F_REQUEST|NLM_F_ACK,
+		      ct, 0,
+		      NULL,
+		      cb, NULL);
+}
+
 #define UNKNOWN_STATS_NUM 4
 
 static int nfct_stats_attr_cb(const struct nlattr *attr, void *data)
@@ -2707,6 +2639,113 @@ done:
 	return MNL_CB_OK;
 }
 
+static int mnl_nfct_print_cb(const struct nlmsghdr *nlh, void *data)
+{
+	char buf[1024];
+	unsigned int op_type = NFCT_O_DEFAULT;
+	unsigned int op_flags = 0;
+	struct nf_conntrack *ct;
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
+	if (output_mask & _O_XML)
+		op_type = NFCT_O_XML;
+	if (output_mask & _O_EXT)
+		op_flags = NFCT_OF_SHOW_LAYER3;
+	if (output_mask & _O_ID)
+		op_flags |= NFCT_OF_ID;
+
+	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
+	printf("%s\n", buf);
+
+	return MNL_CB_OK;
+}
+
+static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *ct, *obj = cmd->tmpl.ct, *tmp = NULL;
+	int res;
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	if (filter_nat(cmd, ct) ||
+	    filter_label(ct, cur_tmpl) ||
+	    filter_network(cmd, ct))
+		goto destroy_ok;
+
+	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
+	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
+		goto destroy_ok;
+
+	if (cmd->options & CT_OPT_TUPLE_ORIG &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
+		goto destroy_ok;
+	if (cmd->options & CT_OPT_TUPLE_REPL &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_REPL))
+		goto destroy_ok;
+
+	tmp = nfct_new();
+	if (tmp == NULL)
+		exit_error(OTHER_PROBLEM, "out of memory");
+
+	nfct_copy(tmp, ct, NFCT_CP_ORIG);
+	nfct_copy(tmp, obj, NFCT_CP_META);
+	copy_mark(cmd, tmp, ct, &cur_tmpl->mark);
+	copy_status(cmd, tmp, ct);
+	copy_label(cmd, tmp, ct, cur_tmpl);
+
+	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
+	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
+		goto destroy_ok;
+
+	res = nfct_mnl_update(&modifier_sock,
+						NFNL_SUBSYS_CTNETLINK,
+						IPCTNL_MSG_CT_NEW,
+						tmp);
+	if (res < 0)
+		fprintf(stderr,
+			   "Operation failed: %s\n",
+			   err2str(errno, CT_UPDATE));
+
+	res = nfct_mnl_print(&modifier_sock,
+			    NFNL_SUBSYS_CTNETLINK,
+			    IPCTNL_MSG_CT_GET,
+			    tmp,
+			    mnl_nfct_print_cb);
+	if (res < 0) {
+		/* the entry has vanish in middle of the update */
+		if (errno == ENOENT)
+			goto destroy_ok;
+		exit_error(OTHER_PROBLEM,
+			   "Operation failed: %s",
+			   err2str(errno, CT_UPDATE));
+	}
+
+	counter++;
+
+destroy_ok:
+	if (tmp)
+		nfct_destroy(tmp);
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+
 static struct ctproto_handler *h;
 
 static void labelmap_init(void)
@@ -3368,19 +3407,18 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_UPDATE:
-		cth = nfct_open(CONNTRACK, 0);
-		/* internal handler for delete_cb, otherwise we hit EILSEQ */
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
+		if (nfct_mnl_socket_open(&sock, 0) < 0
+				|| nfct_mnl_socket_open(&modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd);
-
-		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
-		nfct_close(ith);
-		nfct_close(cth);
+		res = nfct_mnl_dump(&sock,
+				    NFNL_SUBSYS_CTNETLINK,
+				    IPCTNL_MSG_CT_GET,
+				    mnl_nfct_update_cb, cmd, NULL);
+		nfct_mnl_socket_close(&modifier_sock);
+		nfct_mnl_socket_close(&sock);
 		break;
 
 	case CT_DELETE:
-- 
2.25.1

