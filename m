Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76E13F787F
	for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2026 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778507293; cv=none; b=orx5YcwGYIgnMPZe6M2UEMtDlqjhhUHLcGpo3VfzqqbLSu3vJYps1YaJonUvxvOUSjmKxkS0p2bnk9YdjkBD9FnSNszq2FsULvEI0o2phnoOEFr0vWW3KHYo8cVKSqb0QP0k1DRcliP8RPqqrHXLf/iKKI/tOkcrLr8d0nXClVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778507293; c=relaxed/simple;
	bh=5lTw8AW4wHd4EwAFkjJzid9ifnmy2d8f+Nyohbx8bF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAsLnIDbe9JPMB/S/QriQUbDXwQ1kqN6arazVIRPETxspEl39w9Dr0Quoh7W1YeJbidU5aWKu5jPZQXdw57/0j2P7OGGRpajSzx7gHmKv5Jp6iZOlT304UFxhGIv93CDOgjCWA8rFIsh0YtvMfczeZmeDiLmYoTalOgETDPpeS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fdvpZ34P; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fdvpZ34P"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891f625344so41838895e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2026 06:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778507290; x=1779112090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jEKdOT9KNT9VkfLURxJrQMx5JuEqo+lpwOnRqNvfvY=;
        b=fdvpZ34PGkii73OrZ3bKD/2ykJ93QnGL42dlkoCxkXvZPfHQ+BxaVd1wK+uuA1S2KC
         Y4rYShGIkkbz0UGs2T9fcVtKQYeoAu+JzCxdLsFoszsLi2mXeVMuCzCbqCj5kzKenXvo
         nD7bPdh7Qwnl08pcWrrKIqXCXrEgTAyh6wEGG6f1G7b2MXMoRwGEGEe3zBHGRvhi2Zke
         nAHhggyHw58OYe5xwrMxrqKgPXECZASfhLk/23/ygeNy1IqIsb9f78qjthT5RoLVOwWT
         fiad8cf/Oj0ZdfKB6+G7qQtwRijuU7ZblE1Xr0VzkUWNlniao1JxMhaqqqVk3hQGjEAt
         vf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778507290; x=1779112090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5jEKdOT9KNT9VkfLURxJrQMx5JuEqo+lpwOnRqNvfvY=;
        b=rGboLOBSb6t3sNjJYatF4sUQydd/rtCY7t0bY9oxxP91zddZsftP3XjxThNZVMEaBo
         d6X4QCktogEPoccIuqFFFZZkzQUoJmFXqxo2ThWyjj7P4jVYvgo+tiwGPqB1hm+ETuas
         2mBpN84p/RLd6/CE4yRH0OlYiLmWojNmz4/7qWwIPo+fXit49H8EJOkQN6niNOcsL3VU
         4QEomeSdrUaWIkYNXO8dTREksmaSbIp26Xj516vcRxfEZZEC3lsc3SSTR22blXA85OAH
         nO/g7SB5cOPZj56wefinO70ZK9XWG+fDhjDSs5XE4TMl4RQzvqBt37NM1SAHJpfCKN6e
         aaAg==
X-Forwarded-Encrypted: i=1; AFNElJ+mpLclDmwWJGS7cgd5cF9fqcC3xkWkM4szrkJvFFvzX1UfQinYixKEiIFpRcBHP6eQs/hMcjNZ/WHgOB6o+Tg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN3BULIEqSpGXRlH9SyRT1DSmm8vDBTkvcXwctx0vcAJjWFKjm
	LpWU1C9ilM5mVlGjlm24MxwojNYzxpLelOnIUTgYGwtMsyJ03ZFZeinmIYq4obOfHIQ=
X-Gm-Gg: Acq92OGRemuylslCtVpIlLJmdBEs5YoUSLFeEaEYzoZKm8GaHgBF+cpKWLsYhW7IApa
	Zde3MOxpkQh18yoU2fVmdFeqewKqAK8lCtqDumyyZRrHwMia5firT+CILyap9k2YfTqALfsCTmc
	ghZkc3PPjj9zymJn16sBmrgQPDauQRMULuPiqPRntoS/PyaD3q/cdmrY1xfDVQrIopc5h6BmPYI
	ng8veq6uhPld4m3xe9Iw8FAXIbrMwXj2l4tmLO1Hpf4giDiFBLKWkzVPJ6XINYcS67rA1UiXcub
	eez079WB43Th+YzsjpounUs6UmB0g1hoV9nCXqF4rPhDECbSQwFsG/VNTpeufiLoSECEoPYJfjX
	638cJpW9BlFcW07BN3BjhUOcQhiW31xVHrT8BkjAvRuKemGlgwlI+Y9zku299yIO3dCLIGgk+Ow
	dNzMbEHqKm9iSeCSegjPXJm+X2vJXLkl0h274mwgGnPKkTz2M=
