Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502A823E23C;
	Thu, 29 Jan 2026 05:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769662995; cv=none; b=E7CMui0ORzaZKy/ejmp2BHjdvQeHQEQiv4JTj3JAtMdcOpk0s3SnwoWmEKa78xhIZRzwvU5Ihi1FVJgvXVTvNQA0B6+gVWToEOZ9Y3K8tlLOdjq1NmVdazSqbvv5oSwy127xazB0nv2wWmG/77MNBpAV5EXO4AcAqMunXziYvFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769662995; c=relaxed/simple;
	bh=FSYXvM5sO4UQQpej7ya3OLzvJoccIqure6UL7QrXwR4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2+ammZn/NWv1YXqePMsDzcx34h5DTReKEVIT29zsQx/tJ56zul400Gb0pTOYbrEPYQBDaRtLllTUnLoAgvz+O4IeKMd23yi8wiIs2JZMACi1FFP0fo6t0BWD2qpiTAGNY2EGLtQZhOkTbOLFEWajimf9lOxTRBZj7+9ev3WMqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyxTQdwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyxTQdwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD2BC116D0;
	Thu, 29 Jan 2026 05:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769662994;
	bh=FSYXvM5sO4UQQpej7ya3OLzvJoccIqure6UL7QrXwR4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XyxTQdwrtz4oCFt6tWSMMC5jniBpVx7zs9aObMUn6VYM++JhV2H1VWFyckVLnXwYJ
	 SnJFTX5i9FvD/+98OfGB3ut6wdZeWWaCnZud97CTdsHfwpk31r0sbTxduphKpN7dHw
	 67wx0YhTfqv2Eh7Hq5b4VEcTfHwBFELMAABPVHi3wIeywSX8rsoiNE7ZT6Tu7Rx6HV
	 mWCGZCvznZqIknoCmBRd4n9Y0d7Fn20rWsl1M/JZLZ9ZT/8OExkRUSeFK9ghO48q6Z
	 sVJIMIXXwnZ+nSXwlIC0vw/dsjOpNXDzvjdBhH06lDR8OcduS4cM8LT4EkfvRpy2bp
	 R1vOnfChBfanQ==
Date: Wed, 28 Jan 2026 21:03:13 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 0/9] netfilter: updates for net-next
Message-ID: <20260128210313.787486ba@kernel.org>
In-Reply-To: <20260128154155.32143-1-fw@strlen.de>
References: <20260128154155.32143-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Jan 2026 16:41:46 +0100 Florian Westphal wrote:
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
> 
> Patch 8 fixes an esoteric packet-drop problem with UDPGRO and nfqueue added
> in v6.11. Patch 9 adds a test case for this.

Hi!

There's a UAF in the CI:

https://netdev-ctrl.bots.linux.dev/logs/vmksft/nf-dbg/results/494261/vm-crash-thr0-0

