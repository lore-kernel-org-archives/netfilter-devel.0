Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432C0145B34;
	Thu, 13 Jun 2024 11:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279234; cv=none; b=CZ7YK/BxqTqanXC481yRLKV6ZhQ6YHss+x/ErTvophfQ/JfrFpDqk7Re+2DTctXFBBEfVW6V6vsX5AyLrNdCC9eq54FuLrIdCRrpxw7LpQAyfGyAOsz0yeh3E5zVZBODMvcyF63aBikoYjM2e4PmyM5QqPWX7Otj45KKrT/ctkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279234; c=relaxed/simple;
	bh=liMhZjm50fNfiazuOfgzRdDl/zXOqDT/RqYsld329b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty72SzelRIxwrwhrQQh9CiNzCwcOKHWkP42iTTo/a77b6GllsXITlpespPfS+DazN1DQgWYZcEfgi5LBTaXiGWzTYsOWBD9oRZ8TtO4bdWROu6klUCtGzPhhzvByRYk3ms73ont93Uaf8dd9PMg2X6SS1R/y+FA5yHWtcReg1j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7cKSe5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7cKSe5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD1C2BBFC;
	Thu, 13 Jun 2024 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279233;
	bh=liMhZjm50fNfiazuOfgzRdDl/zXOqDT/RqYsld329b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7cKSe5G4hr2fpmED97UcHob7/fRpKxnWKv+/+qZ0vaJA3nmHHBQHlwt8gnKnCj1C
	 k68sj5NCnft+Evt6thuDDjT60rJtyCM3eCXBlV3pVKBK/U9Zc1Q8UGDPEQL+kXcaB7
	 ktxHtNbCblTo92Rx5reMn0Ne16VtzYMkE0U/5x2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 179/213] netfilter: nf_tables: unregister flowtable hooks on netns exit
Date: Thu, 13 Jun 2024 13:33:47 +0200
Message-ID: <20240613113234.887608825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 net/netfilter/nf_tables_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7863,6 +7863,8 @@ static void __nft_release_table(struct n
 
 	list_for_each_entry(chain, &table->chains, list)
 		nf_tables_unregister_hook(net, table, chain);
+	list_for_each_entry(flowtable, &table->flowtables, list)
+		nft_unregister_flowtable_net_hooks(net, flowtable);
 	/* No packets are walking on these chains anymore. */
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {


