Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC029346FC0;
	Fri, 30 Jan 2026 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769789566; cv=none; b=VvNL0enCrGCNM78m+WCPcLR7pV8CwXDjrRBBBpB+nChdAVygQj7dl1EiJ/7AVxo1c9IADp/LfgfuBV8Iq/zciKrPpF3uSkOlEsm9C2RlP897mR9P5LQj/TVyWrAT/sxOD0jQ2ixKaTnWoUYljHNCH/Dyvs5TyIyuZxn2NC9DbqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769789566; c=relaxed/simple;
	bh=5FpF+unw/mdOHQXHU16Qky7WGtQQgRP31arQlU89V0s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JrAOzAEqfG5djmcE34nQcE3AcCPr3BF1ygqazPjzjI0PGK7xwIcAzje1BwLzhL6m2rm+yNZdwZSpu5ULPjJuudH5UY5IjZDBZPJ043Ea+CqJ8rNyTA0wOyj0ZNYUmi6NSb6Qd1yiScolAFq9tZbMSUzSxSq9qwdDPpkhnv4WCUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehr3e2NW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehr3e2NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6A9C116C6;
	Fri, 30 Jan 2026 16:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769789566;
	bh=5FpF+unw/mdOHQXHU16Qky7WGtQQgRP31arQlU89V0s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ehr3e2NWZED4/KsaDSqMd+HreM6aTAtzlcKWNyn1/KsXqmL/rIcDAuBoz5CaEnbRo
	 kIUNZZcZT1JbtmjEf+rmaSNvRfDZDOcoUFOnnQSa1I++jqzlEdSwtPEFsjrEq7VGTC
	 LQ5TyDimDMVujRPRDHVbEVTwRgBYog3sdofFxxDXZ+h5v/bZLUCXWGwEBt3AvZ0rMw
	 Aw+IGeQQJ/peu2CXhgQAitQmWn2ihcNXMb71GZ/Eut8AG9MDNWTDbSZiztbx5bIHAm
	 5EPVgfU2OUaAa9Y1UX0ZfOXsPd+kvzitSVPflf7yVuD0kpUmJUKyNcDRBlcYnPuJFA
	 0Kq0GeNNlzcTQ==
Date: Fri, 30 Jan 2026 08:12:45 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH v2 net-next 0/7] netfilter: updates for net-next
Message-ID: <20260130081245.6cacdde2@kernel.org>
In-Reply-To: <20260129105427.12494-1-fw@strlen.de>
References: <20260129105427.12494-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Jan 2026 11:54:20 +0100 Florian Westphal wrote:
> v2: discard buggy nfqueue patch, no other changes.
> 
> The following patchset contains Netfilter updates for *net-next*:
> 
> Patches 1 to 4 add IP6IP6 tunneling acceleration to the flowtable
> infrastructure.  Patch 5 extends test coverage for this.
> From Lorenzo Bianconi.
> 
> Patch 6 removes a duplicated helper from xt_time extension, we can
> use an existing helper for this, from Jinjie Ruan.
> 
> Patch 7 adds an rhashtable to nfnetink_queue to speed up out-of-order
> verdict processing.  Before this list walk was required due to in-order
> design assumption.

Hi Florian, some more KASAN today:

https://netdev-ctrl.bots.linux.dev/logs/vmksft/nf-dbg/results/496421/vm-crash-thr0-0

