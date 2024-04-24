Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCEF142E7D
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 20:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713989635; cv=none; b=jwGV5Sn/TIhBClcKGy/4Zql0dZXJVN7RhXB0pbW9cRqG4M774Z2y9RAMhmlDRyNQh1c/yj7RQ1zrWciBjdqTmN9qcmT/LViKM9cMFAYDmId97/RCqFnfAWqpp3XG+BabjYcH2VtoBe20swgx4KxulCZwCp+8k/OUehYHI8SL9mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713989635; c=relaxed/simple;
	bh=lXJ/0YBz6Wj1peIwJxFzmOY9k77PCFrbneWoDNEkUzE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=i2hW26kG2vSmfDOOBhp8xx/lfsljBy/q6UbUwQlBLdeQV6YdnRZU45krSLeKGpOpp11ilvWTLQElcTSXqJeH7MTQiEqpNHVq9FbgBiz7j12w5MytHZTZN8T3u6H+PTRXxLKDaxgej+r3MOFhF8chTTDmltpjdTI29ym40NRKFt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: honor table dormant flag from netdev release event path
Date: Wed, 24 Apr 2024 22:13:48 +0200
Message-Id: <20240424201348.159501-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for table dormant flag otherwise netdev release event path tries
to unregister an already unregistered hook.

[524854.857999] ------------[ cut here ]------------
[524854.858010] WARNING: CPU: 0 PID: 3386599 at net/netfilter/core.c:501 __nf_unregister_net_hook+0x21a/0x260
[...]
[524854.858848] CPU: 0 PID: 3386599 Comm: kworker/u32:2 Not tainted 6.9.0-rc3+ #365
[524854.858869] Workqueue: netns cleanup_net
[524854.858886] RIP: 0010:__nf_unregister_net_hook+0x21a/0x260
[524854.858903] Code: 24 e8 aa 73 83 ff 48 63 43 1c 83 f8 01 0f 85 3d ff ff ff e8 98 d1 f0 ff 48 8b 3c 24 e8 8f 73 83 ff 48 63 43 1c e9 26 ff ff ff <0f> 0b 48 83 c4 18 48 c7 c7 00 68 e9 82 5b 5d 41 5c 41 5d 41 5e 41
[524854.858914] RSP: 0018:ffff8881e36d79e0 EFLAGS: 00010246
[524854.858926] RAX: 0000000000000000 RBX: ffff8881339ae790 RCX: ffffffff81ba524a
[524854.858936] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff8881c8a16438
[524854.858945] RBP: ffff8881c8a16438 R08: 0000000000000001 R09: ffffed103c6daf34
[524854.858954] R10: ffff8881e36d79a7 R11: 0000000000000000 R12: 0000000000000005
[524854.858962] R13: ffff8881c8a16000 R14: 0000000000000000 R15: ffff8881351b5a00
[524854.858971] FS:  0000000000000000(0000) GS:ffff888390800000(0000) knlGS:0000000000000000
[524854.858982] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[524854.858991] CR2: 00007fc9be0f16f4 CR3: 00000001437cc004 CR4: 00000000001706f0
[524854.859000] Call Trace:
[524854.859006]  <TASK>
[524854.859013]  ? __warn+0x9f/0x1a0
[524854.859027]  ? __nf_unregister_net_hook+0x21a/0x260
[524854.859044]  ? report_bug+0x1b1/0x1e0
[524854.859060]  ? handle_bug+0x3c/0x70
[524854.859071]  ? exc_invalid_op+0x17/0x40
[524854.859083]  ? asm_exc_invalid_op+0x1a/0x20
[524854.859100]  ? __nf_unregister_net_hook+0x6a/0x260
[524854.859116]  ? __nf_unregister_net_hook+0x21a/0x260
[524854.859135]  nf_tables_netdev_event+0x337/0x390 [nf_tables]
[524854.859304]  ? __pfx_nf_tables_netdev_event+0x10/0x10 [nf_tables]
[524854.859461]  ? packet_notifier+0xb3/0x360
[524854.859476]  ? _raw_spin_unlock_irqrestore+0x11/0x40
[524854.859489]  ? dcbnl_netdevice_event+0x35/0x140
[524854.859507]  ? __pfx_nf_tables_netdev_event+0x10/0x10 [nf_tables]
[524854.859661]  notifier_call_chain+0x7d/0x140
[524854.859677]  unregister_netdevice_many_notify+0x5e1/0xae0

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_filter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 274b6f7e6bb5..d170758a1eb5 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -338,7 +338,9 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		return;
 
 	if (n > 1) {
-		nf_unregister_net_hook(ctx->net, &found->ops);
+		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
+			nf_unregister_net_hook(ctx->net, &found->ops);
+
 		list_del_rcu(&found->list);
 		kfree_rcu(found, rcu);
 		return;
-- 
2.30.2

