Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D707C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2113613D0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhHWP6P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbhHWP6P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 11:58:15 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A2DC061575
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 08:57:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q11so26989994wrr.9
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 08:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+sZ/J9Qq4dHEVLCzesv1jj9JmI1AZ5UF7eotbFhgnE=;
        b=SijjmdW0Ke4vQ5af5yvINJMxQGQUCqSr2/unxOywrd3b1iOmE3xLA8wkq5H8DaFKee
         mtwk4IlbqIoAG5kFSLBLa29URyHz/e/gc3mcb1DEwfcOdI76HcFe7T3/xkeY/uKGmrku
         THatK1/38N2bzO+lJ3TezjuPBWxgk/yTVL4EUSwggIMrnvb/d4aQKRrkczAVDy6wSrsK
         I8uGM0fYtGFmIe/iGuJVE+UWEF0VRN5i7xY5qPKZ9MJTXpXwhcHs6qlmCG1641S4xWj2
         cOyYo+riwNYVUC3cBBFORcPTZtUnJz2foyWGGdXU90Kyr3zNz2kdw5inbKRnnh7eovOG
         gUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+sZ/J9Qq4dHEVLCzesv1jj9JmI1AZ5UF7eotbFhgnE=;
        b=SHjgs9x7YpEhefl5iTqRLRVed1YsEymRP2PFlPJSt65PXPyJKONKRoua7Px7Ftl+7g
         RHWHxF3PPIOneMwFElUoU/zWT3How0Xhj4ql4CE87YdIJCjgEbrIbiBZxpGwwh1ETCf9
         sdyZakFgfFGxvjGpp3sjUxqWgPUiASykJ2/byduBq3Xqcz2rGkd2JcrJuUjMjCXzjSq7
         9fXSZ4OHUW/7S8Iby59tfEbwdEACl/gSCzOcAMyyLi6tB/NZEs7BVXqjZPWRiH0st6gq
         6t1G0AcHqCzdUjUxmUpLDrcFICnz92q3ndl0LW9Tf5VHP9DrCQcU8OIr4BCN+PD7Uifv
         iHSg==
X-Gm-Message-State: AOAM531CHmr8qiW5HvG9BYAfoWpbdKbzkZyWAoU2n8Ax5u1xQXPeeAOY
        lRONi+2cpWvhFdkJ9EoPH9jUzEzjWwSXCA==
X-Google-Smtp-Source: ABdhPJxZtGCHK5Ede0R1hnF1AQLa54ysml0yo3Brt3bjei0YV/JWJO4dVdscB+ObxJAlbvIqrOgpkg==
X-Received: by 2002:adf:ba0f:: with SMTP id o15mr14243204wrg.386.1629734250520;
        Mon, 23 Aug 2021 08:57:30 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf74b.dynamic.kabel-deutschland.de. [95.91.247.75])
        by smtp.gmail.com with ESMTPSA id m16sm3744501wmq.8.2021.08.23.08.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 08:57:29 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 0/2] Reusing nfct handle for bulk ct loads
Date:   Mon, 23 Aug 2021 17:57:13 +0200
Message-Id: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

I've finally got my hands on doing some more sophisticated testing
of the bulk ct operations functionality (-R option), and revealed 
a way to makethe ct load operations to be almost twice as fast 
by reusing the same nfct handleinstead of recreating it for each
entry.
This becomes essential for bulk loads of big amounts of entries,
where the overall speedup reaches values of seconds.

The two patches posted here are the tests/conntrack/bulk-load-stress.sh 
script that could be used for stress testing the bulk operations
and the patch improving the bulk ct load performance.

(Btw the script also reveals that bulk deletion of big amount
of entries specified individually is really slow,
but it's another story which could be addressed later if needed.)

Any feedback/suggestions for the patches are welcome.

Regards,
Mikhail


Mikhail Sennikovsky (2):
  tests/conntrack: script for stress-testing ct load
  conntrack: use same nfct handle for all entries

 src/conntrack.c                     | 160 +++++++++++++++++-----------
 tests/conntrack/bulk-load-stress.sh | 152 ++++++++++++++++++++++++++
 2 files changed, 247 insertions(+), 65 deletions(-)
 create mode 100755 tests/conntrack/bulk-load-stress.sh

-- 
2.25.1

