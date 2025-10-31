Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434D827FD43
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761927360; cv=none; b=uVGL9uTZOmfHyHPRWdCJmpSy9BonEM+A4L06YG6WZwY2u/dMYHfOQmkioaBfzqE2U+1U7L9qaFd+lYBKWECwoRjkCOxVzxmkOkjVsw3fhnDJrsZrCacnB1E3v8s1r52v3ZXtU4Kr6f21odHuqmso+6AKTIKR/sun+5bQcpfhCQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761927360; c=relaxed/simple;
	bh=l2UboIZB7Jxhoe6kAGhgY6mEjfPhwZUdUpsuG2ViUcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enszREpspGL6UMr9fqiPHpSzE/Wrurajxg8sffZE1Ch0KY8YnaAca4cQeTyBgcELWN+tPMfxD/iruJpchlx6g+5WADMQ9dllpuF4V1GSlIRUu3VhuDqZoKCTBXoZ+Sy8BukbzRE6QrGVZASW0JW3DKXWEx8iq2H2KLbnZyrnwQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=W1gW+Sna; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="W1gW+Sna"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xpGMEkM5tFlUGJZA5wcu7wXfYTLTCKT5iOgPsADX+eU=; b=W1gW+SnaKPXPNNaPTXP1piSTN4
	dfhsdm0GgCt/wBjOp2uMPKF+SbGs/azNTcPMBCPaOFG3bmf0K50jomuyffl+RasLnIYAH4MqVVLcK
	mpGV0kJ6N1rE77brNDJVG51kytakVgVH4lpX92ed9j3QHZSBa+nwm+BppyzrljxU0sjxO/VDVxzJR
	FSrz/pm4aydKGvYBFYTtZcaygDqqKr2lrNKXD4YLpTbYVQUAp8MoM1y8Shjx6RnveyNomk7pbY8+8
	tdulnyL1sp7NE5E36dfeHhqU1vO75dIOXLS2IG5qN6v52W1cxA92DP7DWkcNUOt0Q4wrOUFOuDijS
	RrRRix9w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vErn8-000000000CY-2YQK;
	Fri, 31 Oct 2025 17:15:54 +0100
Date: Fri, 31 Oct 2025 17:15:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org, pablo@netfilter.org
Subject: Re: [syzbot] [netfilter?] WARNING in __nf_unregister_net_hook (9)
Message-ID: <aQTgurcz5LdrZWCl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	pablo@netfilter.org
References: <6889adf3.050a0220.5d226.0002.GAE@google.com>
 <69035c0b.050a0220.3344a1.0441.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69035c0b.050a0220.3344a1.0441.GAE@google.com>

[Cc-list trimmed.]

On Thu, Oct 30, 2025 at 05:37:31AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    efd3e30e651d Merge branch 'net-stmmac-hwif-c-cleanups'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ea1704580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5683686a5f7ee53f
> dashboard link: https://syzkaller.appspot.com/bug?extid=78ac1e46d2966eb70fda
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12afbc92580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a6eb09423004/disk-efd3e30e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f8a2fb326497/vmlinux-efd3e30e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a8cdcb8113e1/bzImage-efd3e30e.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+78ac1e46d2966eb70fda@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> hook not found, pf 5 num 0

So this tries to unregister a netdev prerouting hook which does not
exist.

> WARNING: CPU: 1 PID: 9032 at net/netfilter/core.c:514 __nf_unregister_net_hook+0x30a/0x700 net/netfilter/core.c:514
> Modules linked in:
> CPU: 1 UID: 0 PID: 9032 Comm: syz.0.994 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> RIP: 0010:__nf_unregister_net_hook+0x30a/0x700 net/netfilter/core.c:514
> Code: d5 18 f8 05 01 90 48 8b 44 24 10 0f b6 04 28 84 c0 0f 85 e3 03 00 00 41 8b 17 48 c7 c7 00 72 72 8c 44 89 ee e8 67 4f 14 f8 90 <0f> 0b 90 90 e9 d8 01 00 00 e8 a8 17 d7 01 89 c3 31 ff 89 c6 e8 fd
> RSP: 0018:ffffc9000c396938 EFLAGS: 00010246
> RAX: a02a0e56549ab800 RBX: ffff8880583d1480 RCX: ffff888059800000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: dffffc0000000000 R08: ffff8880b8924293 R09: 1ffff11017124852
> R10: dffffc0000000000 R11: ffffed1017124853 R12: ffff88807acf2480
> R13: 0000000000000005 R14: ffff88802701a488 R15: ffff88807796ae3c
> FS:  00007fba157656c0(0000) GS:ffff888126240000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555576f79808 CR3: 000000007f6c4000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  nft_unregister_flowtable_ops net/netfilter/nf_tables_api.c:8979 [inline]

