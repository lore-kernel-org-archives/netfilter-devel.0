Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7934C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351731AbhLARhT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351974AbhLARgd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:33 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCB6C06175B
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:12 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso338274wms.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ip5wQyK/YVDgcvoJxyn/v0bZe8UO1Cl6DfKQsLUu9SY=;
        b=YcqTAM3X17PQfzM3fhSghYkTl7t841v+6g1gpkLmRUlmWV26xLCarifYg753gGBjfH
         aIpTRQwfMq056LZp895SPUcbcAnU4JVztisJgNqwEMEl9m0/upOzsonQ/U6ahk9zpOoE
         vwLDRgEHscqGU2YeNH01TCkeCdYtQWdQn37ygnD5XlJ9g6JA7CJmWn9XChX11btiSAxx
         BXaJYB9JIOC0hjEaHkC7nnXK3dV1Pw0g+LFaGbJZ58H0USUECKywrivrKiWRt0+DcSvK
         fNEJY1va6sE93oKOl4WylNUR0FFWGf006IRgqKXYDdI0Imommpc20SgdJy0CVnSj0PAY
         Ukrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ip5wQyK/YVDgcvoJxyn/v0bZe8UO1Cl6DfKQsLUu9SY=;
        b=1Be56S4Y9cXRWmHzVyfV7taJ4UjBktfHpQwmeDuixCdp9iRs56TU1aL68IdYNGfv5p
         SsZw7Mo+T1P71GOkA1BGKqOcrJLEVu/Qf6TCiBNaMBmjMrQJtn50/v0i/B8KLrvLPL+P
         c2ac64y0o7agmJETWstsdhKl8A252F2x7FLswEjq/1p/S4MewxA5PNzI9kCUfn3XnJeX
         hzdaszFDILjfMp/OcICnlH1Nid2wu5WSPpKjX3Ox4iOydXfrl4kqcjPRGceitclOEs9o
         8V5Q8Ufxrw7SG3x6T1zdAcQllkHtuKEJsYG6zOxpKV7m0moXdpxAM2CbKpdyPv1QVlih
         jvjQ==
X-Gm-Message-State: AOAM530ACDtur8f3+WaKWJcp4SVNUK4C+ImtJQ0wi4I5bIuTD6NuTxMm
        4rs8YRwI3H/Bp+XmwguYEMx3IiBLiMehvA==
X-Google-Smtp-Source: ABdhPJyC1oSe16MPvcURgQcuxWE7yVHlUVQV6n100eyjUh2TqAgMS4o62DHBfEqETS1sviweK8mfkg==
X-Received: by 2002:a05:600c:2dc8:: with SMTP id e8mr8702485wmh.189.1638379990601;
        Wed, 01 Dec 2021 09:33:10 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:09 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 5/6] conntrack: use libmnl for ct entries deletion
Date:   Wed,  1 Dec 2021 18:32:52 +0100
Message-Id: <20211201173253.33432-6-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
References: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to delete
the conntrack table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 108 ++++++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 49 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 327ca55..de5c051 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -608,7 +608,7 @@ static const char usage_parameters[] =
 
 #define OPTION_OFFSET 256
 
-static struct nfct_handle *cth, *ith;
+static struct nfct_handle *cth;
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
@@ -2036,46 +2036,6 @@ done:
 	return NFCT_CB_CONTINUE;
 }
 
-static int delete_cb(enum nf_conntrack_msg_type type,
-		     struct nf_conntrack *ct,
-		     void *data)
-{
-	unsigned int op_type = NFCT_O_DEFAULT;
-	unsigned int op_flags = 0;
-	struct ct_cmd *cmd = data;
-	char buf[1024];
-	int res;
-
-	if (nfct_filter(cmd, ct, cur_tmpl))
-		return NFCT_CB_CONTINUE;
-
-	res = nfct_query(ith, NFCT_Q_DESTROY, ct);
-	if (res < 0)
-		exit_error(OTHER_PROBLEM,
-			   "Operation failed: %s",
-			   err2str(errno, CT_DELETE));
-
-	if (output_mask & _O_SAVE) {
-		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_DESTROY);
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
-	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags);
-done:
-	printf("%s\n", buf);
-
-	counter++;
-
-	return NFCT_CB_CONTINUE;
-}
-
 static void copy_mark(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
 		      const struct nf_conntrack *ct,
 		      const struct u32_mask *m)
@@ -2746,6 +2706,56 @@ destroy_ok:
 	return MNL_CB_OK;
 }
 
+static int mnl_nfct_delete_cb(const struct nlmsghdr *nlh, void *data)
+{
+	unsigned int op_type = NFCT_O_DEFAULT;
+	unsigned int op_flags = 0;
+	struct ct_cmd *cmd = data;
+	char buf[1024];
+	int res;
+	struct nf_conntrack *ct;
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	if (nfct_filter(cmd, ct, cur_tmpl))
+		goto destroy_ok;
+
+	res = nfct_mnl_update(&modifier_sock,
+						NFNL_SUBSYS_CTNETLINK,
+						IPCTNL_MSG_CT_DELETE,
+						ct);
+	if (res < 0)
+		exit_error(OTHER_PROBLEM,
+			   "Operation failed: %s",
+			   err2str(errno, CT_DELETE));
+
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_DESTROY);
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
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags);
+done:
+	printf("%s\n", buf);
+
+	counter++;
+
+destroy_ok:
+	nfct_destroy(ct);
+	return NFCT_CB_CONTINUE;
+}
+
 static struct ctproto_handler *h;
 
 static void labelmap_init(void)
@@ -3422,15 +3432,12 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_DELETE:
-		cth = nfct_open(CONNTRACK, 0);
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
+		if (nfct_mnl_socket_open(&sock, 0) < 0
+				|| nfct_mnl_socket_open(&modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd);
-
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
@@ -3444,12 +3451,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					     NFCT_FILTER_DUMP_L3NUM,
 					     cmd->family);
 
-		res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
+		res = nfct_mnl_dump(&sock,
+				    NFNL_SUBSYS_CTNETLINK,
+				    IPCTNL_MSG_CT_GET,
+				    mnl_nfct_delete_cb, cmd, filter_dump);
 
 		nfct_filter_dump_destroy(filter_dump);
 
-		nfct_close(ith);
-		nfct_close(cth);
+		nfct_mnl_socket_close(&modifier_sock);
+		nfct_mnl_socket_close(&sock);
 		break;
 
 	case EXP_DELETE:
-- 
2.25.1

