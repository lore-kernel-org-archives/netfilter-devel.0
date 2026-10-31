Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793468754;
	b=p2ws1EuOls8tTa4KJtUMlHU0hb6QhxE0gD94y72afbkihPBH4FlKvnh6NPGAUnKsJisw
	 8AXDK4M275vxfiwwkMHr2u46iFOP70RiMxFPv01dBxUuzn8MkfPlU2r8SWbxJvzHxQYwz
	 9GIOp79RRWrwkX6mCLfvLdXS2kqdT0caoGSuEE+f5zTj5C+3+DYUAsGd2qO7FXn4fIHXZ
	 ylgdHuki98olYFcdM/ZCd1e3cgPGz8Sr14cxiYqq1w1nQxRdsXIST4rHAZsaQvkyH47iY
	 ZVGkagOvDl8ECBTB3V88UlTyf90Mjm+OAuqQ/7BdNK7OHQo9TmInWTLhrk0gTT8GXGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793468754;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=FW3M40bAUPpiu6dtg9ihV+GCZPA7IqkpRgmTwP06LZs=;
	b=bCvrXu6TaTUfB5UMW/n/212oxE56q+E2Jh3VyORVFoMc9Arv7QN0P7LTrnKq2btJ5vWK
	 heQgDCWxR269PT1uXyVX9jHwOQgGdeRYzh1lowqrOv5j1mDjKlZNPU/E5bjOWs8SreexN
	 1N9uGUNdyHjf4kCvJPBMIWrx4T94NX0tkQkfWWspHU+SLNOD90gQ3J3HgnvfscDgY0rFa
	 +YdH+iQEvD5lixpjNPV6RyOwtMkyzsoaeDESwkoKwPYQfaCzVCCLxq4Bb2Ic0JHxvzgtc
	 Zt/GaPvK1tZ1UVVWyqGJvxnHkE3n7fSJG915kukZAaM7I6YdpOAzQOu7js7HlFYHDsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=osNMDLr3;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 172DC606A31E;
	Sat, 31 Oct 2026 17:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 172DC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=osNMDLr3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793468750;
	bh=FW3M40bAUPpiu6dtg9ihV+GCZPA7IqkpRgmTwP06LZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=osNMDLr3OcmDU9BVzLikVYLYpyvo22MJjhzKJgoLClYYXq7oVJ9ZJipE7un6Ya7Yk
	 LM1+vUlI3gwLOD2XiGnBBM30U2AQYMY4exFuV1H3glNt9Ns+EHoAY+x+i+86Tkbfxb
	 5Uhse7dHzyVbbJk8osxmTogGw+TdwU8RM2yGYYYSPwnJ0G4zN/GBa6FwXqW6256VuL
	 c7y+TPrnTN/R0QHddx6/b1ma2yNAfEtBpAz8k/FwCcFVj0YBWFrio1HN9kHmF3skRc
	 ZFjmJn1nY0TERlaKBy2fwrA9WEePqOxvqcvts5UJQqYh4yJye0J5tFMkv2PPwV6rjV
	 gW6AmLoT77aTQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8784B6005C;
	Sat, 31 Oct 2026 18:45:50 +0100 (CET)
Date: Sat, 31 Oct 2026 18:45:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: syzbot <syzbot+e1a88d8b7e4cf6b51d85@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@kernel.org,
	fw@strlen.de, horms@kernel.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nf_flow_offload_gc_step
Message-ID: <auYpS96ihQOAR_UP@chamomile>
References: <6ae61c88.6552420f.2a0efc.0003.GAE@google.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ae61c88.6552420f.2a0efc.0003.GAE@google.com>

On Sat, Oct 31, 2026 at 09:51:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d135ab453a74 Merge tag 'backlight-next-7.4' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13a51259580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6f2905533069b0f5
> dashboard link: https://syzkaller.appspot.com/bug?extid=e1a88d8b7e4cf6b51d85
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14020995580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100c4f0d580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d135ab45.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6c39e8158fba/vmlinux-d135ab45.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7fb9f97c1f88/bzImage-d135ab45.xz
> 
> AI-generated root cause summary:
> In the Netfilter flowtable subsystem, nf_flow_table_extend_ct_timeout() only
> accounts for IPPROTO_UDP and IPPROTO_TCP when refreshing conntrack timeouts
> during garbage collection. However, both tc act_ct and nftables flow offload
> support offloading IPPROTO_GRE connections to the flowtable. When the garbage
> collector checks an offloaded GRE connection whose timeout has dropped below
> min_timeout, the missing case in nf_flow_table_extend_ct_timeout() triggers the
> default: WARN_ON_ONCE(1) branch. In a production kernel without panic_on_warn,
> the warning does not crash the system and no memory corruption occurs.
> 
> full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=e1a88d8b7e4cf6b51d85

There is a patch already for this, it will come in the next nf.git PR.

> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e1a88d8b7e4cf6b51d85@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> 1
> WARNING: net/netfilter/nf_flow_table_core.c:553 at nf_flow_table_extend_ct_timeout net/netfilter/nf_flow_table_core.c:553 [inline], CPU#2: kworker/2:2/1358
> WARNING: net/netfilter/nf_flow_table_core.c:553 at nf_flow_offload_gc_step+0xd84/0xf60 net/netfilter/nf_flow_table_core.c:593, CPU#2: kworker/2:2/1358
> Modules linked in:
> CPU: 2 UID: 0 PID: 1358 Comm: kworker/2:2 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: events_power_efficient nf_flow_offload_work_gc
> RIP: 0010:nf_flow_table_extend_ct_timeout net/netfilter/nf_flow_table_core.c:553 [inline]
> RIP: 0010:nf_flow_offload_gc_step+0xd84/0xf60 net/netfilter/nf_flow_table_core.c:593
> Code: f8 e9 82 fd ff ff 4c 89 f7 e8 28 e1 6a f8 e9 12 fc ff ff 48 c7 c7 80 f2 c0 8f e8 17 e1 6a f8 e9 ae fc ff ff e8 1d cb f1 f7 90 <0f> 0b 90 41 be 01 00 00 00 e9 7d fc ff ff e8 09 cb f1 f7 48 8b 04
> RSP: 0018:ffffc9000618fa88 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88803e161380 RCX: 0000000000000000
> RDX: ffff88802c392580 RSI: ffffffff8a1c51f3 RDI: ffff88802c392580
> RBP: ffff88803e161488 R08: 0000000000000001 R09: 0000000000000011
> R10: 000000000000002f R11: 0000000000000000 R12: 1ffff92000c31f56
> R13: ffff88803818f868 R14: 000000000000002f R15: ffffffff8fc0f280
> FS:  0000000000000000(0000) GS:ffff8880d469c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000012000 CR3: 000000002f277000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
>  nf_flow_table_gc_run net/netfilter/nf_flow_table_core.c:616 [inline]
>  nf_flow_offload_work_gc+0x11e/0x1e0 net/netfilter/nf_flow_table_core.c:624
>  process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
>  process_scheduled_works kernel/workqueue.c:3578 [inline]
>  worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
>  kthread+0x373/0x450 kernel/kthread.c:436
>  ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
