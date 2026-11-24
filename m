Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506863;
	b=GjcNM155MMl+DXbAFZ7tZySVA6El2hbIQ2qkwiEfk/0UUYw1I+Etr0vj77evFNxkEuSQ
	 fwHtOG/KQiA1NFXrmcUsyIQ84ZMgHH9tRXHTHiKoUkDgneZ3stCMLjA+LMWr7Z/p1qCv3
	 dsNVXH+qjJcC9RJV+8jdMn3hTJZMEtwy6826xD5+NBnWVTWp5KeQetcAbnSxeiU/tTj5m
	 59aYuDPjxFV3dhKxmobj7g+4j/fwthJhbw6m1wkvYiTPuzQ5DYepJJtrTK4hEpoE/mBU0
	 kCnru+983fP8Sx4oHmwSKuLai/ZgsSRqPAGkeD6bnlER6mhIx+e0lHD6pwdenergYSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506863;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JCB9Arf3kgO8khRLtzH4NIGi9cnIQlT5R56mUfugRho=;
	b=RMIFDX/EGn+TqZ6zKbf3BqZ6hnXV9s3TsKvhnM+JBosThTQYXsuQWFiMd1aVb6/EqkDc
	 svD5EdSC8A75/+6RtZ64B7DOwh0LZRSlV1/phbmQqxNossRuaJ968mKrRcALFIUIEIn/7
	 5RAgB21Jd3+3eD1swxn+E/uFjkoj8hHbYs5DU0wSGv/5PLM+FbKU2sMzQSR5B2fDbMYX/
	 XOAHMYcXJ7riI1WwXo+U4F65tckJRWISgNOY6oWLU5eTW06Eel3TDVahO3SWHziFfU/MK
	 bKFzkrlvQDsMlbjNlU2FXJIaQ6ojWisIXY/k46jXYkorlHQ1QXsESvC3ozeXLcFGUmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n7Wg1sYr;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ECA606A321
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 07:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80ECA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n7Wg1sYr
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so2364980a91.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 23:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795506862; x=1796111662; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JCB9Arf3kgO8khRLtzH4NIGi9cnIQlT5R56mUfugRho=;
        b=n7Wg1sYrAk0a+473VNn49vRqoJ4yJnv9wgIVrWuQMgzK6niyYbZdxW+QLp5pKQR1Fj
         XOlZX3oBot2wBqFvEb7po8LKq8tNshgHXt6viLdhOs9f6qmBRAdUmc8c5nIxb+mrss1r
         Q5NBVlOrMMJ7LJ6KTTy6x61avuRmi5q07WFLZbEmpCGOzo8ZT2aza6NQDTytLHtGXBgc
         cPNBhiCOAOsPXUL0jK5933CqJ+mRa+FJbKBIHZ+aN+Qlndo8RIkuUKFEMED55A46P3dy
         2W2IG+Jkqb6e6DHTrWrSvf9VPptDFlu6wjRTuLF3/M0FgXY6cYV8SVSJrLBQjZ4wDQKd
         SPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506862; x=1796111662;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JCB9Arf3kgO8khRLtzH4NIGi9cnIQlT5R56mUfugRho=;
        b=ChNRY0UykK5IDTEM88Gkm6XFoMSgiZrvc0fKCVL0t0DhFISSk5DIIWi69VI45h6HPX
         niwruQjqFQtnX4CYkWThuaJAIEy8E3EcEzYrt7NUAXScAVT5RkZ/52UjF2TDUGeqgQpF
         JMcpyTZNjatF9gWOKIyjTUeAF96BuM7uHnz8MT1EdRfVzkeWyf7SFkTYUitzZWp4OteD
         H4sl6zW6Fn13Onjvj36whNeD5do4ZnZsWsH6o7Z+H3eBpHXhG59czcZ0spfwj0XImplE
         73F7+uWWv8U34pPhVvunDUpSS9Wtj0lqgCcigKZCw9cWPx0H6OLHkpI4/dp4TB/wa1Nw
         bB4g==
X-Forwarded-Encrypted: i=1; AL+hErEui8+4b3i9Z09/XxITcZEG5bWkmzp0CiYlu/+8FXq14dEzc4AH6ynbTXsvrW/1/ST1Pd2ACBGYs+uE3IXDRAs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+GqoNoloWcImry9XJJNAwl1Kse/b9pD0MAmw4ElQl4yt5biY4C
	zq46YvZpKBKw1IfhcryLmvjuD1v0zT82mJD5M6CH2bMgEgWornqKWlmXY7/kHeh5IT6nVkQQ
X-Gm-Gg: AZFdTZd5/YVK7ZSX1VysL65lXiE0Hkic0ZXld16zDzJhqR0pby1unQWfK2i4ctN/tIj
	yC4SDsLNG6iKoaHgQfUWM07PFyRRfNpptpGnTr9wAdjmEFSFoQFKIW46AJoUfv6FAnaU0/x1FY2
	lU52Wpt29Mg1l4UylI7LgwP3LkzAUmvZUZ/M8eVVCCNqt1rOHWELn31hlZoTSH/d1Y+c2m5ODFM
	OmXvz3eZcg8+u0ghUpduAliZrmF9i8ARIwTNHLMSKVLJb3IemY+8RS7VT95r3TZtwfd/6LR8aSt
	LWzl4ovpUwp2YRqEkXA/QinRVyhC3AdSE4aJi40zfONjqovxBSh/vcec/vwsS14MmBtg6oUayqX
	ItZ/JqXgi+J5nX7q7nGP4UN2kCzIOKuDCvpkdO9AULtmKzEgTEOq1wI/Nk6lHRPG34J3KmxBNGs
	lrFFbukSwycst/lqm5mlmg/weqxygZy0fpOFXqYg8hJ9rpAtGw47B7qVa5TXTFEogYOr2uwbHTD
	gk8yVpAsY0eMRN69phFXAur4v3ZhrWdctPh7n5N+43vmR+T3OoMdytwr1IDtnbO8yZjluRhQi2x
	BpViNJ7t/yfT3iwohFNrO39lFilg4dZvaCxybFtT9xnlJC8Rerse/si9xLlrpihjmxhgY5th/TF
	KlK/GQkm8OgPalg6PhxW6Nd3qXN6/1rAwMNRA
X-Received: by 2002:a17:90b:4ec5:b0:3ac:b2e6:3181 with SMTP id 98e67ed59e1d1-3b41c9476d3mr13476909a91.37.1795506861691;
        Mon, 23 Nov 2026 23:54:21 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b828ab9sm7681673a91.2.2026.11.23.23.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:54:21 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH nf v2] netfilter: flowtable: interlock NF_FLOW_TEARDOWN with NF_FLOW_PENDING
Date: Tue, 24 Nov 2026 15:54:16 +0800
Message-ID: <179550685613.38700.16148920957970479663@gmail.com>
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

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested only; reproducing the race at runtime
requires a hardware-offloaded flowtable device.

Fixes: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
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