[  580.340726][T19113] sctp: Hash tables configured (bind 32/56)
[  601.749973][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  601.985349][    C2] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  602.191750][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  602.555469][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  602.895890][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  603.226543][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  603.435907][    C0] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  603.569421][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  603.672454][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  603.821679][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
[  618.553975][T19316] ==================================================================
[  618.554200][T19316] BUG: KASAN: slab-use-after-free in nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
[  618.554424][T19316] Write of size 1 at addr ff1100001cc9ae68 by task socat/19316
[  618.554600][T19316] 
[  618.554662][T19316] CPU: 2 UID: 0 PID: 19316 Comm: socat Not tainted 6.19.0-rc6-virtme #1 PREEMPT(full) 
[  618.554665][T19316] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  618.554667][T19316] Call Trace:
[  618.554669][T19316]  <TASK>
[  618.554670][T19316]  dump_stack_lvl+0x6f/0xa0
[  618.554678][T19316]  print_address_description.constprop.0+0x6e/0x300
[  618.554683][T19316]  print_report+0xfc/0x1fb
[  618.554684][T19316]  ? nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
[  618.554687][T19316]  ? __virt_addr_valid+0x1da/0x430
[  618.554691][T19316]  ? nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
[  618.554693][T19316]  kasan_report+0xe8/0x120
[  618.554697][T19316]  ? nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
[  618.554699][T19316]  nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
[  618.554702][T19316]  ? __nfqnl_enqueue_packet+0x470/0x470 [nfnetlink_queue]
[  618.554703][T19316]  ? nf_queue_entry_release_refs+0x230/0x240
[  618.554707][T19316]  ? __nf_queue+0x11f/0x1700
[  618.554709][T19316]  __nf_queue+0x50c/0x1700
[  618.554710][T19316]  ? nft_do_chain_inet+0xd8/0x3a0 [nf_tables]
[  618.554722][T19316]  ? nf_queue_entry_get_refs+0x390/0x390
[  618.554724][T19316]  nf_queue+0x18/0x50
[  618.554726][T19316]  nf_hook_slow+0x138/0x1d0
[  618.554729][T19316]  __ip_local_out+0x41f/0x8d0
[  618.554731][T19316]  ? ip_output+0x650/0x650
[  618.554732][T19316]  ? lock_acquire.part.0+0xbc/0x260
[  618.554735][T19316]  ? find_held_lock+0x2b/0x80
[  618.554737][T19316]  ? ip_append_data.part.0+0x1a0/0x1a0
[  618.554740][T19316]  ? ip4_dst_hoplimit+0x15b/0x320
[  618.554742][T19316]  __ip_queue_xmit+0x73f/0x1660
[  618.554744][T19316]  sctp_packet_transmit+0x655/0x1070 [sctp]
[  618.554757][T19316]  sctp_outq_flush_transports+0x321/0x6c0 [sctp]
[  618.554768][T19316]  sctp_outq_flush+0x125/0x190 [sctp]
[  618.554775][T19316]  ? lock_acquire.part.0+0xbc/0x260
[  618.554777][T19316]  ? sctp_outq_flush_data+0x1950/0x1950 [sctp]
[  618.554784][T19316]  ? sctp_outq_tail+0x2b8/0xa20 [sctp]
[  618.554791][T19316]  sctp_cmd_interpreter.isra.0+0x40e/0x4f50 [sctp]
[  618.554801][T19316]  ? sctp_generate_t1_cookie_event+0x20/0x20 [sctp]
[  618.554807][T19316]  ? rcu_lockdep_current_cpu_online+0x39/0x1b0
[  618.554812][T19316]  sctp_side_effects+0xcf/0x230 [sctp]
[  618.554819][T19316]  ? sctp_cmd_interpreter.isra.0+0x4f50/0x4f50 [sctp]
[  618.554825][T19316]  ? __lock_acquire+0x577/0xc10
[  618.554828][T19316]  ? br_deinit+0x5b0/0x5b0 [bridge]
[  618.554836][T19316]  sctp_do_sm+0x1a0/0x4e0 [sctp]
[  618.554844][T19316]  ? sctp_cname+0x1c0/0x1c0 [sctp]
[  618.554851][T19316]  ? __lock_release.isra.0+0x59/0x170
[  618.554853][T19316]  ? sctp_do_8_2_transport_strike.isra.0+0x1160/0x1160 [sctp]
[  618.554860][T19316]  ? __might_fault+0x97/0x140
[  618.554866][T19316]  ? sctp_datamsg_from_user+0x677/0x1140 [sctp]
[  618.554875][T19316]  ? skb_set_owner_w+0x27e/0x610
[  618.554879][T19316]  ? sock_recv_errqueue+0x4a0/0x4a0
[  618.554881][T19316]  sctp_primitive_SEND+0x82/0xe0 [sctp]
[  618.554889][T19316]  sctp_sendmsg_to_asoc+0x9d0/0x1420 [sctp]
[  618.554898][T19316]  ? sctp_close+0x850/0x850 [sctp]
[  618.554904][T19316]  ? mark_held_locks+0x40/0x70
[  618.554907][T19316]  sctp_sendmsg+0x624/0xd70 [sctp]
[  618.554915][T19316]  ? sctp_sendmsg_new_asoc+0x720/0x720 [sctp]
[  618.554921][T19316]  ? current_time+0x83/0x300
[  618.554924][T19316]  ? new_sync_write+0x6f0/0x6f0
[  618.554927][T19316]  ? make_vfsuid+0xe0/0xe0
[  618.554930][T19316]  ? ovl_path_next+0x760/0x760
[  618.554934][T19316]  ? atime_needs_update+0x27f/0x5d0
[  618.554937][T19316]  sock_write_iter+0x281/0x4d0
[  618.554938][T19316]  ? backing_file_read_iter+0x50e/0x730
[  618.554942][T19316]  ? ____sys_recvmsg+0x6b0/0x6b0
[  618.554945][T19316]  ? ovl_mmap+0x270/0x270
[  618.554947][T19316]  ? ____sys_recvmsg+0x6b0/0x6b0
[  618.554948][T19316]  new_sync_write+0x3c5/0x6f0
[  618.554950][T19316]  ? new_sync_read+0x24f/0x6f0
[  618.554952][T19316]  ? new_sync_read+0x6f0/0x6f0
[  618.554954][T19316]  ? generic_atomic_write_valid+0x150/0x150
[  618.554956][T19316]  ? __set_current_blocked+0x110/0x110
[  618.554959][T19316]  ? find_held_lock+0x2b/0x80
[  618.554961][T19316]  ? do_pselect.constprop.0+0x14e/0x1f0
[  618.554964][T19316]  vfs_write+0x65e/0xbb0
[  618.554966][T19316]  ? vfs_read+0x3cc/0x790
[  618.554968][T19316]  ksys_write+0x17e/0x200
[  618.554970][T19316]  ? __ia32_sys_read+0xc0/0xc0
[  618.554972][T19316]  ? rcu_is_watching+0x15/0xd0
[  618.554974][T19316]  do_syscall_64+0xbd/0xfc0
[  618.554979][T19316]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  618.554981][T19316] RIP: 0033:0x7fd5f9750c5e
[  618.554984][T19316] Code: 4d 89 d8 e8 34 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
[  618.554987][T19316] RSP: 002b:00007fffca8a36c0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[  618.554990][T19316] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007fd5f9750c5e
[  618.554992][T19316] RDX: 0000000000002000 RSI: 000055fcf0fd4000 RDI: 0000000000000007
[  618.554993][T19316] RBP: 00007fffca8a36d0 R08: 0000000000000000 R09: 0000000000000000
[  618.554994][T19316] R10: 0000000000000000 R11: 0000000000000202 R12: 000055fcf0fd4000
[  618.554995][T19316] R13: 0000000000002000 R14: 000055fcf0fd4000 R15: 0000000000000007
[  618.554997][T19316]  </TASK>
[  618.554998][T19316] 
[  618.565908][T19316] Allocated by task 19316:
[  618.566029][T19316]  kasan_save_stack+0x30/0x50
[  618.566144][T19316]  kasan_save_track+0x14/0x30
[  618.566258][T19316]  __kasan_kmalloc+0x7b/0x90
[  618.566369][T19316]  __kmalloc_noprof+0x2cd/0x820
[  618.566479][T19316]  __nf_queue+0x11f/0x1700
[  618.566589][T19316]  nf_queue+0x18/0x50
[  618.566671][T19316]  nf_hook_slow+0x138/0x1d0
[  618.566784][T19316]  __ip_local_out+0x41f/0x8d0
[  618.566892][T19316]  __ip_queue_xmit+0x73f/0x1660
[  618.567003][T19316]  sctp_packet_transmit+0x655/0x1070 [sctp]
[  618.567148][T19316]  sctp_outq_flush_transports+0x321/0x6c0 [sctp]
[  618.567294][T19316]  sctp_outq_flush+0x125/0x190 [sctp]
[  618.567408][T19316]  sctp_cmd_interpreter.isra.0+0x40e/0x4f50 [sctp]
[  618.567552][T19316]  sctp_side_effects+0xcf/0x230 [sctp]
[  618.567670][T19316]  sctp_do_sm+0x1a0/0x4e0 [sctp]
[  618.567785][T19316]  sctp_primitive_SEND+0x82/0xe0 [sctp]
[  618.567899][T19316]  sctp_sendmsg_to_asoc+0x9d0/0x1420 [sctp]
[  618.568040][T19316]  sctp_sendmsg+0x624/0xd70 [sctp]
[  618.568160][T19316]  sock_write_iter+0x281/0x4d0
[  618.568270][T19316]  new_sync_write+0x3c5/0x6f0
[  618.568380][T19316]  vfs_write+0x65e/0xbb0
[  618.568464][T19316]  ksys_write+0x17e/0x200
[  618.568546][T19316]  do_syscall_64+0xbd/0xfc0
[  618.568656][T19316]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  618.568794][T19316] 
[  618.568851][T19316] Freed by task 19314:
[  618.568935][T19316]  kasan_save_stack+0x30/0x50
[  618.569047][T19316]  kasan_save_track+0x14/0x30
[  618.569160][T19316]  kasan_save_free_info+0x3b/0x60
[  618.569273][T19316]  __kasan_slab_free+0x43/0x70
[  618.569390][T19316]  kfree+0x119/0x580
[  618.569472][T19316]  nfqnl_reinject+0x7f/0x3d0 [nfnetlink_queue]
[  618.569610][T19316]  nfqnl_recv_verdict+0x76f/0xfd3 [nfnetlink_queue]
[  618.569747][T19316]  nfnetlink_rcv_msg+0x49b/0xf00
[  618.569859][T19316]  netlink_rcv_skb+0x123/0x380
[  618.569970][T19316]  nfnetlink_rcv+0x166/0x4a0
[  618.570080][T19316]  netlink_unicast+0x4a3/0x770
[  618.570195][T19316]  netlink_sendmsg+0x735/0xc60
[  618.570307][T19316]  __sys_sendto+0x24e/0x360
[  618.570419][T19316]  __x64_sys_sendto+0xe4/0x1f0
[  618.570529][T19316]  do_syscall_64+0xbd/0xfc0
[  618.570640][T19316]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  618.570776][T19316] 
[  618.570833][T19316] The buggy address belongs to the object at ff1100001cc9ae00
[  618.570833][T19316]  which belongs to the cache kmalloc-128 of size 128
[  618.571105][T19316] The buggy address is located 104 bytes inside of
[  618.571105][T19316]  freed 128-byte region [ff1100001cc9ae00, ff1100001cc9ae80)
[  618.571381][T19316] 
[  618.571438][T19316] The buggy address belongs to the physical page:
[  618.571573][T19316] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xff1100001cc9be80 pfn:0x1cc9a
[  618.571803][T19316] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  618.571972][T19316] flags: 0x80000000000240(workingset|head|node=0|zone=1)
[  618.572115][T19316] page_type: f5(slab)
[  618.572206][T19316] raw: 0080000000000240 ff1100000103ce40 ffd4000000048090 ff11000001032a88
[  618.572404][T19316] raw: ff1100001cc9be80 0000000000150011 00000000f5000000 0000000000000000
[  618.572603][T19316] head: 0080000000000240 ff1100000103ce40 ffd4000000048090 ff11000001032a88
[  618.572798][T19316] head: ff1100001cc9be80 0000000000150011 00000000f5000000 0000000000000000
[  618.572994][T19316] head: 0080000000000001 ffd4000000732681 00000000ffffffff 00000000ffffffff
[  618.573191][T19316] head: ff1100001cc9bf10 0000000000000000 00000000ffffffff 0000000000000000
[  618.573390][T19316] page dumped because: kasan: bad access detected
[  618.573527][T19316] 
[  618.573584][T19316] Memory state around the buggy address:
[  618.573693][T19316]  ff1100001cc9ad00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  618.573856][T19316]  ff1100001cc9ad80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  618.574015][T19316] >ff1100001cc9ae00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  618.574179][T19316]                                                           ^
[  618.574343][T19316]  ff1100001cc9ae80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  618.574504][T19316]  ff1100001cc9af00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  618.574672][T19316] ==================================================================
[  618.574903][T19316] Disabling lock debugging due to kernel taint
