Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC37EC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Sep 2021 02:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24ED60238
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Sep 2021 02:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhIECrC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Sep 2021 22:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhIECrC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Sep 2021 22:47:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E13C061575
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Sep 2021 19:45:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v1so1882837plo.10
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2021 19:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4hf3I7KsTY7EVtdXHQub+Q/mEJ9pXMlu543/w9Zf1c=;
        b=ZFXRUMfRJp6YV8+CGXdSHqZKn161SDlA0Sg/Pj3D5jWOqATRyezRJkM+tZee2MlUnb
         HzVPkxMeBlyDjRDvX2Kqc2Y4AY/BZbIJmJ8Ec0AzNr3X5PVFxUkwxeTz00qOzB9Sb2kb
         njG1eBNW6DDypNU4m7fDBj6Tj8pO8ZdDNbyrL5wCevwaSYaaV2X3POLf/FrPwPu5a1he
         WDS23LG/VCBSs2DPeMVp+Bjx6mXd3cmV9HYTVgiTgxj52xm22FqFJrCambItfJEPHkr1
         KB62TkOADe1AVVHxaxRBOwpD4mxhKEevMiYZwg9fw5iqgx0k4o6hcM15ssZWRK6ST/fx
         tZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=m4hf3I7KsTY7EVtdXHQub+Q/mEJ9pXMlu543/w9Zf1c=;
        b=bsFhRVfZgsP5RipQFha8YGUe7XDsifq5DJ6+rESnUAMQSSQzTfXsbf2pNt7mGuHIIl
         +pTQ3Wt56CaJbcAB2BfWFvWRpw/8XNTmeG9649SA4yBFqsAhqgmtUIh7rx3TTwHIhmgo
         E+RLP/CfCg//+FV2v3tL9kcAMpffScZQlI/pkx39JqsTsJN/4JWCPLyRuBsKDzPn0r0n
         6/8kYh+xhky6d/FbRfsyp7dkS6WWMi9caf2YBox4KxUdVfFB4mcnnFLWxng1XBVHrTYg
         JM3nIXjuUXYIlfgPg0mRApncs0v92Wg30p3Y13VWcGdvPuwjAxP1Zp1Ywwd5sCiEc0pK
         crmw==
X-Gm-Message-State: AOAM531RJFs+vm5E1D7EA4cRRV7pjyf39AhL1zCjmV840SpmJy+nTdde
        wQcDqmCo6Ag0U8VZCDchUpOiPwTbRR8=
X-Google-Smtp-Source: ABdhPJzSDh7xOeoiRRc+iTUIIOHsP5m8wV2HbXQXNvbV2+vD0z+q9CnxAXbVmP1eLWQu7nHyB876iQ==
X-Received: by 2002:a17:902:ba90:b0:135:6709:705 with SMTP id k16-20020a170902ba9000b0013567090705mr5159241pls.79.1630809959353;
        Sat, 04 Sep 2021 19:45:59 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id p2sm4307194pgd.84.2021.09.04.19.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 19:45:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Fix rendering of verbatim '\n"' in man pages
Date:   Sun,  5 Sep 2021 12:45:54 +1000
Message-Id: <20210905024554.29795-1-duncan_roe@optusnet.com.au>
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
+    # Fix rendering of verbatim "\n" (in code snippets)
+    sed -i 's/\\n/\\\\n/' $target
+
   done
 
   remove_temp_files
-- 
2.17.5

