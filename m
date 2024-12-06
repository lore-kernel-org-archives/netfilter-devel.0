Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38421FC10D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 11:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733485124; cv=none; b=L3qRwY7u+F6fO4Mnvr35EpOVaaIx6HIkxT/nmdpmU/hloho336jCglWZSpJPJm1hX+5GQZznvOS/9g0dZKJmBmdReCPnwUTZl5rLvyhqFkA0gXPCDIkdNr0FyoWFQ0ELslAj83WQFewIdL7MPD5CeD/8WVlfHGowfHV8Ee9zvm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733485124; c=relaxed/simple;
	bh=tVWPt1LONmgtVGv7W0xZ9E6sVw7YqL3Zqfx+lewg0fw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XwpHIj87ylFKRVKRqhJbtpq4d8f3h01uE7MnjQC6JO8kYXDtemnp4ImFV99fYda9AjTFr/y96Kf/ac+qKncWHKimoN/a6wQ56wOk7g7wLvygIu04kGKUp0joSi6jvtUpSzq3zGapE0NqIUVJVdnK/DfGr8TVyiuPf9WY/+dgebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H6p90jAL; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H6p90jAL"
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-466acb9f16dso32361661cf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Dec 2024 03:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733485122; x=1734089922; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QQYAJ7nyfL67ze3V69eEUihNUinS17P41S38XPTUTBE=;
        b=H6p90jALBPKVenGrtSWXKqo73U+1qbuIqL7f5RvXi/VuFzCbFsJKHfigx36x/IyUY0
         IneGT57KsBNFEFDwbfPZoSoZT7wRBoXXFiDYcNHBsSTcewQh15WV4aBnNLr+2uAy1xQt
         LBcR/fgopWGS7z1t89Z+Sd4sLYnDvVJu3uMun8plS4lRQMtIcg2fxgn3P8CrrfrQPe9B
         RwXMnudDKNJ0ahJ+Yt4XR3R2b9OY3xeX2wAAlFt7gmdk3I9VXFEtlTg9i28ryqGzPqm3
         ujjV1RMW9KRPegLryvQkDE5X9TudiTmz8C1InxmbGfkUmWjZ5GXAgJvEH1Kjfj/TwGnk
         xUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733485122; x=1734089922;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QQYAJ7nyfL67ze3V69eEUihNUinS17P41S38XPTUTBE=;
        b=bpmXU6ALOR0muq9MEQ/rKP7cujbFgb4udqQtJSQq2Kh7QljraHUxeqb9vt9OcIAtuB
         9FRRsGfqv00PQ1RBJT5y1KBreWDzglIMbDg5ta6BYV4hIwrPu3gLSP6BieYUcfiV8OOq
         IFOixn3UeYSzcjd9za+GTruEIZu8TRLrhhPE4X5m03faaxgMmZfr6ExHEV+W8Vp4j7ig
         QNCUfQYSpCibPu1e+EBFmFmyHLPWrxdjSVOEs41VrOV6Cat1/SgUBTfkdCl2pbIkWsoF
         O7FiVIbp6690D5DCTdrLvfEmFFuIkxhzltwNOn5Qrpf2tJUWktd44pxdLPhV48575/CJ
         rV1A==
X-Forwarded-Encrypted: i=1; AJvYcCV6ByVicYqlMQLwAx2vgtSkc1+9Cp/8lvGkyFaCyk46Xpj35aCXz3yLNkan8qEdxKdNEJy5nJFRfCn6xlLltdI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp5zYGE5cUMV6zTQH7v5eKSKeo7whEnpjZ1G/QiVZ6WBjJxWJT
	xaWt11peIpQUH43L2Aplx+oOhcKyux8j55g5sKTGNzLpA2uI1rBP4zwFqIwk5NV4YCUgtcdeJIB
	37x7IHrjOdw==
X-Google-Smtp-Source: AGHT+IHkIxtz6Mb4vE3Yzz8m/FhBcsWXGbs+YLaJEA/7H5XkuYcl6TlSjValMUFysgYTORWgUD+SzNWmwjq68A==
X-Received: from qtbge7.prod.google.com ([2002:a05:622a:5c87:b0:466:9ac4:5a8d])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:ac8:58c4:0:b0:461:9d9:15c2 with SMTP id d75a77b69052e-46734c94c38mr47967041cf.1.1733485121968;
 Fri, 06 Dec 2024 03:38:41 -0800 (PST)
