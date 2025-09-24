Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E704C2ECEBC;
	Wed, 24 Sep 2025 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722855; cv=none; b=EsPM1Kpb6JQGf02txDNG9fVo7JVbTMBGgafkCrrsMo/qlgJLhVETt0/Rv00wjdI9wiZQPPdgSk7sBEoYnTruz/QxwjkZsN/nMOWzgxqwllprsUJiYLWdxu1pWbnRLZ3JQWr9U/VvHMyFgwq68e6PxEPaWKx25IT42bAjUP9I4+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722855; c=relaxed/simple;
	bh=X8ia0Xho/bs3jQ9SqjtO/AMMykUZm5KBxbXXaL+G4u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHjK7gy513F1zod4DSN5wl7Y5I0aIvWRPEVicXrf5mErk7+DHJaPoMaqX6X3gXDFV5HdbeEecbGaLbbTZwR3YOSnB9LlVjtRNPdMfOhsr6MZEgbVZDUcdC+ULC6QoxlPEAAuLNrKkjBIrCNNRlH+8AIjBKgd/H/ZZAhh0EpqMeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 71E3E6032B; Wed, 24 Sep 2025 16:07:30 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 6/6] netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack
Date: Wed, 24 Sep 2025 16:06:54 +0200
Message-ID: <20250924140654.10210-7-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250924140654.10210-1-fw@strlen.de>
References: <20250924140654.10210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

ct_seq_show() has an opportunistic garbage collector :

if (nf_ct_should_gc(ct)) {
    nf_ct_kill(ct);
    goto release;
}

So if one nf_conn is killed there, next time ct_get_next() runs,
we skip the following item in the bucket, even if it should have
been displayed if gc did not take place.

We can decrement st->skip_elems to tell ct_get_next() one of the items
was removed from the chain.

Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_standalone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 1f14ef0436c6..708b79380f04 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -317,6 +317,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	smp_acquire__after_ctrl_dep();
 
 	if (nf_ct_should_gc(ct)) {
+		struct ct_iter_state *st = s->private;
+
+		st->skip_elems--;
 		nf_ct_kill(ct);
 		goto release;
 	}
-- 
2.49.1