[ 1144.170509][   T12] ==================================================================
[ 1144.170759][   T12] BUG: KASAN: slab-use-after-free in idr_for_each+0x1c1/0x1f0
[ 1144.170922][   T12] Read of size 8 at addr ff11000012a16a70 by task kworker/u16:0/12
[ 1144.171079][   T12] 
[ 1144.171133][   T12] CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.19.0-rc7-virtme #1 PREEMPT(full) 
[ 1144.171137][   T12] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1144.171139][   T12] Workqueue: netns cleanup_net
[ 1144.171145][   T12] Call Trace:
[ 1144.171147][   T12]  <TASK>
[ 1144.171149][   T12]  dump_stack_lvl+0x6f/0xa0
[ 1144.171154][   T12]  print_address_description.constprop.0+0x6e/0x300
[ 1144.171159][   T12]  print_report+0xfc/0x1fb
[ 1144.171161][   T12]  ? idr_for_each+0x1c1/0x1f0
[ 1144.171163][   T12]  ? __virt_addr_valid+0x1da/0x430
[ 1144.171167][   T12]  ? idr_for_each+0x1c1/0x1f0
[ 1144.171168][   T12]  kasan_report+0xe8/0x120
[ 1144.171172][   T12]  ? idr_for_each+0x1c1/0x1f0
[ 1144.171174][   T12]  ? rtnl_net_notifyid+0x1a0/0x1a0
[ 1144.171176][   T12]  idr_for_each+0x1c1/0x1f0
[ 1144.171178][   T12]  ? idr_find+0x70/0x70
[ 1144.171180][   T12]  ? __lock_release.isra.0+0x59/0x170
[ 1144.171184][   T12]  ? __up_write+0x283/0x4f0
[ 1144.171185][   T12]  ? cleanup_net+0x1f2/0x810
[ 1144.171187][   T12]  cleanup_net+0x260/0x810
[ 1144.171188][   T12]  ? lock_acquire.part.0+0xbc/0x260
[ 1144.171190][   T12]  ? process_one_work+0xd16/0x1390
[ 1144.171193][   T12]  ? net_passive_dec+0x190/0x190
[ 1144.171194][   T12]  ? rcu_is_watching+0x15/0xd0
[ 1144.171197][   T12]  ? process_one_work+0xd16/0x1390
[ 1144.171198][   T12]  ? lock_acquire+0x10a/0x150
[ 1144.171199][   T12]  ? rcu_is_watching+0x15/0xd0
[ 1144.171201][   T12]  process_one_work+0xd57/0x1390
[ 1144.171204][   T12]  ? pwq_dec_nr_in_flight+0x700/0x700
[ 1144.171205][   T12]  ? lock_acquire.part.0+0xbc/0x260
[ 1144.171208][   T12]  ? assign_work+0x152/0x380
[ 1144.171209][   T12]  worker_thread+0x4d6/0xd40
[ 1144.171212][   T12]  ? process_one_work+0x1390/0x1390
[ 1144.171213][   T12]  kthread+0x355/0x5b0
[ 1144.171215][   T12]  ? kthread_is_per_cpu+0xe0/0xe0
[ 1144.171217][   T12]  ? __lock_release.isra.0+0x59/0x170
[ 1144.171219][   T12]  ? rcu_is_watching+0x15/0xd0
[ 1144.171220][   T12]  ? kthread_is_per_cpu+0xe0/0xe0
[ 1144.171221][   T12]  ret_from_fork+0x3fb/0x510
[ 1144.171225][   T12]  ? arch_exit_to_user_mode_prepare.isra.0+0x140/0x140
[ 1144.171228][   T12]  ? __switch_to+0x53c/0xd00
[ 1144.171230][   T12]  ? kthread_is_per_cpu+0xe0/0xe0
[ 1144.171231][   T12]  ret_from_fork_asm+0x11/0x20
[ 1144.171235][   T12]  </TASK>
[ 1144.171236][   T12] 
[ 1144.175222][   T12] Allocated by task 32108:
[ 1144.175317][   T12]  kasan_save_stack+0x30/0x50
[ 1144.175407][   T12]  kasan_save_track+0x14/0x30
[ 1144.175493][   T12]  __kasan_slab_alloc+0x5f/0x70
[ 1144.175580][   T12]  kmem_cache_alloc_noprof+0x226/0x6e0
[ 1144.175675][   T12]  radix_tree_node_alloc.constprop.0+0x176/0x340
[ 1144.175790][   T12]  idr_get_free+0x326/0x840
[ 1144.175878][   T12]  idr_alloc_u32+0x14a/0x2e0
[ 1144.175966][   T12]  idr_alloc+0x7d/0xc0
[ 1144.176033][   T12]  peernet2id_alloc+0x22c/0x340
[ 1144.176122][   T12]  __dev_change_net_namespace+0x8e5/0x1980
[ 1144.176232][   T12]  do_setlink.isra.0+0x211/0x25d0
[ 1144.176325][   T12]  rtnl_newlink+0x75c/0xe90
[ 1144.176416][   T12]  rtnetlink_rcv_msg+0x6fe/0xb90
[ 1144.176503][   T12]  netlink_rcv_skb+0x123/0x380
[ 1144.176590][   T12]  netlink_unicast+0x4a3/0x770
[ 1144.176678][   T12]  netlink_sendmsg+0x735/0xc60
[ 1144.176767][   T12]  ____sys_sendmsg+0x419/0x850
[ 1144.176852][   T12]  ___sys_sendmsg+0xfd/0x180
[ 1144.176943][   T12]  __sys_sendmsg+0x124/0x1c0
[ 1144.177031][   T12]  do_syscall_64+0xbd/0xfc0
[ 1144.177118][   T12]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[ 1144.177225][   T12] 
[ 1144.177268][   T12] Freed by task 12:
[ 1144.177335][   T12]  kasan_save_stack+0x30/0x50
[ 1144.177422][   T12]  kasan_save_track+0x14/0x30
[ 1144.177507][   T12]  kasan_save_free_info+0x3b/0x60
[ 1144.177599][   T12]  __kasan_slab_free+0x43/0x70
[ 1144.177690][   T12]  kmem_cache_free+0xfe/0x5e0
[ 1144.177780][   T12]  rcu_do_batch+0x28b/0xfe0
[ 1144.177873][   T12]  rcu_core+0x2b4/0x5f0
[ 1144.177944][   T12]  handle_softirqs+0x1d7/0x840
[ 1144.178030][   T12]  irq_exit_rcu+0xa2/0xf0
[ 1144.178095][   T12]  sysvec_apic_timer_interrupt+0x9d/0xe0
[ 1144.178188][   T12]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[ 1144.178295][   T12] 
[ 1144.178340][   T12] Last potentially related work creation:
[ 1144.178425][   T12]  kasan_save_stack+0x30/0x50
[ 1144.178513][   T12]  kasan_record_aux_stack+0x8c/0xa0
[ 1144.178599][   T12]  __call_rcu_common.constprop.0+0xa6/0xa00
[ 1144.178705][   T12]  delete_node+0x198/0x810
[ 1144.178792][   T12]  radix_tree_delete_item+0xc5/0x1b0
[ 1144.178889][   T12]  unhash_nsid_callback+0xb4/0x100
[ 1144.178972][   T12]  idr_for_each+0x108/0x1f0
[ 1144.179057][   T12]  cleanup_net+0x260/0x810
[ 1144.179141][   T12]  process_one_work+0xd57/0x1390
[ 1144.179224][   T12]  worker_thread+0x4d6/0xd40
[ 1144.179308][   T12]  kthread+0x355/0x5b0
[ 1144.179372][   T12]  ret_from_fork+0x3fb/0x510
[ 1144.179462][   T12]  ret_from_fork_asm+0x11/0x20
[ 1144.179552][   T12] 
[ 1144.179597][   T12] The buggy address belongs to the object at ff11000012a16a38
[ 1144.179597][   T12]  which belongs to the cache radix_tree_node of size 576
[ 1144.179825][   T12] The buggy address is located 56 bytes inside of
[ 1144.179825][   T12]  freed 576-byte region [ff11000012a16a38, ff11000012a16c78)
[ 1144.180038][   T12] 
[ 1144.180085][   T12] The buggy address belongs to the physical page:
[ 1144.180191][   T12] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xff11000012a17848 pfn:0x12a14
[ 1144.180374][   T12] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[ 1144.180506][   T12] flags: 0x80000000000240(workingset|head|node=0|zone=1)
[ 1144.180617][   T12] page_type: f5(slab)
[ 1144.180689][   T12] raw: 0080000000000240 ff11000001043700 ffd40000004ab810 ffd40000008b6d10
[ 1144.180850][   T12] raw: ff11000012a17848 000000000016000e 00000000f5000000 0000000000000000
[ 1144.180998][   T12] head: 0080000000000240 ff11000001043700 ffd40000004ab810 ffd40000008b6d10
[ 1144.181151][   T12] head: ff11000012a17848 000000000016000e 00000000f5000000 0000000000000000
[ 1144.181305][   T12] head: 0080000000000002 ffd40000004a8501 00000000ffffffff 00000000ffffffff
[ 1144.181459][   T12] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[ 1144.181612][   T12] page dumped because: kasan: bad access detected
[ 1144.181723][   T12] 
[ 1144.181770][   T12] Memory state around the buggy address:
[ 1144.181853][   T12]  ff11000012a16900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1144.181993][   T12]  ff11000012a16980: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
[ 1144.182116][   T12] >ff11000012a16a00: fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb
[ 1144.182238][   T12]                                                              ^
[ 1144.182362][   T12]  ff11000012a16a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1144.182497][   T12]  ff11000012a16b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1144.182618][   T12] ==================================================================
[ 1144.182760][   T12] Disabling lock debugging due to kernel taint
