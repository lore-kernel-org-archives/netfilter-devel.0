Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591E1C48BC2
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 16:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398AC619CB
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 16:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhF0QWG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Jun 2021 12:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhF0QWD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Jun 2021 12:22:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B284BC061766
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jun 2021 09:19:38 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j11-20020a05600c1c0bb02901e23d4c0977so11264546wms.0
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jun 2021 09:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Ya8bcE5B9mZqBLYjxYQKOGyjXrk4mCJTYJHXgJ9Ev4=;
        b=0PLvLYBiPtLVvFHh8ba/btIkDxuHk1lDhsClFiz0uoTeYC6DpGbRtItFCe/cgciHPu
         MfW4th291+fdJRQdQgk/7OHIvyWUI7gqF7QJWIdcSD6RS+9EGAdKH2gyLAJFjhVzPBSc
         SzRIhtNzHtkUwXvh2swIwTFA0GF+7Ozflk37HrFPz1v4J3OaDkRilzHgWlDk14hHVw7U
         SoQsrYQ7v/svrMpr7fImnIfGXM7TNHt4P0by2LjEAS5fD93SMYwl7TCSibuQZ5SxT2p2
         g93mo54H57WTE7muNA/ak56aguktakndATpL3WLVjBRPbZWxdgSgzV/NHxWc4RU4GbRm
         n2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Ya8bcE5B9mZqBLYjxYQKOGyjXrk4mCJTYJHXgJ9Ev4=;
        b=KbwDUHdj2ZGktEfyC/HDb1q/D1AvOcBzoEDZTDWeMPdG0ntgK0eeQg7EmfI7hzEwD7
         9f1hO/c/8k9S1zl0fujRk3nFF8l0W73SNaMqp8JbiojKu6TQmqUSy8FCIfKn9UkFVVfG
         Kdi74Dl9nXTzHzQmcDGuuCupjRgxhxOTVw66pJo81tYHaFWR2r3DwpnnC2LEgy54EwMG
         1Hc0EY390IHC16pMYcEEk5z4TNmEBDpUWsmRGINyHgdJUMeQKR33M1JJF1nPwurv42ZQ
         jy/KBE+RFvF6nnR91F7+ozwbfdox9wyA9Ij+0035tHtzQVwDgVTdWqqs5tBdSSc2PyxM
         JFDw==
X-Gm-Message-State: AOAM5326n1+YYpibx2oQGgouonVp65T7J379j1XXPyw/DLY3z+S11dag
        npNbsfiYTCOglZfOflvr5ivGaw==
X-Google-Smtp-Source: ABdhPJwUZnE5/yNGwDmoRFsGxsQRevaEKbLKGJzC/0/NjhoTVNE40buQznz9x/qIMEX+t2xqQzTJSA==
X-Received: by 2002:a7b:c4da:: with SMTP id g26mr21518677wmk.3.1624810777414;
        Sun, 27 Jun 2021 09:19:37 -0700 (PDT)
Received: from localhost.localdomain (p200300d9974f98002cd84be72c5877b5.dip0.t-ipconnect.de. [2003:d9:974f:9800:2cd8:4be7:2c58:77b5])
        by smtp.googlemail.com with ESMTPSA id f22sm10820384wmb.46.2021.06.27.09.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 09:19:37 -0700 (PDT)
From:   Manfred Spraul <manfred@colorfullife.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netfilter-devel@vger.kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/2] ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock
Date:   Sun, 27 Jun 2021 18:19:19 +0200
Message-Id: <20210627161919.3196-3-manfred@colorfullife.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210627161919.3196-1-manfred@colorfullife.com>
References: <20210627161919.3196-1-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch solves three weaknesses in ipc/sem.c:

1) The initial read of use_global_lock in sem_lock() is an
intentional race. KCSAN detects these accesses and prints
a warning.

2) The code assumes that plain C read/writes are not
mangled by the CPU or the compiler.

3) The comment it sysvipc_sem_proc_show() was hard to
understand: The rest of the comments in ipc/sem.c speaks
about sem_perm.lock, and suddenly this function speaks
about ipc_lock_object().

To solve 1) and 2), use READ_ONCE()/WRITE_ONCE().
Plain C reads are used in code that owns sma->sem_perm.lock.

The comment is updated to solve 3)

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
---
 ipc/sem.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index bf534c74293e..b7608502f9d8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -217,6 +217,8 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
  * this smp_load_acquire(), this is guaranteed because the smp_load_acquire()
  * is inside a spin_lock() and after a write from 0 to non-zero a
  * spin_lock()+spin_unlock() is done.
+ * To prevent the compiler/cpu temporarily writing 0 to use_global_lock,
+ * READ_ONCE()/WRITE_ONCE() is used.
  *
  * 2) queue.status: (SEM_BARRIER_2)
  * Initialization is done while holding sem_lock(), so no further barrier is
@@ -342,10 +344,10 @@ static void complexmode_enter(struct sem_array *sma)
 		 * Nothing to do, just reset the
 		 * counter until we return to simple mode.
 		 */
-		sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
+		WRITE_ONCE(sma->use_global_lock, USE_GLOBAL_LOCK_HYSTERESIS);
 		return;
 	}
-	sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
+	WRITE_ONCE(sma->use_global_lock, USE_GLOBAL_LOCK_HYSTERESIS);
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = &sma->sems[i];
@@ -371,7 +373,8 @@ static void complexmode_tryleave(struct sem_array *sma)
 		/* See SEM_BARRIER_1 for purpose/pairing */
 		smp_store_release(&sma->use_global_lock, 0);
 	} else {
-		sma->use_global_lock--;
+		WRITE_ONCE(sma->use_global_lock,
+				sma->use_global_lock-1);
 	}
 }
 
@@ -412,7 +415,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 	 * Initial check for use_global_lock. Just an optimization,
 	 * no locking, no memory barrier.
 	 */
-	if (!sma->use_global_lock) {
+	if (!READ_ONCE(sma->use_global_lock)) {
 		/*
 		 * It appears that no complex operation is around.
 		 * Acquire the per-semaphore lock.
@@ -2435,7 +2438,8 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 
 	/*
 	 * The proc interface isn't aware of sem_lock(), it calls
-	 * ipc_lock_object() directly (in sysvipc_find_ipc).
+	 * ipc_lock_object(), i.e. spin_lock(&sma->sem_perm.lock).
+	 * (in sysvipc_find_ipc)
 	 * In order to stay compatible with sem_lock(), we must
 	 * enter / leave complex_mode.
 	 */
-- 
2.31.1

