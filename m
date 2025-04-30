Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C81D95A3;
	Wed, 30 Apr 2025 07:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998117; cv=none; b=PK04GUihXCWp8+zvmeH2RaarTgYdybpN/zJGs5hX0tiCWq7J3r8poJMBp0WDTJ9foadTzjfmQ1Gc8Ws2OmswlBa2mnZAtfl4/fQdnVLKeHH1fvgaEaUocnCG49yVsPHtGcN+hJ0Sz26IqS1sdGUP+8T94bh/SSB5UShHBPgL3As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998117; c=relaxed/simple;
	bh=FlcdOUjhL4Bk8l+hSj23sWzUWFFFLfUxDsBh29Xxmvw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=P+t5tuQifByoExgDzZsqGDjrY3uWYNd/G/p1kdCCnQgeEaVpgmyId+ou4w1VAx3uBibIJnie+0ZNHFtSZZsQZWL6XLIYkUfXmhZPtqW5BO9JH4J7/2nWROHKE85CrZW49tNQmJcqxmKz2UlB65kwwMy7yd9ul57ZZtCMoWcVl7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YImLkOxp; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YImLkOxp"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-47691d82bfbso156985351cf.0;
        Wed, 30 Apr 2025 00:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745998114; x=1746602914; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3f7/haHpct3qXDE85QVeKOGieE+1sU2Y5nS5oX126v8=;
        b=YImLkOxp5fw68vAcA4bLkRuEkKk4lFHdUkVJFZu2y3WlYpR6YNG+lX2VaQWfo0D6Bw
         bt+MHkDerZqmeih14ywMHlWKrH9sHEAaESMYCoLxUgv3UnlGhLpYiN7wOy/PPugYJpiR
         Rlp/ZvDr5afQdBeU/0QE4QIuaWU4+z/NJSS5IRJLmB52lVGQHZ0FikD/ghh6tDydLrQa
         ju1gzJJebfdy8rToWA51u2JWLX9256+jzsvgDwAGqfQPx89TA5nw8EFs1j4cs4EUHK1D
         Vr5U0/vjUyu5yTmr4CBTHV5XPqY2ml9Y+315LWaZTi9YRdAUcZZnFV9fqxp42DAWPlBa
         hOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745998114; x=1746602914;
        h=references:in-reply-to:message-id:date:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3f7/haHpct3qXDE85QVeKOGieE+1sU2Y5nS5oX126v8=;
        b=WVTuhI3XjYjkpfR8G4AFRv6GIY39da6frTknhRvQC7Xls0xKRsDTwo/L1rRrPa0s1I
         rLc/zANjRfcOtZsqrrVBohiA4hwl34dcR37jXHml+ExgxAiOYm1VQ0rhtGi4nefU6DJg
         dmOZBBJPIqI8bZCcH1QPXi+BWMcWW9FD5130unfBKjdmOlc2HpoKn3sVRYv5mUzfyr6K
         GsCuXTUjjNsaxuqlrCrkN0FoJUyxdUD5boTKHdy4c5v54GWO87la9Yu9iqydWEqt+G8i
         98uaCQI1aQRUxA3hnhnWPG1yTNZcwl+28mxYE8LEhpiFUqx68YCIK21Q1UbyIfKqDaA+
         u0+A==
X-Forwarded-Encrypted: i=1; AJvYcCVJYRj2/G8TcNy5dNlFHfuydYTxXgbxbr5lOb76365Fs11QfLbURJiBQ7p0ZpNfpEpXWk2zhajMPcBLoeGZ6o8s@vger.kernel.org, AJvYcCXYbMj835P3ZN+4hPHHTiIuzb/xCwN3E48JzKqliP8zzzxInwQuTOTY/eTVF4LU+Z9si3TGUr4BJEQT65I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXzmvNNULVJjTyG8cs9Yg/TfeWLBt8FgF31c/jLIX2q4zwAfkt
	q/DqOSV4c0Zq5/AuxBONyiW9YymInYp5nsHjhC03XI/FcfBoQEDK
X-Gm-Gg: ASbGncuvLqwCGK32dUzdQWjOaPECSVsT4qPUC1dNG00+YkShwZLOpAS7z9dIsR2GMbw
	UFiULvy4lOAaCXM01WXXmaURvRkiQ5lgQlD/vHgnO9nlF1g6xCGEqgJl0hyqv+J5da5NjaltHUJ
	Ed1cfiuDzwHummQqa3pO3AotfPBwwkcgjkfDaG1J6wRSmChb2+PPPNT6Ed0/xLLvXoqFPaRixzQ
	U+G5ZnoNNTJAH1ST7OeLLIjZqE83+WpYjdyxl8vgNIrXRDdpO/etEdrsunY+rDZrmSSfxNBokgJ
	bvY1eXUxtT7dZSJmxxx4u5aDur/gzLXzDtlz/VCFulsW52FdYdnHMvEDQTk=
