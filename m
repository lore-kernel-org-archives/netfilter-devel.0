Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604652;
	b=K+TDtPW3/R73yvK5p0L3LPGHeiLUeAy09eHd/0pYEaU6NKQQx48O2aU4s4d4EMkWL/rK
	 dCkSQd4Kp48lpHuh/RPT4Pf1f+4mpOXpscWsORhWA/SvtBGurwK7JxNRUCBx8b//bebas
	 T/s4gFXwr//YbeQJgViUvxIhBeMrDOIc+eQskI1L1hLnppcm8APEZmXjojLmizfNPmeAF
	 2zWk3ZXIpuDH5J+ELACIumdTy0F/OuOBdk2ruy17+U5fQqhAbOOY1yFLdShY0zrthZMxr
	 owxtqZxnI1yy9xnjdcXy+z65XIdyUrLRKxb9TuZBBHP5wIKpVojNq/i4FcWGqNkOgXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604652;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=RI1LTDKM6gU+kRJPf9idiLjvZjawI12ooLY1rUsEH3o=;
	b=nn+8f4p6cEy+3s4iLGs8nqSPudLmpDXg5RomjSoNYDrgdG6yVERBBd0JDQBlcEwEwGwE
	 29n0RMjdRsbQJ9eOZBgMbzDRrc7ihXri3kWZ3PWDFWdBHWiMY8W9xvTLpM4bUGEMOiw/4
	 BsnBbXViztYDaXrOaZ4nFLGFKKMKSp3ezOYzEa3rmA5iomcxOr95LVaMe0DMJLQ4Rh5G3
	 frq7sBQocFJn0PV2+TIpNy63qiMWsNj4geuT+rAVsLw7T1IPLDyrme+EfjQMXWK7y7Fah
	 JQMrD5MgGBdBfezXqKatfX7go/MIRlsT9uXsLLGniQjRmVfW94X1jd2e5wShnaN58SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LnEjP8+p;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0350606A321
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 11:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0350606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LnEjP8+p
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b413d04c93so3270209a91.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 03:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795604651; x=1796209451; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RI1LTDKM6gU+kRJPf9idiLjvZjawI12ooLY1rUsEH3o=;
        b=LnEjP8+p4UK0lWeePSgGhKWnRTKvVH9GGM5auKjqmHZVbkYUwrw1tu5WEHpvgGrOiY
         o8sIQnpgx67Z6++oGBfDABLtXV8iOA6wHSitvFpYNfQAP/4wt+/FG08ijmJVyD4SVgzF
         sRv3NidpNTNXBjC3a9fUP2aOihlLb93zu8q+LehWcCsjR0TKbabvJXYw45E+G4bXnV2o
         AozNZ85bhEkFwRys0rQ9X8Mvil/wQg4Kofg7NZd2m39DnUoWiNgZhAj8LhnyTSyJ0z72
         FgESwEn7cULNzUdN/W5WM0ZG99EIJRVEiisKJWuBvFhiE/YE/BiZKvvKLDg4xLq1VaKf
         CdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795604651; x=1796209451;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RI1LTDKM6gU+kRJPf9idiLjvZjawI12ooLY1rUsEH3o=;
        b=dhRgfzLPVK6tmmvYLGTtOrJ17aM3+fLLuH+l4mEaZCuSK21I5SBVELMW+Y6VLGuUjE
         yn+j813qbrV5z3M0HxMXBgtAFrGwG34YDkuywZv4RdxbfOmc9bk01URu48Z4o5WAe7Er
         8cLeg8oRf+fKF0ngX5iVaoxUGKeY22hIGRrxYj2J2UhwxqC1ahS4R8jNFelDbDRBBEM4
         qeAF9+0xAkyQ5aYdN7V6XPX3cAiTkC/PvAyqd4SUvbt0ObRW7XkJMBBpgulHbpfvyzHw
         u2tJOUqj8sAlqmSw/3C3XLmXOlMw+f8Bf37ckDioXPHzc6CKd0V4u7RYqSuFuPnJKd7Y
         g/ZA==
X-Forwarded-Encrypted: i=1; AL+hErHYC5X7PZ81Wg3CMMYWNR43s/yNd/56ADkGMQpMGKVCbZZT/yHVNh1BRt39gVTGvq9EwJG6lQL/v0P227NF3KU=@vger.kernel.org
X-Gm-Message-State: APuU4Z96c9tClapYvY1weHYC/vkhNPb/T6iebkjaJdIojw13Dqu0Ee5v
	ZB6T01ASHaSB1FE41f9fw2D7yH1MaMU+K8kKaM2pOE3HCb9+svD0HnHO
