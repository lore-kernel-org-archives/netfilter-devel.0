Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83E8C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 17:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiHAR03 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiHAR02 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 13:26:28 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0778EC
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 10:26:26 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id v2so8936628qvs.12
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Aug 2022 10:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mentovai.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=fNarQYMRnBq5Y9VyS7gfFeBQ4kQVmVO8Gecb6gDbemI=;
        b=mB5rfznI9ebr4xpLMoD6C8lcQGObOC7nAa8+JcPdhUlYkAGMLUwmfEpfjoCLw/G9HX
         8gWSHP+1mHgIaeyD+BPi4D9YrcFCM7R1BmqWzIwMJSGCM43AC7s8HBj9kkouAvfhIu0H
         om1ogHB7BkZqaDJiF7ywy/rFs5EjWEnUUw6Ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=fNarQYMRnBq5Y9VyS7gfFeBQ4kQVmVO8Gecb6gDbemI=;
        b=s75nCxDlYxe6SmgSjuHYIFY/0imU5B5EhUmHk4O/7rGtJ1w/Q0MPJ5CZ5oc6F5Ot04
         PikBzLa5+EV0fVdNDAJJDTn/UpwOUfgo2rupW3yIcAMdONkKUdnxQr/yuep63/ntCGWd
         YgTgflr7ruRVzbggiHLRNZUDl7Z1barveo1kgh29CzSyOs1wM4oLqxNGjZdRu7QBRO3m
         2Rnr3ydI48SJXLfP4AJTzh87zeUvTyVI0GnzftTgz1nwRZ2enf69WO6cTrmO6QAi6meI
         Nf6npopeX/3Qwo4j7qjAMHHzcj8LE16+NjVqQJ8YNo37kwIfD30lac/9oPnVW3WK2qBl
         aUMg==
X-Gm-Message-State: ACgBeo1AKQ2UBrfrh6VT25dZi0DzV07hxVbP3RGwLvmWyewFvxeyE0yY
        E6K2iLxTKLUo++MMfuDE2A0Qm4j/GABYbRb+
X-Google-Smtp-Source: AA6agR7Shn/tmoGt0QBe4y8Q7QYsZv3f+o2Mnsrm5G5J6wJ/LLDe92MtYvch11oRzEVSDBak/btH2w==
X-Received: by 2002:a05:6214:76a:b0:474:5c93:9b6c with SMTP id f10-20020a056214076a00b004745c939b6cmr14599414qvz.14.1659374785737;
        Mon, 01 Aug 2022 10:26:25 -0700 (PDT)
Received: from redacted ([2620:0:1003:512:99ac:20c:e94f:2e06])
        by smtp.gmail.com with ESMTPSA id y6-20020a05620a44c600b006a6ebde4799sm9180602qkp.90.2022.08.01.10.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 10:26:25 -0700 (PDT)
From:   Mark Mentovai <mark@mentovai.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl] build: doc: refer to bash as bash, not /bin/bash
Date:   Mon,  1 Aug 2022 13:26:20 -0400
Message-Id: <20220801172620.34547-1-mark@mentovai.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This locates bash according to its presence in the PATH, not at a
hard-coded path which may not exist or may not be the most suitable bash
to use.

Signed-off-by: Mark Mentovai <mark@mentovai.com>
---
 doxygen/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 29078dee122a..189a233f3760 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -21,7 +21,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # The command has to be a single line so the functions work
 # and so `make` gives all lines to `bash -c`
 # (hence ";\" at the end of every line but the last).
-	/bin/bash -p -c 'declare -A renamed_page;\
+	bash -p -c 'declare -A renamed_page;\
 main(){ set -e; cd man/man3; rm -f _*;\
   count_real_pages;\
   rename_real_pages;\
-- 
2.37.1

