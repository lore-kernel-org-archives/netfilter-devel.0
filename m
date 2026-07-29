Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC0F4949E9
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785333441; cv=none; b=WDc6ufUPgcSJ4bx5JxAjdL0xjEa02s6n3OzTME4Ude0hvSWN8jpQhlIhZkKhpvIFezT2APUeK5PXliL2SgLI2JwuNb7/4Z9zHzCynxN1pmJehqOX4x9H0RBHcE6IhA5FftaUAJvJzTStqhkqMJmjfWc0vjjLO1Mr1JWgIfm+sx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785333441; c=relaxed/simple;
	bh=xtv6sDi7m6aeBrIE+wYVnUSxWvDrMu4sjvSBvi8vnO8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rfyu7c3XUNjYeGB/+NV0wtyIi8jfFgOoIs583HXJU6GRrUMFnQEfHgONrvSpoDrLIjk1ZHVWLiRlSNJO95/1jtg/4nynuEj+lH/c713w7mWqNYKs2YSASyTihiGRS7YwBvADHRJnDbvghalywNNa5u/9Aah6jqv5wwRALQgjGQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=A+UaiZyV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="A+UaiZyV"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso9555395ad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 06:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785333430; x=1785938230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e9m87LSvmyMwoUxnztNDZ0Cv0nd1knfLpg/zZDbXJaQ=;
        b=A+UaiZyVAYlQyz/wZNpouRprSioiTJhFV4KfGYKtLIByE3iWhsLJTs8g96OpfvZzUQ
         YiDJ9mhg7iqmltSc35pnEIUv7gu5onv9yUIorBtlb7I6ga4oWdV3lBitYSougFR/Db7n
         /GcE2a+DA2lZb2TtI+tXZhK917mWYxjWQ9Q8O1KZnkg+LUuZdyLHLV1slxC/ApCdzjlN
         NbDgjj3g7Oko83V5a+tzUNqRZxQUUcl9PZfuykzZAIBNq4AZ7GmCkGposEZNpjUU8aRn
         UqjYT/R2kjfKU+I6RrkhWbZmKAzOIk1o/O0GEiMviqRVOpM0tISYJNL9qFWjpQ7JBkRA
         /xOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785333430; x=1785938230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e9m87LSvmyMwoUxnztNDZ0Cv0nd1knfLpg/zZDbXJaQ=;
        b=A3+YQTp2Rjftavb/qgALqw3zRxyT2JJ22ZIOFiMY2TvM3HGht8C9OhU8ptgBRxNvtY
         ITLFSKf6YeAyC71mxbagwGAaRe+UyFZIWxDTsVExJum2BTw4rH4/egpkqxjYQAVZuc7O
         UnEvkj4X2muTeNQMfLg5W++0jrlwnvR4p9Ikhl1q06bJzwJRE5IztLJ/L180P1AA+w38
         hFXWyqWMZnNPX82xCFQ2qF3XXbECKeazgk9/GuVkGS5whcXJZxIvOyL8NxMGNnhYgdpB
         1Y+xXroQ0ugyX87yqF0UgzStTsEjt9k7lT0GBlQEv280yOD3/9EnJL7kml+YCetD0k68
         gN5Q==
X-Forwarded-Encrypted: i=1; AHgh+RrR6Ilql7Fqpw71QJIyi4gjrB2S1M4fe50fZZXFiFVdh7KMFjonzC2CJ/avy7dIChNCIp2vIxxHWGYnGka0WKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1kmGqihtrjCbTwxcfJyTgjkC66iMvUu+FoBa9mjKrC0HeVLwH
	s6Q5f/N9773CGsy2WdOZbVYs4SYiUKeBd3H1hvxgNawN7kPNPrgdcI4tvt8a89XLE/HnuYRmUsE
	ypDafAX2/onI=
