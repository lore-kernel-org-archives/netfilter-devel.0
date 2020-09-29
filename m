Return-Path: <SRS0=rcIs=DG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46478C4727C
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BAA2076A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="HLEu9FFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbgI2Mhf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729464AbgI2LU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 07:20:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8718FC0613D0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2020 04:20:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id nw23so14461498ejb.4
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2020 04:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/b6h2KswLuKwpp8xT/XN8130Yfl0B5Rusgq/9wUVjkc=;
        b=HLEu9FFsXkjlwykNztJh6ZwK+0/0dX/yfP4LupOH2Y06cBltGA5C+KJ7WRrvQjKoYK
         CQ8FIOXZXDAN6SO9LiJL5J2SLy7+GE8hSA8uwhH5KFaAi/3Ya3XFNNcgGROKLdHAyBX3
         5lyCGrYLs3J9hUT1En6cVB5//UNRcwn8ltdq/pxRnNSLf1RrY2h48m/iSjo5u7ZRF7bJ
         xFVmkQWV2kPu891Gz1bfsLa3q+EN6w00bItfcT4HFB/s5lP+SI6RHWVfERC3PV7ID3x/
         sZAiYKLvGVINpPauVL3sDo/9IFTPGusGXeuilkkgkRW0JPnCv67he4C8c+sqD7ugpiDq
         NvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/b6h2KswLuKwpp8xT/XN8130Yfl0B5Rusgq/9wUVjkc=;
        b=eHBD0AsspeFP9DCotkd8CEs4hJfm6FAd9LbnCfuWll2nDT3N6pDr9+VgMNJs15FeqL
         rfT0R9srXlj5iT/nwxC8b27AmgpS/w4S8Ga266A3GFUcJAHX5Apq/xdxgPRo9oYVIDPi
         z5pHSq4EKiM1I7E7GEYd85YtQjfwosK0BXP2arHbk96CkF119ZGXiada17jJcD+wh7Wj
         wHJ3uRat7Ra6637sbnRIrEXH5nJQ/VfzdsC/EnQxZk7EDhSR0cvGqOB1Ui74+vNTgiba
         8p9EslAUqjhNvoyahn8GD+Gpw/wOXik9OTo6I3WB8PpuVoxKPscTIf4qbx7AcFFgm9gH
         PHmg==
X-Gm-Message-State: AOAM5326swrs4KeYGWR4fHyJOJEWpA2iD2v8uqavEp8x0VKB7/QkHqPh
        Gtcm25X/9OKPaN96c037yJboutGMQlvTew==
X-Google-Smtp-Source: ABdhPJyWHjSW/+UBPFiXclhJ9213LdKcBAjUKErg8n/DzocIIcDVuvWFKXk/WtrRa21QPFJmyk28Ng==
X-Received: by 2002:a17:906:2818:: with SMTP id r24mr3492935ejc.100.1601378450090;
        Tue, 29 Sep 2020 04:20:50 -0700 (PDT)
Received: from localhost.localdomain (ip5f5af5ad.dynamic.kabel-deutschland.de. [95.90.245.173])
        by smtp.gmail.com with ESMTPSA id bn2sm1999761ejb.48.2020.09.29.04.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:20:49 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 1/2] conntrack: -L/-D both ipv4/6 if no family is given
Date:   Tue, 29 Sep 2020 13:20:16 +0200
Message-Id: <20200929112017.18582-2-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929112017.18582-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200926181928.GA3598@salvia>
 <20200929112017.18582-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Starting commit 2bcbae4c14b253176d7570e6f6acc56e521ceb5e
conntrack -L as well as conntrack -D list/delete
IPv4 entries only if no family is specified.

Restore original behavior to list/delete both IPv4 and IPv6
entries if no family is specified.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a11958b..3f5eb37 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1578,6 +1578,11 @@ nfct_filter_network_direction(const struct nf_conntrack *ct, enum ct_direction d
 	enum nf_conntrack_attr attr;
 	struct ct_network *net = &dir2network[dir];
 
+	if (family == AF_UNSPEC) {
+		exit_error(OTHER_PROBLEM,
+			   "Internal Error: unspecified Family!");
+	}
+
 	if (nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) != family)
 		return 1;
 
@@ -2433,6 +2438,10 @@ nfct_filter_init(const int family)
 {
 	filter_family = family;
 	if (options & CT_OPT_MASK_SRC) {
+		if (family == AF_UNSPEC) {
+			exit_error(OTHER_PROBLEM,
+				   "Internal Error: unspecified Family!");
+		}
 		if (!(options & CT_OPT_ORIG_SRC))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-src without --src");
@@ -2440,6 +2449,10 @@ nfct_filter_init(const int family)
 	}
 
 	if (options & CT_OPT_MASK_DST) {
+		if (family == AF_UNSPEC) {
+			exit_error(OTHER_PROBLEM,
+				   "Internal Error: unspecified Family!");
+		}
 		if (!(options & CT_OPT_ORIG_DST))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-dst without --dst");
@@ -2894,7 +2907,9 @@ parse_opts:
 	}
 
 	/* default family */
-	if (family == AF_UNSPEC)
+	if (family == AF_UNSPEC
+			&& command != CT_LIST
+			&& command != CT_DELETE)
 		family = AF_INET;
 
 	/* we cannot check this combination with generic_opt_check. */
@@ -2993,9 +3008,12 @@ parse_opts:
 						  NFCT_FILTER_DUMP_MARK,
 						  &tmpl.filter_mark_kernel);
 		}
-		nfct_filter_dump_set_attr_u8(filter_dump,
-					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+
+		if (family != AF_UNSPEC) {
+			nfct_filter_dump_set_attr_u8(filter_dump,
+						     NFCT_FILTER_DUMP_L3NUM,
+						     family);
+		}
 
 		if (options & CT_OPT_ZERO)
 			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
@@ -3104,9 +3122,12 @@ parse_opts:
 						  NFCT_FILTER_DUMP_MARK,
 						  &tmpl.filter_mark_kernel);
 		}
-		nfct_filter_dump_set_attr_u8(filter_dump,
-					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+
+		if (family != AF_UNSPEC) {
+			nfct_filter_dump_set_attr_u8(filter_dump,
+							 NFCT_FILTER_DUMP_L3NUM,
+							 family);
+		}
 
 		res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
 
-- 
2.25.1

