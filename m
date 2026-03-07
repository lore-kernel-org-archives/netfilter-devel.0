Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8863101A9
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772904104; cv=none; b=Y4QR80l6IktUMxHZmjcqEGm4S/htVb+/xW12m50OTcRm4+9RyUKhMj+l7SVLA6ovjNBb2Cc4+5m1/tMohqAbOe6MMOkTLyP35zCoNgjk9SpDu5aNeIBkRLG9rBBqpJ6JOwxYWrHqyj7gmBKvuPbz5keCjJcep73WK2LAd/KghMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772904104; c=relaxed/simple;
	bh=obw9NEmMNv3ovLkGbluAsJMYRP851f/edRgphSVDAcg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SoSfMqlOZLVLpMTu6R6Z160A453rUCvFnVTdPGLu7QFvmn8roq7ETw5Lup+dJo6N6DFnCpmPDYCE6rF0lU3ohsjckxfpSjKr+TPZ2LD+SfdhVXD+xP+HF0CByjehjfF3F8Pys3OcHIpBMovGfHZSdOKFqouw2+PQw/G+rklQo6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xhaj2BcP; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xhaj2BcP"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-359866a1d02so6034092a91.0
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 09:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772904102; x=1773508902; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CC5icOgNQNOqgvtiMdx/aKHCLWBG2eflRi/wju2Pats=;
        b=Xhaj2BcP5GAEiQb3ue6iFKbKoybBqz1ado8YE8kzcTOJZR/2xxQIT3cbsM0uLAyA32
         riqzu4SFQQBt6+ERXwtEXlV4OC5k2s6zYEkaCjK+V3f+ZFGv/LPm8bmJTinysFwU1HBO
         Dni8E03eQ/O9QbNCs0Yc+Ov6+yeH9dJtAR0TkLGe/Cp7ra/jP1qLj3Iu/3qUqPpvbMCG
         2q75W1E/7HhSDZEb+6DFoZR56UiGJuDHm+AP/T3nKSPPoke6VxXpgfrwnfpFxO/B91+H
         Dp2HvcfGhQMF6Nl+jju8gljdOddNzrysAsvDWDqEpCOKsKEekwT38g9vLQRkqm7J5UO9
         q0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772904102; x=1773508902;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CC5icOgNQNOqgvtiMdx/aKHCLWBG2eflRi/wju2Pats=;
        b=oj1PR0fkpVWkHulB+ZIgM0tTngevpdRv27ZQqVHmYpDkAaXcnVxNmrwjf91ol5oB6N
         5k4aQWjVbBNt+kUxdekXY7TxjA1ta9a14O0lf4CvoDxkVRvSqSGuh9xpc8sbjn/KwiZb
         nkBRQZj0DdPc10InkMqhGpaQF9RX671gPfFJzScTou7/FMLwB1IyYsqVJc9SfXI7aDW/
         Se8AsOcGiIPjbuu6wxCasnfDoXx7lmYYI70XBLispDpcdNtVAgQ1fWEHmrHwbNQxcGkr
         8pBtRx1eE2Jc4vjNIy0Iqjg5+ziUjU0bQjIFnTpQvHyI6hT4SV1jkxZo534x498A+iEs
         sXEg==
X-Gm-Message-State: AOJu0YwKH2cLhj/CDavlmjP93Ozb2VxgRlQK3kt0+0gkdcvTc7FP/vyR
	Raf50ZJZpNUKUh2nMPkks3NIYC7jfgLBuVTzCrLjPw4oHnajdVtOgJYV
X-Gm-Gg: ATEYQzz00ZJO3GPz55PY92/Z3adaoBUBTRsr0UBaCjtAyh92L4qDmuXuSlwZCEVVWN4
	SragTMwwb2mr7QzEUU9tK7aVlBw6xzIOLcDA7gS/vft/i8G3a3JAWKSzmM73Rop9w0xfNDsKwa0
	nb9tlKIxGhpp63CU/8iqgbHLsAj2x/aERSNAn5jQ+ISeDyTSdNQ6aWJcK14rZTcKu3P46+BvnkW
	KXmldwj2RY7507r2lMIRVOjrQzBKiHTrr7SR0Cur0p5atUL+qs1TrTT/673z8T9QeUylYC6di4p
	dIbfWm1oWw+BFgIma2GF5U1QP2NYnpr6P93WaAxMRiLYw9UIoHN0Xqwr/9sFz9wPPGxgIK2/QOG
	a3FnMIVSrrNhN6FbwfXjCBiocHrgssUhpLYMSKPFw/GtzisYd/LnPXIpWa13rAkzvzUM1j8mCBu
	o4rmcS9nYYg7VBQh0Ik4eNYcavhvpfl4Ii8eq6f9Mprg==
X-Received: by 2002:a17:902:d48b:b0:2ae:51bb:9809 with SMTP id d9443c01a7336-2ae82444376mr63634715ad.36.1772904101970;
        Sat, 07 Mar 2026 09:21:41 -0800 (PST)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e9ca8fsm81074275ad.30.2026.03.07.09.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 09:21:41 -0800 (PST)
