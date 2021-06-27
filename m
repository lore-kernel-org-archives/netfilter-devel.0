Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDF9C49EAB
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 16:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5602F6024A
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 16:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhF0QWC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Jun 2021 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhF0QWC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Jun 2021 12:22:02 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E8BC061767
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jun 2021 09:19:38 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j2so17511508wrs.12
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jun 2021 09:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bl7tOyVQLtJI72CQjTGh8rGAW+CFWr3Hxz4A4VKSTvg=;
        b=fqAXNhYM29djTo7zJMQY7R29qc1NFTC/yHm9R5xMGA2zHl16Uk8EgOQtvydJHCXwdY
         Z3l06OOOUmvrgLsdA49lp0ZVQ5TOVHNWzs1DcYnSosnvryzrCOH1M3hiYcubJwZahumC
         H32VZEfwMZexFpHm1viy4FS2Ejs5pJH0Iquhy83Wr9GWVOBKtI5dCzCvhDg3bM9x69BN
         nlg9jgnBokWh96hcq0Sobp8vTA5VU51rZkf7fZrU0Gpdwci1O7/x4QK/XfT0Vd+cYgOA
         hoMvYa/JgHZeCmo/Hr0/AdH7nY/svdMTqVmSNkXkSjd8Lkt+G+novuNLcKVnXV8BGUzL
         biyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bl7tOyVQLtJI72CQjTGh8rGAW+CFWr3Hxz4A4VKSTvg=;
        b=LmZu2kF3QP8MWzWQuoHSdfPVX5qChcW/g2RHgLdriEkivO/HG44WNaCIP55yV7MHIU
         F2W9pdolb3yNu9pc9o9IuGenLDQfm2jqajkmUvHS5mTwk5vkYYr0BE01Xh3URrvfE8yP
         Q5CqLOKdnUVQRlA3sjyYsXXuaBIWVQd9uCh3B1kJfbd32eOQAonR3zEixKH/8xFVThkp
         9s4/+BeZEwOT/krzLrVu9cd4TdHXZHvPpH2453Zos7zupSUKHgBREs3QyS0fhUBFEoZs
         jleQgXncWufp4iLyjNG8BQ69Nn9aLPRsC0VXh1PoyhleTdS7I1slEUuv5uX2lP4VD8GG
         oMAA==
X-Gm-Message-State: AOAM531rJcIIvhxAmr59+BLXAgNv2FAEKvTGlXxwuA3xh+tQLf3W9pKv
        oGoM8x5SStjUqWts/bdqNRUKQg==
X-Google-Smtp-Source: ABdhPJzEVfouweQ2qLAqglPV77F5jQY3fucDT365XiYmMIJvHC/9+PgPvWknTv8Adh9B0oI43nKUKg==
X-Received: by 2002:a05:6000:137c:: with SMTP id q28mr6148555wrz.207.1624810776650;
        Sun, 27 Jun 2021 09:19:36 -0700 (PDT)
Received: from localhost.localdomain (p200300d9974f98002cd84be72c5877b5.dip0.t-ipconnect.de. [2003:d9:974f:9800:2cd8:4be7:2c58:77b5])
        by smtp.googlemail.com with ESMTPSA id f22sm10820384wmb.46.2021.06.27.09.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 09:19:36 -0700 (PDT)
From:   Manfred Spraul <manfred@colorfullife.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netfilter-devel@vger.kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/2] net/netfilter/nf_conntrack_core: Mark access for KCSAN
Date:   Sun, 27 Jun 2021 18:19:18 +0200
Message-Id: <20210627161919.3196-2-manfred@colorfullife.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210627161919.3196-1-manfred@colorfullife.com>
References: <20210627161919.3196-1-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

KCSAN detected an data race with ipc/sem.c that is intentional.

As nf_conntrack_lock() uses the same algorithm: Update
nf_conntrack_core as well:

nf_conntrack_lock() contains
  a1) spin_lock()
  a2) smp_load_acquire(nf_conntrack_locks_all).

a1) actually accesses one lock from an array of locks.

nf_conntrack_locks_all() contains
  b1) nf_conntrack_locks_all=true (normal write)
  b2) spin_lock()
  b3) spin_unlock()

b2 and b3 are done for every lock.

This guarantees that nf_conntrack_locks_all() prevents any
concurrent nf_conntrack_lock() owners:
If a thread past a1), then b2) will block until that thread releases
the lock.
If the threat is before a1, then b3)+a1) ensure the write b1) is
visible, thus a2) is guaranteed to see the updated value.

But: This is only the latest time when b1) becomes visible.
It may also happen that b1) is visible an undefined amount of time
before the b3). And thus KCSAN will notice a data race.

In addition, the compiler might be too clever.

Solution: Use WRITE_ONCE().

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 net/netfilter/nf_conntrack_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e0befcf8113a..d3f3c91b770e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -153,7 +153,15 @@ static void nf_conntrack_all_lock(void)
 
 	spin_lock(&nf_conntrack_locks_all_lock);
 
-	nf_conntrack_locks_all = true;
+	/* For nf_contrack_locks_all, only the latest time when another
+	 * CPU will see an update is controlled, by the "release" of the
+	 * spin_lock below.
+	 * The earliest time is not controlled, an thus KCSAN could detect
+	 * a race when nf_conntract_lock() reads the variable.
+	 * WRITE_ONCE() is used to ensure the compiler will not
+	 * optimize the write.
+	 */
+	WRITE_ONCE(nf_conntrack_locks_all, true);
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
 		spin_lock(&nf_conntrack_locks[i]);
-- 
2.31.1

