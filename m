Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502C5426692;
	Fri, 24 Jul 2026 10:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890189; cv=none; b=bC4H1x674Xwjuh8e0WKSJht5Ia1bxXPfoaPga2wvaIpBsDo8B2CrTnyLKqCXF6vAHc3D/MrWW6s141WvO2Ko4CRgxjigkjZLAvjhQQW1dPuVE+7b/CxSTzA5Ha4rL3HUhb2EqGXEom/OvVp35nZ1u48yMocfw+mOCJ7BJ76PH5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890189; c=relaxed/simple;
	bh=Cfo2G+9dQCnvqhFqfQdXBpZdhqAIsgcOB2DOfFrdvSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3gS3ymrOQotDzBQqAk20V9Ftdv/5Rotk24JXgXb11eCVA0xoIf4SzPvzzwSFsI1aubCCcskpEXzyK9I040fbGf+AsKWlIvueyAIrZpJXysQyoOZYXcHW56IOZgnzz+9lXSV2QIt6TV851u7gYrvOF3bjral8WEuWmJYdSPPkVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GA4U43EJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GA4U43EJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBEAF601A0;
	Fri, 24 Jul 2026 12:49:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890183;
	bh=3HcTKP3VhekqumQLR1T6jktxVOnkQpKT9NcrdIKvcNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GA4U43EJ51zYH4uLcWiI+vVIvr1JPPyhok/Dl6yfJQfJzYUZ+LoXvMOQ2YgkcHUVr
	 TPPmxfacOlJKplzWqaaqCDaeOTKxiyRAxAdc2hcvK6RoVHoXTtmQo3oLuwdpPZj3h0
	 DZ/c6byrF/ntNMFEKpQ/RFyYg7lrBbUnbjpvZq/xcieFfZEl6a6fLgOA1YdrLoiZdd
	 MNNUUKHit8UDrbH16He/6wfH7MxOOCoch/uE+4qz8ce/7XjachhG9txKj9NkmSxtc6
	 9tNRNn+GaeCL5gBl6Iyy9WjzUflrKLl0JbOxtSEyfLiY11+vrhnwFxEnn8WR/j8q+V
	 /gBrF5Rj9dITw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 1/7] ipvs: Move defense_work and est_reload_work to system_dfl_long_wq
Date: Fri, 24 Jul 2026 12:49:26 +0200
Message-ID: <20260724104932.437729-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724104932.437729-1-pablo@netfilter.org>
References: <20260724104932.437729-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ismael Luceno <iluceno@suse.de>

Under synflood conditions binding these handlers to system_long_wq may
pin them to a saturated CPU.

We've observed improved throughtput on a DPDK/VPP application with this
change, which we attribute to the reduced context switching.

Neither handler has per-CPU data dependencies nor cache locality
requirements that would prevent this change.

Signed-off-by: Ismael Luceno <iluceno@suse.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 6 +++---
 net/netfilter/ipvs/ip_vs_est.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index bcf40b8c41cf..d7e669efab4d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -235,7 +235,7 @@ static void defense_work_handler(struct work_struct *work)
 	update_defense_level(ipvs);
 	if (atomic_read(&ipvs->dropentry))
 		ip_vs_random_dropentry(ipvs);
-	queue_delayed_work(system_long_wq, &ipvs->defense_work,
+	queue_delayed_work(system_dfl_long_wq, &ipvs->defense_work,
 			   DEFENSE_TIMER_PERIOD);
 }
 #endif
@@ -290,7 +290,7 @@ static void est_reload_work_handler(struct work_struct *work)
 	atomic_set(&ipvs->est_genid_done, genid);
 
 	if (repeat)
-		queue_delayed_work(system_long_wq, &ipvs->est_reload_work,
+		queue_delayed_work(system_dfl_long_wq, &ipvs->est_reload_work,
 				   delay);
 
 unlock:
@@ -5126,7 +5126,7 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 		goto err;
 
 	/* Schedule defense work */
-	queue_delayed_work(system_long_wq, &ipvs->defense_work,
+	queue_delayed_work(system_dfl_long_wq, &ipvs->defense_work,
 			   DEFENSE_TIMER_PERIOD);
 
 	return 0;
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index ab09f5182951..78964aa861e9 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -243,7 +243,7 @@ void ip_vs_est_reload_start(struct netns_ipvs *ipvs, bool restart)
 	/* Bump the kthread configuration genid if stopping is requested */
 	if (restart)
 		atomic_inc(&ipvs->est_genid);
-	queue_delayed_work(system_long_wq, &ipvs->est_reload_work, 0);
+	queue_delayed_work(system_dfl_long_wq, &ipvs->est_reload_work, 0);
 }
 
 /* Start kthread task with current configuration */
-- 
2.47.3

