Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224CD6F06A;
	Wed, 30 Apr 2025 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745995447; cv=none; b=RJ3Dke498mn1IDY47le+k1CJxHurw+WXsYkeHaLi6uWN/IRTpWawFeNhlk69T1qUEfoQSJc+KOIu8SeC5Q8JrL3XVUNBK80Qze5CvsBVUrDe7jfxg0KjqNHgb4poVEqCR7YYACtWms70651TIOJCVhkTJUOGHi+d4vYZ3VzG+x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745995447; c=relaxed/simple;
	bh=AYp6pQ3LowXrZUdlkiNr5Hgj/8BH0hPF1FmqZZTurvs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=GHKBgffn8CSe2CqsaINgQS3btWl/G04YPAXB2H+Ii2ojWDj9pOcrriWxAN1BiCCrt9t/bpZzJf4VNcJ7Wo/gRg6xNjDmC2vgdKTbPO+eLR23bdNiwN0GxEGB6zZZCz9aawyNuaPzbk2CbHQYiVRIa+ZBjz/BnMzLoGxoSkS0mLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YM3ERsI2; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YM3ERsI2"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6f4e3618437so35216666d6.1;
        Tue, 29 Apr 2025 23:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745995445; x=1746600245; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ISfzHoRYtiJGPKJU8QM+7CDd8eBpcXDrcqU+YJg8cfA=;
        b=YM3ERsI2jmP3848Yl+lbMQlVftU2ExBDcmyO/gDpYwA9IaRMU2UlQ6PPi2caqrL16a
         YiVJPiqXSDMO1qbkTLRTs2lASDcra7nBzGxgjbk8f7AJpeYkFVgW7cKsl1dNplxLOHne
         wBHW8P5tmFH/AGpC3OW9e6YtnVWKZDCL7lE+MuTZ0sK9PQsm7cQCXudUlq/fLDcWxXdL
         TBsHMMF8M5LOVL0hfFGRdjgu6HEql3B8q0pcykXwZbEz0Qeipazt8bMH7XMpQN4nfvox
         IC9r6paAxn7CzHrCkDrTtyfweo6vZ2mvy0JsyIkJ56OjCyH1CBf3VTweViqBfPdHcDLf
         ylPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745995445; x=1746600245;
        h=references:in-reply-to:message-id:date:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISfzHoRYtiJGPKJU8QM+7CDd8eBpcXDrcqU+YJg8cfA=;
        b=ExDtvqvnP75YO1cuXKYXEeVormrrK1YZ3yRCINxTnPCSC5D0wN5hrQvCX3qiWuRjvB
         LJ2KCqQaZAktrvg//UCcYT4NjHG6DawlTTMOxzU3uBMHkifYkyKBYa0viPYjCbVLc2gE
         gtdQ4eoRQhz7xRNQpMCm7opuOkNn4WpC6WETCT4hLHQyhyccRWAglyV0ZsQ19Vk0ri8q
         zbrNms9NRd6ykmhf0EORyhLrmlIAWDG7BcGcHR9I+2WQm1IsjVrrj9tzWTKocyGRmlNf
         Cpka+41Nazw1YfOwD2Drel5WzDyltqT0PTX++2cLMdDrlHL47gQMjiaJbo8+vea9td98
         bUcg==
X-Forwarded-Encrypted: i=1; AJvYcCUIp3+eaAixbFeuYSvDTHnfHSoSJTegfxeUgWcpU2bW7YueS+itDREjzemQb9lqkBxGm0g90/S3TPiZ52w=@vger.kernel.org, AJvYcCXPc07jot0/YE5RSB4F2d5qgvsDFM+tz2etnJ4Lb+pRuFxhsGlKAnhwhQHgjpY9N3VHtdjRjmAgAnv1vU2bfyh3@vger.kernel.org
X-Gm-Message-State: AOJu0YyFCl11jbTf6/2tjjcvVWO7JvbA1abOAvq4rY7Ur8QkpP58dFAS
	GcPx0sh6nPZLo9c1TTHikJTGnQKQbVZfJ4kLNrsQ5XzuYfetGYSH
X-Gm-Gg: ASbGnctPKpsgxjbORdTMBw38pww/XnCtSVUqUZYWARUMFCT8oXR9sF/hG9pU/ExpkJq
	XOiYfxOJMabcvXY6kz7IhW5y6QEEvlVoNS18rVnYz27gqYavinYWj7pTqgzc0G2vsqiqh51pE43
	4Sfxo/YE1q/UTelgVL5JT3cK6n/RaAKgs1oLVmMtJKs3mRp1QMxfI0MOFEn40PO316VGGyyFHol
	Wp+cOWw5qdcC/7Wr7cnEx+75OQUvu9C4pajnJq7XVduAMCAZSltCwU4S54iPd+Vi97VY17JmAiy
	5iUlUZxuJ9tlCg+ZQcoyE+kHxoT3nCLb2H3fiZfzxn8oDV/xeGRkPi8WwaryJC/3NuvuyA==
X-Google-Smtp-Source: AGHT+IEJDOqILfMnwLve4xLjMjTtESiNuO4408dKv7NjG+Wo5RDb4PBOsFQKC/5cf/C55E25bUSbSg==
X-Received: by 2002:ad4:5cc5:0:b0:6cb:ee08:c1e8 with SMTP id 6a1803df08f44-6f4fcee2fffmr41127546d6.23.1745995444833;
        Tue, 29 Apr 2025 23:44:04 -0700 (PDT)
Received: from localhost.localdomain ([66.198.16.131])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4fe709702sm5107086d6.51.2025.04.29.23.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 23:44:04 -0700 (PDT)
From: avimalin@gmail.com
X-Google-Original-From: vimal.agrawal@sophos.com
To: vimal.agrawal@sophos.com,
	linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	anirudh.gupta@sophos.com
Subject: [PATCH v2] nf_conntrack: sysctl: expose gc worker scan interval via sysctl
Date: Wed, 30 Apr 2025 06:43:42 +0000
Message-Id: <20250430064342.62592-1-vimal.agrawal@sophos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250429132921.GA4721@breakpoint.cc>
References: <20250429132921.GA4721@breakpoint.cc>
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

 include/net/netfilter/nf_conntrack.h    | 1 +
 net/netfilter/nf_conntrack_core.c       | 4 +++-
 net/netfilter/nf_conntrack_standalone.c | 9 +++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

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

