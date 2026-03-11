Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59358313E3B
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 19:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773258081; cv=none; b=O3+FobutXDe7iXXZC7wyq7fLOpuwyvh87PYUiDQ0K0ImfDINukAa5tOOs1DZIuqK/xfeqbgtYWrCmEUXLFeT4tti2wn+Cn2CkV5L3TXFs7Z8YqjSb5+H28iweAIBzpN7NUhXFWPbg1a7svtPVDWEOWodOK50mMKv8kMddGLdGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773258081; c=relaxed/simple;
	bh=JmzZ5cArUGLdVYVbW1glxu2tEsH90YQOrUa0/YOI0Es=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tgVxR11MjYLEPS9N5U/yPJRHnUTxiGPx03FtREMqoi+kdoOCRQtegDruGrMxsbyDzbqOXWII4quZcQO4tqD/8QJGxR/Qy8eurwDQER5UoYET0lEOHMe52YuwtcEbt9IDhGl6ST9ndOQwC8QQxE9kA47AG/imBHrk85yh+exutwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=AJ6x8yC+; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="AJ6x8yC+"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1271195d2a7so657565c88.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1773258078; x=1773862878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0wyN7pn3XZY19VGN08Uvl0u7SIQ9oF05liu+AZCu18U=;
        b=AJ6x8yC+7o/lAmibpOtT7MjE6Pa4z2SZF1agRnMzOY5dakiPhQcsbgS31TR4Z6NzA2
         d2XmC3itSbq3PvcwYeuly8IsZievObej3lShM4yPAWZBPMAcIaqWjYTfEjwGiffGTD/i
         uv/1qtGRYvJ8vAYAU8e7AHd6bJfdNpzZDpw9456FFMWu1tBT4P57h2m8A/RYPPYeeUdb
         70vvMnLZdXdGI7rWL4TUN7LVgri/mLDvB1X1nkiZ+UbUhaEn10aqQprjWJZGfKlQ2yWa
         nooWQA7RF0cbCmdpbqGlHDMn2rNbSddxPqrfEo1QqKDY56wOEIfOxnWX4rzIZXvnxEY2
         SBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258078; x=1773862878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wyN7pn3XZY19VGN08Uvl0u7SIQ9oF05liu+AZCu18U=;
        b=djDejTtGYA4buMzReN9oPN3zGZR6cZpTayaxHeeQzxyznwv4nlmaXk7kNPP7jmTr6o
         LxD2SeQpNEHKnXAMLl8+Fiwga2oT2H9qFo1T9wuCO79dwl59lS333jGeaKTiHkueKjom
         sbV5WDSs8o0Vv48y06YNYOUGT2M82BRYuCGw0FXY377Jgw8stekaGy8yoraEe8BKLuJO
         a/c9PQug1nZHhHY1SwW8nVCGwgkI9sLafNAJyyYuTSzZvVkyz9zjyNkCXf2PNoId2fuL
         nK5lb30WKT8RIIiMnO4uUGmNuCrG5dZMsFkVJc/j59iPq6jz9TuAx+29FgiOFZBmcQt7
         ikLQ==
X-Gm-Message-State: AOJu0YwRPxFB/DsJXBIV74K18zTxfu51mhs1nR5bbpl6rcHV1jUK0MS5
	Vjn1H8Y+GdFFOvaqle//o+a/TYVm/J9xopyi2Yb0cLLpY/mdKNEicJz1N06qVEBqjUlVdGsHKi+
	aqh4Sog==
X-Gm-Gg: ATEYQzzgmOsiGxLdPnT2Mr4J6NTQZ0nUzdSIWIPSAZ5JAfeqdQrFnUFU5XSVlmgdJpO
	r6489V7kpZumhQKemV8QopqhETIoVP9GylX2sjEvLh7N4USzbHj/PTwpggkxdy8Stz/ks1QJb40
	IDXSbdv6lGMcCLMkNpcSyb8J+yiL4v2ItjaeI7heMZf+0ounhFoVFYTxicQaQZyx/zxvMU+FKQY
	L1Mamj+BJode3WvG7reTOrgyeM6JxgiEfA5Euroa9MVVs836HmsYD2EvV9cOMHx2v8vcI0xx4l+
	tqYfBABFJ0V9BTk8HHkGed5/mKpDFU5z7vDPdBhfh0NCGtCmDXu/XuAL8OmoXpGug8pejDySKN4
	4gnvC02Xfuy3C7H8mOBtK36cuK/t/VnC0jYxMwEDT5+3D037EOOjH/a3IByDlpn1FihJ+mHJKgG
	dqMu+vXxL3kiBIlScf88cw1VomeWZCfV56lj4RI7k/gP7hBBvBvvLKsDlGiH7CUusP
X-Received: by 2002:a05:7022:6987:b0:127:3816:50c6 with SMTP id a92af1059eb24-128e77882d3mr1910091c88.8.1773258077754;
        Wed, 11 Mar 2026 12:41:17 -0700 (PDT)
