Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4443A2551
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 04:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212502; cv=none; b=AAojCG9ra6w6EP2GRCrqWKaIf/7sMfAwZ9k5vjSNNGDGDiKZBfFXQmpOATOFkr7XuDmA9q0JNmaMPIUomQv8jaxMAAwWidDbbMm8zK936fW3J+Z7jVCoIZ1jXGCVkY6ZxH5A/PW8LEBvd1IV5/1GiDSgNc/k6CdmzvuSQkjIZS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212502; c=relaxed/simple;
	bh=z9YDVT9dO7eY3oONRZrnB8Un+kTHwUZmgKWSt69DsFU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WnjtBuWdKyUg54m2j8+rwwpWEX//En/ei1cfXKpAnp+sZSQwCAkELCIrgChRsDF7wxJcoolCRGxHjTTFfRU236YHyaVdEynXpv41LdFRXyGox9UC8cTKW1rdaNJu9D4XkvgbnfQxv2AFL+nHKy6SPtJUo/f5ZwIEf79pDDfVbJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=XgHKgA97; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="XgHKgA97"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f256eaedf8so35623996d6.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 21:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785212500; x=1785817300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wIfReckQIvU7mcolyJLQK/Nsuz3ePy+9i+ZRkaCU5Kc=;
        b=XgHKgA97fDN3gSBgJZa41SvzwmhSb3izPkMpnopAJI474//YQz0Gv9uTw0J6qxoCdC
         iC1Wb+4BdSH8PKh/dH3Uaj31Q5TW8QE29JL8PFr6fRk+XsrnvA5zKcQeoOjCjkzyQ+Yt
         fixb0bHy5NyFmAFQs17slmV7F4U1X0JGgMAQ8qVToCUPYnlNd87Z69v8W3rnk1SUigoy
         q3KzQmEt3Jgrnv6Le7YezTzDLjxmPbKKUrzEqmkgrFQXZNTU4bn3QBQmB6xmIpAJFpyc
         2T1PvCm5jbzbxPGdllMUL4jPvNTFiUh1tqLk0nCkNfroYWCP+iOYvdlzTqQ5cdIMYqw4
         IgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785212500; x=1785817300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wIfReckQIvU7mcolyJLQK/Nsuz3ePy+9i+ZRkaCU5Kc=;
        b=Vg+IgS++tgS5ul3U8fGl12mcQx+Jr0YpImUAq3J93XXxFhN8GWFaEWxhtnmygDR6A7
         f6ELEhGZmmfai8AvFGdpBlYbFQaQPVr+boiRvvSlCxNV//sV49JrWvRxGPbaE3X/hGmQ
         JBeCx/otGuStmecP8+pPmjQ5SNLpiy2XRQ5uqP3HGKaH8qFMeiZWLGbxzgzohjYKk14x
         /dVhxSWXwZcGaz39UDWPsbIfl+z75hWIa/hCMe9906DcezFMksm2/PtMxIuRvqINJUue
         aoDsv46eldoA2zI4hHjgYZnjNsFZt8V3M1XBlEGQ2/RgSFwOXKwPYMB3YE2DagNBd+2H
         fU5A==
X-Forwarded-Encrypted: i=1; AHgh+RpvsS6yQzaM4qBAhkvVJoWr5+TgRw2LnpwYDMhvQrkue6TCGMVQ6jxe0QMPhucbr7kgH7FRGk1F2r4YRXGLaCc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym7evgfsIMOQHi0XSaDBFfp293HLQVmJ/s8Wagyy89qVEu4Foe
	Wj9fu8Fknpnr1YsioDgbH87auHGYnL1p0WOochJ+C0OcPCiJRqeAV/wM6bbbUgAz8/fZOw3lT8y
	KoYg2obEqSgQ=
X-Gm-Gg: AR+sD10Vxrog3UbUJ4a0OqSl4naAHuu6QcSBVZlUKPdXDhLf8KD4ntjQoQ3kJpf9XxZ
	ZwjUbHmssuqBsu0ErQxVFD89qYNNrWP0MwdMAEYTteTbNidRXQzZAVJrxScgu1Lf3ifAMt3aLd5
	BrR+dJ8wMwsnVoIUILQIRf3FzmQM6j2PPqFbQ1nbn9dLJP1iExHHCOaNayj6LH4wRvYQls8Jpk7
	dZ5o1jJMOIYE6y+BuwmZGOY6NiKDZsfbNsJwDcZQetGiRoKb2OZazPD/cyVE0RGdz2haZ3eXI9i
	trt/sJYetYc5Wm4qfNPS3a8UX3mRaMrlMBvx1+tghkGiJ9TDtih9rGE4F8f+pFtktSyfXjrplK/
	HYW7T17DbowqQ9hueo09ZxedT2Y32L1WJy0nmIqacyT/6iakSe2ekx/ahxugsApwjuaVZfcHMeM
	grNQdYlHJiyKVlEwyFFg==
X-Received: by 2002:ad4:5e8b:0:b0:8fd:6e32:2bff with SMTP id 6a1803df08f44-908173a13fcmr7841726d6.64.1785212499622;
        Mon, 27 Jul 2026 21:21:39 -0700 (PDT)
Received: from Roxy.localdomain ([203.175.14.58])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e86d499dsm79520786d6.42.2026.07.27.21.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 21:21:39 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: ja@ssi.bg,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: horms@verge.net.au,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jwiesner@suse.de,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf v2 1/1] ipvs: stop estimator after disabled calc phase
Date: Tue, 28 Jul 2026 12:21:28 +0800
Message-ID: <03a7ee4873f9dfc51add97df5b67bf0b0d793dbe.1785211268.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IPVS estimator kthread 0 starts with zeroed chain and tick limits until
its initial calculation phase completes. If network namespace teardown
clears ipvs->enable during that phase, ip_vs_est_calc_phase() can return
without installing positive limits.

The kthread can then continue into its main loop and drain
est_temp_list with zero chain_max, tick_max and est_max_count values.
Each enqueue consumes one available tick row, but est_count never
reaches the zero est_max_count value. After all rows are consumed, the
row lookup returns IPVS_EST_NTICKS and ip_vs_enqueue_estimator() writes
past the ticks and tick_len arrays.

Exit kthread 0 after the calculation phase if the kthread is stopping or
IPVS has been disabled. That keeps temporary estimators from being
drained after the limits failed to initialize.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v2:
- Exit the estimator kthread after the calculation phase if IPVS
  has been disabled or the kthread is stopping, as suggested by
  Julian Anastasov.
- Drop the later enqueue and drain guards from v1.
- v1 Link: https://lore.kernel.org/all/6359e0031f0ee7cc969bae3483308de362d3c709.1784878022.git.zhilinz@nebusec.ai

 net/netfilter/ipvs/ip_vs_est.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index ab09f51829512..86d20f19fe317 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -191,8 +191,11 @@ static int ip_vs_estimation_kthread(void *data)
 		}
 
 		/* kthread 0 will handle the calc phase */
-		if (ipvs->est_calc_phase)
+		if (ipvs->est_calc_phase) {
 			ip_vs_est_calc_phase(ipvs);
+			if (kthread_should_stop() || !READ_ONCE(ipvs->enable))
+				return 0;
+		}
 	}
 
 	while (1) {
-- 
2.43.0

