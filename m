Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4C4C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Nov 2021 18:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhKTS0j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Nov 2021 13:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbhKTS0j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Nov 2021 13:26:39 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C53AC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Nov 2021 10:23:35 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v1so23686858edx.2
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Nov 2021 10:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYd2k/kJNErKKoaNmHPUwn+gxft65Im2LD4lPjU6h70=;
        b=inN4/Fm2EfQRnRppKvLUtwRwScWUZ8x4r2BGwmPzzJg73khgJrbf0EkUZwOI3fTNt0
         w1b0tLY0F6RYSw/K72xMBimzTppi/PCvVFMqBz7fgHcfYmBv7C3jVnWVYeaSXaUzk4Ej
         IyWG4cnQia/C0Hf7Dzq4aJXJkvt8QrzOIJ0u79CXwwo8KLfWRn9PuAShtLT+ZKvL+wt/
         U0wTYrEi1P0j48h1jWykilJpxSctaPwtpZkp8NqRtkIy4ymW1N6LJ8KmaDH1tnSWLwLp
         lKPVVFPv6Id5bQszwIvh33XvrlfUJ3ABudi+JRnSTSv/nCLm7yGpSBkIr7fJSt/Nlz3N
         EPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYd2k/kJNErKKoaNmHPUwn+gxft65Im2LD4lPjU6h70=;
        b=krR2BCHzQENJQg1nax0R/vPifkAKpafvfme1UTSUGzD3557ZvmSYWIN3mwwuzRlmkS
         8X1M2SZtN2BMrK/p6QkhLtidsTvYQDpwed3IqZGZbylTFMiUw1ucY4w5ldNNKf4eCQuJ
         u5kQVSZqw/f2ZWNzPgnKRX/44XTMMJqen8S37mdA6ihZEm+iYCSlUOTOlNi2j4D1DX3r
         EhHmF6cMeYgirYHbisKM3MHFO88OUFS0S/CMzFuvaUlPCCBGGbDlgB7IZZiD3WMX2Wq3
         eW7RDruIwrPVx5j4EDnEC2M5o7z7o2uv92IaDGv+A25aJEx9xhCsP3QnFqS+qyKigGDQ
         AcSg==
X-Gm-Message-State: AOAM5320Zg6bogQZ0D+frN4ZTOfDoIVYUOJGFXWOn+3DgaMRFLfi4Y11
        7YJph689F8Qn9q2LIc67Ny8=
X-Google-Smtp-Source: ABdhPJw9yGsW2GHWG0BNzRgpINs9Lk4zTshw695cpQwzRu8Ispg6vSOJ/TkWD2D6TGzinThoz8FxVg==
X-Received: by 2002:a17:906:4dd0:: with SMTP id f16mr21126390ejw.454.1637432613606;
        Sat, 20 Nov 2021 10:23:33 -0800 (PST)
Received: from jimi.localdomain ([37.142.70.89])
        by smtp.gmail.com with ESMTPSA id b2sm1515631edv.73.2021.11.20.10.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 10:23:33 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, shmulik.ladkani@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH nf-next] netfilter: conntrack: configurable conntrack gc scan interval
Date:   Sat, 20 Nov 2021 20:23:27 +0200
Message-Id: <20211120182327.1086993-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In Commit 4608fdfc07e1 ("netfilter: conntrack: collect all entries in one cycle")
conntrack gc was changed to run periodically every 2 minutes.

On systems handling many UDP connections, this leads to bursts of session
termination handling.

As suggested in the original commit, provide the ability to control the gc
interval using a sysctl knob.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 4 ++++
 include/net/netfilter/nf_conntrack.h             | 1 +
 net/netfilter/nf_conntrack_core.c                | 4 +++-
 net/netfilter/nf_conntrack_standalone.c          | 9 +++++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 311128abb768..7aaa5e26ed3f 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -207,3 +207,7 @@ nf_flowtable_udp_timeout - INTEGER (seconds)
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
         Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+
+nf_conntrack_gc_scan_intervaL - INTEGER (seconds)
+	default 120
+	minimum 1
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index cc663c68ddc4..f4ed812936a8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -314,6 +314,7 @@ extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
 extern unsigned int nf_conntrack_max;
+extern unsigned int nf_conntrack_gc_scan_interval;
 
 /* must be called with rcu read lock held */
 static inline void
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 054ee9d25efe..5fc56751d4ed 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -83,6 +83,8 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define MIN_CHAINLEN	8u
 #define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
 
+__read_mostly unsigned int nf_conntrack_gc_scan_interval = GC_SCAN_INTERVAL;
+EXPORT_SYMBOL_GPL(nf_conntrack_gc_scan_interval);
 static struct conntrack_gc_work conntrack_gc_work;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
@@ -1422,7 +1424,7 @@ static void gc_worker(struct work_struct *work)
 {
 	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	unsigned long next_run = GC_SCAN_INTERVAL;
+	unsigned long next_run = max(nf_conntrack_gc_scan_interval, HZ);
 	struct conntrack_gc_work *gc_work;
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 80f675d884b2..436e37df70e5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -565,6 +565,7 @@ enum nf_ct_sysctl_index {
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	NF_SYSCTL_CT_TIMESTAMP,
 #endif
+	NF_SYSCTL_CT_GC_SCAN_INTERVAL,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_RECV,
@@ -707,6 +708,13 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra2 	= SYSCTL_ONE,
 	},
 #endif
+	[NF_SYSCTL_CT_GC_SCAN_INTERVAL] = {
+		.procname	= "nf_conntrack_gc_scan_interval",
+		.data		= &nf_conntrack_gc_scan_interval,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
 		.procname	= "nf_conntrack_generic_timeout",
 		.maxlen		= sizeof(unsigned int),
@@ -1123,6 +1131,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+		table[NF_SYSCTL_CT_GC_SCAN_INTERVAL].mode = 0444;
 	}
 
 	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
-- 
2.32.0

