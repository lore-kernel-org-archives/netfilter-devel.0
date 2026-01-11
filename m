Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E3E8635D
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768149616; cv=none; b=ICJ1Q4JMAAE9l8KmV7iJKeivca9auPupqIGR6Y3kV7jSqbhXTY9mcC4xOWUGDRp7cflufT4WWhLHIJFu0HzjppL7qyA7faZz/nHW/+qjgcjitQ8YKDkZmTEBZFBmQJdKvYU7VoIvz/LRcVQUVqzjYlb5W0KoaEfym+Lbh2+s/NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768149616; c=relaxed/simple;
	bh=Dr5HQMn6/WT9nf5jbiqNs+RZHGM1XWBwBk58zgT4Gno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tZtNTs6j9Aan1PeF4amNrJtNMmteYm6UOjblrIs7TyKetm1ZNtoJd7MB4OYbRPT+slti8P7Iy0KxDaM2QWGWChnCfwA9yMRJvMw0EMuQADhklXntJsWiKkAjFdb+g2e4x1/NiNC3P1LoZ5QWl0sLRI7Hs5ucdjV8mTc/Iq9iT34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=qBj1tC+u; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="qBj1tC+u"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8bb6a27d407so554465785a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 08:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768149613; x=1768754413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2wzHDcr5BQPsKGaow7JGDJwoqgrDh0fz584Olx3ZA4=;
        b=qBj1tC+u0rRZ4B1lyOpfQMQXwEs4zDDp2aFuqWe/GWO86iNlq5fPO6NL/UEIpbXjj6
         U2vfRMe5DRBxFEDQAIjrRKA+CEkq84Qot9mv2fcitMU6ZT4wbsRtOOQfGY7xDFJYk3mF
         iMt0LCMiAJlmXKhC51gYBvxYTC+gZ11bmsN/N+n4kCniWw5g1OOTgoP7fE6teUHiMMPi
         lKmQA6A1ZuhMup/lB8pvx211JeGcIxy+ESJIHFBMLJaIBX0zVXSE+RnjRGCiXFbkK0nB
         IiwfPf9zyQh/Q776hJMSeTF4FNNKcxZ4JrOafn5/kDJ2WQuSSUYDAMuasXMNgR5KFcDS
         hqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768149613; x=1768754413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r2wzHDcr5BQPsKGaow7JGDJwoqgrDh0fz584Olx3ZA4=;
        b=J8XFA6gOEeaPjw3xv+6tAVz7BkbdmyFORdFdWLXzu5nWcaVMnSiFl7LW54Mn29OkYj
         mDp5iCrexq2+O7L8zoGY8dLiUD5FMN0w41pKLQgunHAok1lIxTHV+lD6Cvq9q/lAzg8n
         hol9MVvZQKM5qA+gJfUbfVRR06IsoBIveg1Eh1GZj+766NE5AZklimitsY+SJSYXZao8
         Xd8TaJaXkNoroEq0lsYyueUeSRghhgQMClVILVGus8aSXKUfl4LsLR0Rl07EzYTx+nzo
         DuNIs79c8MepcqwBVOGrZRpiuh8/4iHkItY5LEPMWuxVn9zeMN2Z45/7ytbz8EPivD02
         zPlg==
X-Forwarded-Encrypted: i=1; AJvYcCXa0yMehsfvEnbN5MCI0TVE8oRz04j+sSnvGrufYXpmuPg3glGD0gFHWpHgdUDtS2uPbS7qOlBc0ijFvyWfd/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYO0MUWds4wU3shTForKsCIoNUeNoeMhgc6ti4EnDdaVGIivLM
	UHHsVIJ5nudf6zB84N3AgskXEjMC9O2hvf802hoLbKGuhGRMzl+5j7eDcaU7DT28Hw==
X-Gm-Gg: AY/fxX7zdSQ5nvbq9oRsKqOyvnO4pezJ1sX5rRtcnQi7UgCY0AAt4C5D0J5mBLHCEYT
	O2gomWbksq8WV9ipNCJSmFmxn2VJhza+5QXizD4Z/bnY2UZmsEsHbOoj2zhis051WL+bUoU6TGu
	eZOuXx0aNcki98WggliQ5hH5ub6r+uxEqxhVg3tgwzsMMMbAYTLPwe7Fq2ykNWcBNx0+U8txyMo
	BS3HP1xAwtondikeNphN5UnJAr68h0wNIviQygTdT7OWSnsSAQF9I9bJ+WzpQ+ceMXR7V1tKvw7
	+rZTDzMTlYDb9gPzgbcO9bgeYiln32WJ7uVDClBbBNVTN8gkulgyX2m4Ne5FuVTxSpdgIOMlARB
	3R4SrrPPfRzmmsQNwuwL8tpKFAvvOFK0/oJWC947XLcjTS8KCgCjpuLN0ayjQmX0MFMH6QDzbel
	ublj29m4pstAs=
X-Google-Smtp-Source: AGHT+IFtW4LB1CJummYrSFhilsiCXLNUDLPFAzkNxMWGSyNK/PRwT5kYS2BE7I2qKUYIqPvbX6Q8gw==
X-Received: by 2002:a05:620a:c53:b0:8c2:9ff4:a8bd with SMTP id af79cd13be357-8c389367480mr2138178985a.15.1768149613545;
        Sun, 11 Jan 2026 08:40:13 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a8956sm1276589085a.10.2026.01.11.08.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 08:40:12 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	victor@mojatatu.com,
	dcaratti@redhat.com,
	lariel@nvidia.com,
	daniel@iogearbox.net,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	zyc199902@zohomail.cn,
	lrGerlinde@mailfence.com,
	jschung2@proton.me,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>
Subject: [PATCH net 5/6] net/sched: fix packet loop on netem when duplicate is on
Date: Sun, 11 Jan 2026 11:39:46 -0500
Message-Id: <20260111163947.811248-6-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As stated by William [1]:

"netem_enqueue's duplication prevention logic breaks when a netem
resides in a qdisc tree with other netems - this can lead to a
soft lockup and OOM loop in netem_dequeue, as seen in [2].
Ensure that a duplicating netem cannot exist in a tree with other
netems."

In this patch, we use the first approach suggested in [1] (the skb
ttl field) to detect and stop a possible netem duplicate infinite loop.

[1] https://lore.kernel.org/netdev/20250708164141.875402-1-will@willsroot.io/
[2] https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc1ilxsEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=@willsroot.io/

Fixes: 0afb51e72855 ("[PKT_SCHED]: netem: reinsert for duplication")
Reported-by: William Liu <will@willsroot.io>
Reported-by: Savino Dicanosa <savy@syst3mfailure.io>
Closes: https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc1ilxsEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=@willsroot.io/
Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/sch_netem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index a9ea40c13527..4a65fb841a98 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -461,7 +461,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	skb->prev = NULL;
 
 	/* Random duplication */
-	if (q->duplicate && q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
+	if (q->duplicate && !skb->ttl &&
+	    q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
 		++count;
 
 	/* Drop packet? */
@@ -539,11 +540,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (skb2) {
 		struct Qdisc *rootq = qdisc_root_bh(sch);
-		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
-		q->duplicate = 0;
+		skb2->ttl++; /* prevent duplicating a dup... */
 		rootq->enqueue(skb2, rootq, to_free);
-		q->duplicate = dupsave;
 		skb2 = NULL;
 	}
 
-- 
2.34.1