Received: from localhost.localdomain ([2600:1700:4a3d:5010:7185:74c9:dc1e:956])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7bf1e1asm4074436c88.3.2026.03.11.12.41.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Mar 2026 12:41:17 -0700 (PDT)
From: Prasanna S Panchamukhi <panchamukhi@arista.com>
To: netfilter-devel@vger.kernel.org
Cc: panchamukhi@arista.com,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next] netfilter: conntrack: expose gc_scan_interval_max via sysctl
Date: Wed, 11 Mar 2026 12:40:58 -0700
Message-ID: <20260311194058.13860-1-panchamukhi@arista.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The conntrack garbage collection worker uses an adaptive algorithm that
adjusts the scan interval based on the average timeout of tracked
entries.  The upper bound of this interval is hardcoded as
GC_SCAN_INTERVAL_MAX (60 seconds).

Expose the upper bound as a new sysctl,
net.netfilter.nf_conntrack_gc_scan_interval_max, so it can be tuned at
runtime without rebuilding the kernel.  The default remains 60 seconds
to preserve existing behavior.  The sysctl is global and read-only in
non-init network namespaces, consistent with nf_conntrack_max and
nf_conntrack_buckets.

In environments where long-lived offloaded flows dominate the table,
the adaptive average drifts toward the maximum, delaying cleanup
of short-lived expired entries such as those in TCP CLOSE state
(10s timeout). Adding sysctl to set the maximum GC scan helps to
tune according to the evironment.

Signed-off-by: Prasanna S Panchamukhi <panchamukhi@arista.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: Jonathan Corbet <corbet@lwn.net>
cc: Shuah Khan <skhan@linuxfoundation.org>
cc: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Florian Westphal <fw@strlen.de>
cc: Phil Sutter <phil@nwl.cc>
cc: netdev@vger.kernel.org
cc: linux-doc@vger.kernel.org
cc: linux-kernel@vger.kernel.org
to: netfilter-devel@vger.kernel.org
cc: coreteam@netfilter.org
---
 Documentation/networking/nf_conntrack-sysctl.rst | 11 +++++++++++
 include/net/netfilter/nf_conntrack.h             |  1 +
 net/netfilter/nf_conntrack_core.c                |  9 ++++++---
 net/netfilter/nf_conntrack_standalone.c          | 10 ++++++++++
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 35f889259fcd..c848eef9bc4f 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -64,6 +64,17 @@ nf_conntrack_frag6_timeout - INTEGER (seconds)
 
 	Time to keep an IPv6 fragment in memory.
 
+nf_conntrack_gc_scan_interval_max - INTEGER (seconds)
+	default 60
+
+	Maximum interval between garbage collection scans of the connection
+	tracking table. The GC worker uses an adaptive algorithm that adjusts
+	the scan interval based on average entry timeouts; this parameter caps
+	the upper bound. Lower values cause expired entries (e.g. connections
+	in CLOSE state) to be cleaned up faster, at the cost of slightly more
+	CPU usage. Minimum value is 1.
+	This sysctl is only writeable in the initial net namespace.
+
 nf_conntrack_generic_timeout - INTEGER (seconds)
 	default 600
 
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bc42dd0e10e6..0449577f322e 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -331,6 +331,7 @@ extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
 extern unsigned int nf_conntrack_max;
+extern unsigned int nf_conntrack_gc_scan_interval_max;
 
 /* must be called with rcu read lock held */
 static inline void
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 27ce5fda8993..54949246f329 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -91,7 +91,7 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
  * allowing non-idle machines to wakeup more often when needed.
  */
 #define GC_SCAN_INITIAL_COUNT	100
-#define GC_SCAN_INTERVAL_INIT	GC_SCAN_INTERVAL_MAX
+#define GC_SCAN_INTERVAL_INIT	nf_conntrack_gc_scan_interval_max
 
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
@@ -204,6 +204,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
+
+unsigned int nf_conntrack_gc_scan_interval_max __read_mostly = GC_SCAN_INTERVAL_MAX;
+
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
@@ -1568,7 +1571,7 @@ static void gc_worker(struct work_struct *work)
 				delta_time = nfct_time_stamp - gc_work->start_time;
 
 				/* re-sched immediately if total cycle time is exceeded */
-				next_run = delta_time < (s32)GC_SCAN_INTERVAL_MAX;
+				next_run = delta_time < (s32)nf_conntrack_gc_scan_interval_max;
 				goto early_exit;
 			}
 
@@ -1630,7 +1633,7 @@ static void gc_worker(struct work_struct *work)
 
 	gc_work->next_bucket = 0;
 
-	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
+	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, nf_conntrack_gc_scan_interval_max);
 
 	delta_time = max_t(s32, nfct_time_stamp - gc_work->start_time, 1);
 	if (next_run > (unsigned long)delta_time)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 207b240b14e5..f8cab779763f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -637,6 +637,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
 #endif
+	NF_SYSCTL_CT_GC_SCAN_INTERVAL_MAX,
 
 	NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -920,6 +921,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 #endif
+	[NF_SYSCTL_CT_GC_SCAN_INTERVAL_MAX] = {
+		.procname	= "nf_conntrack_gc_scan_interval_max",
+		.data		= &nf_conntrack_gc_scan_interval_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+		.extra1		= SYSCTL_ONE,
+	},
 };
 
 static struct ctl_table nf_ct_netfilter_table[] = {
@@ -1043,6 +1052,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+		table[NF_SYSCTL_CT_GC_SCAN_INTERVAL_MAX].mode = 0444;
 	}
 
 	cnet->sysctl_header = register_net_sysctl_sz(net, "net/netfilter",
-- 
2.50.1 (Apple Git-155)

