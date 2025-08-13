Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C5D2F745B;
	Wed, 13 Aug 2025 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085096; cv=none; b=prCTU7igu2XKjR2v88gmaOL765JtdRBU6fRDtm0B8Hkgrgmfr3sQg+hDvTq0PS00Ez3lYoLNKuOiVNi14arB7xg7tyiymOTr0lZIWLIW+lnfccWXbY1jJXl8tnasNVaId3t7/+IKSi+p+dJ+LJRatr1YI7Yihe651eHI/ZQuGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085096; c=relaxed/simple;
	bh=f7Fmm8iRQl8ST44gaTUWNWlRHQac1e3x4cYflciZfRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuIM0vG6+6C2YG+wJuwyJG+xjc03bijiOUwEAJqWPadjpFVdZQrJevDwC4Be0C/68utLQCorCApEajKJQykGsqVoRksEgcOKYMTN3YAAODrlLyQLMZClZAAMVz2Z4tBgNUeyAKopxMunyPrqUvtsXOowUdUXiv1WAUFbX9YLsXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3096F6061F; Wed, 13 Aug 2025 13:38:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Frederic Weisbecker <frederic@kernel.org>,
	Julian Anastasov <ja@ssi.bg>
Subject: [PATCH net 2/3] ipvs: Fix estimator kthreads preferred affinity
Date: Wed, 13 Aug 2025 13:36:37 +0200
Message-ID: <20250813113800.20775-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250813113800.20775-1-fw@strlen.de>
References: <20250813113800.20775-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Frederic Weisbecker <frederic@kernel.org>

The estimator kthreads' affinity are defined by sysctl overwritten
preferences and applied through a plain call to the scheduler's affinity
API.

However since the introduction of managed kthreads preferred affinity,
such a practice shortcuts the kthreads core code which eventually
overwrites the target to the default unbound affinity.

Fix this with using the appropriate kthread's API.

Fixes: d1a89197589c ("kthread: Default affine kthread to its preferred NUMA node")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/ip_vs.h            | 13 +++++++++++++
 kernel/kthread.c               |  1 +
 net/netfilter/ipvs/ip_vs_est.c |  3 ++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ff406ef4fd4a..29a36709e7f3 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1163,6 +1163,14 @@ static inline const struct cpumask *sysctl_est_cpulist(struct netns_ipvs *ipvs)
 		return housekeeping_cpumask(HK_TYPE_KTHREAD);
 }
 
+static inline const struct cpumask *sysctl_est_preferred_cpulist(struct netns_ipvs *ipvs)
+{
+	if (ipvs->est_cpulist_valid)
+		return ipvs->sysctl_est_cpulist;
+	else
+		return NULL;
+}
+
 static inline int sysctl_est_nice(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_est_nice;
@@ -1270,6 +1278,11 @@ static inline const struct cpumask *sysctl_est_cpulist(struct netns_ipvs *ipvs)
 	return housekeeping_cpumask(HK_TYPE_KTHREAD);
 }
 
+static inline const struct cpumask *sysctl_est_preferred_cpulist(struct netns_ipvs *ipvs)
+{
+	return NULL;
+}
+
 static inline int sysctl_est_nice(struct netns_ipvs *ipvs)
 {
 	return IPVS_EST_NICE;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 0e98b228a8ef..31b072e8d427 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -893,6 +893,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kthread_affine_preferred);
 
 /*
  * Re-affine kthreads according to their preferences
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index f821ad2e19b3..15049b826732 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -265,7 +265,8 @@ int ip_vs_est_kthread_start(struct netns_ipvs *ipvs,
 	}
 
 	set_user_nice(kd->task, sysctl_est_nice(ipvs));
-	set_cpus_allowed_ptr(kd->task, sysctl_est_cpulist(ipvs));
+	if (sysctl_est_preferred_cpulist(ipvs))
+		kthread_affine_preferred(kd->task, sysctl_est_preferred_cpulist(ipvs));
 
 	pr_info("starting estimator thread %d...\n", kd->id);
 	wake_up_process(kd->task);
-- 
2.49.1

