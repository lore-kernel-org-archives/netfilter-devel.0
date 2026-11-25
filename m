Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591484;
	b=MOHv4bXiDnLMTxSnBvA7H0eIDvI0wm0eMLonKe4/WGfxCK5yPAGQGakQsR8CJPKwXdh/
	 e0fR6PPyk9e2r3PpkaDrfNPLVaCRK5TBqd9trb05e4M/wb2kCBNnSogXvtA5Vp46yNPIK
	 47qD0QG05OSR4qKmZnleCg8496UP0G/JhrkRAyMVmqyNz+CDNa1Sp49+jedvCZggSkcEz
	 v5Uaj9McNBqWfvsf3UQgjlZ7KlhgAvoyom/F2Qus2R3Nn7DtDgobJC25GqNWG6+eX9Bgr
	 e4dLIDgyIWved0gEDLBF+esmeifM5HKmOeHvSmkl/6C7QRpwhWkhHJpkgIV21+JjFLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591484;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=3RvJ7jvZeAedFK81T5hXt5zG8ttm1un36O2UVXfViZM=;
	b=LorFwLrcPZIvQYPZjNO0cQXcBq38Nhlcls6y82kxBQaaEobuEwLoOnnxueVWMYYDGlzj
	 LkvhSfT69gG7xrfWrPDXjcbVeqU0AQKeIw/UwTyEkVJEHdUD2WDNAwGljuA7h878gs/2D
	 FgUZ2afPek3q0olAglOmv5GxUyjCDndJsEMmBN1txDzSTzvQUuEJhX4wkTfZg2Mr5ybp9
	 0EYPzNzlg5AtCUUq8S1R4FGDbjYev9mU5hcLvPtSneMvofyH8djETY9kTc+50Dgebp4f3
	 rEAEcXaqhDocixJklD3hvmn/gj/VAjFuuoaKgSGkk35PSdrLN/nrBdJmX06/qOT4Fjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RhS3WEkx;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F07606A321
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 07:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46F07606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RhS3WEkx
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f01f296937so41839905ad.3
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 23:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795591483; x=1796196283; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3RvJ7jvZeAedFK81T5hXt5zG8ttm1un36O2UVXfViZM=;
        b=RhS3WEkxMbYkcos86zbxOOxcOiVgOieDqIOuzEZA9EaPEQR4bUE3VSWA1P2zv+CMBr
         qs6Ed7nnma9czP5ITNyU+tEKsnBSDhu5WIrbaAqgYKwdgsOXPoCr7d7vQ6awLMDwe77O
         9bwSvSgz7+Bu2EaWmJ/oXwHf+QOzgwLYUNB3Drarqf+voavWszOwhofY9MUJpODDy2W6
         J5cl63JeSdGLYAnJSPKk7GX/sZAdrau/kNeaJVu2ElvzftkzlwmeNXnrE9BJl4AYejzI
         XdBd0YUasixnoQisLMsiuMGnhGnmwIFsi+Tf2/KS+91SbI1FjQ0FRCP2X6n+pxSBlIJw
         Eb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795591483; x=1796196283;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3RvJ7jvZeAedFK81T5hXt5zG8ttm1un36O2UVXfViZM=;
        b=fv5TutnmUDq3C9zNStC44pX5Gc/k+du87whiAQbZj957Xh8rlL+iQBI0I+xqdP5aNJ
         q47ub6G7GGlVXa/i9h44aAjOv+2tTk170CI+Z9r1RxTU8KH/lqIlF53MYXeKqkwUkwdN
         beCjaXc7wSda2TcW1glce770ucx6mNHX1qbA/E/ftz0gV+Gue+iHdCVFl/VnqxiwMpHF
         zJ/8nVMQQxKOmInG6ftd3hdW2G3TflR386MSKLUYR4bkDO2uPvAua1yN2IYlaIBKb3g7
         8Kc4ybATXT4O4zRPvM+sZJYzFphJT4gavzCZcstYRe+2B0Wy1jt3wqBxqHEmO7nWXFto
         H86Q==
