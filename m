Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36CEC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Feb 2022 18:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbiBPS7f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 13:59:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiBPS7f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 13:59:35 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285B62AD677
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:22 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b13so5651769edn.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EZ7ytmr6CisnyWZjF/ZgmMPc4mI9elGEaPH+Ed56cJQ=;
        b=PkWaZPx6VRAZSTTw5HkF4BtxvJSMq/s66PzsWUoQOrg0c7tPtydzX9ngy5oSVjhN0H
         7VbSlHs0vGvQ+sq6iWZI2dYwr4qFa6ZtoDJ7+skgBNGgdiwsEUnB20M9jxiF5lgqwIvv
         Dxood/f8MbKCbcireI9YlC7Oys/gfrSQ8mR6Unh47v3F54Hu+JGX01e+4B8Ch/0zpWI6
         mfGOu1TW4+/0m1VlF//OK/1edN9iLAY7iJcUw7XYI2rL4LwoOQ4GLvfMGcAKW+fawoy2
         hCi8kHeN7o6+fOfIoPw5IjkhlufO8CWFhMPImz0rVzReOMrRujq2a0hgWpygCfc55ISS
         hTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EZ7ytmr6CisnyWZjF/ZgmMPc4mI9elGEaPH+Ed56cJQ=;
        b=4oyj4/nZ3p6ZY/Ufom1QucR64y1puVF1/ss8aKkl+UggwLRLf2hryxO2M4q59xaUCm
         Tdoh+2asexH2bI6Q0oUyD/OSEREB+nCLaIX/ssB9v/bTBL15ZwskusIQAZPkDS3Dt4LB
         rWWDfLxw2oYEwyU7exYl+ETltkyRZtfp+7bJakxi3xNCHgst5HsaYIyRWiomRx9QZDID
         EuCqqUKvgiIXsfvgM+7vk20sbnxDo/3h/j0ruQrWDwL7o7mOeoBmbNepIK6hylj1lMCi
         b61uNscH2LpmFIV+E/ivrCvaqCh38anX/bF0+0271YY5vkLJtNPwODZ9CInjVq9dtpdS
         WATA==
X-Gm-Message-State: AOAM5300yOINW08mkXSIbcMPIWKhq4/1gvFChnoj//5wBfd8Yiqrqjaq
        V1LWE/BczX6A9TsPephPl/CG0a16QBrryg==
X-Google-Smtp-Source: ABdhPJxij8nDepNLkFAUug1e/gwSJxGHOlLd8NJGJ0PaVrnyRnDkku4TAxkhD/k0iM6OTKcAudS+UA==
X-Received: by 2002:aa7:d49a:0:b0:410:875c:e21b with SMTP id b26-20020aa7d49a000000b00410875ce21bmr4462092edr.357.1645037960212;
        Wed, 16 Feb 2022 10:59:20 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf784.dynamic.kabel-deutschland.de. [95.91.247.132])
        by smtp.gmail.com with ESMTPSA id dz8sm2156167edb.96.2022.02.16.10.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:59:19 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 2/3] conntrack: use libmnl for ct entries deletion
Date:   Wed, 16 Feb 2022 19:58:25 +0100
Message-Id: <20220216185826.48218-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
References: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to delete
the conntrack table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 109 ++++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 161e6a5..8cd760b 100644
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
@@ -2775,6 +2735,57 @@ destroy_ok:
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
+	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
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
+	res = nfct_mnl_set_ct(modifier_sock,
+			      NFNL_SUBSYS_CTNETLINK,
+			      IPCTNL_MSG_CT_DELETE,
+			      ct);
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
+	return MNL_CB_OK;
+}
+
 static struct ctproto_handler *h;
 
 static void labelmap_init(void)
@@ -3447,15 +3458,12 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_DELETE:
-		cth = nfct_open(CONNTRACK, 0);
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
+		if (nfct_mnl_socket_open(sock, 0) < 0
+		    || nfct_mnl_socket_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd);
-
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
@@ -3469,12 +3477,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					     NFCT_FILTER_DUMP_L3NUM,
 					     cmd->family);
 
-		res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
+		res = nfct_mnl_dump(sock,
+				    NFNL_SUBSYS_CTNETLINK,
+				    IPCTNL_MSG_CT_GET,
+				    mnl_nfct_delete_cb, cmd, filter_dump);
 
 		nfct_filter_dump_destroy(filter_dump);
 
-		nfct_close(ith);
-		nfct_close(cth);
+		nfct_mnl_socket_close(modifier_sock);
+		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_DELETE:
-- 
2.25.1

