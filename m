Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AF233D4F2;
	Fri, 31 Jul 2026 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511103; cv=none; b=A8Mx6OhcxHmH6AAlWVI2FrwG4O84CkKNa2v4vh8dQjGWkl2Saj2cR5Xib5XtzlPdvq41dqcCm0DOjehvp/iyWy5o0eAzfPYxsg6VTMGbNaS7FZD8B+IoPYJaP8QburnJa+w09wgOtqtfGwBgNg9ATRHdsNQCT+frj+9vsPjFn98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511103; c=relaxed/simple;
	bh=3+plMy1reTofK3oC9+Bx4+/dwnNtmyypcIFhEpogSQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=actQRj+Qsl95UG9uM49L3i+Dxzx9qZGaY0nhfhLcif7ROu9PAu2mHLPP+5pW/4NhMB82Wc1Pq0R/Vy8yw7I3fWcuATA+dzoFyEU7wEmAF8ociyHz7/7hWcyuTo7ii09eOf84rrR3kMDRQdo1hhOdMcNOjPDVwsp76oj6bmMbSj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VipNZJqZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VipNZJqZ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8971E601A7;
	Fri, 31 Jul 2026 17:18:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511094;
	bh=weIP8KkEnf7VHM5Cwbpe3/hqJhu/A9u0NpF6fQLYTAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VipNZJqZli+NkeeF+aA8CKlKH9E/dGztcjeSR0tXASksMTG/+Ksk/7INi11qkYN/A
	 BbcNKS2g3bjO6JJC8WocQYzSKD1buOMGS29rKgXbjj0hY5bwpMG18VqPSr0R0ue/7q
	 kyA+W8KxJi3KlVUwh2ktnjHwwDmg/UpWBEP1J/EAd//YefDVchrfSzcpKY6yOD8KSn
	 EqTjVs3I5DPyfcjzevzmkmUTTNRQBh7B2F5Ij/a1+A3GX4PyP4Z9QNK3XURmm6jCoq
	 Lt5G6f5CkhMP2jmHQFy5I8GRWYzYxqlVupuU3d3DuBSB6CyDEMR4f5SgmZGIAUzVqh
	 grkRShgJscLRg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/10] ipvs: stop estimator after disabled calc phase
Date: Fri, 31 Jul 2026 17:17:57 +0200
Message-ID: <20260731151806.849724-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
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
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_est.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index ab09f5182951..05a216a47b45 100644
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
2.47.3