Date: Sun, 8 Mar 2026 02:21:37 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH net] netfilter: ctnetlink: fix use-after-free in
 ctnetlink_dump_exp_ct()
Message-ID: <aaxeoWfcuQJcZlkw@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

ctnetlink_dump_exp_ct() stores a conntrack pointer in cb->data for the
netlink dump callback ctnetlink_exp_ct_dump_table(), but drops the
conntrack reference immediately after netlink_dump_start().  When the
dump spans multiple rounds, the second recvmsg() triggers the dump
callback which dereferences the now-freed conntrack via nfct_help(ct),
leading to a use-after-free on ct->ext.

The bug is that the netlink_dump_control has no .start or .done
callbacks to manage the conntrack reference across dump rounds.  Other
dump functions in the same file (e.g. ctnetlink_get_conntrack) properly
use .start/.done callbacks for this purpose.

Fix this by adding .start and .done callbacks that hold and release the
conntrack reference for the duration of the dump, and move the
nfct_help() call after the cb->args[0] early-return check in the dump
callback to avoid dereferencing ct->ext unnecessarily.

KASAN report:

[    3.484270] BUG: KASAN: slab-use-after-free in ctnetlink_exp_ct_dump_table+0x4f/0x2e0
[    3.484508] Read of size 8 at addr ffff88810597ebf0 by task ctnetlink_poc/133
[    3.484717]
[    3.484772] CPU: 1 UID: 0 PID: 133 Comm: ctnetlink_poc Not tainted 7.0.0-rc2+ #3 PREEMPTLAZY
[    3.484775] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    3.484778] Call Trace:
[    3.484782]  <TASK>
[    3.484785]  dump_stack_lvl+0x64/0x80
[    3.484797]  print_report+0xce/0x660
[    3.484804]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    3.484811]  ? __kmalloc_large_node_noprof+0x1f/0xc0
[    3.484818]  ? __virt_addr_valid+0xef/0x1a0
[    3.484825]  ? ctnetlink_exp_ct_dump_table+0x4f/0x2e0
[    3.484827]  kasan_report+0xce/0x100
[    3.484829]  ? ctnetlink_exp_ct_dump_table+0x4f/0x2e0
[    3.484833]  ctnetlink_exp_ct_dump_table+0x4f/0x2e0
[    3.484836]  netlink_dump+0x333/0x880
[    3.484841]  ? __pfx_netlink_dump+0x10/0x10
[    3.484844]  ? netlink_recvmsg+0x27c/0x4b0
[    3.484847]  ? kmem_cache_free+0x100/0x440
[    3.484849]  ? netlink_recvmsg+0x27c/0x4b0
[    3.484851]  netlink_recvmsg+0x3e2/0x4b0
[    3.484855]  ? aa_sk_perm+0x184/0x450
[    3.484862]  ? __pfx_netlink_recvmsg+0x10/0x10
[    3.484864]  ? __pfx_aa_sk_perm+0x10/0x10
[    3.484866]  ? mutex_unlock+0x80/0xd0
[    3.484870]  ? __pfx_netlink_recvmsg+0x10/0x10
[    3.484873]  sock_recvmsg+0xde/0xf0
[    3.484880]  __sys_recvfrom+0x150/0x200
[    3.484882]  ? __pfx___sys_recvfrom+0x10/0x10
[    3.484885]  ? ksys_write+0xe1/0x160
[    3.484889]  ? __pfx_ksys_write+0x10/0x10
[    3.484891]  __x64_sys_recvfrom+0x76/0x90
[    3.484893]  do_syscall_64+0xc3/0x6e0
[    3.484898]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    3.484903] RIP: 0033:0x42366d
[    3.484907] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d fd 19 09 00 00 41 89 ca 74 20 45 31 c9 45 31 c0 b8 2d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 6b c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
[    3.484908] RSP: 002b:00007fffb7e89be8 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
[    3.484915] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000042366d
[    3.484916] RDX: 0000000000004000 RSI: 00007fffb7e8ac30 RDI: 0000000000000003
[    3.484920] RBP: 00007fffb7e8ec50 R08: 0000000000000000 R09: 0000000000000000
[    3.484921] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffb7e8ed68
[    3.484922] R13: 00007fffb7e8ed78 R14: 00000000004af868 R15: 0000000000000001
[    3.484924]  </TASK>
[    3.484925]
[    3.491086] Allocated by task 133:
[    3.491190]  kasan_save_stack+0x33/0x60
[    3.491308]  kasan_save_track+0x14/0x30
[    3.491425]  __kasan_slab_alloc+0x6e/0x70
[    3.491545]  kmem_cache_alloc_noprof+0x134/0x440
[    3.491683]  __nf_conntrack_alloc+0xa8/0x2b0
[    3.491815]  ctnetlink_create_conntrack+0xa1/0x900
[    3.491959]  ctnetlink_new_conntrack+0x3cf/0x7d0
[    3.492097]  nfnetlink_rcv_msg+0x48e/0x510
[    3.492223]  netlink_rcv_skb+0xc9/0x1f0
[    3.492339]  nfnetlink_rcv+0xdb/0x220
[    3.492450]  netlink_unicast+0x3ec/0x590
[    3.492568]  netlink_sendmsg+0x397/0x690
[    3.492687]  ____sys_sendmsg+0x538/0x550
[    3.492807]  ___sys_sendmsg+0xfc/0x170
[    3.492921]  __sys_sendmsg+0xf4/0x180
[    3.493032]  do_syscall_64+0xc3/0x6e0
[    3.493143]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    3.493293]
[    3.493344] Freed by task 0:
[    3.493433]  kasan_save_stack+0x33/0x60
[    3.493549]  kasan_save_track+0x14/0x30
[    3.493666]  kasan_save_free_info+0x3b/0x60
[    3.493795]  __kasan_slab_free+0x43/0x70
[    3.493913]  slab_free_after_rcu_debug+0xad/0x1e0
[    3.494051]  rcu_core+0x5c3/0x9c0
[    3.494148]  handle_softirqs+0x148/0x460
[    3.494260]  __irq_exit_rcu+0x97/0xf0
[    3.494363]  sysvec_apic_timer_interrupt+0x71/0x90
[    3.494495]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[    3.494635]
[    3.494682] Last potentially related work creation:
[    3.494815]  kasan_save_stack+0x33/0x60
[    3.494923]  kasan_record_aux_stack+0x8c/0xa0
[    3.495044]  kmem_cache_free+0x1f5/0x440
[    3.495153]  nf_conntrack_free+0xc1/0x140
[    3.495264]  ctnetlink_del_conntrack+0x4c4/0x520
[    3.495391]  nfnetlink_rcv_msg+0x48e/0x510
[    3.495505]  netlink_rcv_skb+0xc9/0x1f0
[    3.495611]  nfnetlink_rcv+0xdb/0x220
[    3.495714]  netlink_unicast+0x3ec/0x590
[    3.495823]  netlink_sendmsg+0x397/0x690
[    3.495932]  ____sys_sendmsg+0x538/0x550
[    3.496041]  ___sys_sendmsg+0xfc/0x170
[    3.496145]  __sys_sendmsg+0xf4/0x180
[    3.496248]  do_syscall_64+0xc3/0x6e0
[    3.496350]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    3.496487]
[    3.496534] The buggy address belongs to the object at ffff88810597eb40
[    3.496534]  which belongs to the cache nf_conntrack of size 248
[    3.496866] The buggy address is located 176 bytes inside of
[    3.496866]  freed 248-byte region [ffff88810597eb40, ffff88810597ec38)
[    3.497187]
[    3.497234] The buggy address belongs to the physical page:
[    3.497385] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810597e140 pfn:0x10597e
[    3.497632] flags: 0x200000000000200(workingset|node=0|zone=2)
[    3.497794] page_type: f5(slab)
[    3.497884] raw: 0200000000000200 ffff88810463fb40 ffff888104640410 ffff888104640410
[    3.498089] raw: ffff88810597e140 00000008000c0004 00000000f5000000 0000000000000000
[    3.498293] page dumped because: kasan: bad access detected
[    3.498442]
[    3.498489] Memory state around the buggy address:
[    3.498619]  ffff88810597ea80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    3.498812]  ffff88810597eb00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
[    3.499005] >ffff88810597eb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    3.499197]                                                              ^
[    3.499379]  ffff88810597ec00: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
[    3.499573]  ffff88810597ec80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    3.499765] ==================================================================