Date: Fri,  6 Dec 2024 11:38:39 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241206113839.3421469-1-edumazet@google.com>
Subject: [PATCH nf-next] netfilter: xt_hashlimit: htable_selective_cleanup() optimization
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

I have seen syzbot reports hinting at xt_hashlimit abuse:

[  105.783066][ T4331] xt_hashlimit: max too large, truncated to 1048576
[  105.811405][ T4331] xt_hashlimit: size too large, truncated to 1048576

And worker threads using up to 1 second per htable_selective_cleanup() invocation.

[  269.734496][    C1]  [<ffffffff81547180>] ? __local_bh_enable_ip+0x1a0/0x1a0
[  269.734513][    C1]  [<ffffffff817d75d0>] ? lockdep_hardirqs_on_prepare+0x740/0x740
[  269.734533][    C1]  [<ffffffff852e71ff>] ? htable_selective_cleanup+0x25f/0x310
[  269.734549][    C1]  [<ffffffff817dcd30>] ? __lock_acquire+0x2060/0x2060
[  269.734567][    C1]  [<ffffffff817f058a>] ? do_raw_spin_lock+0x14a/0x370
[  269.734583][    C1]  [<ffffffff852e71ff>] ? htable_selective_cleanup+0x25f/0x310
[  269.734599][    C1]  [<ffffffff81547147>] __local_bh_enable_ip+0x167/0x1a0
[  269.734616][    C1]  [<ffffffff81546fe0>] ? _local_bh_enable+0xa0/0xa0
[  269.734634][    C1]  [<ffffffff852e71ff>] ? htable_selective_cleanup+0x25f/0x310
[  269.734651][    C1]  [<ffffffff852e71ff>] htable_selective_cleanup+0x25f/0x310
[  269.734670][    C1]  [<ffffffff815b3cc9>] ? process_one_work+0x7a9/0x1170
[  269.734685][    C1]  [<ffffffff852e57db>] htable_gc+0x1b/0xa0
[  269.734700][    C1]  [<ffffffff815b3cc9>] ? process_one_work+0x7a9/0x1170
[  269.734714][    C1]  [<ffffffff815b3dc9>] process_one_work+0x8a9/0x1170
[  269.734733][    C1]  [<ffffffff815b3520>] ? worker_detach_from_pool+0x260/0x260
[  269.734749][    C1]  [<ffffffff810201c7>] ? _raw_spin_lock_irq+0xb7/0xf0
[  269.734763][    C1]  [<ffffffff81020110>] ? _raw_spin_lock_irqsave+0x100/0x100
[  269.734777][    C1]  [<ffffffff8159d3df>] ? wq_worker_sleeping+0x5f/0x270
[  269.734800][    C1]  [<ffffffff815b53c7>] worker_thread+0xa47/0x1200
[  269.734815][    C1]  [<ffffffff81020010>] ? _raw_spin_lock+0x40/0x40
[  269.734835][    C1]  [<ffffffff815c9f2a>] kthread+0x25a/0x2e0
[  269.734853][    C1]  [<ffffffff815b4980>] ? worker_clr_flags+0x190/0x190
[  269.734866][    C1]  [<ffffffff815c9cd0>] ? kthread_blkcg+0xd0/0xd0
[  269.734885][    C1]  [<ffffffff81027b1a>] ret_from_fork+0x3a/0x50

We can skip over empty buckets, avoiding the lockdep penalty
for debug kernels, and avoid atomic operations on non debug ones.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/xt_hashlimit.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 0859b8f767645c7562f1688850e73a199e5608aa..fa02aab567245e6df886ed6626cb556ba0f1e533 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -363,11 +363,15 @@ static void htable_selective_cleanup(struct xt_hashlimit_htable *ht, bool select
 	unsigned int i;
 
 	for (i = 0; i < ht->cfg.size; i++) {
+		struct hlist_head *head = &ht->hash[i];
 		struct dsthash_ent *dh;
 		struct hlist_node *n;
 
+		if (hlist_empty(head))
+			continue;
+
 		spin_lock_bh(&ht->lock);
-		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
+		hlist_for_each_entry_safe(dh, n, head, node) {
 			if (time_after_eq(jiffies, dh->expires) || select_all)
 				dsthash_free(ht, dh);
 		}
-- 
2.47.0.338.g60cca15819-goog

