Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6E134F27B;
	Sun, 14 Jun 2026 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437574; cv=none; b=AIpsvH37jEIqyS7skTVMw0utDN9ojW/B5K2wjp63wi9NgGrliJ2eSEQwukfl3CVtwRfZUc5QAUKDxKhA41YRf9QZgx5dXrK88DpLlPZJKD5fVEQvelrcS9TOVkmmQQKyMAjvIA4wpNYzBDvFdCrEFL/wvP6A8+IVCLlsNiFXG1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437574; c=relaxed/simple;
	bh=ye6NSIfdNM26vxcGHD6JPUpQp8zLRzr3cZPC/C1KpFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AovzqfBVEk8e+WxDfabssUNZuBjj93ZbVv/JPjT8O2R6Q8vy5zQ6DTanidUHRrUDuHAqRQfUJXbPiFVI6+wNU/Dpzp35OHEfqt6qx9CRCOtay03EBTcs2jm69MHkeMcWXBRIw7egAx9PrClZ7cQP50/F+9it2/hfQd6MebAq7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vTrcQBpO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vTrcQBpO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 31382600B9;
	Sun, 14 Jun 2026 13:46:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437570;
	bh=e4pQ0atVWip758KhLvu1k+y1ZRIRG75G9mQeVDiq/Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTrcQBpO5r0enYDJW6CoCxQEc5b7wO2PAQ88o69u96wSJz5T4lXhDlHWUDweCme00
	 7Pmj9qg+mthdY/JFsZi6u8nuhFo2A/X5NsgK8NCLRYeNELDTCNYluj0KOWGh19D9Eg
	 odjWAX+y7yN+zkNTqd83gXaxpU19FbVnQyW9tuaumy/sWHNWBcVqJ30o6ZwzJ/PEy+
	 YqByPXkgxXPk5z+gG2owM2N1sjDPjx+QrxSAEHPqI+gwgB2FvL+1S+HvXAVtRp0EyQ
	 VvvoPTlKB7C9VHrhFjxWjh8dngmpNUgJ/Xa8Zze4cTZSiJngnhU1dEghsN3cBUSB5j
	 k45q1SH4j2VmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 01/11] ipvs: Replace use of system_unbound_wq with system_dfl_long_wq
Date: Sun, 14 Jun 2026 13:45:55 +0200
Message-ID: <20260614114605.474783-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marco Crivellari <marco.crivellari@suse.com>

This patch continues the effort to refactor workqueue APIs, which has
begun with the changes introducing new workqueues and a new
alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior
of workqueues to become unbound by default so that their workload
placement is optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better
named new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can
be removed in the future.

This specific work is considered long, so enqueue it using
system_dfl_long_wq instead of system_dfl_wq.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c |  4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index e76a73d183d5..cb36641f8d1c 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -285,7 +285,7 @@ static inline int ip_vs_conn_hash(struct ip_vs_conn *cp)
 	/* Schedule resizing if load increases */
 	if (atomic_read(&ipvs->conn_count) > t->u_thresh &&
 	    !test_and_set_bit(IP_VS_WORK_CONN_RESIZE, &ipvs->work_flags))
-		mod_delayed_work(system_unbound_wq, &ipvs->conn_resize_work, 0);
+		mod_delayed_work(system_dfl_long_wq, &ipvs->conn_resize_work, 0);
 
 	return ret;
 }
@@ -916,7 +916,7 @@ static void conn_resize_work_handler(struct work_struct *work)
 
 out:
 	/* Monitor if we need to shrink table */
-	queue_delayed_work(system_unbound_wq, &ipvs->conn_resize_work,
+	queue_delayed_work(system_dfl_long_wq, &ipvs->conn_resize_work,
 			   more_work ? 1 : 2 * HZ);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index f765d1506839..bcf40b8c41cf 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -821,7 +821,7 @@ static void svc_resize_work_handler(struct work_struct *work)
 	if (!READ_ONCE(ipvs->enable) || !more_work ||
 	    test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
 		return;
-	queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work, 1);
+	queue_delayed_work(system_dfl_long_wq, &ipvs->svc_resize_work, 1);
 	return;
 
 unlock_m:
@@ -1869,7 +1869,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 
 	/* Schedule resize work */
 	if (grow && !test_and_set_bit(IP_VS_WORK_SVC_RESIZE, &ipvs->work_flags))
-		queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work,
+		queue_delayed_work(system_dfl_long_wq, &ipvs->svc_resize_work,
 				   1);
 
 	*svc_p = svc;
@@ -2125,7 +2125,7 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
 		rcu_read_unlock();
 		if (shrink && !test_and_set_bit(IP_VS_WORK_SVC_RESIZE,
 						&ipvs->work_flags))
-			queue_delayed_work(system_unbound_wq,
+			queue_delayed_work(system_dfl_long_wq,
 					   &ipvs->svc_resize_work, 1);
 	}
 	return 0;
@@ -2606,7 +2606,7 @@ static int ipvs_proc_conn_lfactor(const struct ctl_table *table, int write,
 		} else {
 			WRITE_ONCE(*valp, val);
 			if (rcu_access_pointer(ipvs->conn_tab))
-				mod_delayed_work(system_unbound_wq,
+				mod_delayed_work(system_dfl_long_wq,
 						 &ipvs->conn_resize_work, 0);
 		}
 	}
@@ -2638,7 +2638,7 @@ static int ipvs_proc_svc_lfactor(const struct ctl_table *table, int write,
 			    READ_ONCE(ipvs->enable) &&
 			    !test_bit(IP_VS_WORK_SVC_NORESIZE,
 				      &ipvs->work_flags))
-				mod_delayed_work(system_unbound_wq,
+				mod_delayed_work(system_dfl_long_wq,
 						 &ipvs->svc_resize_work, 0);
 			mutex_unlock(&ipvs->service_mutex);
 		}
-- 
2.47.3

