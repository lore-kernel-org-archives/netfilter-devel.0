Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690BC3F54D9
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098833; cv=none; b=Y5UNVWGGcu/xszXyK+EfMugjnF1X1V7VQrRszecblnSKqFL689tFYvXMxWBA/qlKsZaR+DTOR+ViDSTELHhD7JVpE2dohpoaQwWHuF906C2OkVt2jI30W7B7oKPPrKh++3IQ4OwCFGisx2HHs/a3wX+vgn2xqkMP1JNBdD82vx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098833; c=relaxed/simple;
	bh=xWs2nKvEnKcCSbWKBlaysRqdlSEJAqnTt7D60iU/S3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixiZQZwXUOu9+O9rWxuwL7ZHVQZ7OwSVywp0Ir6fHYLMHQkN7GDR6JoDHjKPUVv/2LJrO9kaqqyxyAftm5JXGOn3MepHYTmRBui+GZ7J7T6esfh4Fn2QWUbm1CspfvIsJDUZ3tvvSMCOxWo14Ui7vwsLjLwmShoiv9UAFkggAxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=e8lMBwKA; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="e8lMBwKA"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469a3490bso163112b3a.3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 10:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790098832; x=1790703632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8u+pzk+HNiZCdG2339AV8ATTiqqklCANQ4P670vhRS8=;
        b=e8lMBwKAvqKeuVTdC7XJ36vCegaN7US2pLQ6U+jKQmbZejy9yRwtt1UgeoXtrN589m
         2mW/8qDtdMmIr0FjoAHNDBvtNkuMIpZcgwcn+3wMhdqPIbmSK56e67HBltVD9RBJ15sy
         Bb6MG1tDyGbL0fVmX8AH/ozEpRWCICx5BrDEogo8DPZsVSuP6ksYfJdP7T5guEtIT53q
         uAu1cnnVCO1m6Pi6RLzNA4j3KQ2CgFFguchh7G+B5rillWK8nmE+xS96yy+7vyZrqsXt
         lv3sIeBDf74VpxfRol/QhCx4D2JREKmhvG/VLNbH6mxRCJXWluc/zQFadUFGmnvJkqOf
         kqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098832; x=1790703632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8u+pzk+HNiZCdG2339AV8ATTiqqklCANQ4P670vhRS8=;
        b=ErzQs9jxekGWLIqo6e6HK1mnF3uHJ5fvB5V5PNwDYWOUEOEwqVVfjxVwVQNXOOtGTS
         muraRD+k1vIMMy1ROn8E4tjXJjfmE0AouWybw4QcWSXXYzZV+/exlLZ+UX+XXg0+uIKP
         qhbikbJXN+VlyKL4TqBRFZi/z8h8rbSwc5mycXwX5GVKKDJQ84p+UxeS3+9HQTPG9Q8L
         /OyGjLvQIhM1F4oOa67gdLamnyqm8iZfAsMvHaL/DWGOPPkqYwGOvHmH0pQbnMYbLMXl
         DV4suTJm1FhP6N4x6aCHkuyrMT2mzX45eV7IsRMkx+SPw5djbRxrpjr1qgFyhFR8nAzi
         EvPQ==
X-Gm-Message-State: AFuF++l/kiykxgt0iTwSsubFhgwey7qIDwAjBA0CyGgIsfEcDLrIJiQa
	4AlY1JDAi8W+Rd3Ci5Ni2DpwRDBoaRf+CTQFyzrzPFynGt4bgyCA1KKL13WpVBRu13sNoOdCu5f
	KIaEr1vm5
X-Gm-Gg: AYBFou3UodgPL1gzdb2vW1Q2ArSoJLMOxoWnSBM8J0jsvbHt4ge2ihkRDS2Tm8s3Xfz
	mhO1ViLu55x697gI2CyNU+s0M5oYc4cUj3ZTOLaFZwiIpSMcNi2+JVzXolmFSoUmvYx/OrZnp98
	bWKXMuZ71qdNeFbaZrvUgBP2125+o/sNYG+gTwhtxijkQQfBM+8MIHgjbI3RmG0jfOlcqUeVrtn
	M5qKTZLMnrTk1nvqomz63fJsRyICl7BWrjUaLJ/EV956XP9ln2T88BCecGNvAFK/sB1ku2kdV0G
	3o+A0kfPbmDbJWRhsA711M4Iyv+KoM8MceLYQDVhH0GafGyWSueO+oG6lqJyw6h29B4oBpnzs3n
	5wUb9yJ241HVFdnr+bD3IqY587fhi7r99d+z9zxjzFBBqjxRDyfabGgEPKLvf2SJTgl/mRNR6No
	MJbm9KkhmGQxfsL2l1TXEplC63CKmAMIXB+jYOgwcCVh5WGS2YsOdS+otRRmlMANLR9wpHW6zFs
	SJuJr2D