X-Gm-Gg: AR+sD11uGlPLnvxt4JyHbuunqmkoGy6k0xwINW4udHkEeeBK217prTy6GBEeRsOh2+s
	YOpRG1zrmDm6lDZ7S4XWJ3ctt6c9aw47Q/6ox6fS7cewEsHPCwot9DdHmhYgVzscHWJ4BYQus0z
	wz1p+LNk1FIDfZass1nL/om2yeWBilllBhGn/PhSU8oefDkeIsOjkcsK5Ci84oISXpZBw/KvluT
	FmThBxsT5Vq+OW9OxNUgaIbuNKWsjd861Mqmq7kStZFsbaRLMdJWonhUpvbPSqCBkP7Lq0h5Aei
	FhBEMw6f6PRH7l7hryh52FI9i7eXdftDkv96Zd4ugyrCpGxPBAzxlCNWJobEX051yHjfpUoIreB
	Hwzfkyawugg7PLnBWUetMWNdN8is2yplfyXaGVcFDs0uEAIlD+DR+/IpCFX08r4d7wtYQ0z9l9T
	DZ/39ZyqHKXenPp6J9G8Nn4rmDETcvIm0JZx+wAYxi2ucNw0n1pyUdMi63ceyEthSSwl258aV2A
	COt
X-Received: by 2002:a17:902:ce0b:b0:2ca:6d2a:871 with SMTP id d9443c01a7336-2d015d511fdmr79672115ad.37.1785333430367;
        Wed, 29 Jul 2026 06:57:10 -0700 (PDT)
Received: from Roxy.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bc5afasm11837285ad.46.2026.07.29.06.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 06:57:09 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	ja@ssi.bg
Cc: horms@verge.net.au,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	jwiesner@suse.de,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf v3 1/1] ipvs: stop estimator after disabled calc phase
Date: Wed, 29 Jul 2026 21:56:59 +0800
Message-ID: <154d1474f8c36c34d9b86c7ca1b33d73f5435241.1785289432.git.zhilinz@nebusec.ai>
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

Estimator kthreads can now self-exit before teardown or reload stops
kd->task. Keep an extra task reference after creation and release it
with kthread_stop_put(), so kd->task remains valid until the stop paths
consume that reference.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v3:
- Keep an extra task_struct reference for estimator kthreads and
  release it with kthread_stop_put(), as suggested by Julian
  Anastasov, so self-exiting kthreads do not leave kd->task dangling.
- v2 Link: https://lore.kernel.org/all/03a7ee4873f9dfc51add97df5b67bf0b0d793dbe.1785211268.git.zhilinz@nebusec.ai

changes in v2:
- Exit the estimator kthread after the calculation phase if IPVS
  has been disabled or the kthread is stopping, as suggested by
  Julian Anastasov.
- Drop the later enqueue and drain guards from v1.
- v1 Link: https://lore.kernel.org/all/6359e0031f0ee7cc969bae3483308de362d3c709.1784878022.git.zhilinz@nebusec.ai

 net/netfilter/ipvs/ip_vs_est.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index ab09f51829512..05a216a47b45e 100644
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
@@ -270,6 +273,7 @@ int ip_vs_est_kthread_start(struct netns_ipvs *ipvs,
 		kd->task = NULL;
 		goto out;
 	}
+	get_task_struct(kd->task);
 
 	set_user_nice(kd->task, sysctl_est_nice(ipvs));
 	if (sysctl_est_preferred_cpulist(ipvs))
@@ -286,7 +290,7 @@ void ip_vs_est_kthread_stop(struct ip_vs_est_kt_data *kd)
 {
 	if (kd->task) {
 		pr_info("stopping estimator thread %d...\n", kd->id);
-		kthread_stop(kd->task);
+		kthread_stop_put(kd->task);
 		kd->task = NULL;
 	}
 }
@@ -526,7 +530,7 @@ static void ip_vs_est_kthread_destroy(struct ip_vs_est_kt_data *kd)
 	if (kd) {
 		if (kd->task) {
 			pr_info("stop unused estimator thread %d...\n", kd->id);
-			kthread_stop(kd->task);
+			kthread_stop_put(kd->task);
 		}
 		ip_vs_stats_free(kd->calc_stats);
 		kfree(kd);
-- 
2.43.0

