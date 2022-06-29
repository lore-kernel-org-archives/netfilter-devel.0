Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D794C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiF2RJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiF2RJ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 13:09:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858E81057F
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:09:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id pk21so33932516ejb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OdwHSfjRIu6py1mkqgqDwj3RQVOg2nYKo2R/epj1SNA=;
        b=Omam5UGdtM1/vDgHzW12tabeV9dlHlJOSalX3uNqnzxOpZ6QdFSx1Ub6NDYRk0xIJI
         Yc010SkKOdkJRdriJPKNMXyn9sjkzSEzq0p23VjQ+equJy/ERx067SxgGSbJUWn5QynC
         cH11tzL6KjnZM8erNXfi2/7Zc2GkYndJuqILeCORL+5pLH44GEnV/9U0MVeX+weRjCX0
         ulDEOftY5uwwSKwqNWYspmrgPRa6RdkNWVe2m9FQRFis5TAC9O82QNbBgxcZmdGnpX5t
         q/BWT/HQFCAiL2iwgsYbNHXCkGsJLqWmTBi4wA0GfviRZ11RBRKFRBgxA/4KITlwsIvB
         FG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OdwHSfjRIu6py1mkqgqDwj3RQVOg2nYKo2R/epj1SNA=;
        b=5VsyaAVOtRDWEOCvXbP05dnc80zw9Q8JdNMrd6uzzJpAVy3pMN+hn7nChyAQcEpyY0
         aAHg9PkKz42BOjWQl+/z+6qq8xjjjk25Nn8nOV+4dd7QEVc38GK+AsgDEd2iR4DGihf5
         mWv8sG5hIAdl6dF+pBfL8/HbUUwjGGv9TpIoH2V5QemCfyWs4DOQakk3KeG0TNeB++HX
         8rGzRypzrHSfKm4wtVZ69AaYIlS/74jRfcjDIeijWZVYYcUUHJW7qAQGogK5kA++HJjR
         4O46++6W/I7V6Pnx8bfQgAHNYX2GT7PHtMcMdPWiq+yJT4l9HgEfQIuU2ZeIQfLoryWh
         w03g==
X-Gm-Message-State: AJIora9UIZ+WK7X1nuAIsyPR7GVcllEbtW9YyKFAAdCA5BhzvWGD+xBi
        tONMcWwEwY0coesP4UNQopGdrJGRM1hJIg==
X-Google-Smtp-Source: AGRyM1tUl11/q1LB8RHbmd4CKOXYnutWuxBTvDwFcn2pv9iFixVA65PXIV418OliqIR1HgjtOF94Dg==
X-Received: by 2002:a17:907:7248:b0:726:30fc:e7fc with SMTP id ds8-20020a170907724800b0072630fce7fcmr4472635ejc.274.1656522595582;
        Wed, 29 Jun 2022 10:09:55 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([85.214.13.132])
        by smtp.gmail.com with ESMTPSA id s6-20020a1709062ec600b00711d88ae162sm8008829eji.24.2022.06.29.10.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:09:54 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 1/3] conntrack: generalize command parsing
Date:   Wed, 29 Jun 2022 19:09:39 +0200
Message-Id: <20220629170941.46219-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
References: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently the -U command has a special case handling
in the do_parse because it does not have EXP_ counterpart.
Generalizing it would simplify adding support for new commands
w/o EXP_ counterpart.

As a preparation step for adding the new "-A" command support,
make the -U command be handled the same way as the rest.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index d49ac1a..6c999f4 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -446,6 +446,7 @@ static const int cmd2type[][2] = {
 	['h']	= { CT_HELP,	CT_HELP },
 	['C']	= { CT_COUNT,	EXP_COUNT },
 	['S']	= { CT_STATS,	EXP_STATS },
+	['U']	= { CT_UPDATE,	0 },
 };
 
 static const int opt2type[] = {
@@ -2995,15 +2996,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'h':
 		case 'C':
 		case 'S':
-			type = check_type(argc, argv);
-			if (type == CT_TABLE_DYING ||
-			    type == CT_TABLE_UNCONFIRMED) {
-				exit_error(PARAMETER_PROBLEM,
-					   "Can't do that command with "
-					   "tables `dying' and `unconfirmed'");
-			}
-			add_command(&command, cmd2type[c][type]);
-			break;
 		case 'U':
 			type = check_type(argc, argv);
 			if (type == CT_TABLE_DYING ||
@@ -3011,11 +3003,16 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 				exit_error(PARAMETER_PROBLEM,
 					   "Can't do that command with "
 					   "tables `dying' and `unconfirmed'");
-			} else if (type == CT_TABLE_CONNTRACK)
-				add_command(&command, CT_UPDATE);
-			else
+			}
+			if (cmd2type[c][type])
+				add_command(&command, cmd2type[c][type]);
+			else {
 				exit_error(PARAMETER_PROBLEM,
-					   "Can't update expectations");
+					   "Can't %s %s",
+					   get_long_opt(c),
+					   type == CT_TABLE_CONNTRACK ?
+					           "ct" : "expectations");
+			}
 			break;
 		/* options */
 		case 's':
-- 
2.25.1