X-Google-Smtp-Source: AGHT+IHcIOb0aoioQULV8gzpF66C+Z3jnLphJ2cA68GtIqnfJ5EZbC6j9zp9MZFht7/l/vnEUluvtA==
X-Received: by 2002:a05:622a:4c17:b0:476:afd2:5b4b with SMTP id d75a77b69052e-489e44b5c68mr25930111cf.8.1745998114192;
        Wed, 30 Apr 2025 00:28:34 -0700 (PDT)
Received: from localhost.localdomain ([66.198.16.131])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47e9eaf4873sm89848711cf.1.2025.04.30.00.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 00:28:33 -0700 (PDT)
From: avimalin@gmail.com
X-Google-Original-From: vimal.agrawal@sophos.com
To: vimal.agrawal@sophos.com,
	linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	anirudh.gupta@sophos.com
Subject: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval via sysctl
Date: Wed, 30 Apr 2025 07:28:10 +0000
Message-Id: <20250430072810.63169-1-vimal.agrawal@sophos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250430071140.GA29525@breakpoint.cc>
References: <20250430071140.GA29525@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

From: Vimal Agrawal <vimal.agrawal@sophos.com>

Default initial gc scan interval of 60 secs is too long for system
with low number of conntracks causing delay in conntrack deletion.
It is affecting userspace which are replying on timely arrival of
conntrack destroy event. So it is better that this is controlled
through sysctl

Fixes: 2aa192757005 ("netfilter: conntrack: revisit the gc initial rescheduling bias")
Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Anirudh Gupta <anirudh.gupta@sophos.com>
---
v2: Don't allow non-init_net ns to alter this global sysctl
v3: Add documentation in nf_conntrack-sysctl.rst

 Documentation/networking/nf_conntrack-sysctl.rst | 5 +++++
 include/net/netfilter/nf_conntrack.h             | 1 +
 net/netfilter/nf_conntrack_core.c                | 4 +++-
 net/netfilter/nf_conntrack_standalone.c          | 9 +++++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 238b66d0e059..207b62047639 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -64,6 +64,11 @@ nf_conntrack_frag6_timeout - INTEGER (seconds)
 
 	Time to keep an IPv6 fragment in memory.
 
+nf_conntrack_gc_scan_interval_init - INTEGER (seconds)
+	default 60
+
+	Default for garbage collector's initial scan interval.
+
 nf_conntrack_generic_timeout - INTEGER (seconds)
 	default 600
 
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 3f02a45773e8..eaf1933687b2 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -321,6 +321,7 @@ extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
 extern unsigned int nf_conntrack_max;
+extern unsigned int nf_conntrack_gc_scan_interval_init;
 
 /* must be called with rcu read lock held */
 static inline void
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..d7e03c29765a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -204,6 +204,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
+__read_mostly unsigned int nf_conntrack_gc_scan_interval_init = GC_SCAN_INTERVAL_INIT;
+EXPORT_SYMBOL_GPL(nf_conntrack_gc_scan_interval_init);
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
@@ -1513,7 +1515,7 @@ static void gc_worker(struct work_struct *work)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
 	if (i == 0) {
-		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->avg_timeout = nf_conntrack_gc_scan_interval_init;
 		gc_work->count = GC_SCAN_INITIAL_COUNT;
 		gc_work->start_time = start_time;
 	}
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..bdbf37a938bb 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -559,6 +559,7 @@ enum nf_ct_sysctl_index {
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	NF_SYSCTL_CT_TIMESTAMP,
 #endif
+	NF_SYSCTL_CT_GC_SCAN_INTERVAL_INIT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_RECV,
@@ -691,6 +692,13 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra2 	= SYSCTL_ONE,
 	},
 #endif
+	[NF_SYSCTL_CT_GC_SCAN_INTERVAL_INIT] = {
+		.procname	= "nf_conntrack_gc_scan_interval_init",
+		.data		= &nf_conntrack_gc_scan_interval_init,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
 		.procname	= "nf_conntrack_generic_timeout",
 		.maxlen		= sizeof(unsigned int),
@@ -1090,6 +1098,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+		table[NF_SYSCTL_CT_GC_SCAN_INTERVAL_INIT].mode = 0444;
 	}
 
 	cnet->sysctl_header = register_net_sysctl_sz(net, "net/netfilter",
-- 
2.17.1

