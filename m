Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBFDC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 04:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5724160E73
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 04:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhIFEN0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 00:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIFENZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 00:13:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3B8C061575
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Sep 2021 21:12:17 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t1so5458014pgv.3
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2021 21:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QI5qgv0t6oTOL4Uu94FwbxK0zjTtwcYByeeenWPp4JU=;
        b=L/VDwelvTc9LR/Wg2tRXMm9Nrh674dtJGREYWJ31UlxvSTwOvhMwMbvl36Bbeu2PM7
         gl5yIXuNtOU20yp2girdZN1WJtJHOLuuUYe+DcjbhZfN77RwMeLbp6uvZV9mE1uisgkg
         MEvlvuASIjuVZcgP+q3ICEaNDuJtIVnjFFQGY4ACOfFisJsfUypV98LHEqZXIF7IosWU
         FLzc04OBtKNwZfNm4aGA0H6YtujM9IxVAmaoFC2f5jR16H6L+xoz1abC8/bULLHuKJTi
         AZYYgRNka2nvjWMDcHAw9emGjtvgIPZDMQj3dkGmC69B7nbkCQuSfpZFgkauQl/L0dJT
         n7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=QI5qgv0t6oTOL4Uu94FwbxK0zjTtwcYByeeenWPp4JU=;
        b=EvMW7xhJEAABWKdI0evXByKnMK6jtVmjNzoogRr23+hfZ1je0HfEUqteHZtCO/tsjd
         cT+Qi1zsWd4Qj2CV+VY9RWplbu9lvs1DcuWMF3VxLDHVihCq/6C9Jgg7jpBHIbSLhbXT
         wq0AwMJFH5e+C/oPKMkk1WE36yJpxx6pvxkzxw78O9jknE2DbnT6MpqEpbPeoHSSmbED
         TyK1dCmKr9sg0RMBfVxpoZtwccUgcYORJ252vJ7onQOEgU8Q/rMG7L1jqUKfSWtdhtMf
         wzLT6HpIxlauPgCsOB0NPi6US3ZiIaf1Nx31YI7gWmQ/tg+n45yylgEIKLTyx06fa54L
         7EFg==
X-Gm-Message-State: AOAM530Zw7uN6jfaJpRivtLBIPTh7vsdQheq15gELh16OwMSomNtWLwb
        cTdENnKZergj3uYdO66X5Xv5qqKVSXM=
X-Google-Smtp-Source: ABdhPJyTiZDCLS7YQVeaMTq+DBJBmLc4BVNfYoHEOoLsz/P9+YZwL2f46lIIi67wfpn7674Gpf3VAw==
X-Received: by 2002:a62:2fc1:0:b0:3f5:176f:67c8 with SMTP id v184-20020a622fc1000000b003f5176f67c8mr10023703pfv.17.1630901537162;
        Sun, 05 Sep 2021 21:12:17 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u12sm7202404pgi.21.2021.09.05.21.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 21:12:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] src: consistently use `gh` in code, code snippets and examples
Date:   Mon,  6 Sep 2021 14:12:12 +1000
Message-Id: <20210906041212.28886-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

i.e. rather than `qh` sometimes

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_log.c |  6 +++---
 utils/nfulnl_test.c    | 22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index a7554b5..546d667 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -183,14 +183,14 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
  * Here's a little code snippet that binds to the group 100:
  * \verbatim
 	printf("binding this socket to group 100\n");
-	qh = nflog_bind_group(h, 100);
-	if (!qh) {
+	gh = nflog_bind_group(h, 100);
+	if (!gh) {
 		fprintf(stderr, "no handle for group 100\n");
 		exit(1);
 	}
 
 	printf("setting copy_packet mode\n");
-	if (nflog_set_mode(qh, NFULNL_COPY_PACKET, 0xffff) < 0) {
+	if (nflog_set_mode(gh, NFULNL_COPY_PACKET, 0xffff) < 0) {
 		fprintf(stderr, "can't set packet copy mode\n");
 		exit(1);
 	}
diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index da140b4..d888fc1 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -51,8 +51,8 @@ static int cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 int main(int argc, char **argv)
 {
 	struct nflog_handle *h;
-	struct nflog_g_handle *qh;
-	struct nflog_g_handle *qh100;
+	struct nflog_g_handle *gh;
+	struct nflog_g_handle *gh100;
 	int rv, fd;
 	char buf[4096];
 
@@ -74,21 +74,21 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 	printf("binding this socket to group 0\n");
-	qh = nflog_bind_group(h, 0);
-	if (!qh) {
-		fprintf(stderr, "no handle for grup 0\n");
+	gh = nflog_bind_group(h, 0);
+	if (!gh) {
+		fprintf(stderr, "no handle for group 0\n");
 		exit(1);
 	}
 
 	printf("binding this socket to group 100\n");
-	qh100 = nflog_bind_group(h, 100);
-	if (!qh100) {
+	gh100 = nflog_bind_group(h, 100);
+	if (!gh100) {
 		fprintf(stderr, "no handle for group 100\n");
 		exit(1);
 	}
 
 	printf("setting copy_packet mode\n");
-	if (nflog_set_mode(qh, NFULNL_COPY_PACKET, 0xffff) < 0) {
+	if (nflog_set_mode(gh, NFULNL_COPY_PACKET, 0xffff) < 0) {
 		fprintf(stderr, "can't set packet copy mode\n");
 		exit(1);
 	}
@@ -96,7 +96,7 @@ int main(int argc, char **argv)
 	fd = nflog_fd(h);
 
 	printf("registering callback for group 0\n");
-	nflog_callback_register(qh, &cb, NULL);
+	nflog_callback_register(gh, &cb, NULL);
 
 	printf("going into main loop\n");
 	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
@@ -107,9 +107,9 @@ int main(int argc, char **argv)
 	}
 
 	printf("unbinding from group 100\n");
-	nflog_unbind_group(qh100);
+	nflog_unbind_group(gh100);
 	printf("unbinding from group 0\n");
-	nflog_unbind_group(qh);
+	nflog_unbind_group(gh);
 
 #ifdef INSANE
 	/* norally, applications SHOULD NOT issue this command,
-- 
2.17.5

