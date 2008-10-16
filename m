From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] xt_recent: use proc_create_data()
Date: Thu, 16 Oct 2008 18:03:20 +0400
Message-ID: <20081016140320.GB17872@x200.localdomain>
References: <20081015041326.GB24058@x200.localdomain> <48F73DBE.5040808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:6003 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYJPOAV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:00:21 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1704869ugf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2008 07:00:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <48F73DBE.5040808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2008 at 03:12:30PM +0200, Patrick McHardy wrote:
> Alexey Dobriyan wrote:
>> It's tiny little bit safer because ->data always appears initialized.
>
> These don't seem to actually fix anything,

It does ;-) Initializing ->data after proc_create() when proc entry
becomes fully visible and accessible is no-no.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
IP: [<ffffffffa002119c>] recent_seq_start+0x4c/0x90 [xt_recent]
PGD 17d33c067 PUD 107afe067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0 
Modules linked in: ipt_LOG xt_recent af_packet iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 xt_tcpudp iptable_filter ip_tables x_tables ext2 nls_utf8 fuse sr_mod cdrom [last unloaded: ntfs]
Pid: 32373, comm: cat Not tainted 2.6.27-04ab591808565f968d4406f6435090ad671ebdab #6
RIP: 0010:[<ffffffffa002119c>]  [<ffffffffa002119c>] recent_seq_start+0x4c/0x90 [xt_recent]
RSP: 0018:ffff88015fed7e28  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 0000000000000080 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88015fed7e48 R08: 00000000002381ae R09: 000000000000011c
R10: 0000000000000000 R11: 2222222222222222 R12: ffff88017d2799f8
R13: 0000000000000000 R14: ffff88015fed7e88 R15: 0000000000001000
FS:  00007f2d270c86f0(0000) GS:ffffffff805554c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000100 CR3: 000000015ce3a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cat (pid: 32373, threadinfo ffff88015fed6000, task ffff88001320aa60)
Stack:
 fffffffffffffffb ffff88006c333420 fffffffffffffffb ffffffff802b0ff0
 ffff88015fed7eb8 ffffffff802b1072 ffff88015fed7f48 00000000018db000
 ffff880152a64d80 ffff88006c333450 0000000000000000 ffffffff802b0ff0
Call Trace:
 [<ffffffff802b0ff0>] ? seq_read+0x0/0x360
 [<ffffffff802b1072>] seq_read+0x82/0x360
 [<ffffffff802b0ff0>] ? seq_read+0x0/0x360
 [<ffffffff802b0ff0>] ? seq_read+0x0/0x360
 [<ffffffff802cc06c>] proc_reg_read+0x7c/0xc0
 [<ffffffff80295897>] vfs_read+0xa7/0xe0
 [<ffffffff80295be0>] sys_read+0x50/0x90
 [<ffffffff8020b66b>] system_call_fastpath+0x16/0x1b
Code: 24 e8 89 15 40 e0 41 c7 44 24 08 00 00 00 00 8b 15 82 2d 00 00 85 d2 74 41 31 ff 89 f8 89 fe 48 c1 e0 04 4a 8d 8c 28 00 01 00 00 <48> 8b 01 eb 0c 48 ff cb 48 83 fb ff 74 23 48 89 d0 48 8b 10 48 
RIP  [<ffffffffa002119c>] recent_seq_start+0x4c/0x90 [xt_recent]
 RSP <ffff88015fed7e28>
CR2: 0000000000000100
Kernel panic - not syncing: Fatal exception in interrupt

> so please also resend once net-next is open again.
