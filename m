Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ACE1946DA;
	Thu, 19 Feb 2026 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771504006; cv=none; b=QYPbGX1hBNCqKAXNkw/8diuxSVp5AgyxFhD7xnmhYIwoghBFm09tg8Y1u2C0ffH+zfMJvF9VvG6CuKyBSnTO7Xex5BVN5JiUoDJVPQcuZRgmWgbstw6wbP+kuFDCAj29YQK65ptc4LV4g8Yx03dK9LuW+ddtZB5SIpylSHctkoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771504006; c=relaxed/simple;
	bh=WWNDYmDurhKhiMRGxM0OxWlHH8s1Go8hhj6ttk7N7Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU0bdukbh1LNcSv3MfMACxzmBCCI060QdhTcmFdDQ7eDkZC1qDC8m//HIKUhW8mmCz2q8Nyz3uqNQTEqItuG9H4Y2tRdycLs5+yJ53hDiwYKvw4ab7bXiFOR3MGJ8TYuQw6vp+ScllIFrYFLxiLwbWBy+5cIPJkgQsNsazdAFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pgqNhpO+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pgqNhpO+"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 32FCD60253;
	Thu, 19 Feb 2026 13:26:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771503995;
	bh=5tucPx83ij3BIVmjNx5q6OBL7ANHZFuec6ke4EP8SvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pgqNhpO+5u9H2OopCZiXlb+HURVSvvYJKVm1YeKCGFj2Qj08lsjxSFEOsbhoRavQQ
	 YU+Lljim9+dqvw/gA4X51mLbz5Lkr2rHGipCq2QYCSY+pH9e6/3F8/mG2atmnMT2mP
	 pDfDY0kow9fufkFF8GevttK2qhoR/QgjG94IZ//Mlq2Jz/6ZCVmSh20SAR2hE0bPUR
	 cFa5DtIAKoE6+0uSRpP58Py+/159GtFPxnCEfF7j6mCExK8EvVhdfMSZVLnZHHoY8q
	 vu76Ugee5hLp5Vr0uqBB53Dh2nEJYVNsc0ZH2IMGhF/4pAG5TQK4As8F2lVxe5y4OH
	 GZzIfZf7DVIpw==
Date: Thu, 19 Feb 2026 13:26:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: syzbot <syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	fw@strlen.de, horms@kernel.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_map_deactivate
Message-ID: <aZcBeD8NCE5k7zeC@chamomile>
References: <6996dd95.050a0220.21cd75.010c.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6996dd95.050a0220.21cd75.010c.GAE@google.com>

On Thu, Feb 19, 2026 at 01:53:25AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4c51f90d45dc selftests/bpf: Add powerpc support for get_pr..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=159e5aaa580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d9e410399043c26
> dashboard link: https://syzkaller.appspot.com/bug?extid=4924a0edc148e8b4b342
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13437652580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1250a7b2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/173ab67d0a10/disk-4c51f90d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9c8787b7cc0e/vmlinux-4c51f90d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/bf9799a7764a/bzImage-4c51f90d.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com
> 
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fb5ea615fac R14: 00007fb5ea615fa0 R15: 00007fb5ea615fa0
>  </TASK>
> ------------[ cut here ]------------
> iter.err
> WARNING: net/netfilter/nf_tables_api.c:845 at nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845, CPU#0: syz.0.17/5992

This is triggered with fault injection.

This is an interval set allocating a new array that is allocated with
GFP_KERNEL (rbtree/pipapo follow a similar approach), I suspect fault
injection is making this memory allocation fail.

Then, this WARN_ON_ONCE below triggers:

static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
{               
        struct nft_set_iter iter = {
                .genmask        = nft_genmask_next(ctx->net),
                .type           = NFT_ITER_UPDATE,
                .fn             = nft_mapelem_deactivate,
        };
        
        set->ops->walk(ctx, set, &iter);
        WARN_ON_ONCE(iter.err);

For the traceback below, it should be possible to add NFT_ITER_RELEASE
to skip the allocation.

But there are other paths where this can happen too, I am looking into
making these nft_map_activate/nft_map_deactivate function never fail
in the second stage, this is the idea:

- For anonymous sets, the allocation (clone) can be skipped since they
  are immutable.
- For non-anonymous sets, add a .clone interface to nft_set_ops so
  the clone is not done from the 

Those two should be relatively small, I am preparing a patch.

> Modules linked in:
> CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
> RIP: 0010:nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845
> Code: 8b 05 86 5a 4e 09 48 3b 84 24 a0 00 00 00 75 62 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 63 6d fa f7 90 <0f> 0b 90 43 80 7c 35 00 00 0f 85 23 fe ff ff e9 26 fe ff ff 89 d9
> RSP: 0018:ffffc900045af780 EFLAGS: 00010293
> RAX: ffffffff89ca45bd RBX: 00000000fffffff4 RCX: ffff888028111e40
> RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
> RBP: ffffc900045af870 R08: 0000000000400dc0 R09: 00000000ffffffff
> R10: dffffc0000000000 R11: fffffbfff1d141db R12: ffffc900045af7e0
> R13: 1ffff920008b5f24 R14: dffffc0000000000 R15: ffffc900045af920
> FS:  000055557a6a5500(0000) GS:ffff888125496000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb5ea271fc0 CR3: 000000003269e000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __nft_release_table+0xceb/0x11f0 net/netfilter/nf_tables_api.c:12115
>  nft_rcv_nl_event+0xc25/0xdb0 net/netfilter/nf_tables_api.c:12187
>  notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
>  blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
>  netlink_release+0x123b/0x1ad0 net/netlink/af_netlink.c:761
>  __sock_release net/socket.c:662 [inline]
>  sock_close+0xc3/0x240 net/socket.c:1455
>  __fput+0x44f/0xa70 fs/file_table.c:469
>  fput_close_sync+0x11f/0x240 fs/file_table.c:574
>  __do_sys_close fs/open.c:1509 [inline]
>  __se_sys_close fs/open.c:1494 [inline]
>  __x64_sys_close+0x7e/0x110 fs/open.c:1494
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb5ea39c629
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff72e03568 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 00007fb5ea615fa0 RCX: 00007fb5ea39c629
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007fff72e035d0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fb5ea615fac R14: 00007fb5ea615fa0 R15: 00007fb5ea615fa0
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
