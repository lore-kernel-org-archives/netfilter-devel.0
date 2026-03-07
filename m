Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC74130BF6B
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772904036; cv=none; b=Sg4EEmg56pQ5iGtYYWJRFzIMFWhBRg6cVhKOVKlP/UU1wk8waN2ClnqzpHCRGz9US25QBrvp1Q3KflGAyq3Qe4fNwXYOT9DIx7S8eUD0v7Ebmc3d3XjqJCR2jrrnE89UrIZPAy5W2Smd0IeA9G2k3Zao7XBCmPS+gwrUoVGhCyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772904036; c=relaxed/simple;
	bh=fyETq3X2bZY58I4IM3hbdRRDgYFGM507fOLGvwvyxr8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LyXpYCzdTBmuRyR6kMFrjb5PTBNQgDz+c8KVO1Zks64UFDuUvOIujZUSs5s+TU1GdtuXD/vcOiRVwOxftSOspZfW6sgg6PL4ZwvkNMKZ8eIhe6gUuVLv1agur9SoEh0hsboij73yyKzke+CdewG4uMB0WypiaZitKxnQvm6bZmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FudCyQ6w; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FudCyQ6w"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae46fc8ec1so47136645ad.3
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 09:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772904034; x=1773508834; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zpSGTu6vacyeTzrMBC22WKYF49INeHhhnp+064qr4lU=;
        b=FudCyQ6ws+B4YAmH5LaiZKjHa+d4sLi3sdq9EHI6pL80Y+oMl6vZMHkzMqhDN4paI+
         SkDpbb5a2OVTXl6/jkjxoKHQZf0u5Z7r1f3SF80UR82OPIwrsyPtJA5YN+LBFR6tq7/i
         9XRYniPZGln7OULrOPRmNcHFiwbZ4eQhDBnmZR8ZS6ul11HWHqf54KOBKhu1Bnnt7ZAZ
         8aJGNcfJ1JI81GOfPtjeQnvYfCjqozNLAPF79J7jXpEWrL6K9jNbW4DB7JF74Kfj61uu
         RXXUQRbWCSv5GFkzg/X06o9iNhOzJ8EAbIg+2oaVVNMvHeHBr4uIEuShIvNfbpMaiUZm
         Ie/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772904034; x=1773508834;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zpSGTu6vacyeTzrMBC22WKYF49INeHhhnp+064qr4lU=;
        b=qcshaiAVhjVi7Ige3kF+EiG+w7+CtntgmcgZrrMSKzzp3bQjtwyOoTPUT49D70aKrM
         JpMClo4NeO5KRKtf5L0c19opgViYdIW0Fttki6u3LR+IlFYJQQLVDvNFOiWmos+RAb7o
         fhi7cMS2x0kmdIR7lMeIKsdLws8BPpHy2dfasGcyEigPib034zNOuBSgW1ZQmtHcplQZ
         3wXmT5qXS6OG64j+j3ijO6GfhLj497SZVsWLCbLHZMdxvhilvEjnHhsdddZSLbI+TqEa
         L34cf42DapUh//YCSLPi1+r8FkADhfaEpGt5fFSkPXae8WbKBCXF7VA2DGjw1zaKhRqu
         xk6g==
X-Gm-Message-State: AOJu0YywIaUguQSk1YKkeRT1hlnW5N1uPsX5uC6RatWfNUiPkfPEkd9X
	DY5Rk6wVewUgav8cL9T2Y7H3gL7lOsg3kJd7VLIePCBbhpXx0vLeiYx9
