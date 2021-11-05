Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578DCC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377C761215
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhKELlG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 07:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232477AbhKELlG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 07:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636112305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ht6doVdMIicTfM2Cvbp122VOqHl1WRIw68L/uSAKMbo=;
        b=hwAPSCr242VAJAdLsBFIGq97RoZAhBMTpEPb7ygt0dChscFezTzjEkdkurpUYOwDPGXzd8
        cqxkoFadI29VgCQFw05GZAhD1nPuzi5skrYMe7ZphMywZS947cg2yN7YeYp2jnJeA4Kd/i
        bYS7zTrq9p1yyH79P3qDRCJ6ORdPgXw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-GzU-jxF8N3KIyYZDRqYfbw-1; Fri, 05 Nov 2021 07:38:24 -0400
X-MC-Unique: GzU-jxF8N3KIyYZDRqYfbw-1
Received: by mail-wm1-f71.google.com with SMTP id r6-20020a1c4406000000b0033119c22fdbso3188573wma.4
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Nov 2021 04:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ht6doVdMIicTfM2Cvbp122VOqHl1WRIw68L/uSAKMbo=;
        b=4Qo1Qr9++X08gLGyUL3GlVTf+pXi9c5bcJrLZvY0KrH0p3hCJnfww+dtRn8dAhnpvH
         X7dlUENTpu2/X9frm59j5zn0D0aerIKvu3gkTTUKPzA9fsn2BA8CEpbc6+E/rRWlerxq
         x1iJ6/jynnTdXpOzk/aztvol/mMLqNCA9a/QLgm2pXCD1OKkbRLMdD5a4okGXe1bqZN+
         QQa/i2VEf2oAUBGX0bsEq4HqK1w+MlEyeLH1OVqGIKnxl0arMUSrySJv2uNBeK2tQvrn
         igSSd13dhWPDUu3RmjBHYoO1He61cFKOI5q7v5ncp5YJRPvrJ32Rx8FHlh4At4xReDjX
         aqtQ==
X-Gm-Message-State: AOAM531XR13vPxzB1GujppfuyxvsYnnnjQ9SWjUO3FwY05V+wAja83Uk
        eU+Qaub5j/QK10F0o0qoLZT+qT9h3PYNcz/1AT9lKaSSbYqwlvSpKOI7uQCCZ/LavYB3/WMcbYa
        kkv1GNnESe+DJcVuqUto8k7Sxvi8dLiBGCzp1O26+KQhlyAmcRbBj8HlCKg15XNl8E1+B6Qi+PS
        l7ww==
X-Received: by 2002:a1c:750b:: with SMTP id o11mr30363210wmc.5.1636112303215;
        Fri, 05 Nov 2021 04:38:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxFkir+83nZzE9s2wQ5HWh2TmK9XJ8gvOsHNYvNbg26IyFeTNtQAKJ92xacdLR4pXdyMIFbg==
X-Received: by 2002:a1c:750b:: with SMTP id o11mr30363182wmc.5.1636112302915;
        Fri, 05 Nov 2021 04:38:22 -0700 (PDT)
Received: from localhost ([185.112.167.34])
        by smtp.gmail.com with ESMTPSA id s24sm7176660wmj.26.2021.11.05.04.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 04:38:22 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     phil@nwl.cc
Subject: [PATCH nft v2 1/4] tests: shell: README: copy edit
Date:   Fri,  5 Nov 2021 12:39:08 +0100
Message-Id: <20211105113911.153006-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <YXmjii3KR7nyrK8u@salvia>
References: <YXmjii3KR7nyrK8u@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Grammar, wording, formatting fixes (no substantial change of meaning).

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

base-commit: 6ad2058da66affc105d325e45ff82fd5b5cac41e
-- 
2.33.1