X-Gm-Gg: AZFdTZeWRQXTGytJqXCmQEYiR0bXhg6cfBli53J2HHNjopPXa7oauuLyHTis0KmofwF
	GbqLdZWfciZFOlsYzvE1mzlAtVBijl/BnsNuM0bjAMgUz+jZZpGPKLwAx2wKlKUecIG8DiDMjSS
	rW9NJvP8Y6c+w72G6ggZAM9ieKglrBAnV69KoZhQY16Q8F4eT7D4IPsJ8aMmRBveGiEa8biMGtJ
	6sspqKqFm8WXZFVPzPMjQTeImWnyuTSTR59dyrOStrO1ruTZicGieq4y2VErqueKvrQ1JzpVIxy
	Rw67PgartOYakWuhildhivEkNi5aPAg8AwDysEGcR8h4sGRQ9qmILFusXuSk7f+QfnNHWog8Ad2
	oEUrNa5qdyXMBArD5V0CPb5V1CdS1ufYn7472LzwDz92omytLfdZKWQGh1rksph1bAz6rDLSZF6
	+zjjgSEQXUqd0unUTIepFx0/SCw9kexaWUnfX7lXumyqhQJRDlhj0FyAReJZrmklcLWNDw3CC8o
	vEgXnZmJ5QwtGzE2M4RXKSYsjZaLoLWXeQ/tkrpVLZx1weSKHKcGo7133hG4Dn153EDk8tmGMl3
	aAteR0MLP14zx1V6XFl16YYDJsYTYpnTyN1Isr7GiGSlEGb+QIiq7xYKM6xAeJqkkMr/mCnR7Hq
	M5C5wWh+qLyUFcgBuO04ZT5AGbYiK4i5u/wTa
X-Received: by 2002:a17:90b:2e49:b0:3b4:625:3d2f with SMTP id 98e67ed59e1d1-3b41cb212bfmr15854965a91.55.1795604650485;
        Wed, 25 Nov 2026 03:04:10 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad8ef99sm28178398a91.12.2026.11.25.03.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 03:04:10 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH nf v4] netfilter: flowtable: interlock NF_FLOW_TEARDOWN with NF_FLOW_PENDING
Date: Wed, 25 Nov 2026 19:04:03 +0800
Message-ID: <179560464380.44975.9475732143161255806@gmail.com>
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

nf_flow_offload_gc_step() checks NF_FLOW_PENDING once at entry, before
the teardown decision that may set NF_FLOW_TEARDOWN and free the flow
via flow_offload_del(). A concurrent caller can set NF_FLOW_PENDING and
queue a FLOW_CLS_REPLACE work item holding a raw pointer to the flow
after the early check but before teardown is decided, so the flow is
freed via RCU while the queued work item can still dereference and
clear NF_FLOW_PENDING on offload->flow.

Move the NF_FLOW_PENDING check after the teardown decision and pair it
with a full memory barrier, so a caller that sets the pending bit after
the barrier is guaranteed to observe NF_FLOW_TEARDOWN set and bail out.
This complements commit 0abb54363974 ("netfilter: flowtable: do not hw
offload flows in teardown state"), which provides the caller-side
teardown check in nf_flow_offload_refresh().

Found with an LLM-assisted code review tool and verified by inspection.
Build-tested only; reproducing the race at runtime requires a
hardware-offloaded flowtable device.

Fixes: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
v4: drop the work_alloc()-side teardown check, which duplicates the
    caller-side check added by 0abb54363974 in net-next, per Pablo's
    review; keep only the GC-side interlock. Generated against net-next.
v3: rebase onto net-next with 0abb54363974 included; note how the check
    inside work_alloc() complements the refresh-side check and why the
    GC-side barrier is still needed. No code changes.
v2: resend via direct SMTP without line-wrapping corruption in the diff.

 net/netfilter/nf_flow_table_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d5652e45ee04..7b11c4935aa5 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -580,9 +580,6 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 {
 	bool teardown;
 
-	if (test_bit(NF_FLOW_PENDING, &flow->flags))
-		return;
-
 	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (nf_flow_has_expired(flow) ||
@@ -596,6 +593,11 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
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
-- 
2.50.1 (Apple Git-155)