X-Received: by 2002:a05:6a00:1ca1:b0:87a:346f:d032 with SMTP id d2e1a72fcca58-87d1c1bcdfemr316026b3a.47.1790098831228;
        Tue, 22 Sep 2026 10:40:31 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1cfc0843sm147812b3a.12.2026.09.22.10.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:40:30 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	vega@nebusec.ai,
	caoruide123@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: ecache: bound destroy event redelivery
Date: Wed, 23 Sep 2026 01:39:56 +0800
Message-ID: <48840876b129e0094fbd8048e96fb6e3fae51055.1787158072.git.vega.cover-letter@nebusec.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787158072.git.vega.cover-letter@nebusec.ai>
References: <cover.1787158072.git.vega.cover-letter@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ruide Cao <caoruide123@gmail.com>

A conntrack whose destroy event cannot be delivered is kept on the
per-netns ecache list while the workqueue retries the notification.
The worker stops at the first failure and retries every 10 ms without
a lifetime limit. A listener that enables NETLINK_BROADCAST_ERROR and
never drains its receive queue can therefore retain conntracks and
keep the worker busy indefinitely.

Start a per-netns deadline when redelivery begins. If the listener
remains congested after the existing 15 second grace period, detach
all queued entries through the normal evicted-list path and release
their references. Reset the deadline when the list drains, preserving
redelivery for transient congestion while preventing permanent
conntrack retention.

Fixes: dd7669a92c60 ("netfilter: conntrack: optional reliable conntrack event delivery")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 include/net/netfilter/nf_conntrack.h |  1 +
 net/netfilter/nf_conntrack_ecache.c  | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bc42dd0e10e6..d4c646c685b4 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -46,6 +46,7 @@ struct nf_conntrack_net_ecache {
 	struct delayed_work dwork;
 	spinlock_t dying_lock;
 	struct hlist_nulls_head dying_list;
+	unsigned long retry_deadline;
 };
 
 struct nf_conntrack_net {
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index cc8d8e85169f..9280fc947da9 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -31,6 +31,7 @@ static DEFINE_MUTEX(nf_ct_ecache_mutex);
 #define DYING_NULLS_VAL			((1 << 30) + 1)
 #define ECACHE_MAX_JIFFIES		msecs_to_jiffies(10)
 #define ECACHE_RETRY_JIFFIES		msecs_to_jiffies(10)
+#define ECACHE_RETRY_TIMEOUT		(15 * HZ)
 
 enum retry_state {
 	STATE_CONGESTED,
@@ -52,8 +53,8 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 {
 	unsigned long stop = jiffies + ECACHE_MAX_JIFFIES;
 	struct hlist_nulls_head evicted_list;
-	enum retry_state ret = STATE_DONE;
 	struct nf_conntrack_tuple_hash *h;
+	enum retry_state ret = STATE_DONE;
 	struct hlist_nulls_node *n;
 	unsigned int sent;
 
@@ -63,6 +64,22 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 	sent = 0;
 	spin_lock_bh(&cnet->ecache.dying_lock);
 
+	if (!cnet->ecache.retry_deadline)
+		cnet->ecache.retry_deadline = jiffies + ECACHE_RETRY_TIMEOUT;
+
+	if (time_after_eq(jiffies, cnet->ecache.retry_deadline)) {
+		hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list,
+						hnnode) {
+			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
+			hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+			hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
+					     &evicted_list);
+		}
+		ret = STATE_DONE;
+		goto out_unlock;
+	}
+
 	hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list, hnnode) {
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
@@ -89,6 +106,10 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 		}
 	}
 
+out_unlock:
+	if (hlist_nulls_empty(&cnet->ecache.dying_list))
+		cnet->ecache.retry_deadline = 0;
+
 	spin_unlock_bh(&cnet->ecache.dying_lock);
 
 	hlist_nulls_for_each_entry_safe(h, n, &evicted_list, hnnode) {
-- 
2.47.3