X-Gm-Gg: ATEYQzzYlIukwvdjnwplbprk7kPp6sW414ck3Hm5IBRRZAORdxNU0LNsBbB8SbRrtlS
	oVzjiAF/jCDOIzDuX6fM7LI3TnugWbw+Yt32dtyYu/N7q3srRRmFuTQGz9BVOxNqTVxTCTp9Min
	nrsMmzT5tB4TVvRN+Le1m2E7yVdGBvuhByBGcaRBovjeStVlHd7AwWL34I8PsB/3PvmfMOSdKm5
	Sqbzq2DeqIjs1p0VmTxGF/BpBNhRKN0hOajcPrwqQdzHNcVuSG/+uxh3WYYJjWp/CLIqOBjozGq
	QE+I+kaIAWy+syYCRxpCiyNsJcbohS5ccJ0Cx0rjT3iC+VJSwed7SSNDullMD/BAJvfPDgFNypQ
	Nyd4Okmz4xz/hbFKqMnXI9ZUP3e/PJJ8KJhnSL6gAALPoAMvmV/TP2JoeKR+XmVZSW/K7h1biev
	rgwwiV8Y4oyyxe2Ew6ePK1yF4IE54Am6okipEv8BmBDQ==
X-Received: by 2002:a17:903:1988:b0:2ab:2633:d981 with SMTP id d9443c01a7336-2ae82433dccmr58237875ad.32.1772904034079;
        Sat, 07 Mar 2026 09:20:34 -0800 (PST)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840ad92fsm93265705ad.77.2026.03.07.09.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 09:20:33 -0800 (PST)
Date: Sun, 8 Mar 2026 02:20:29 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH net] netfilter: ctnetlink: fix use-after-free of exp->master
 in expectation dump
Message-ID: <aaxeXUnPpqLUURrt@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

ctnetlink_exp_dump_table() iterates the expectation hash table under
rcu_read_lock and dereferences exp->master to access the master
conntrack's fields (ct_net, tuplehash, ct->ext).  However, expectations
do not hold a reference on exp->master.  A concurrent conntrack deletion
via NFNL_SUBSYS_CTNETLINK (a different nfnetlink subsystem mutex) can
free the master conntrack while the dump is in progress, leading to
use-after-free on ct->ext which is freed immediately by kfree().

Fix this by taking a reference on exp->master with
refcount_inc_not_zero() before accessing it.  If the master conntrack is
already being destroyed, skip the expectation.

KASAN report:

[    6.517462] ==================================================================
[    6.517694] BUG: KASAN: slab-use-after-free in ctnetlink_exp_dump_expect+0x584/0x660
[    6.517940] Read of size 1 at addr ffff888102b4ab00 by task poc2/135
[    6.518122]
[    6.518176] CPU: 1 UID: 0 PID: 135 Comm: poc2 Not tainted 7.0.0-rc2+ #5 PREEMPTLAZY
[    6.518179] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.518182] Call Trace:
[    6.518186]  <TASK>
[    6.518187]  dump_stack_lvl+0x64/0x80
[    6.518198]  print_report+0xce/0x660
[    6.518204]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    6.518213]  ? __virt_addr_valid+0xef/0x1a0
[    6.518219]  ? ctnetlink_exp_dump_expect+0x584/0x660
[    6.518221]  kasan_report+0xce/0x100
[    6.518224]  ? ctnetlink_exp_dump_expect+0x584/0x660
[    6.518226]  ctnetlink_exp_dump_expect+0x584/0x660
[    6.518228]  ? __pfx_ctnetlink_exp_dump_expect+0x10/0x10
[    6.518232]  ? kasan_save_track+0x14/0x30
[    6.518236]  ? skb_put+0x72/0xb0
[    6.518242]  ? __asan_memset+0x23/0x50
[    6.518246]  ? __nlmsg_put+0x97/0xb0
[    6.518250]  ctnetlink_exp_fill_info.constprop.0+0xf9/0x180
[    6.518253]  ctnetlink_exp_dump_table+0x24a/0x2e0
[    6.518255]  netlink_dump+0x333/0x880
[    6.518259]  ? __pfx_netlink_dump+0x10/0x10
[    6.518262]  ? __asan_memset+0x23/0x50
[    6.518264]  ? __pfx_mutex_lock+0x10/0x10
[    6.518267]  __netlink_dump_start+0x391/0x450
[    6.518269]  ctnetlink_get_expect+0x393/0x3f0
[    6.518271]  ? __pfx_ctnetlink_get_expect+0x10/0x10
[    6.518274]  ? __pfx_ctnetlink_exp_dump_table+0x10/0x10
[    6.518276]  ? __pfx___nla_validate_parse+0x10/0x10
[    6.518283]  ? mutex_lock+0x7e/0xd0
[    6.518285]  ? __pfx_mutex_lock+0x10/0x10
[    6.518288]  nfnetlink_rcv_msg+0x48e/0x510
[    6.518293]  ? __pfx_nfnetlink_rcv_msg+0x10/0x10
[    6.518296]  ? __sys_sendmsg+0xf4/0x180
[    6.518298]  ? do_syscall_64+0xc3/0x6e0
[    6.518302]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    6.518307]  netlink_rcv_skb+0xc9/0x1f0
[    6.518309]  ? __pfx_nfnetlink_rcv_msg+0x10/0x10
[    6.518311]  ? __pfx_netlink_rcv_skb+0x10/0x10
[    6.518313]  ? security_capable+0xda/0x160
[    6.518318]  nfnetlink_rcv+0xdb/0x220
[    6.518321]  ? __pfx___netlink_lookup+0x10/0x10
[    6.518324]  ? __pfx_nfnetlink_rcv+0x10/0x10
[    6.518326]  ? netlink_deliver_tap+0x5f/0x400
[    6.518329]  netlink_unicast+0x3ec/0x590
[    6.518331]  ? __pfx_netlink_unicast+0x10/0x10
[    6.518333]  ? __pfx___alloc_skb+0x10/0x10
[    6.518334]  ? __alloc_frozen_pages_noprof+0x26f/0x560
[    6.518340]  ? __virt_addr_valid+0xef/0x1a0
[    6.518342]  ? __check_object_size+0x25f/0x450
[    6.518347]  netlink_sendmsg+0x397/0x690
[    6.518349]  ? __pfx_netlink_sendmsg+0x10/0x10
[    6.518351]  ? __import_iovec+0x220/0x270
[    6.518355]  ? __check_object_size+0x4b/0x450
[    6.518357]  ____sys_sendmsg+0x538/0x550
[    6.518361]  ? __pfx_____sys_sendmsg+0x10/0x10
[    6.518363]  ? __pfx_copy_msghdr_from_user+0x10/0x10
[    6.518366]  ? __pfx_lru_add+0x10/0x10
[    6.518372]  ___sys_sendmsg+0xfc/0x170
[    6.518374]  ? __pfx____sys_sendmsg+0x10/0x10
[    6.518376]  ? __pfx_do_wp_page+0x10/0x10
[    6.518382]  __sys_sendmsg+0xf4/0x180
[    6.518384]  ? __pfx___sys_sendmsg+0x10/0x10
[    6.518387]  ? do_user_addr_fault+0x3b5/0x750
[    6.518389]  do_syscall_64+0xc3/0x6e0
[    6.518391]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    6.518393] RIP: 0033:0x4242c4
[    6.518398] Code: c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 00 f3 0f 1e fa 80 3d 9d 1d 09 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 20 89 55
[    6.518400] RSP: 002b:00007ffc8ae20558 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[    6.518406] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00000000004242c4
[    6.518408] RDX: 0000000000000000 RSI: 00007ffc8ae20590 RDI: 0000000000000003
[    6.518409] RBP: 00007ffc8ae205d0 R08: 0000000000000300 R09: 0000000000000002
[    6.518410] R10: 000000001109e380 R11: 0000000000000202 R12: 00007ffc8ae277b8
[    6.518412] R13: 00007ffc8ae277c8 R14: 00000000004b0828 R15: 0000000000000001
[    6.518413]  </TASK>
[    6.518414]
[    6.528830] Allocated by task 132:
[    6.528935]  kasan_save_stack+0x33/0x60
[    6.529053]  kasan_save_track+0x14/0x30
[    6.529169]  __kasan_krealloc+0xf4/0x180
[    6.529287]  krealloc_node_align_noprof+0x124/0x3c0
[    6.529434]  nf_ct_ext_add+0xd8/0x1a0
[    6.529556]  ctnetlink_create_conntrack+0x38d/0x900
[    6.529718]  ctnetlink_new_conntrack+0x3cf/0x7d0
[    6.529870]  nfnetlink_rcv_msg+0x48e/0x510
[    6.529993]  netlink_rcv_skb+0xc9/0x1f0
[    6.530109]  nfnetlink_rcv+0xdb/0x220
[    6.530219]  netlink_unicast+0x3ec/0x590
[    6.530336]  netlink_sendmsg+0x397/0x690
[    6.530453]  ____sys_sendmsg+0x538/0x550
[    6.530575]  ___sys_sendmsg+0xfc/0x170
[    6.530700]  __sys_sendmsg+0xf4/0x180
[    6.530823]  do_syscall_64+0xc3/0x6e0
[    6.530946]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    6.531100]
[    6.531151] Freed by task 132:
[    6.531244]  kasan_save_stack+0x33/0x60
[    6.531359]  kasan_save_track+0x14/0x30
[    6.531475]  kasan_save_free_info+0x3b/0x60
[    6.531601]  __kasan_slab_free+0x43/0x70
[    6.531731]  kfree+0x1ca/0x430
[    6.531836]  nf_conntrack_free+0xb2/0x140
[    6.531969]  ctnetlink_del_conntrack+0x4c4/0x520
[    6.532113]  nfnetlink_rcv_msg+0x48e/0x510
[    6.532235]  netlink_rcv_skb+0xc9/0x1f0
[    6.532350]  nfnetlink_rcv+0xdb/0x220
[    6.532462]  netlink_unicast+0x3ec/0x590
[    6.532579]  netlink_sendmsg+0x397/0x690
[    6.532702]  ____sys_sendmsg+0x538/0x550
[    6.532831]  ___sys_sendmsg+0xfc/0x170
[    6.532958]  __sys_sendmsg+0xf4/0x180
[    6.533079]  do_syscall_64+0xc3/0x6e0
[    6.533192]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    6.533341]
[    6.533392] The buggy address belongs to the object at ffff888102b4ab00
[    6.533392]  which belongs to the cache kmalloc-128 of size 128
[    6.533749] The buggy address is located 0 bytes inside of
[    6.533749]  freed 128-byte region [ffff888102b4ab00, ffff888102b4ab80)
[    6.534113]
[    6.534163] The buggy address belongs to the physical page:
[    6.534324] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x102b4a
[    6.534550] flags: 0x200000000000000(node=0|zone=2)
[    6.534696] page_type: f5(slab)
[    6.534794] raw: 0200000000000000 ffff888100041a00 dead000000000122 0000000000000000
[    6.535036] raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
[    6.535284] page dumped because: kasan: bad access detected
[    6.535450]
[    6.535500] Memory state around the buggy address:
[    6.535641]  ffff888102b4aa00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    6.535852]  ffff888102b4aa80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    6.536075] >ffff888102b4ab00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    6.536306]                    ^
[    6.536411]  ffff888102b4ab80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    6.536619]  ffff888102b4ac00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    6.536829] ==================================================================

Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c9d725fc2d71..261ff4c67719 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3167,6 +3167,7 @@ static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
+	struct nf_conn *master;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 	unsigned long last_id = cb->args[1];
@@ -3180,12 +3181,20 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;

-			if (!net_eq(nf_ct_net(exp->master), net))
+			master = exp->master;
+			if (!refcount_inc_not_zero(&master->ct_general.use))
 				continue;

+			if (!net_eq(nf_ct_net(master), net)) {
+				nf_ct_put(master);
+				continue;
+			}
+
 			if (cb->args[1]) {
-				if (ctnetlink_exp_id(exp) != last_id)
+				if (ctnetlink_exp_id(exp) != last_id) {
+					nf_ct_put(master);
 					continue;
+				}
 				cb->args[1] = 0;
 			}
 			if (ctnetlink_exp_fill_info(skb,
@@ -3194,8 +3203,11 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 						    IPCTNL_MSG_EXP_NEW,
 						    exp) < 0) {
 				cb->args[1] = ctnetlink_exp_id(exp);
+				nf_ct_put(master);
 				goto out;
 			}
+
+			nf_ct_put(master);
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
--
2.43.0