Fixes: e844a928431f ("netfilter: ctnetlink: allow to dump expectation per master conntrack")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c9d725fc2d71..65aa44a12d01 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3212,7 +3212,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nf_conn *ct = cb->data;
-	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conn_help *help;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 	unsigned long last_id = cb->args[1];
 	struct nf_conntrack_expect *exp;
@@ -3220,6 +3220,10 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	if (cb->args[0])
 		return 0;
 
+	help = nfct_help(ct);
+	if (!help)
+		return 0;
+
 	rcu_read_lock();
 
 restart:
@@ -3249,6 +3253,24 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int ctnetlink_dump_exp_ct_start(struct netlink_callback *cb)
+{
+	struct nf_conn *ct = cb->data;
+
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
+		return -ENOENT;
+	return 0;
+}
+
+static int ctnetlink_dump_exp_ct_done(struct netlink_callback *cb)
+{
+	struct nf_conn *ct = cb->data;
+
+	if (ct)
+		nf_ct_put(ct);
+	return 0;
+}
+
 static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 				 struct sk_buff *skb,
 				 const struct nlmsghdr *nlh,
@@ -3264,6 +3286,8 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
+		.start = ctnetlink_dump_exp_ct_start,
+		.done = ctnetlink_dump_exp_ct_done,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
-- 
2.43.0

