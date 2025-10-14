Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099402FE053;
	Tue, 14 Oct 2025 11:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760442721; cv=none; b=g79nWei4DrMPohKtTaVy57nMm+aYgVU8DXAttUJsEAz/SMfHVUMl6wDUHJddfYMrJ8ZY2XtqnzWFHhS5BOw55xjXebw0fuqE8thpcCybEe4tqq0nchgiEmp6MmBmkFJuF0WAOY0LSSk3SRMa0icrinaGZwTtXeed2ux8ynuruoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760442721; c=relaxed/simple;
	bh=Hfs/oyD16dhuLjpqiLOj0BghJMlBJWnviczL0Y3NGms=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=upUz62G3iS47rYWNN9h4O/w5z2zcWOyvzgnmvFFOQVL8ly0GSbWUWw6YxDXmmePIPdxiUMdIokMyvJHQlBbGk8hwB675tMjAY1sZORMrbzscTACfl4Rg3baqYQ6GzEtmOL/LXYtzLB3dIGDh5Ehq8fzl5J/d9+xnZSqlDYt+m3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.202.115.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
	<phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH net-next] netfilter: conntrack: Reduce cond_resched frequency in gc_worker
Date: Tue, 14 Oct 2025 19:51:03 +0800
Message-ID: <20251014115103.2678-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc9.internal.baidu.com (172.31.3.19) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The current implementation calls cond_resched() in every iteration
of the garbage collection loop. This creates some overhead when
processing large conntrack tables with billions of entries,
as each cond_resched() invocation involves scheduler operations.

To reduce this overhead, implement a time-based throttling mechanism
that calls cond_resched() at most once per millisecond. This maintains
system responsiveness while minimizing scheduler contention.

gc_worker() with hashsize=10000 shows measurable improvement:

Before: 7114.274us
After:  5993.518us (15.8% reduction)

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/netfilter/nf_conntrack_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 344f882..779ca03 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1513,7 +1513,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 static void gc_worker(struct work_struct *work)
 {
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	u32 end_time, start_time = nfct_time_stamp;
+	u32 end_time, resched_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
 	unsigned int expired_count = 0;
 	unsigned long next_run;
@@ -1536,6 +1536,7 @@ static void gc_worker(struct work_struct *work)
 	count = gc_work->count;
 
 	end_time = start_time + GC_SCAN_MAX_DURATION;
+	resched_time = nfct_time_stamp;
 
 	do {
 		struct nf_conntrack_tuple_hash *h;
@@ -1615,7 +1616,10 @@ static void gc_worker(struct work_struct *work)
 		 * we will just continue with next hash slot.
 		 */
 		rcu_read_unlock();
-		cond_resched();
+		if (nfct_time_stamp - resched_time > msecs_to_jiffies(1)) {
+			cond_resched();
+			resched_time = nfct_time_stamp;
+		}
 		i++;
 
 		delta_time = nfct_time_stamp - end_time;
-- 
2.9.4

