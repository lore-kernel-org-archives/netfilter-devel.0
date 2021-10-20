Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12C5C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2C961355
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhJTMqs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:46:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhJTMqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X2vLvjDbbPmVdBAwPo3y12lvJp+8OYfuPpTQbXbHwTA=;
        b=fYEdi6zzEg0fM5JGfQP9Zimm6U9OxZM4LHO2VXgKoeooF/nG9e7n4v6OXi3yNbZkBpbtki
        KIJGC+2HWcruBEs+q01wXYwCaWEh5Mklyv2nEcOhz+uc1dqUEJXXg9H9xktvU/9MTsXK3g
        xT6YVSbKaYOl26Ypt1FkpFhU/ukgjpI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-h6-j95qHPHKrZcGyokAM7Q-1; Wed, 20 Oct 2021 08:44:32 -0400
X-MC-Unique: h6-j95qHPHKrZcGyokAM7Q-1
Received: by mail-wm1-f72.google.com with SMTP id c5-20020a05600c0ac500b0030dba7cafc9so4151160wmr.5
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X2vLvjDbbPmVdBAwPo3y12lvJp+8OYfuPpTQbXbHwTA=;
        b=j/PU6nm79vefr/yT4plnq8a2GOZtnjE48zJ3zSjry+K+MClPHYC8VT/CWvIZguo9tJ
         1vVHO2he1+U6+ys/LRXL0c9DYiVN2IwlYh/Cyvr+birPeWlT4V4eOantep9PzaYWcdJd
         3zS26J8RnwXDkw/cyqSKXtBkBwVUfXKmux3L7hkkJ/aNL6xIM0/cLiFRUpLVqFUaAo/7
         TLv5orCfzdD/W+lM9Gz9oUwebAMA7uf3IQSLrVh0N30Oc6+RkXrwUtjugsZqdxyRYdlE
         MMzkqAxBg7YRsk77dlAXg2nQPV52QdS6gEjX3upqKK02sgWDtZkVbHHeFOgnunatcEgf
         8osA==
X-Gm-Message-State: AOAM532eDMTO60UV9/s/TLfqkN70JhkTOWKyZl228M3mDSEgFGiIRxOg
        tGT0r3/wjS54WBsNijnJHxEAgk6Rk0aNWY7ceFdRuHpp78OrJREK9uqvcq5Pp0az/EuUXhe3HSD
        nPAGfmuCUAHdATorJ7K4zpOr5o3IKltvBWeXMdukfMzkE3yMDowhkpm5w3SlZrdM1ElHLLpzZTl
        UvrA==
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr13595873wmg.129.1634733870726;
        Wed, 20 Oct 2021 05:44:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwakAFv0hVI/AdHp420L5lMpZmFODQl7MFle5rKrwRfyWjcyOlWzD/svarjycb6oCgtzeUKWg==
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr13595857wmg.129.1634733870524;
        Wed, 20 Oct 2021 05:44:30 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id i203sm4990112wma.48.2021.10.20.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:44:30 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] tests: shell: README: copy edit
Date:   Wed, 20 Oct 2021 14:45:10 +0200
Message-Id: <20211020124512.490288-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/shell/README | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/tests/shell/README b/tests/shell/README
index e0279bbdc30c..35f6e3785f0e 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -1,16 +1,17 @@
-This test-suite is intended to perform tests of higher level than
-the other regression test-suite.
+This test suite is intended to perform tests on a higher level
+than the other regression test suites.
 
-It can run arbitrary executables which can perform any test apart of testing
-the nft syntax or netlink code (which is what the regression tests does).
+It can run arbitrary executables which can perform any test, not
+limited to testing the nft syntax or netlink code (which is what
+the regression tests do).
 
 To run the test suite (as root):
  $ cd tests/shell
  # ./run-tests.sh
 
-Test files are executables files with the pattern <<name_N>>, where N is the
-expected return code of the executable. Since they are located with `find',
-test-files can be spread in any sub-directories.
+Test files are executable files matching the pattern <<name_N>>,
+where N is the expected return code of the executable. Since they
+are located with `find', test files can be put in any subdirectory.
 
 You can turn on a verbose execution by calling:
  # ./run-tests.sh -v
@@ -18,11 +19,11 @@ You can turn on a verbose execution by calling:
 And generate missing dump files with:
  # ./run-tests.sh -g <TESTFILE>
 
-Before each call to the test-files, `nft flush ruleset' will be called.
-Also, test-files will receive the environment variable $NFT which contains the
-path to the nftables binary being tested.
+Before each test file invocation, `nft flush ruleset' will be called.
+Also, test file process environment will include the variable $NFT
+which contains the path to the nft binary being tested.
 
 You can pass an arbitrary $NFT value as well:
  # NFT=/usr/local/sbin/nft ./run-tests.sh
 
-By default the tests are run with the nft binary at '../../src/nft'
+By default, the tests are run with the nft binary at '../../src/nft'

base-commit: 2139913694a9850c9160920b2c638aac4828f9bb
-- 
2.33.1

