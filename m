Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098B0348C6E;
	Fri, 10 Jul 2026 14:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694275; cv=none; b=V8K192PipqmoVTkjiHV7/8wgUW68beBg0Ty0U588AR2VXaSRL5o50NLGox8IjhNhvuTYL6KPWZSMsWsSs038PCYMoujqPheb//6GobD2sRUyuX7oVDlrXes566HZzqM+D0Dce96hrRCJQASCxF7+Ja1++7cNQv0fZKltT9KVa5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694275; c=relaxed/simple;
	bh=/T5XlWGP2PLa/f5cETS2ktMuZeb/SjA9TIEitRMNBNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN/qNUKKkzdvtnEPczB7CER7eZOg9wn55vzeU1LGo/LcPngXNJfvQPTRKI+PsVuY7zf97kcPlxdNIEq20emng4bgAOERWxcYdhDurhy9Q985/J70O7WRAWULTu9HdiMl++sOaa9rTvejA/59wIiIZsfNNlJt5LbYverS+MAnrbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 527706059A; Fri, 10 Jul 2026 16:37:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/9] netfilter: ecache: fix inverted time_after() check
Date: Fri, 10 Jul 2026 16:37:26 +0200
Message-ID: <20260710143733.29741-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

ecache_work_evict_list() redelivers DESTROY events for conntracks that
were moved to the per-netns dying_list after event delivery failed.  It
sets a 10ms deadline:

    stop = jiffies + ECACHE_MAX_JIFFIES

but then tests:

    time_after(stop, jiffies)

This condition is true while the deadline is still in the future, so the
worker returns STATE_RESTART after the first successful redelivery in the
usual case.  ecache_work() maps STATE_RESTART to delay 0, which turns the
redelivery path into one dying conntrack per workqueue dispatch and makes
the sent > 16 batching/cond_resched() path effectively unreachable.

A conntrack netlink listener whose receive queue is congested can make
DESTROY event delivery fail with -ENOBUFS.  With sustained conntrack
churn, entries then accumulate on the dying_list and are only drained at
the degraded one-entry-per-dispatch rate once delivery succeeds again,
wasting CPU on back-to-back workqueue reschedules and prolonging
conntrack memory/resource pressure.

In a KASAN QEMU test with CONFIG_NF_CONNTRACK_EVENTS=y and
nf_conntrack.enable_hooks=1, a congested DESTROY listener caused 8192
nf_ct_delete() calls to return false and move entries to the dying_list.
After closing the listener, the unfixed kernel needed 7670 ecache_work()
entries to destroy 7669 conntracks.  With this change, the same 8192
entries were destroyed by 2 ecache_work() entries.

Swap the comparison so the worker restarts only after the deadline has
expired.

Fixes: 2ed3bf188b33 ("netfilter: ecache: use dedicated list for event redelivery")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 9df159448b89..cc8d8e85169f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -77,7 +77,7 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 		hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode, &evicted_list);
 
-		if (time_after(stop, jiffies)) {
+		if (time_after(jiffies, stop)) {
 			ret = STATE_RESTART;
 			break;
 		}
-- 
2.54.0

