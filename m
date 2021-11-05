Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9775C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D6356125F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhKELlH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 07:41:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232536AbhKELlG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 07:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636112306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMn3M6OD1yPsfV/Uw8z0+Cb2dCEsQ3vv+FawncgFiL0=;
        b=K/bq8UqemiyAIJtxmJb3yiPWdRuzCtgyKSWPUOPDUUuJvbgC9tonsq1IA5u16XRGTD0QNk
        AhjtI9GeW+MtcxL0YRoJAj8VyCstVNm4L76HsM0pKfY/jnGKeL/RdXItNxBbcjgphIXo8E
        egyrAvrItF24iKSdhQcDH2yrzYp68+c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-REYQVSDbMFCwvi767wqFcQ-1; Fri, 05 Nov 2021 07:38:25 -0400
X-MC-Unique: REYQVSDbMFCwvi767wqFcQ-1
Received: by mail-wm1-f70.google.com with SMTP id g80-20020a1c2053000000b003331a764709so431776wmg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Nov 2021 04:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BMn3M6OD1yPsfV/Uw8z0+Cb2dCEsQ3vv+FawncgFiL0=;
        b=zvl5Y4IRteb5LozHb6Y9IfFcW4K27nANqKKLWDlDtmrwaTB5/dE+CWSv2Ble4aWvqg
         QyXBtDdHnxZ4rt0+6bngVP64ku2kOtB1a/RJoBYhx7xrLHFPcjvnnS2rKnJrk2ZDcrvI
         DsEwIgRZrjrp+lWQvk0O9hPRh6ga9wvXOsSfjfq3u9J5K7Y+531RrvzN2YzT+X1aJEeY
         uhqXqGpirGDVt6p1SHyk/jaDWiqoOX3hyb2RgMrzp6YdIs3wKaqYwzW1NmUpMwLYPGhC
         aYIcx5IQcpYimB1u0vHk5U74zjgP8NqNBNqbNaDvUjlIhyrwm4Gf2EX2XvCHZz0+55va
         Yc/Q==
X-Gm-Message-State: AOAM530MaLYvHBxC1WGLzG/Mr1U+6lvtR2Tbp6RtZFRLYG/1/UC9wIGD
        91RpyWgz6/a7XwIhrtf5vRQxmhahTvwgrytYqwskJG1a7p+vuEG/g/+YlhTXnqn9U1PzmN/jhOY
        bQwkU4SZnrg3LHQ//0f06nQAWPQ8YAOV/gsw45/2p7aeUCvLOquOsdi1rQ6V3M6Lr5pyYgCdrEy
        amFA==
X-Received: by 2002:a5d:5186:: with SMTP id k6mr27776612wrv.146.1636112304385;
        Fri, 05 Nov 2021 04:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNBx/CA9Pi7CIU2RxE/J2cxTiAMaKmFXzZql375shPaLfkVsDkHg2MuFdCXtM4912LYCaSrA==
X-Received: by 2002:a5d:5186:: with SMTP id k6mr27776578wrv.146.1636112304127;
        Fri, 05 Nov 2021 04:38:24 -0700 (PDT)
Received: from localhost ([185.112.167.34])
        by smtp.gmail.com with ESMTPSA id d7sm7629582wrw.87.2021.11.05.04.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 04:38:23 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     phil@nwl.cc
Subject: [PATCH nft v2 2/4] tests: shell: README: $NFT does not have to be a path to a binary
Date:   Fri,  5 Nov 2021 12:39:09 +0100
Message-Id: <20211105113911.153006-2-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105113911.153006-1-snemec@redhat.com>
References: <YXmjii3KR7nyrK8u@salvia>
 <20211105113911.153006-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since commit 7c8a44b25c22, $NFT can contain an arbitrary command,
e.g. 'valgrind nft'.

Fixes: 7c8a44b25c22 ("tests: shell: Allow wrappers to be passed as nft command")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/shell/README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/README b/tests/shell/README
index 35f6e3785f0e..4dd595d99556 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -21,7 +21,7 @@ And generate missing dump files with:
 
 Before each test file invocation, `nft flush ruleset' will be called.
 Also, test file process environment will include the variable $NFT
-which contains the path to the nft binary being tested.
+which contains the nft command being tested.
 
 You can pass an arbitrary $NFT value as well:
  # NFT=/usr/local/sbin/nft ./run-tests.sh
-- 
2.33.1

