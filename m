Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C7BC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C4BC61355
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhJTMpp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:45:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhJTMpp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YS4yMwmiwDdcqxsZCyh9neUE336lrBdmb1va5UsgZkU=;
        b=JXrVBxYGairz055QyR1T8S48Z+zatQ8fCV9TVj28WTatvrIFgS+UB02PhLMgwtHVH7+U+o
        GhFTe7VT2zY6Pbnmf7IU+PpPyxbN+l7hv4T+N8a0Up6bh9W7lFC4Gb80nHXKx/FPTWAps8
        YFkbNz+ZH6VuCOLg8t67fFT/ZctGlXE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-bFm07o-sP7Cn0Dlw1KvavA-1; Wed, 20 Oct 2021 08:43:28 -0400
X-MC-Unique: bFm07o-sP7Cn0Dlw1KvavA-1
Received: by mail-wm1-f72.google.com with SMTP id d16-20020a1c1d10000000b0030d738feddfso3130151wmd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YS4yMwmiwDdcqxsZCyh9neUE336lrBdmb1va5UsgZkU=;
        b=WYdm7D6Y902wp7YzxQpTPTs//ztQQDDGOsU8CMThn2i2Rzfm/lDvqm65SYFOE/KqQB
         WUelaaFF1E87YU2Pe5mzmIDQE0ysBAq94MZNKoVHs/vr5YsrYWI0m7YUbvu+xv64vf2M
         CpKwwtDYE4ioLdE/YzUGyqntv/ECNUWwM41VjR0vnptScTv8g9lIJO9I0IxzwnCEIeYa
         TpBm0bpEVbGzcOB7ilb9tNfnJu5uO+rKVlZhyPPk/FMLHZ3QoNdC9/iyqwKAhLep5H4w
         ZXhP81CQ1C+MpufKuISA1J9P8leKbEq7IcB0SGrVzk+pW/R6nkzv6jSG7qjGjsGx+gmw
         vI+g==
X-Gm-Message-State: AOAM5336qnqPVhxy5vmgBGDXBLw++4SbedzPSW8FxKVKlhffECG4qNhp
        v+Q1iHbxLRHeMzPSH9EHeWgPPUmr5Cnf7fQQMTwQNiI2d/9tBDNauVWfM09vS9R4FRXMiv1NYaz
        TtVd25KIqtIYLwNiViBR8KU8UbcW1HCTeE9/EOjSJvLnVKOskP9nvwON9P8JqcDtDhUBt9Xywy5
        iMYQ==
X-Received: by 2002:a05:6000:1563:: with SMTP id 3mr51498965wrz.20.1634733807277;
        Wed, 20 Oct 2021 05:43:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKDfyAlEpob4URfeG0gdIyiwHE6HbW0/RnlGtRIQdSP6tWZ/dVWE00zJtdaF9IVzOCF2vk0w==
X-Received: by 2002:a05:6000:1563:: with SMTP id 3mr51498946wrz.20.1634733807086;
        Wed, 20 Oct 2021 05:43:27 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id 196sm1862855wme.20.2021.10.20.05.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:43:26 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: run-tests.sh: ensure non-zero exit when $failed != 0
Date:   Wed, 20 Oct 2021 14:44:09 +0200
Message-Id: <20211020124409.489875-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

POSIX [1] does not specify the behavior of `exit' with arguments
outside the 0-255 range, but what generally (bash, dash, zsh, OpenBSD
ksh, busybox) seems to happen is the shell exiting with status & 255
[2], which results in zero exit for certain non-zero arguments.

[1] https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#exit
[2] https://git.savannah.gnu.org/cgit/bash.git/tree/builtins/common.c#n579

Fixes: 0c6592420586 ("tests: fix return codes")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/build/run-tests.sh | 2 +-
 tests/shell/run-tests.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index 9ce93a8ed381..f78cc9019a30 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -52,4 +52,4 @@ done
 rm -rf $tmpdir
 
 echo "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
-exit $failed
+[ "$failed" -eq 0 ]
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 349ec6cb1b16..f77d850ef285 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -160,4 +160,4 @@ echo ""
 msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
 
 kernel_cleanup
-exit $failed
+[ "$failed" -eq 0 ]

base-commit: 2139913694a9850c9160920b2c638aac4828f9bb
-- 
2.33.1

