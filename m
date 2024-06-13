Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D89338398;
	Thu, 13 Jun 2024 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240553; cv=none; b=ehdXYqyMjcvDQaiz6TrZiWTbhHezZdGEfqwnjuldHyvG8KFGqRuv6ruMk3z+/wYu5jTiFlJBKuv12EM0mJXlaE6QPfaXzHEwO86ffAeIL3qL2Zt5mB59fD9NCA8BZ0VtXgBsAK6FnIXenlnSKPq/mg+S4iazLoOnnMmaHIxhWoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240553; c=relaxed/simple;
	bh=cDRgaENBtUjY9YFDVTSQV0dO/lZ3NFM4p3xHDaTGT1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cPk2IRrH9eU9lOKXwmuhNfSPuXK8o288vQUI9Thsk2XchHkEWlEMHc5uFU7ztshDPMkPa4A0Pz/YsfG7KeTFcnHtDVU49W8E+hYd5rAW/bghcktvetJv9ycYDpTvKEtuU/lfojpoMCwrjJbKNbvsZTY/j4pcaQ5tQGPbWpbP2G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 21/40] netfilter: nf_tables: unregister flowtable hooks on netns exit
Date: Thu, 13 Jun 2024 03:01:50 +0200
Message-Id: <20240613010209.104423-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 6069da443bf65f513bb507bb21e2f87cfb1ad0b6 upstream.

Unregister flowtable hooks before they are releases via
nf_tables_flowtable_destroy() otherwise hook core reports UAF.

BUG: KASAN: use-after-free in nf_hook_entries_grow+0x5a7/0x700 net/netfilter/core.c:142 net/netfilter/core.c:142
Read of size 4 at addr ffff8880736f7438 by task syz-executor579/3666

CPU: 0 PID: 3666 Comm: syz-executor579 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 __dump_stack lib/dump_stack.c:88 [inline] lib/dump_stack.c:106
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106 lib/dump_stack.c:106
 print_address_description+0x65/0x380 mm/kasan/report.c:247 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 __kasan_report mm/kasan/report.c:433 [inline] mm/kasan/report.c:450
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:450 mm/kasan/report.c:450
 nf_hook_entries_grow+0x5a7/0x700 net/netfilter/core.c:142 net/netfilter/core.c:142
 __nf_register_net_hook+0x27e/0x8d0 net/netfilter/core.c:429 net/netfilter/core.c:429
 nf_register_net_hook+0xaa/0x180 net/netfilter/core.c:571 net/netfilter/core.c:571
 nft_register_flowtable_net_hooks+0x3c5/0x730 net/netfilter/nf_tables_api.c:7232 net/netfilter/nf_tables_api.c:7232
 nf_tables_newflowtable+0x2022/0x2cf0 net/netfilter/nf_tables_api.c:7430 net/netfilter/nf_tables_api.c:7430
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline] net/netfilter/nfnetlink.c:652
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline] net/netfilter/nfnetlink.c:652
 nfnetlink_rcv+0x10e6/0x2550 net/netfilter/nfnetlink.c:652 net/netfilter/nfnetlink.c:652

__nft_release_hook() calls nft_unregister_flowtable_net_hooks() which
only unregisters the hooks, then after RCU grace period, it is
guaranteed that no packets add new entries to the flowtable (no flow
offload rules and flowtable hooks are reachable from packet path), so it
is safe to call nf_flow_table_free() which cleans up the remaining
entries from the flowtable (both software and hardware) and it unbinds
the flow_block.

Fixes: ff4bf2f42a40 ("netfilter: nf_tables: add nft_unregister_flowtable_hook()")
Reported-by: syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1f303d29597e..719b30d6ec64 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7863,6 +7863,8 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 
 	list_for_each_entry(chain, &table->chains, list)
 		nf_tables_unregister_hook(net, table, chain);
+	list_for_each_entry(flowtable, &table->flowtables, list)
+		nft_unregister_flowtable_net_hooks(net, flowtable);
 	/* No packets are walking on these chains anymore. */
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {
-- 
2.30.2

