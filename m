Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2676D1F0E51;
	Wed, 12 Mar 2025 23:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821504; cv=none; b=qsmM4HoLKxsjm2LcIywHS94LZ3e6172SArpApvW9PLlY1xpI+0y7l6fzOncKSE0kXmotq4kVADAUAxlyCdKhIfoFRlmBtLb/3bn6qqxlaEjmt49TSQ5YmMpfKqjVyOEb9LSne29jTy3TZhxVmlppnRDU+KHkKD7Q8A+9k5oFcoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821504; c=relaxed/simple;
	bh=U25XPuZChGih5sMqbblu+4+hSDFhayuJxQqCvl0h7+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lj+T07oiCQZn/BPby1LyTDZP6hY6aKQPsSTVJ3gviI4W59RtzW6EiNKQyiIhZD0IVbtfnf+zFLKBj63pj2CzsSgihm1EzvXJaWGeOwbQ93+sSMPRw8ZVwfvSDu22ajHRTNdnz/h6AFLJy81iNzm4gsDf98hbCIHYl6AEIOsZnQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DF7w9czB; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cqiB4q4a; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DF7w9czB";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cqiB4q4a"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C35F46028B; Thu, 13 Mar 2025 00:18:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821501;
	bh=s+Y/PTpwDLFLlDO+a9HwUA8HkC9QAepkO6/zuXcY8HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DF7w9czBYe8ammjyohI7D1Tfb8eQtp6LfrDV0Xi+0X4ox0Y/39YHb+gckoxVGHUtF
	 F6Cyl7zMy30X60AKonIFjAqiwYsh6BxCR7TiDbpSIyrcSkRYfF3J2sl4rSsKtU2A25
	 vwod2nBarvCFrfxyN4EQFPEbME70g27XmWAgaz2MCt6gSLZQrNZP87URXFKkS2FgWj
	 nj8y63LkuzyLGvIH0X5932VmQ4ZL/pbWMM0h3vTr7N6cF+yxO4iRBeg4dCGNYieSXh
	 nWh8M0nNDN7RDRahTTY8rtV26xHI4AO2+54Bg/fMwWE+RtGALXOkEllI+dlaTyMuTr
	 Ak9ht1a6ZWXIw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7DE6F6029E;
	Thu, 13 Mar 2025 00:18:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821500;
	bh=s+Y/PTpwDLFLlDO+a9HwUA8HkC9QAepkO6/zuXcY8HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqiB4q4aj416mTimypX/Y5b+YRkE+swbY2LC09sAV1o1DHXlx4ua4rb0vKpfTmkNL
	 iChG0qTpkfH0pXFxasCUZFuR3hk3GUoRFMd/5m81HXGRuVyvDbZqHNcnUj8DiTVpKA
	 +cGyuKZiovIP7P3hJYTQngAL6AfjMXURArnirCQxE5MLaDZbaiZuSW9GOUIUbetoNO
	 M3tlQJvhcrIITl5cSR+wcueyJC/2kHjByQXklbKtMSkbUbhqsGVJhjmSz6+vUYk+Yh
	 rHvhu8PEjZAYgOf3kICNKRQ2BtMaaaVGNntb0mvKR6HheM3RnRQXgYatO4WeO2+L/3
	 GhkbMAe6CcsUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/3] netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()
Date: Thu, 13 Mar 2025 00:18:10 +0100
Message-Id: <20250312231812.4091-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250312231812.4091-1-pablo@netfilter.org>
References: <20250312231812.4091-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kohei Enju <enjuk@amazon.com>

