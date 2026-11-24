Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795490490;
	b=YaqPb+f2ekoXGwtRw0afPe1hJ97iOIKJG+9NFohAImS50Z6btqDQ2c27jB2BMIpZHcBk
	 821TBF/hdMdjNXrE1VZHGAH33vFIbJWnJHwJfYb8gGszb9TB3XwQBTJ/xI/jNmG+ZjWjR
	 waAhD0nM4rDGHgGOXWT1a3Ayh8bYPRIuEl8Z0GbdUg8mNxo64DWCEOEJl/+fZlB7puxVk
	 kmZrzD44yS1qm9RBEGC0vQ3P9APu2XsTARE8Lb5kIJqBnu12B7kjumD7JMjAInieGosWg
	 iY4qlH6rekwFuP+44gFfoml/2vFbSuSE/AcnvwqzxYGnOJaztVBdUgBwW1aXEkwQzeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795490490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=oaCz9FAobFX+cqXKdeVDaXGsBDT/dh6s+LEZD6XoqC0=;
	b=hRnHOPG8p3R0ZB96QwtQn4cmdpHtM9qn4BRQlsfdQrrZsVMfO7Ds19QsYeIBvRiSq7pq
	 Z8NRerk5/VMPpsmG3T8ULFP7YexDjuZPTfXs6//nUaLXqKrzLPuJ30cY1pHtvx5kpxPEi
	 8oMDogkLHszA3YVFN+DJiUdL5SZhE7CQeBva9cvLbk/enfW0mWZLHCkvAkx+94eqeIN8c
	 LCr0ZoWmY8aNbVjx99VeF60hDRNC/qbui9KfzLTrXMWAhyc9kUPMbLWBSj8zVBY0i0o6J
	 BIc9bv6BY1ZwiwChoira3CF5GU7k0QCreEeVkProhMaeFm6vVKU01yJ0ymrOW033mcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ygdhWyXJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.49
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064C1606A322
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 03:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 064C1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ygdhWyXJ
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-67db763cec7so4164536d50.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 19:21:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795490489; cv=none;
        d=google.com; s=arc-20260327;
        b=Om1he8NSFVroymHma800YXqUdzVXNJA4iip/TJpjFWP8jKG+AyW0MQafyMfziOFNpp
         +WXLzegPkiQMi9MZ3R5U9JcvKrAnF68glH0AYF9zXbICHtGqjd0lccPooMf0QgaIf/09
         4guhp5ksPKJ+oxcnf1gEcLyT5vJUyP+d+IenVdD2F7tjVCJQrttwXJoCMHhbv1jxxgBk
         swC6w0KNs9DtY3mwQzoooaQfeSK7HNg1DzK4HD74KVMW4EF4L2NDE57hegRkUN2GZTLo
         llD1WonpBVnxf5UWeHBdVyFc3Rus6RObteLovQg45QKdLZKNOYhhfJO2Q7Y5XLD365Mm
         Sthg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=oaCz9FAobFX+cqXKdeVDaXGsBDT/dh6s+LEZD6XoqC0=;
        fh=0tSCR0C33wk3GNR8y8CzW22c7w1Q4uigJ2tdUvy2d58=;
        b=klTeoP75A8Hi+44zTUUo5QgawskKURqY11ByZ7x83pvV+56kxF87vtDAV08yL9X0xk
         vBmxvLfwYmED1ICm+6iMRwWj9zFpcuixYeO0d5GXCtKxCyPFw0qGOuWkUXAu2XmFiibU
         7qmgwkNJBwo8ev3t0v6jBz2Cyt9sV4z/iB2aF+BmZjjgXAv0aUyjO2t1qPBTE95lLYZM
         Qve2ObyBc24Z9HCGJzA4qCFQmdbvhSaRrf4o/CvO5MLUpClQC/y6haASKQOxhtxnwhv4
         I/8PS+NS70/QIbXE0Cbqmi2rs0w10dy7sbaWCu3MrVw6A2hzcmdhmxRR8W70NcMxwLaI
         4nJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795490489; x=1796095289; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oaCz9FAobFX+cqXKdeVDaXGsBDT/dh6s+LEZD6XoqC0=;
        b=ygdhWyXJ2CwF7ZVtnVsPGbwTCnWx5ht+tzkPURyfSIv2fLnVMEViXq2doQdwo9o6Lq
         eH7t66NiHQZYgp+dYLRHslcGfwdcPzaR3DkWd/okPXArmZZvfzXTLAzcnqyUhRiUZvr9
         mvqR/gG03w8CR8H502UE9jqgMs/5Gx/XvHvyPbpg3m3BuGqtZ/myYh1M9kDLmBHeUho6
         lgUSCL2/TVdEUYz39dpaWLIOomLcQs6btSQ5ZMpqXqvOBzN+L0WwnFinvD3pW5uEq+aD
         4I5IjpVfqkY/GqZkVsLmaIlm5CEmy7W8TXSAkBfQ30IUGez845V/cl1x5HcA1X4jg96Z
         wGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795490489; x=1796095289;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oaCz9FAobFX+cqXKdeVDaXGsBDT/dh6s+LEZD6XoqC0=;
        b=0HhSVygUVPNGQXlTiXvg3MWJLKVIOBPdiqauiwnj+e7PhrQDJF6g+MLztHkU85tmBJ
         6ZVr04Mbx+2AT9wb+pblCDscQazxOaBsatfAbdxEfT0lPrUPLe9IRdQz0I2C3cERMLQl
         f5Dj9AM/tM6Ynh8vGGTffTxfJbl7bzDiA/ILneL+A+MZauDKYx43fbmAkiuB3IG53pAD
         1ZUsuc/yZycG6GKGxfRMAw+FvBeSLxQcLQeEONDY9z5pMwb8B9k/uFIKdwOceR5WRNiZ
         8Row7kA0VXP3ajH1JYHOD5ds/mOfYGdMY/7xnTQDb7ts/3MtbKuElpUfrV0wwR815UTw
         KeQw==
X-Forwarded-Encrypted: i=1; AL+hErEIG1QZRU/frJtjENQJkfl3koj2SLP3fHxpg5npBsz148wYgXggJS2qeX3cqp6Tn5weQgc/wcAngWgAJ+Zg4Bk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+/3/lUqWW5qUoCp5Y3eaGXjqvreniAM4Z7eqpmWmajMMI2ewm+
	HM82DbcSjn8yZQfgp0r43kOxATlxx+28LI14rkL28OhLOLQtck8IRvSlRTurQ+9r6GYk2HDgoVR
	UrD2Aifs8/je/1xQ73C5bWFT800LnG5c=
X-Gm-Gg: AZFdTZdbstJJP6WwLJn2cNPUQNSomkICIHxPBAXbpLbPh21iNJJ+Q+qf1Bdg6pzi5ER
	Tj1ExYDd1gQumuPt66BU6FNAPQXxY1QEL7YGwdXzNJrbgtFIWqMjz15WHZfpG+YvL1bW1qjqVMq
	FHPSNdJcCd/g8PyCHTMXYP+XxoLY8tkIYsjKJXz0d2CIQjhiiz/+pcBZZ05ISWAX5hozQX3N6he
	NoIM0nhnohmzlgj6rc5tJVKUZrkZcWiB6qav76zPdkEQW3i2JMIas2aqoK5ePNJYhAwTkRMillZ
	Y9sciV6fe/zazsTGpRwYQI3XJis5ioyqxx8mqqVmtI2W/2+Q2Z/e6qnUEIMmcim3MwhHBq4OQgH
	sim2WPF1ZJFyCn9SEKGTfMIsiJUA3cb476hz/
X-Received: by 2002:a53:ac90:0:b0:67b:f57b:e83f with SMTP id
 956f58d0204a3-67df447f272mr4806179d50.84.1795490488933; Mon, 23 Nov 2026
 19:21:28 -0800 (PST)
Received: from 723974502065 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Nov 2026 19:21:28 -0800
From: Qican Ma <goonsomeway@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 23 Nov 2026 19:21:28 -0800
X-Gm-Features: Aa3M54rNlXAI5CQumPMU76HNcv4d3a5IJ4JIzap1D3akCM2UEOumxiswycw6PKQ
Message-ID: <CA+OT+OPg-vtPQxO-5dqLo=DGe9yH_k3m3sM8oyE3yKHHmTskVQ@mail.gmail.com>
Subject: [PATCH nf] netfilter: flowtable: interlock NF_FLOW_TEARDOWN with NF_FLOW_PENDING
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

nf_flow_offload_gc_step() checks NF_FLOW_PENDING once at entry before
setting NF_FLOW_TEARDOWN and potentially freeing the flow via
flow_offload_del(). Concurrently, flow_offload_add() or a datapath caller
that looked up the flow prior to teardown can call
nf_flow_offload_work_alloc(), set NF_FLOW_PENDING, and queue a
FLOW_CLS_REPLACE work item holding a raw pointer to the flow without
rechecking NF_FLOW_TEARDOWN. If the pending bit is set after the GC check,
flow_offload_del() frees the flow via RCU while the queued work item can
still dereference and clear NF_FLOW_PENDING on offload->flow.

Interlock the two flags: in nf_flow_offload_gc_step(), check
NF_FLOW_PENDING after NF_FLOW_TEARDOWN has been observed or set, paired
with a full memory barrier; in nf_flow_offload_work_alloc(), recheck
NF_FLOW_TEARDOWN after test_and_set_bit(NF_FLOW_PENDING) for
FLOW_CLS_REPLACE and bail out if set. Restrict the teardown check to
FLOW_CLS_REPLACE because GC itself queues FLOW_CLS_DESTROY and
FLOW_CLS_STATS work on flows already marked for teardown.

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested only; reproducing the race at runtime
requires a hardware-offloaded flowtable device.

Fixes: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
 net/netfilter/nf_flow_table_core.c    | 8 +++++---
 net/netfilter/nf_flow_table_offload.c | 7 +++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c
b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9d..fcd37f7a37f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -578,9 +578,6 @@ static void nf_flow_offload_gc_step(struct
nf_flowtable *flow_table,
 {
 	bool teardown;

-	if (test_bit(NF_FLOW_PENDING, &flow->flags))
-		return;
-
 	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);

 	if (nf_flow_has_expired(flow) ||
@@ -594,6 +591,11 @@ static void nf_flow_offload_gc_step(struct
nf_flowtable *flow_table,
 		nf_flow_table_extend_ct_timeout(flow->ct);
 	}

+	/* Pairs with test_and_set_bit(NF_FLOW_PENDING) in work_alloc(). */
+	smp_mb();
+	if (test_bit(NF_FLOW_PENDING, &flow->flags))
+		return;
+
 	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
diff --git a/net/netfilter/nf_flow_table_offload.c
b/net/netfilter/nf_flow_table_offload.c
index 4365859220e..402a46e1645 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1088,6 +1088,13 @@ nf_flow_offload_work_alloc(struct nf_flowtable
*flowtable,
 	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;

+	/* Pairs with smp_mb() in nf_flow_offload_gc_step(). */
+	if (cmd == FLOW_CLS_REPLACE &&
+	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
+		return NULL;
+	}
+
 	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
 	if (!offload) {
 		clear_bit(NF_FLOW_PENDING, &flow->flags);
-- 
2.50.1 (Apple Git-155)
