Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089E8C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 22:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCDE2600AA
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 22:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbhIQWKd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 18:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbhIQWK3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 18:10:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593A7C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 15:09:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f21so7093248plb.4
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 15:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDlxVUw0c9apc185NpwxUKCe02MNVAMpS+lvk+MoqSw=;
        b=ZD95DmEIEi6lyLOyx42Pmynp7tl27ifT2QAdYAi7TOi1FCpNA7ZFv5uT8O25trcMtr
         Xrmw8Ot4rhn3IZ01N7zIGPCby6NqzxtRiIotA9T5CHgYZZDRrpKqIQHjiBngfft3fSs+
         C0/nyjV3kdmTUGd/Z/7xfuD7o+Q4gmVkwwZwn3oa05CBWBdAFhezyCGk7EeZ7DNhgR98
         eefjUgDqIfE8uHArqYBI9o9hMEYHYN/ICPgVWIsg7fph4ERCoQcpXIfJCWDm6EgreZtj
         nRxFio/gosHviHiQnJ7Ko3Kn8u9eXi4da8XuqyDlNp0fdd+1n0+7/rlLt/e6tIDgxqqg
         9nxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=YDlxVUw0c9apc185NpwxUKCe02MNVAMpS+lvk+MoqSw=;
        b=tKULDWYQI5EwQzu75KD4My7TVG+d8/nkAlVAJL+or6gu8tRIEmfXQIuftH+az+2GW/
         zznMUOd9TjJTA6qgWKR/FMeP0x2989RTtl36lHhD/IAKGk95uC0CBgLV1jXmGmROFWMY
         MrImfYG8YL6yDvVdQ80vntXfRYU+Sy8OQIvEgI5m0BNRNL3Ws6aHG5klodIVecpLpUog
         FJHTr/N130iUSBEBxOha5NhcXDvVQasE8cQEM1BQmMf/HL/z28pC6eGkB160SvxbB1c1
         927Zg2OEClUPfJQoyaJhIF2YszB+08r4t/D2gv+zqMpud+nVbyDZnXvv9SS3Z1DhygX0
         qmNQ==
X-Gm-Message-State: AOAM530w8nUEh2yfbZbScyrQBjp8eaC8tXI6alfu3AEO5Q2TksdCmEpt
        fDbQu1GVzajs4shzEgjXuTCZUmEWRxY=
X-Google-Smtp-Source: ABdhPJwr3+rvXfPwxZCwVQaL/LJEGwyD70omojpSR/iRAHyXt4yD2hubePUb39S+HVHS6hxDevlttA==
X-Received: by 2002:a17:902:ced1:b0:13b:a0f8:63 with SMTP id d17-20020a170902ced100b0013ba0f80063mr11636101plg.37.1631916546821;
        Fri, 17 Sep 2021 15:09:06 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id y126sm7004406pfy.88.2021.09.17.15.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:09:06 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH ulogd] XML: support nflog pkt output
Date:   Sat, 18 Sep 2021 07:08:23 +0900
Message-Id: <20210917220822.37012-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

plugin input type ULOGD_DTYPE_RAW was missing

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_XML.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index ba33739..ea7ed96 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -314,7 +314,7 @@ static struct ulogd_plugin xml_plugin = {
 	.input = {
 		.keys = xml_inp,
 		.num_keys = ARRAY_SIZE(xml_inp),
-		.type = ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM,
+		.type = ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM | ULOGD_DTYPE_RAW,
 	},
 	.output = {
 		.type = ULOGD_DTYPE_SINK,
-- 
2.30.2

