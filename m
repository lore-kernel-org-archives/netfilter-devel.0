Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0002539FEA;
	Fri, 24 Nov 2023 19:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeWhH/XT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BEDC433C7;
	Fri, 24 Nov 2023 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854126;
	bh=vFHS9QQ5nUcX6zCL7Kr9lTIHaDJM0jFHQa5d0A3gZwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeWhH/XTOwuXwjWd1zuhhnHl3IV6RuyJ4NBvN9MnzRTCQM70/8LK7UBtq+iQBG5Rb
	 QxQwjGUcjG0AorlBw/lXf5SO44eEyNzVCljgfTLJ1/zTVukm5x0KWCC3qnIReyBlfu
	 jq+l73uTAlJHRNo+5AIxa9gWidFdTmqMN7OYKm1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 154/159] netfilter: nf_tables: unregister flowtable hooks on netns exit
Date: Fri, 24 Nov 2023 17:56:11 +0000
Message-ID: <20231124171948.192831203@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8186,16 +8186,24 @@ int __nft_release_basechain(struct nft_c
 }
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
 
+static void __nft_release_hook(struct net *net, struct nft_table *table)
+{
+	struct nft_flowtable *flowtable;
+	struct nft_chain *chain;
+
+	list_for_each_entry(chain, &table->chains, list)
+		nf_tables_unregister_hook(net, table, chain);
+	list_for_each_entry(flowtable, &table->flowtables, list)
+		nft_unregister_flowtable_net_hooks(net, flowtable);
+}
+
 static void __nft_release_hooks(struct net *net)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_table *table;
-	struct nft_chain *chain;
 
-	list_for_each_entry(table, &nft_net->tables, list) {
-		list_for_each_entry(chain, &table->chains, list)
-			nf_tables_unregister_hook(net, table, chain);
-	}
+	list_for_each_entry(table, &nft_net->tables, list)
+		__nft_release_hook(net, table);
 }
 
 static void __nft_release_table(struct net *net, struct nft_table *table)