X-Forwarded-Encrypted: i=1; AL+hErGtX4HmAuXtXenk/Nwjc/aTDVwOdnwQsT1GLLpWn7KcZmw+R65e+jXbUgYrQBVgbMCDD8h91/9n4p6HJGIv4zc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+kHQL1JiHkWA71drjo78EQoWPQi7QGMUQaLATAVt0JaTVwxgyR
	dgOly2x2FZJNNPBOMnYg2VugV0lcXrFe6rsiqk2g2gZYBdNR+6ah1w5p
X-Gm-Gg: AZFdTZfD3xR5m0d1utyeNQ9p1xC+hD++ws0SYObs30Fvo9tzlGfxE7nBDeqXYwTVg4V
	9zY2gF45CKxb6lGlSpItdVl4Kwwh2EPi6qHFoVhvXGhD1Z78+mkgIDI2S9mVFYrfDgX8KEJ0qLm
	xVhiHFfm18fD/68TYWQtvFRixDD6T/34wp1ZROe9+jxPk+EiLsNor4DmbUjqvUoLxReuDCWkDl2
	Pxy4wvK5RmGbt++4f9Jd0/x3kVw6Vr+8MnNqqHc6TOxGR3ltZ/Te+2iIrQ2MVJIdA0CpAgbH+Zk
	CTgiS2ZUd1G8YA9KykOibbOD+nV8wgKSUBgCeg/dWpNdzjiL4KTpP0FsKn3N4YXmyoBGFmJUXRA
	vGXufT4Onne2FsXXmmtMfEQuzJ1fYnE4zophvJsamrzvNXLuxcxyzCoKnOvAPo8y5vXzuxMSutP
	AYS41mns4jkPTN8AxgjoKNac2jXeIY25L3836+eSf3DAXts/L8jbX5ggbOPO5IUpoPrs/7OB0uq
	hRs0kv1FuLhnyd1kWz0Z4MIBBCMgv3/d418Pmme4bx+X65YRApeKGHJbVh0atFZ4Km9tOkrYkw0
	9I6LeuQ6eiteltULuPY9Dvz9LU2YBJsTtFhcA+m9YQDYtruIpPLvOyFwfRWMHfPID4M6WOkvDXZ
	M/qvxg4wUiFHFMdkerGuWBSJQ0Jebfg0B7/b0Ph+SyaIdqjpOXEnllFRr4Xo=
X-Received: by 2002:a17:902:e74f:b0:2f0:b586:1945 with SMTP id d9443c01a7336-2f0b5861a66mr66612785ad.22.1795591482900;
        Tue, 24 Nov 2026 23:24:42 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f0667679d8sm62418155ad.48.2026.11.24.23.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 23:24:42 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH nf v3] netfilter: flowtable: interlock NF_FLOW_TEARDOWN with NF_FLOW_PENDING
Date: Wed, 25 Nov 2026 15:24:37 +0800
Message-ID: <179559147736.38007.14255585896242834600@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

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

This complements commit 0abb54363974 ("netfilter: flowtable: do not hw
offload flows in teardown state"), which checks the teardown bit in the
nf_flow_offload_refresh() caller: checking inside
nf_flow_offload_work_alloc() covers all FLOW_CLS_REPLACE callers,
including flow_offload_add(), and the GC-side barrier closes the
remaining window where GC reads NF_FLOW_PENDING at entry before
NF_FLOW_TEARDOWN is set.

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested only; reproducing the race at runtime
requires a hardware-offloaded flowtable device.

Fixes: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
v3: rebase onto net-next with 0abb54363974 included; note how the check
    inside work_alloc() complements the refresh-side check and why the
    GC-side barrier is still needed. No code changes.
v2: resend via direct SMTP without line-wrapping corruption in the diff.

 net/netfilter/nf_flow_table_core.c    | 8 +++++---
 net/netfilter/nf_flow_table_offload.c | 7 +++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9d..fcd37f7a37f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -578,9 +578,6 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 {
 	bool teardown;
 
-	if (test_bit(NF_FLOW_PENDING, &flow->flags))
-		return;
-
 	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (nf_flow_has_expired(flow) ||
@@ -594,6 +591,11 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
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
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e..402a46e1645 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1088,6 +1088,13 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
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