Since commit b36e4523d4d5 ("netfilter: nf_conncount: fix garbage
collection confirm race"), `cpu` and `jiffies32` were introduced to
the struct nf_conncount_tuple.

The commit made nf_conncount_add() initialize `conn->cpu` and
`conn->jiffies32` when allocating the struct.
In contrast, count_tree() was not changed to initialize them.

By commit 34848d5c896e ("netfilter: nf_conncount: Split insert and
traversal"), count_tree() was split and the relevant allocation
code now resides in insert_tree().
Initialize `conn->cpu` and `conn->jiffies32` in insert_tree().

BUG: KMSAN: uninit-value in find_or_evict net/netfilter/nf_conncount.c:117 [inline]
BUG: KMSAN: uninit-value in __nf_conncount_add+0xd9c/0x2850 net/netfilter/nf_conncount.c:143
 find_or_evict net/netfilter/nf_conncount.c:117 [inline]
 __nf_conncount_add+0xd9c/0x2850 net/netfilter/nf_conncount.c:143
 count_tree net/netfilter/nf_conncount.c:438 [inline]
 nf_conncount_count+0x82f/0x1e80 net/netfilter/nf_conncount.c:521
 connlimit_mt+0x7f6/0xbd0 net/netfilter/xt_connlimit.c:72
 __nft_match_eval net/netfilter/nft_compat.c:403 [inline]
 nft_match_eval+0x1a5/0x300 net/netfilter/nft_compat.c:433
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x426/0x2290 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x1a5/0x230 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_slow_list+0x24d/0x860 net/netfilter/core.c:663
 NF_HOOK_LIST include/linux/netfilter.h:350 [inline]
 ip_sublist_rcv+0x17b7/0x17f0 net/ipv4/ip_input.c:633
 ip_list_rcv+0x9ef/0xa40 net/ipv4/ip_input.c:669
 __netif_receive_skb_list_ptype net/core/dev.c:5936 [inline]
 __netif_receive_skb_list_core+0x15c5/0x1670 net/core/dev.c:5983
 __netif_receive_skb_list net/core/dev.c:6035 [inline]
 netif_receive_skb_list_internal+0x1085/0x1700 net/core/dev.c:6126
 netif_receive_skb_list+0x5a/0x460 net/core/dev.c:6178
 xdp_recv_frames net/bpf/test_run.c:280 [inline]
 xdp_test_run_batch net/bpf/test_run.c:361 [inline]
 bpf_test_run_xdp_live+0x2e86/0x3480 net/bpf/test_run.c:390
 bpf_prog_test_run_xdp+0xf1d/0x1ae0 net/bpf/test_run.c:1316
 bpf_prog_test_run+0x5e5/0xa30 kernel/bpf/syscall.c:4407
 __sys_bpf+0x6aa/0xd90 kernel/bpf/syscall.c:5813
 __do_sys_bpf kernel/bpf/syscall.c:5902 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5900 [inline]
 __ia32_sys_bpf+0xa0/0xe0 kernel/bpf/syscall.c:5900
 ia32_sys_call+0x394d/0x4180 arch/x86/include/generated/asm/syscalls_32.h:358
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:387
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:412
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:450
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4121 [inline]
 slab_alloc_node mm/slub.c:4164 [inline]
 kmem_cache_alloc_noprof+0x915/0xe10 mm/slub.c:4171
 insert_tree net/netfilter/nf_conncount.c:372 [inline]
 count_tree net/netfilter/nf_conncount.c:450 [inline]
 nf_conncount_count+0x1415/0x1e80 net/netfilter/nf_conncount.c:521
 connlimit_mt+0x7f6/0xbd0 net/netfilter/xt_connlimit.c:72
 __nft_match_eval net/netfilter/nft_compat.c:403 [inline]
 nft_match_eval+0x1a5/0x300 net/netfilter/nft_compat.c:433
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x426/0x2290 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x1a5/0x230 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_slow_list+0x24d/0x860 net/netfilter/core.c:663
 NF_HOOK_LIST include/linux/netfilter.h:350 [inline]
 ip_sublist_rcv+0x17b7/0x17f0 net/ipv4/ip_input.c:633
 ip_list_rcv+0x9ef/0xa40 net/ipv4/ip_input.c:669
 __netif_receive_skb_list_ptype net/core/dev.c:5936 [inline]
 __netif_receive_skb_list_core+0x15c5/0x1670 net/core/dev.c:5983
 __netif_receive_skb_list net/core/dev.c:6035 [inline]
 netif_receive_skb_list_internal+0x1085/0x1700 net/core/dev.c:6126
 netif_receive_skb_list+0x5a/0x460 net/core/dev.c:6178
 xdp_recv_frames net/bpf/test_run.c:280 [inline]
 xdp_test_run_batch net/bpf/test_run.c:361 [inline]
 bpf_test_run_xdp_live+0x2e86/0x3480 net/bpf/test_run.c:390
 bpf_prog_test_run_xdp+0xf1d/0x1ae0 net/bpf/test_run.c:1316
 bpf_prog_test_run+0x5e5/0xa30 kernel/bpf/syscall.c:4407
 __sys_bpf+0x6aa/0xd90 kernel/bpf/syscall.c:5813
 __do_sys_bpf kernel/bpf/syscall.c:5902 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5900 [inline]
 __ia32_sys_bpf+0xa0/0xe0 kernel/bpf/syscall.c:5900
 ia32_sys_call+0x394d/0x4180 arch/x86/include/generated/asm/syscalls_32.h:358
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:387
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:412
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:450
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Reported-by: syzbot+83fed965338b573115f7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83fed965338b573115f7
Fixes: b36e4523d4d5 ("netfilter: nf_conncount: fix garbage collection confirm race")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index ebe38ed2e6f4..913ede2f57f9 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -377,6 +377,8 @@ insert_tree(struct net *net,
 
 	conn->tuple = *tuple;
 	conn->zone = *zone;
+	conn->cpu = raw_smp_processor_id();
+	conn->jiffies32 = (u32)jiffies;
 	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
 	nf_conncount_list_init(&rbconn->list);
-- 
2.30.2

