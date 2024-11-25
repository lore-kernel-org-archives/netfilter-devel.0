Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790B9185935;
	Mon, 25 Nov 2024 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732530639; cv=none; b=h0yRTh2Lg8XjEOcYDQUhY6CuerBRb1P3s+gxzm3FpXvBfHrKol1luTFlSLDJCn1EBGuhxSdCn8B60OF8SQzFDIkvZdcZiQIrz04gwO0zYz7EZlXYledIUiXO9NG1e+f95GNDG0F7H2GRzB3X7yei6zUI2g9pWl0OIaku9L5ssIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732530639; c=relaxed/simple;
	bh=MYRRw8F6lcMAra7mTnNKMG4JQKyAPo8Yz4Vd7ymQeXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oE+oBmqT/+mU7SGO4jhwNEUwZdOTpZVdwHF0fM/chbjatuA5cqT0f+PSEaVS8RTeagOUTRHH8g01WIfKwN4c7apkE2v0MbHCnBsAnQ39FUiVFQ7gCmaiVVTOwPUHxlhAKO9GHq1O/pPbjvM5ZsDwZIYqQpvNxX/siaTvFgUKEl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=48218 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tFWMF-007spC-UT; Mon, 25 Nov 2024 11:30:22 +0100
Date: Mon, 25 Nov 2024 11:30:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: syzbot <syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_socket_init
Message-ID: <Z0RRutRfeaWVs63d@calendula>
References: <67443b01.050a0220.1cc393.006f.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <67443b01.050a0220.1cc393.006f.GAE@google.com>
X-Spam-Score: 0.8 (/)
X-Spam-Report: SpamASsassin versoin 3.4.6 on ganesha.gnumonks.org summary:
 Content analysis details:   (0.8 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  1.0 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
                             mail domains are different
  2.5 SORTED_RECIPS          Recipient list is sorted by address
  0.1 TW_BF                  BODY: Odd Letter Triples with BF
  0.1 TW_YZ                  BODY: Odd Letter Triples with YZ

At quick glance, cgroup maximum depth seems INT_MAX.

On Mon, Nov 25, 2024 at 12:53:21AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    06afb0f36106 Merge tag 'trace-v6.13' of git://git.kernel.o..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=111a7b78580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=95b76860fd16c857
> dashboard link: https://syzkaller.appspot.com/bug?extid=57bac0866ddd99fe47c0
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131a7b78580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158e81c0580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/49111529582a/disk-06afb0f3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f04577ad9add/vmlinux-06afb0f3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b352b4fae995/bzImage-06afb0f3.xz
> 
> The issue was bisected to:
> 
> commit 7f3287db654395f9c5ddd246325ff7889f550286
> Author: Florian Westphal <fw@strlen.de>
> Date:   Sat Sep 7 14:07:49 2024 +0000
> 
>     netfilter: nft_socket: make cgroupsv2 matching work with namespaces
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=105d8778580000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=125d8778580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=145d8778580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com
> Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5849 at net/netfilter/nft_socket.c:220 nft_socket_init+0x2db/0x3a0 net/netfilter/nft_socket.c:220
> Modules linked in:
> CPU: 1 UID: 0 PID: 5849 Comm: syz-executor186 Not tainted 6.12.0-syzkaller-07834-g06afb0f36106 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> RIP: 0010:nft_socket_init+0x2db/0x3a0 net/netfilter/nft_socket.c:220
> Code: 42 0f b6 04 30 84 c0 0f 85 c8 00 00 00 88 5d 00 bb 08 00 00 00 e9 aa fe ff ff e8 30 4a 9e f7 e9 5d ff ff ff e8 26 4a 9e f7 90 <0f> 0b 90 e9 4a ff ff ff 89 e9 80 e1 07 38 c1 0f 8c 9a fd ff ff 48
> RSP: 0018:ffffc90003eb71d8 EFLAGS: 00010293
> RAX: ffffffff89f7030a RBX: 0000000000000100 RCX: ffff888034de0000
> RDX: 0000000000000000 RSI: 0000000000000100 RDI: 00000000000000ff
> RBP: 00000000000000ff R08: ffffffff89f702c5 R09: 1ffffffff203a5b6
> R10: dffffc0000000000 R11: fffffbfff203a5b7 R12: 1ffff110061c5004
> R13: ffff8880347742a2 R14: dffffc0000000000 R15: ffff888030e28020
> FS:  00005555769d4380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000200 CR3: 0000000029582000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3444 [inline]
>  nf_tables_newrule+0x185e/0x2980 net/netfilter/nf_tables_api.c:4272
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
>  nfnetlink_rcv+0x14e3/0x2ab0 net/netfilter/nfnetlink.c:665
>  netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
>  netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1347
>  netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1891
>  sock_sendmsg_nosec net/socket.c:711 [inline]
>  __sock_sendmsg+0x221/0x270 net/socket.c:726
>  ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2583
>  ___sys_sendmsg net/socket.c:2637 [inline]
>  __sys_sendmsg+0x269/0x350 net/socket.c:2669
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcc94659e69
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe0bc7a0d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fcc94659e69
> RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fcc946a3036
> R13: 00007ffe0bc7a110 R14: 00007ffe0bc7a150 R15: 0000000000000000
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
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
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
