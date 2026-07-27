Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03668374A1D
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785171497; cv=none; b=LjJ71BzWhXt2LTA+3OYSqkX2gM8YZvE3b+Du8n0oJfyXCqExMKbYHwHWLXvQxu8ON4ODtdCEjwE/mOAlBycc77Xs6RLt5hYWCOfuValquHwgCtu5rbjvl2xLDHsOf9ipLIbxUcjcBmcd7fVI82/4BkdnR1iR6P02vM7zkoEAC/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785171497; c=relaxed/simple;
	bh=G68Gw8S2FyC9JyVHaUKphxTz7Kj/Y7rJiAfzKci+mDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTd4sWz2LHjBYHSdfBVyoR5+WTfFHfTk9KWJUmS56D9seqnVPQfkU7qQ7+TNn5PboznHcwvIu7SYoGAZM1V2hqkDYhCjdjIHWbwFflaXttQGUqgcl4whZQtykYNrxsPW2dkT6mqSnleW2qM4lkeqdHxkmd4rYa5jmIhAAi+m6x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Opn0mCak; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Opn0mCak"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cf52d15d88so29926505ad.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 09:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785171491; x=1785776291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mPtK2X3qlTxvVchUvjOBCqUeSyHhTBiCD+BTJfM1Tck=;
        b=Opn0mCak9XQQu9bg0mQXRBEBaa0qrDTSEeL8gdFWGM4kTyDvgQ8WMHRYusontUfPd1
         3YLFrgaHd4XcUHXx2pXu/jtG39AvPFj9qAxdRleFL7i1qxgvHWKboUREptG7T/6bfvr7
         nr2yz/qj0efngqnbRaSGBtqTRy+9DHzpqpJDBNlHaIWrgig5mmMDiYFdJejHBw+ZqKEo
         2O5AOs1sV1m1fARdaZc/sLBU1q2bRAacxgyRYIOlkpHwj1gTH3e17Lrm9AJPhbZTJHj+
         LOvPZFMt5DgmTzam6pxJ+kWHX3TkiGCCY5UUSEugQsKP/dhD8pAvajCzihsFdEliw9JI
         SWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171491; x=1785776291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mPtK2X3qlTxvVchUvjOBCqUeSyHhTBiCD+BTJfM1Tck=;
        b=FldnOCvpb1cwsRh55wlijRZ1u1PdNcS82laX6AGcZcn1Q2ehzwG1+MlJjj6X2UooVS
         Ls7UeLbIO1Q70Lfy7D5ewvWrmDWrnpJTPejoJhbEO639+wKLSNvdDbTUR1YrhfiFN6Gq
         Xz+G2dRLQAgrW6XcM3J1WCYH0AMiCY/6jXM3aFr9HL6yGAjWqmBpeL7P4SV4WWzeT7nK
         XcGcSO7SwToQD42z1NFeRfi+i5iUaa3ERqcn2R+4d8Ygjpjeaxpi2E2QC9/whJuZ2erg
         88dBB+nbyobgrbbiFR5c1J9amBIuzPeI/N+zZQea8Mj3SfZxS7cnr45tqVKJC3KqL4rU
         OCUA==
X-Forwarded-Encrypted: i=1; AHgh+RriRR5F4/ygJ3CkCWxLshXzxrzaM3A3Lgrp26m6OLyNgiWuScKvi3EEMwVmuEGcnlN7i14Go9i486icXsG70pU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzulnAqffulE6ad29UZ2h6vGxcCCiDnQj/6LTGkfCt9zVLz7dl/
	YL01Qkgln4S3BQDxe/4dHyvBT7a3kI4qWfirLYu+agwgPJyNTQDe/SO/
X-Gm-Gg: AR+sD12vYuYTrO8VaC7uk7g8VEtyXiSlfeNTPPEQvRPCTUS/ZB2GVYIjBU6tWZL6hOO
	PhP5L+jzfBJ6lPrWZnk+kJFzepFlHMIkcA+AwpEnBpVnPouz4RelySLz4g06h2x2TmVimKVUP9L
	8B0oZhZbaMLxw1xdLRMQMh7kXKwGQTWeveAfZxSWKU8Q3Vi4ZIwWcpQOmZDtFSzT99e8NvB2PPc
	R6H01Bbfq/lOecBDfL/pTOVBZ9ZpcWTE6t28vBleJDE3V6XOkpygO2mwiGYpAxh2n3tMqtx5Uv/
	PHiLdW09ZpBJAfejZhT7WSlI8TX3qYSCfZbLxHjgt500chOB+VBvWCkKo9KFGAeNKEDOw6b6RU9
	Q2iqleGBa1NVs2dvharuaE/1Zr0nqBetr05yIowutQxBOJeUDnBfaE7BuaBlftYk3cDbTz4HzXg
	VOkpMpYorp1ao9dYj4/DGp
X-Received: by 2002:a05:6a20:a10b:b0:3c0:9c1a:894a with SMTP id adf61e73a8af0-3c67e07704cmr8311973637.66.1785171491083;
        Mon, 27 Jul 2026 09:58:11 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb66b282asm3653821a12.18.2026.07.27.09.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:58:10 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jwiesner@suse.de,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf 1/1] ipvs: guard estimator enqueue until limits are set
Date: Tue, 28 Jul 2026 00:58:01 +0800
Message-ID: <6359e0031f0ee7cc969bae3483308de362d3c709.1784878022.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1784878022.git.zhilinz@nebusec.ai>
References: <cover.1784878022.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

IPVS estimator kthread 0 starts with zeroed chain and tick limits until
its initial calculation phase completes. If network namespace teardown
clears ipvs->enable during that phase, ip_vs_est_calc_phase() can return
without installing positive limits.

The kthread can then drain est_temp_list with zero chain_max, tick_max
and est_max_count values. Each enqueue consumes one available tick row,
but est_count never reaches the zero est_max_count value. After all rows
are consumed, the row lookup returns IPVS_EST_NTICKS and
ip_vs_enqueue_estimator() writes past the ticks and tick_len arrays.

Do not drain temporary estimators before est_chain_max is ready, and
reject enqueue attempts that do not have valid per-kthread limits or a
valid tick row.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
 net/netfilter/ipvs/ip_vs_est.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index ab09f51829512..8c8bb2085d1e3 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -196,7 +196,8 @@ static int ip_vs_estimation_kthread(void *data)
 	}
 
 	while (1) {
-		if (!id && !hlist_empty(&ipvs->est_temp_list))
+		if (!id && READ_ONCE(ipvs->est_chain_max) &&
+		    !hlist_empty(&ipvs->est_temp_list))
 			ip_vs_est_drain_temp_list(ipvs);
 		set_current_state(TASK_IDLE);
 		if (kthread_should_stop())
@@ -421,6 +422,11 @@ static int ip_vs_enqueue_estimator(struct netns_ipvs *ipvs,
 
 add_est:
 	ktid = kd->id;
+	if (!kd->chain_max || !kd->tick_max || !kd->est_max_count) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* For small number of estimators prefer to use few ticks,
 	 * otherwise try to add into the last estimated row.
 	 * est_row and add_row point after the row we should use
@@ -450,6 +456,10 @@ static int ip_vs_enqueue_estimator(struct netns_ipvs *ipvs,
 		if (row >= IPVS_EST_NTICKS)
 			row = find_first_bit(kd->avail, IPVS_EST_NTICKS);
 	}
+	if (row >= IPVS_EST_NTICKS) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	td = rcu_dereference_protected(kd->ticks[row], 1);
 	if (!td) {
-- 
2.43.0