X-Received: by 2002:a05:600c:3b8f:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e642deefamr241378475e9.7.1778507289999;
        Mon, 11 May 2026 06:48:09 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e701e957asm188062665e9.6.2026.05.11.06.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:48:09 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Simon Horman <horms@verge.net.au>,
	Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next 2/2] ipvs: Replace use of system_unbound_wq with system_dfl_wq
Date: Mon, 11 May 2026 15:47:37 +0200
Message-ID: <20260511134744.277032-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511134744.277032-1-marco.crivellari@suse.com>
References: <20260511134744.277032-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch continues the effort to refactor workqueue APIs, which has begun
with the changes introducing new workqueues and a new alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior of
workqueues to become unbound by default so that their workload placement is
optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better named
new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>
Cc: lvs-devel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 net/netfilter/ipvs/ip_vs_conn.c |  4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 9ea6b4fa78bf..2625c0379556 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -285,7 +285,7 @@ static inline int ip_vs_conn_hash(struct ip_vs_conn *cp)
 	/* Schedule resizing if load increases */
 	if (atomic_read(&ipvs->conn_count) > t->u_thresh &&
 	    !test_and_set_bit(IP_VS_WORK_CONN_RESIZE, &ipvs->work_flags))
-		mod_delayed_work(system_unbound_wq, &ipvs->conn_resize_work, 0);
+		mod_delayed_work(system_dfl_wq, &ipvs->conn_resize_work, 0);
 
 	return ret;
 }
@@ -916,7 +916,7 @@ static void conn_resize_work_handler(struct work_struct *work)
 
 out:
 	/* Monitor if we need to shrink table */
-	queue_delayed_work(system_unbound_wq, &ipvs->conn_resize_work,
+	queue_delayed_work(system_dfl_wq, &ipvs->conn_resize_work,
 			   more_work ? 1 : 2 * HZ);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c7c7f6a7a9f6..f8fe1c8981d8 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -800,7 +800,7 @@ static void svc_resize_work_handler(struct work_struct *work)
 	if (!READ_ONCE(ipvs->enable) || !more_work ||
 	    test_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
 		return;
-	queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work, 1);
+	queue_delayed_work(system_dfl_wq, &ipvs->svc_resize_work, 1);
 }
 
 static inline void
@@ -1833,7 +1833,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	/* Schedule resize work */
 	if (t && ip_vs_get_num_services(ipvs) > t->u_thresh &&
 	    !test_and_set_bit(IP_VS_WORK_SVC_RESIZE, &ipvs->work_flags))
-		queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work,
+		queue_delayed_work(system_dfl_wq, &ipvs->svc_resize_work,
 				   1);
 
 	*svc_p = svc;
@@ -2078,7 +2078,7 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
 	} else if (ns <= t->l_thresh &&
 		   !test_and_set_bit(IP_VS_WORK_SVC_RESIZE,
 				     &ipvs->work_flags)) {
-		queue_delayed_work(system_unbound_wq, &ipvs->svc_resize_work,
+		queue_delayed_work(system_dfl_wq, &ipvs->svc_resize_work,
 				   1);
 	}
 	return 0;
@@ -2511,7 +2511,7 @@ static int ipvs_proc_conn_lfactor(const struct ctl_table *table, int write,
 		} else {
 			WRITE_ONCE(*valp, val);
 			if (rcu_access_pointer(ipvs->conn_tab))
-				mod_delayed_work(system_unbound_wq,
+				mod_delayed_work(system_dfl_wq,
 						 &ipvs->conn_resize_work, 0);
 		}
 	}
@@ -2543,7 +2543,7 @@ static int ipvs_proc_svc_lfactor(const struct ctl_table *table, int write,
 			    READ_ONCE(ipvs->enable) &&
 			    !test_bit(IP_VS_WORK_SVC_NORESIZE,
 				      &ipvs->work_flags))
-				mod_delayed_work(system_unbound_wq,
+				mod_delayed_work(system_dfl_wq,
 						 &ipvs->svc_resize_work, 0);
 			mutex_unlock(&ipvs->service_mutex);
 		}
-- 
2.54.0

