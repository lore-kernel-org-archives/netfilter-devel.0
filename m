Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387AD4A02;
	Sun,  8 Mar 2026 10:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772966785; cv=none; b=jLfXrP94/JqUvcyLFb4pdBYytL4eK1K+5Z1mYDHA7y+uEQiV1SEzxEiC3ltYe1Benp/XFfOeMNpb53j0kFeUl3x2aayWxHFHlYWwApJIh8P2a8cBSiEFCFPxvLa46J7a9ROZviwVuIYoQVv9aog5GSIKd9nyugfMthVRFWMqQ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772966785; c=relaxed/simple;
	bh=YP1Oa2fDXHorc7Eu0+C6ijFA2CUJVHcJ5jOZHEVxTyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVW+fxJ6eBsaLJs5vS/2heAfpQ5wzks5E2iofUVXTNeSj3oqnfHfmcmRCbVLW3e3gFYO/jnU5kIAJOR405iqb30bClS9JwLd9VZ36LvB6caPYVHGG9963akoFdeI6cIG5mr2o5yiIDEn+OSNVaFcp4Xwas2uUt+j49MT84v16hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lbnor7lA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lbnor7lA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CEE3A60338;
	Sun,  8 Mar 2026 11:46:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772966781;
	bh=kOHk9G53xuNeeSNXfbFpGJnMSZBLkYtMEuo30MxxD4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lbnor7lAiERPJu8ykpaVLxNeQsvNPeN6LA+pOhmDpzdkRHTHnduLTTtVTs9QP2RcW
	 Y07WiPuIcpxPFnZSm3jJV1o2Bls7OTaJ97MgvDHRgyJaq/5ICtszPR99HDZ9MLfWOp
	 8/p54tFTp4tyBjwkGMt0fN8kUI2C0apHTUWLiTfQ+RK+Ig7vlBQQYRmLyCrVvnu7N5
	 b6E/kb59AJFr/67c7ydSsugVJfkXlND6fePdZVv+pMs+CW1Ha6BOIZu5HzRc/tjUFT
	 /tBrXteRU8mSyku9BFelOF9SKRJ1exI098cQpsbxFqVNLvj1RiNUHp9bnravFhe0SM
	 mLWuibs2rONmA==
Date: Sun, 8 Mar 2026 11:46:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: ctnetlink: fix use-after-free of
 exp->master in single expectation GET
Message-ID: <aa1Te4_dE-GeMFpl@chamomile>
References: <aaxehlr7zbTj7dbe@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaxehlr7zbTj7dbe@v4bel>

On Sun, Mar 08, 2026 at 02:21:10AM +0900, Hyunwoo Kim wrote:
> ctnetlink_get_expect() in the non-dump path calls
> nf_ct_expect_find_get() which only takes a reference on the expectation
> itself, not on exp->master.  It then calls ctnetlink_exp_fill_info()
> which dereferences exp->master extensively (tuplehash, ct->ext via
> nfct_help()).
> 
> A concurrent conntrack deletion through NFNL_SUBSYS_CTNETLINK (a
> different nfnetlink subsystem mutex than NFNL_SUBSYS_CTNETLINK_EXP) can
> free the master conntrack while the single GET is in progress, leading
> to use-after-free.  In particular, kfree(ct->ext) is immediate and not
> RCU-deferred.
> 
> Fix this by taking a reference on exp->master under rcu_read_lock
> (required for SLAB_TYPESAFE_BY_RCU) before calling
> ctnetlink_exp_fill_info() and releasing it afterwards.
> 
> KASAN report:
> 
> [    6.526107] ==================================================================
> [    6.526345] BUG: KASAN: slab-use-after-free in ctnetlink_dump_tuples_ip+0xbc/0x1f0

Please, fix this with in the same patch, I suggest you call this patch: 
 
  netfilter: ctnetlink: hold reference on master conntrack when dumping expectation

it is the same class of bug.

Thanks

