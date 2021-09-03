Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC7BC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 07:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D56E610C8
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 07:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhICHrx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 03:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhICHrx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 03:47:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB84C061575
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Sep 2021 00:46:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 8so4768729pga.7
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Sep 2021 00:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K0dBWLY4WphnRbbHNd/ZQoN4fA58R5GWwACuMOWnIu0=;
        b=Ro2biMO/6JJwLy/MgZavTipr3sgGRBD3bG1haEG7JyI57CfYM7EJiIXY5I05C2tXBV
         OT4QyiGYFgnohtoQlDUFnHakpSOYpJk6g3CAsU1BmMTCjC7O6hgEL7ExuFb4Jjliew+X
         nZGUtbPfhpe+pJk3XsBgMn8FMyNei/0QbcyaPz1pATdFyPimrUKaQCI3BDxWqYlSlTLo
         sxw51fRiVSlrz+SHEibo8BeFoBEbc0x2sBxSnATqaBcg1aCS1bVk9z1OK9AQbltL6BEs
         kfcs17U+8pHAezQ6O7o7QNlM2cwzPMNf66UVa/42al+P9aAiZenp1O1iXldgY08wp1IF
         Bryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=K0dBWLY4WphnRbbHNd/ZQoN4fA58R5GWwACuMOWnIu0=;
        b=pKyUclt/KYjVL0oIQ4YaHpvMJCUnjPk/N+PuwtV/oZYjiY3amUxZwhEQ3CHcLQ2YJJ
         Vghr7mAZC8Dbf1/L+u6vg8lru2SoSS5HNpF322SCDZKVPQw08eI140ip9kQ2NSL9VPx2
         xfrrfVSm3OeMflIu4L8cgQvDGklt5H8ZqxwZcreMeq0FodAnvd2tdklXnrBHQveh912g
         BMkysuGrlF+IIsP9WBBodnI/QkLPKy10nw8dR5oF1PZJtNX/n+3UNnKwJUZh/uJbUlg4
         BFBRtS9B9SwSDVQGrO32mrac/q7O2L+YN6cWSOSQac4o0+e3gVdC97koXcj3/spyt+wB
         8OYA==
X-Gm-Message-State: AOAM533npFXThqOZA3X7wxqCi4fpMrtO0S8L2Wjd8bZobC/xJYV3Ue+U
        YMTnWOpsaiVrrUzsalCqkmz07Izifqw=
X-Google-Smtp-Source: ABdhPJzqvoGUfWkOE+pYcM3vK6u6MMxbW1zO64zh4XcBSF1fSw/ui2Gmwc6Z6MvNOmU9B5MPkW7FIQ==
X-Received: by 2002:a63:f817:: with SMTP id n23mr2447597pgh.250.1630655213092;
        Fri, 03 Sep 2021 00:46:53 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id l14sm4353926pjq.13.2021.09.03.00.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 00:46:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Fix rendering of verbatim '\n"' in man pages
Date:   Fri,  3 Sep 2021 17:46:47 +1000
Message-Id: <20210903074647.27580-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without this patch, '\n"' rendered as '0' in e.g. man nfq_create_queue

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index e0cda71..96c97d5 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -69,6 +69,10 @@ post_process(){
     del_empty_det_desc
     del_def_at_lines
     fix_double_blanks
+
+    # Fix rendering of verbatim '\n"' (in code snippets)
+    sed -i 's/\\n/\\\\n/' $target
+
   done
 
   remove_temp_files
-- 
2.17.5

