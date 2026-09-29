Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFA6525A8C
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790687392; cv=none; b=rIdMlZuT31ZXtGv38XPEuyrd+tpWH5bL3ptDXb2VMTEdP6A5gsuzGIeU6lCn677MqY91I5+0h0Tqg8Icz4mCOLG23PmFtNWqb7L5Q9pgpk2bwpX0Jb83ygTKMPvdZAD+Qe+IxW+gqVEMn6pdTIy6CEaGH/5Gu/BziMCWd+MgnEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790687392; c=relaxed/simple;
	bh=HqqZs3GHGkELFGeEOrZHDN4w5GmzVW/h0+Nct+nTP0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mxjss1zutPhXDWjBWP07AhRJ2U3/gjOQ6ALXEv5a80qkE/O20l7yvl+TfGtpTdbPxwnYiKVPvDOCvEMdP7TBmn5jMUCLXX53BkdpyP6gJCAFzxMeKGjFGTJwrKcijeBV1SNbgOkHlT+ryGReCPHhOZPVzShauM8zI34oI5mVQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 08F5560344; Tue, 29 Sep 2026 15:09:48 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Vega <vega@nebusec.ai>
Subject: [PATCH nf-next] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Tue, 29 Sep 2026 15:09:39 +0200
Message-ID: <20260929130939.17872-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When early-drop scan is enabled, gc_worker() reads tmp->ct_net, resolves
cnet with nf_ct_pernet(), and reads cnet->count with RCU read lock held but
before acquiring a reference to tmp.

Its unlikely but possible that the worker gets preempted before reading
cnet->count while nf_conntrack_cleanup_net_list manages to unlink all
conntracks and returns in the mean time.
This allows for the pernet memory to get free'd.

On resume, use after free would occur when the worker reads cnet->count.

This can be solved either via another synchronize_rcu() in
nf_conntrack_cleanup_net_list or via cheaper flush_work().  If work
wasn't running no race can happen as next call cannot observe
already-unlinked conntrack objects.

This is an LLM finding with no reproducer, but it appears to be correct.

Fixes: c6dd940b1f74 ("netfilter: allow early drop of assured conntracks")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..6cba999e8056 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2507,6 +2507,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		goto i_see_dead_people;
 	}
 
+	/* must wait for current scan loop, worker also looks at
+	 * struct nf_conntrack_net, which is about to be free'd.
+	 */
+	flush_work(&conntrack_gc_work.dwork.work);
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		warn_on_keymap_list_leak(net);
 		nf_conntrack_ecache_pernet_fini(net);
-- 
2.55.0

