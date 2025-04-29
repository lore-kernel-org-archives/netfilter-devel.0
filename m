Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8EB2D3A6F;
	Tue, 29 Apr 2025 13:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932231; cv=none; b=eY8wReudSNc2M6FQjjPQgcIZWhKEawGbOdQA7Uuj/Ez5qCcwyJ8yQqkHHTEvOjMft8gA0heD4ax+kiIHlemBWgLSRDk0F97XP6nFUpnOJvGUD1aTEBSIGyjBePwZwYagUCeKR7zWjrLwI4YmodUKPMUzqAJMRsqlJCDureR5bGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932231; c=relaxed/simple;
	bh=razCufydCp8cSHS/7J5vw1wi4K0fz0XIO+8dvv0DB+Y=;
	h=From:To:Subject:Date:Message-Id; b=ZJ0Jgx5/fqwNGMO+ExfDv5rz7mVpq4zv3uxyWtl3Uou2rWqwNGoxB0VbCOfFYCUS8+wXFcd1RdEFATkk2fVRAGeNX9EdVEkcnH+/khvYONyAWklT4uw/0hFN9CWLxXM7SFffTr9AAG3EAYE+SeOjSE3bI9dba/aprRX0VpovMuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DmeNJNH4; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DmeNJNH4"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6f2b05f87bcso63236306d6.3;
        Tue, 29 Apr 2025 06:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745932228; x=1746537028; darn=vger.kernel.org;
        h=message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1Ad8WcxFYbWKFDodgJLrjO3snYPRzQsSNvXxKTQWLM=;
        b=DmeNJNH4RYNBKS1rH1oajWNNisRupDHl9DbF5O1tpCKNkf8wQNiMyCvA4fBqQcSEnc
         pKvdYYfEYZgtLOPO8/W9JzbOoCqiu2T1y6ecTFHUhHdco0+pQGOogkJWGpn+Nq7I/UvH
         nT+CMAFXcN3+vVExqMrwL9hstMNnjBDO0v1o+vRN7A+O1fPqvc8ujp5gPU0H2aLr8CWb
         PofgFZwXBbEPWwxKExZOt9vnw3n+fGdxE8ACCloj0eXJG3TcCy3kp1mb0pNci4hApli8
         dyLfdejIaPVWzjpl2gdFCV1jXjXZmAKtKolUih9EAUkQiz34S52FupxMS1o7kXYQRW3v
         EyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745932228; x=1746537028;
        h=message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i1Ad8WcxFYbWKFDodgJLrjO3snYPRzQsSNvXxKTQWLM=;
        b=GNJPyoSpAXxvr/MEQF8LeQ4sLtq9DoJgOP5oPKgy+xR07rkQSxR6LpLl98jnWT9/eA
         nx7+u21z044mk87BzMyu3VMoaC0B9t9Ebr4YEaTsClbUqeDnbcjegAtdDuTHQGqaE7bd
         L1Q5d9NxM854hOVDXLly58kGOdhYOD1HdMNaElu5dBFqRKvKSv0dge6khdwr8DAVlhwC
         +XO21izuRuURwLxsyptOIltWd5cvlGSpAHzbsaZSX9jl4a6CR+mQCpLfCDPl+ICEphj+
         FBdsfyHDq0jeKj+m4fLZbL5htsTvpLTcJux305hJROKfHClbtt+a85tExd5ZsCGXR2l7
         Cf1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhwE/cvCbfkn49GXGgjtXF7Y4DJ/z0ISYdOWWLWsLmtfQpujkD8G8ptFqfvtUG6Te7NjGL4dszSQhIg3s=@vger.kernel.org, AJvYcCXI0RwlC3S7M1UrjD6Pj2wTrgd1fPknIm8PKcPxMbFbkmziS9Q5zioqH9NufYG7MoJhd1ehq/qQczBhGBPuhz75@vger.kernel.org
X-Gm-Message-State: AOJu0YzbZ74W6erSbGJpDHFDPVY60WLZlSEiRItzWZuBDANym8Q/6evy
	obTeqT2MHyMTYhUFczcNx7tRvzGoTWiCnpZVMEBfEypJAXa2zcTpkwjT0CuX
X-Gm-Gg: ASbGncvIRQBLKv7SDPowCRqupwTPGcSmEZMS1a2g6NjEjIGIen8yBdKqVSvxadZ5lpk
	mLHKE53W/dpuSBb2Old0J3HCo5xZ+dRH23Rf9JvicCBM3ytWVYasrOXXeAgI6hTOHKokBkuSHYB
	1Qe1K7CgA93N8OiurQRl6lUtUjVfmdwKNu49JzeRQaoySstaCZqlI97BUd5YNEx7L+Iw1SqUewP
	bgLVm+ioHSjiYXiCpVqMp1HzOSgdXF4gak9dkW9zGyWf6mNDjmx3OCx+4YXfI40XJOF0zURgce1
	pMQggFnK7w1rMzEd1MSBoCJxa6v/ID1dbrYlQnbzvwcc5keVLaYnDQtL8qw=
X-Google-Smtp-Source: AGHT+IFZrVL0RYfWiTsG+OSx+3dBccZ7bd1zJVFN0sjXwUvXySkf4wb483/cMALj5hXfa/JeSnbdPA==
X-Received: by 2002:a05:6214:20cb:b0:6e8:eabf:fd55 with SMTP id 6a1803df08f44-6f4f0656a49mr47022756d6.39.1745932228160;
        Tue, 29 Apr 2025 06:10:28 -0700 (PDT)
Received: from localhost.localdomain ([66.198.16.131])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4c08eef25sm72883676d6.20.2025.04.29.06.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 06:10:27 -0700 (PDT)
From: avimalin@gmail.com
X-Google-Original-From: vimal.agrawal@sophos.com
To: vimal.agrawal@sophos.com,
	linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	anirudh.gupta@sophos.com
Subject: [PATCH v1] nf_conntrack: sysctl: expose gc worker scan interval via sysctl
Date: Tue, 29 Apr 2025 13:09:40 +0000
Message-Id: <20250429130940.74538-1-vimal.agrawal@sophos.com>
X-Mailer: git-send-email 2.17.1
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
Reviewed-by: Anirudh Gupta <anirudh.gupta@sophos.com>
---
 include/net/netfilter/nf_conntrack.h    | 1 +
 net/netfilter/nf_conntrack_core.c       | 4 +++-
 net/netfilter/nf_conntrack_standalone.c | 8 ++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

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
index 2f666751c7e7..480ff9a6f185 100644
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
-- 
2.17.1

