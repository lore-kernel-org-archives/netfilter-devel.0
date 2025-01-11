Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA591BBBC0;
	Sat, 11 Jan 2025 23:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736636892; cv=none; b=a5Rxn5lDWGBA1957ZQ/om6XchRHHCg/nfcFbfyau5s0XOI1dBNYXNUeHszBQLW2rqhWQ/Q7NESh778+lZAyAYfBH+Wl2O0vStY13OQS1EgSmmyJPLQ8wMd0OqD08+ywxxqRJkZ7cB4KV/X5qSpk4Nr9JTpf6aHowObOaJa2ba24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736636892; c=relaxed/simple;
	bh=rh+NXkFkOSCld0emXqgPxXDTnO4nE88OW8sOnUZBH8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CEy5+JZbgcDmKRkdhPT2eUXUEyY4t0zsB+c+6Zm4s/+R+BP9aYz73V7c3iLARYqpAxXO1blJbJPD9AElJkBKPM3lGq4kCmdkTjbP957qMOnthtoswIhYA8VuUvumshREHtTJlwaLJS3KJWYWGenaMbFwo0sh1AaQ8+iVNqPOqIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net-next 3/4] netfilter: xt_hashlimit: htable_selective_cleanup() optimization
Date: Sun, 12 Jan 2025 00:07:59 +0100
Message-Id: <20250111230800.67349-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250111230800.67349-1-pablo@netfilter.org>
References: <20250111230800.67349-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

I have seen syzbot reports hinting at xt_hashlimit abuse:

[  105.783066][ T4331] xt_hashlimit: max too large, truncated to 1048576
[  105.811405][ T4331] xt_hashlimit: size too large, truncated to 1048576

And worker threads using up to 1 second per htable_selective_cleanup() invocation.

[  269.734496][    C1]  [<ffffffff81547180>] ? __local_bh_enable_ip+0x1a0/0x1a0
[  269.734513][    C1]  [<ffffffff817d75d0>] ? lockdep_hardirqs_on_prepare+0x740/0x740
[  269.734533][    C1]  [<ffffffff852e71ff>] ? htable_selective_cleanup+0x25f/0x310
[  269.734549][    C1]  [<ffffffff817dcd30>] ? __lock_acquire+0x2060/0x2060
[  269.734567][    C1]  [<ffffffff817f058a>] ? do_raw_spin_lock+0x14a/0x370
[  269.734583][    C1]  [<ffffffff852e71ff>] ? htable_selective_cleanup+0x25f/0x310
[  269.734599][    C1]  [<ffffffff81547147>] __local_bh_enable_ip+0x167/0x1a0
[  269.734616][    C1]  [<ffffffff81546fe0>] ? _local_bh_enable+0xa0/0xa0
[  269.734634][    C1]  [<ffffffff852e71ff>] ? htable_selective_cleanup+0x25f/0x310
[  269.734651][    C1]  [<ffffffff852e71ff>] htable_selective_cleanup+0x25f/0x310
[  269.734670][    C1]  [<ffffffff815b3cc9>] ? process_one_work+0x7a9/0x1170
[  269.734685][    C1]  [<ffffffff852e57db>] htable_gc+0x1b/0xa0
[  269.734700][    C1]  [<ffffffff815b3cc9>] ? process_one_work+0x7a9/0x1170
[  269.734714][    C1]  [<ffffffff815b3dc9>] process_one_work+0x8a9/0x1170
[  269.734733][    C1]  [<ffffffff815b3520>] ? worker_detach_from_pool+0x260/0x260
[  269.734749][    C1]  [<ffffffff810201c7>] ? _raw_spin_lock_irq+0xb7/0xf0
[  269.734763][    C1]  [<ffffffff81020110>] ? _raw_spin_lock_irqsave+0x100/0x100
[  269.734777][    C1]  [<ffffffff8159d3df>] ? wq_worker_sleeping+0x5f/0x270
[  269.734800][    C1]  [<ffffffff815b53c7>] worker_thread+0xa47/0x1200
[  269.734815][    C1]  [<ffffffff81020010>] ? _raw_spin_lock+0x40/0x40
[  269.734835][    C1]  [<ffffffff815c9f2a>] kthread+0x25a/0x2e0
[  269.734853][    C1]  [<ffffffff815b4980>] ? worker_clr_flags+0x190/0x190
[  269.734866][    C1]  [<ffffffff815c9cd0>] ? kthread_blkcg+0xd0/0xd0
[  269.734885][    C1]  [<ffffffff81027b1a>] ret_from_fork+0x3a/0x50

We can skip over empty buckets, avoiding the lockdep penalty
for debug kernels, and avoid atomic operations on non debug ones.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 0859b8f76764..fa02aab56724 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -363,11 +363,15 @@ static void htable_selective_cleanup(struct xt_hashlimit_htable *ht, bool select
 	unsigned int i;
 
 	for (i = 0; i < ht->cfg.size; i++) {
+		struct hlist_head *head = &ht->hash[i];
 		struct dsthash_ent *dh;
 		struct hlist_node *n;
 
+		if (hlist_empty(head))
+			continue;
+
 		spin_lock_bh(&ht->lock);
-		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
+		hlist_for_each_entry_safe(dh, n, head, node) {
 			if (time_after_eq(jiffies, dh->expires) || select_all)
 				dsthash_free(ht, dh);
 		}
-- 
2.30.2