> [    6.526570] Read of size 2 at addr ffff8881042a8cb2 by task poc3/134
> [    6.526745]
> [    6.526798] CPU: 0 UID: 0 PID: 134 Comm: poc3 Not tainted 7.0.0-rc2+ #6 PREEMPTLAZY
> [    6.526801] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    6.526805] Call Trace:
> [    6.526808]  <TASK>
> [    6.526809]  dump_stack_lvl+0x64/0x80
> [    6.526821]  print_report+0xce/0x660
> [    6.526828]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [    6.526836]  ? kasan_save_stack+0x33/0x60
> [    6.526841]  ? __virt_addr_valid+0xef/0x1a0
> [    6.526848]  ? ctnetlink_dump_tuples_ip+0xbc/0x1f0
> [    6.526850]  kasan_report+0xce/0x100
> [    6.526852]  ? ctnetlink_dump_tuples_ip+0xbc/0x1f0
> [    6.526855]  ctnetlink_dump_tuples_ip+0xbc/0x1f0
> [    6.526858]  ? __pfx_ctnetlink_dump_tuples_ip+0x10/0x10
> [    6.526860]  ? ctnetlink_dump_tuples_proto+0x144/0x190
> [    6.526862]  ? skb_put+0x72/0xb0
> [    6.526868]  ctnetlink_dump_tuples+0x19/0x60
> [    6.526870]  ctnetlink_exp_dump_tuple+0x6f/0xd0
> [    6.526872]  ctnetlink_exp_dump_expect+0x315/0x660
> [    6.526875]  ? __pfx_ctnetlink_exp_dump_expect+0x10/0x10
> [    6.526878]  ? __kmalloc_node_track_caller_noprof+0x1c6/0x590
> [    6.526885]  ? kmalloc_reserve+0x75/0x160
> [    6.526887]  ? skb_put+0x72/0xb0
> [    6.526889]  ? __asan_memset+0x23/0x50
> [    6.526892]  ? __nlmsg_put+0x97/0xb0
> [    6.526897]  ctnetlink_exp_fill_info.constprop.0+0xf9/0x180
> [    6.526899]  ctnetlink_get_expect+0x2f3/0x400
> [    6.526901]  ? __pfx_ctnetlink_get_expect+0x10/0x10
> [    6.526903]  ? __pfx___nla_validate_parse+0x10/0x10
> [    6.526912]  ? mutex_lock+0x7e/0xd0
> [    6.526914]  ? __pfx_mutex_lock+0x10/0x10
> [    6.526917]  nfnetlink_rcv_msg+0x48e/0x510
> [    6.526922]  ? __pfx_nfnetlink_rcv_msg+0x10/0x10
> [    6.526925]  ? __sys_sendmsg+0xf4/0x180
> [    6.526927]  ? do_syscall_64+0xc3/0x6e0
> [    6.526930]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    6.526935]  netlink_rcv_skb+0xc9/0x1f0
> [    6.526937]  ? __pfx_nfnetlink_rcv_msg+0x10/0x10
> [    6.526940]  ? __pfx_netlink_rcv_skb+0x10/0x10
> [    6.526942]  ? security_capable+0xda/0x160
> [    6.526947]  nfnetlink_rcv+0xdb/0x220
> [    6.526951]  ? __pfx___netlink_lookup+0x10/0x10
> [    6.526953]  ? __pfx_nfnetlink_rcv+0x10/0x10
> [    6.526955]  ? netlink_deliver_tap+0x5f/0x400
> [    6.526958]  netlink_unicast+0x3ec/0x590
> [    6.526960]  ? __pfx_netlink_unicast+0x10/0x10
> [    6.526961]  ? __pfx___alloc_skb+0x10/0x10
> [    6.526963]  ? __alloc_frozen_pages_noprof+0x26f/0x560
> [    6.526966]  ? __virt_addr_valid+0xef/0x1a0
> [    6.526969]  ? __check_object_size+0x25f/0x450
> [    6.526973]  netlink_sendmsg+0x397/0x690
> [    6.526975]  ? __pfx_netlink_sendmsg+0x10/0x10
> [    6.526977]  ? __import_iovec+0x220/0x270
> [    6.526981]  ? __check_object_size+0x4b/0x450
> [    6.526983]  ____sys_sendmsg+0x538/0x550
> [    6.526987]  ? __pfx_____sys_sendmsg+0x10/0x10
> [    6.526990]  ? __pfx_copy_msghdr_from_user+0x10/0x10
> [    6.526992]  ? __pfx_lru_add+0x10/0x10
> [    6.526998]  ___sys_sendmsg+0xfc/0x170
> [    6.527000]  ? __pfx____sys_sendmsg+0x10/0x10
> [    6.527002]  ? __pfx_do_wp_page+0x10/0x10
> [    6.527008]  __sys_sendmsg+0xf4/0x180
> [    6.527010]  ? __pfx___sys_sendmsg+0x10/0x10
> [    6.527013]  ? do_user_addr_fault+0x3b5/0x750
> [    6.527015]  do_syscall_64+0xc3/0x6e0
> [    6.527017]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    6.527020] RIP: 0033:0x424304
> [    6.527025] Code: c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 00 f3 0f 1e fa 80 3d 5d 1d 09 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 20 89 55
> [    6.527027] RSP: 002b:00007ffcc8012368 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
> [    6.527033] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000424304
> [    6.527034] RDX: 0000000000000000 RSI: 00007ffcc80123a0 RDI: 0000000000000003
> [    6.527035] RBP: 00007ffcc80123e0 R08: 0000000000000000 R09: 0000000000000002
> [    6.527037] R10: 0000000020797380 R11: 0000000000000202 R12: 00007ffcc80175c8
> [    6.527038] R13: 00007ffcc80175d8 R14: 00000000004b0828 R15: 0000000000000001
> [    6.527040]  </TASK>
> [    6.527041]
> [    6.537631] Allocated by task 131:
> [    6.537736]  kasan_save_stack+0x33/0x60
> [    6.537853]  kasan_save_track+0x14/0x30
> [    6.537970]  __kasan_slab_alloc+0x6e/0x70
> [    6.538094]  kmem_cache_alloc_noprof+0x134/0x440
> [    6.538248]  __nf_conntrack_alloc+0xa8/0x2b0
> [    6.538391]  ctnetlink_create_conntrack+0xa1/0x900
> [    6.538547]  ctnetlink_new_conntrack+0x3cf/0x7d0
> [    6.538687]  nfnetlink_rcv_msg+0x48e/0x510
> [    6.538810]  netlink_rcv_skb+0xc9/0x1f0
> [    6.538926]  nfnetlink_rcv+0xdb/0x220
> [    6.539036]  netlink_unicast+0x3ec/0x590
> [    6.539155]  netlink_sendmsg+0x397/0x690
> [    6.539285]  ____sys_sendmsg+0x538/0x550
> [    6.539418]  ___sys_sendmsg+0xfc/0x170
> [    6.539545]  __sys_sendmsg+0xf4/0x180
> [    6.539658]  do_syscall_64+0xc3/0x6e0
> [    6.539769]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    6.539916]
> [    6.539967] Freed by task 0:
> [    6.540053]  kasan_save_stack+0x33/0x60
> [    6.540165]  kasan_save_track+0x14/0x30
> [    6.540281]  kasan_save_free_info+0x3b/0x60
> [    6.540406]  __kasan_slab_free+0x43/0x70
> [    6.540523]  slab_free_after_rcu_debug+0xad/0x1e0
> [    6.540664]  rcu_core+0x5c3/0x9c0
> [    6.540769]  handle_softirqs+0x148/0x460
> [    6.540892]  __irq_exit_rcu+0x97/0xf0
> [    6.541004]  sysvec_apic_timer_interrupt+0x71/0x90
> [    6.541149]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [    6.541304]
> [    6.541355] Last potentially related work creation:
> [    6.541498]  kasan_save_stack+0x33/0x60
> [    6.541614]  kasan_record_aux_stack+0x8c/0xa0
> [    6.541746]  kmem_cache_free+0x1f5/0x440
> [    6.541865]  nf_conntrack_free+0xc1/0x140
> [    6.541985]  ctnetlink_del_conntrack+0x4c4/0x520
> [    6.542126]  nfnetlink_rcv_msg+0x48e/0x510
> [    6.542249]  netlink_rcv_skb+0xc9/0x1f0
> [    6.542365]  nfnetlink_rcv+0xdb/0x220
> [    6.542475]  netlink_unicast+0x3ec/0x590
> [    6.542593]  netlink_sendmsg+0x397/0x690
> [    6.542711]  ____sys_sendmsg+0x538/0x550
> [    6.542830]  ___sys_sendmsg+0xfc/0x170
> [    6.542940]  __sys_sendmsg+0xf4/0x180
> [    6.543049]  do_syscall_64+0xc3/0x6e0
> [    6.543157]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    6.543301]
> [    6.543349] The buggy address belongs to the object at ffff8881042a8c80
> [    6.543349]  which belongs to the cache nf_conntrack of size 248
> [    6.543739] The buggy address is located 50 bytes inside of
> [    6.543739]  freed 248-byte region [ffff8881042a8c80, ffff8881042a8d78)
> [    6.544101]
> [    6.544152] The buggy address belongs to the physical page:
> [    6.544316] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881042a8500 pfn:0x1042a8
> [    6.544584] flags: 0x200000000000200(workingset|node=0|zone=2)
> [    6.544759] page_type: f5(slab)
> [    6.544859] raw: 0200000000000200 ffff88810485d500 ffff88810485fd10 ffff88810485fd10
> [    6.545083] raw: ffff8881042a8500 00000008000c0004 00000000f5000000 0000000000000000
> [    6.545308] page dumped because: kasan: bad access detected
> [    6.545469]
> [    6.545521] Memory state around the buggy address:
> [    6.545664]  ffff8881042a8b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [    6.545878]  ffff8881042a8c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [    6.546089] >ffff8881042a8c80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [    6.546300]                                      ^
> [    6.546442]  ffff8881042a8d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
> [    6.546654]  ffff8881042a8d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 
> Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index c9d725fc2d71..3225d4e98513 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3300,6 +3300,7 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
>  {
>  	u_int8_t u3 = info->nfmsg->nfgen_family;
>  	struct nf_conntrack_tuple tuple;
> +	struct nf_conn *master;
>  	struct nf_conntrack_expect *exp;
>  	struct nf_conntrack_zone zone;
>  	struct sk_buff *skb2;
> @@ -3354,10 +3355,19 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
>  	}
>  
>  	rcu_read_lock();
> +	master = exp->master;
> +	if (!refcount_inc_not_zero(&master->ct_general.use)) {
> +		rcu_read_unlock();
> +		nf_ct_expect_put(exp);
> +		kfree_skb(skb2);
> +		return -ENOENT;
> +	}
> +
>  	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).portid,
>  				      info->nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
>  				      exp);
>  	rcu_read_unlock();
> +	nf_ct_put(master);
>  	nf_ct_expect_put(exp);
>  	if (err <= 0) {
>  		kfree_skb(skb2);
> -- 
> 2.43.0
> 