There must be a flowtable hook for the device, otherwise
nft_hook_find_ops() would have returned NULL and the above function not
called.

>  nft_flowtable_event net/netfilter/nf_tables_api.c:9758 [inline]
>  __nf_tables_flowtable_event+0x5bf/0x8c0 net/netfilter/nf_tables_api.c:9803
>  nf_tables_flowtable_event+0x103/0x160 net/netfilter/nf_tables_api.c:9834
>  notifier_call_chain+0x1b6/0x3e0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
>  call_netdevice_notifiers net/core/dev.c:2281 [inline]
>  unregister_netdevice_many_notify+0x1860/0x2390 net/core/dev.c:12333
>  unregister_netdevice_many net/core/dev.c:12396 [inline]
>  unregister_netdevice_queue+0x33c/0x380 net/core/dev.c:12210
>  unregister_netdevice include/linux/netdevice.h:3390 [inline]
>  hsr_dev_finalize+0x707/0xaa0 net/hsr/hsr_device.c:800

This is error-path. Looking at the function, either register_netdevice()
returned non-zero or one of the hsr_add_port() calls.

Being totally clueless I wrote a small patch adding a few printk's to
report events and hook removals, this caused a pass with Syzkaller.

Next I instructed it to repeat the test with current net-next and no
extra patches. This time a different error happened:

WARNING in nf_hook_entry_head

------------[ cut here ]------------
WARNING: CPU: 0 PID: 36 at net/netfilter/core.c:329 nf_hook_entry_head+0x23e/0x2c0 net/netfilter/core.c:329
Modules linked in:
CPU: 0 UID: 0 PID: 36 Comm: kworker/u8:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Workqueue: netns cleanup_net
RIP: 0010:nf_hook_entry_head+0x23e/0x2c0 net/netfilter/core.c:329
Code: 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 4c 89 ff e8 7d b9 b6 f8 4d 39 37 74 36 e8 53 04 51 f8 90 <0f> 0b 90 31 db 48 89 d8 5b 41 5e 41 5f 5d c3 cc cc cc cc cc e8 39
RSP: 0018:ffffc90000ac7768 EFLAGS: 00010293
RAX: ffffffff896eff5b RBX: ffff888030a98000 RCX: ffff8881416b9e40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff8881416b9e40 R09: 0000000000000006
R10: 000000000000000a R11: 0000000000000000 R12: ffff888020ec8000
R13: 0000000000000005 R14: ffff888020ec8000 R15: ffff888030a98108
FS:  0000000000000000(0000) GS:ffff88812613e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2e4b7156c0 CR3: 000000000dd38000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __nf_unregister_net_hook+0x74/0x700 net/netfilter/core.c:491
 nft_unregister_flowtable_ops net/netfilter/nf_tables_api.c:8977 [inline]
 __nft_unregister_flowtable_net_hooks net/netfilter/nf_tables_api.c:8992 [inline]
 __nft_release_hook+0x180/0x350 net/netfilter/nf_tables_api.c:11985
 __nft_release_hooks net/netfilter/nf_tables_api.c:11999 [inline]
 nf_tables_pre_exit_net+0xa7/0x110 net/netfilter/nf_tables_api.c:12150
 ops_pre_exit_list net/core/net_namespace.c:161 [inline]
 ops_undo_list+0x187/0x990 net/core/net_namespace.c:234
 cleanup_net+0x4d8/0x820 net/core/net_namespace.c:696
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To hit this warning in nf_hook_entry_head(), pf must be NFPROTO_NETDEV
and hooknum neither NF_NETDEV_INGRESS nor _EGRESS. Could this be an
RCU-related problem? Or is this some memory corruption which happens to
always hit flowtable hooks?

Cheers, Phil
