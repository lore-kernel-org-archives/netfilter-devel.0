Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000DBC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 10:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbhKUK6b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 05:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238007AbhKUK6b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 05:58:31 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60125C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 02:55:26 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso11215703wmf.0
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 02:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gMnViNSNvesGUSsfVte4NTYS6J7f9hlYyewfACZamII=;
        b=bPkV5arHBTSvV0WK2HEBGFtH75a62Bt4GB2aML7z3vrt1ddxdPb4fsDWqXZ+3F1KMa
         /BLLOjX8FDFdid8uPZU/ck3kCc017wRDcG/Fhjdj1PU+ZmSkhzkeSsmXpDgSioc0nfPb
         w6IPVElx7znSCeQGYddyFmU5yrTazNUch34vCJey95BMJN8tKC64wuZIcDVlyQXvSqAn
         QA1aHql3336QEUkjFKVtWV1Fe2wM0U5d2hUnL4qJ5ddeUNJHChRx1e02jwAo0hy2hRF5
         8ZPF6nZPmsR6zw8UdsttVUwsHprLucHkP4IWqMYwDiN11+6AnV85ks8Eblc7J93UgmKR
         d7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gMnViNSNvesGUSsfVte4NTYS6J7f9hlYyewfACZamII=;
        b=zSG0UOk+HzpxE1jRIBV/Fz/5CLS3DgPpYIi+gKa6S+MtXf+LaaaFYqTfSEccWBm0qS
         QR7p78z0Fsc9BPrmJUFR7+VKyXTX/MXD4ZtYfYGGcewqKXFOa31mTdbn7ggYs7cQJnyD
         DhaTow2ZuUyzlsZIVYB/dnCKGab6olycGqFEFLFMHKHg9ZTh65UvMxWE/d64+k3OMj8J
         BTN9HTIYX5uNc8PBBr7hjdCnteqZ/iaRC0MDZ8dJbGnojv49BaGBon5GkPbKgtVuIz4P
         W8kCs2Hd0RiQa++GL7j3kgb1aQtssITEzj+LacYpZxiDuL+0aDp2GHkvWsOK6ua2Qcg2
         KOFw==
X-Gm-Message-State: AOAM531rT3qNMcSA3CySLJqNQd0Z2AtrfD63NrMV1cxrKI/tOwCg/hPb
        j1yq+5xdVjkeFXXFXweytkA=
X-Google-Smtp-Source: ABdhPJxU2SCtPgy7t85Ti/7XvCeoTJfzZj+h4DXSZdgJdXZF3zrM724TZ2f3x5nR+Znc5mQXqoL7lA==
X-Received: by 2002:a1c:9842:: with SMTP id a63mr18849899wme.102.1637492124248;
        Sun, 21 Nov 2021 02:55:24 -0800 (PST)
Received: from jimi.localdomain ([37.142.70.89])
        by smtp.gmail.com with ESMTPSA id h13sm5466155wrx.82.2021.11.21.02.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 02:55:23 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, shmulik.ladkani@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH nf-next,v2] netfilter: conntrack: configurable conntrack gc scan interval
Date:   Sun, 21 Nov 2021 12:54:48 +0200
Message-Id: <20211121105448.2756593-1-eyal.birger@gmail.com>
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

v2: fix compiler warning on max() macro usage
---
 Documentation/networking/nf_conntrack-sysctl.rst | 4 ++++
 include/net/netfilter/nf_conntrack.h             | 1 +
 net/netfilter/nf_conntrack_core.c                | 6 +++++-
 net/netfilter/nf_conntrack_standalone.c          | 9 +++++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

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
index 054ee9d25efe..76867baaf05c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -83,6 +83,8 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define MIN_CHAINLEN	8u
 #define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
 
+__read_mostly unsigned int nf_conntrack_gc_scan_interval = GC_SCAN_INTERVAL;
+EXPORT_SYMBOL_GPL(nf_conntrack_gc_scan_interval);
 static struct conntrack_gc_work conntrack_gc_work;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
@@ -1422,7 +1424,9 @@ static void gc_worker(struct work_struct *work)
 {
 	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	unsigned long next_run = GC_SCAN_INTERVAL;
+	unsigned long next_run = max_t(unsigned int,
+				       nf_conntrack_gc_scan_interval,
+				       HZ);
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

