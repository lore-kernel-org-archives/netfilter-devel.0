Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57DB2DA76D
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755770132; cv=none; b=RNPflVQeUFkGQ9eOe/fa4Hbf69kn8cP8llKhMDytXjaIVPHrHU3qAdHafeUYnOU4GUKQTGpVwNjGg4vasJ/I6fLNSNMAJZhO5Q8HfNv2dYQOP76L94TJceOl3HsuttiUgw1m7iLDp3K71zLnYiErG1sNM3sL3ATnaHoNTuoGUe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755770132; c=relaxed/simple;
	bh=bNC84wX9VbuKkp3Xk8CymGb8jOoIPWrXBqmjlKAHW58=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HZ4qSZeAu7724Z931rpkWO5agzSAASSCkxZQQ0VxtWUDe87yrAtkfqpnb0WiESLkiSrd6nhQvLxw53Tm4SAxXNKW+OhW6/9dfQtrSNysGZrijLN1MvNuKsWTCl7Nu7bevFVJi7PRAn4xLIUXR0lxBOVy/+3MBOrFYmJ//4hvGhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-88432e140b8so74099139f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 02:55:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755770130; x=1756374930;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MKWfvnqfyZafY2UKt97D9JqmTwGSaSHAeKRW8S7fgRM=;
        b=u921RhDwoXKTxqXBDvvGG3PbfaZ+DF5HY20MqlFPWxaUneBOqlif205gqN5HWSAvff
         P8aQQNzx/fdQ/6Siv+HJbtYlGIAY3uFdvAYIu4DwW5iJ8Uqv+JENt8mg7sBd8+3qx9bT
         Lu2uwVGCUXa6qdnAFzMMT69jR7qpdDsDqBo6De4h/NQTekpR2yVFdNvH+FlAIeHNDrbr
         aOZNQh0pPURFUQLdxeuoGG1YMUkrbwsHUiBtqRx4sUptCzf4ju9N9nMG44/Pu0kjeJe4
         VkkpM+WtPOz0MXC0VF8hvOF+sWBViDC13NewMyEsPmzpB2mf0VDED240WbKcBpvS3kBh
         htGw==
X-Forwarded-Encrypted: i=1; AJvYcCWNxqeK9CMVnqPEz7fx5T3WtZoU3x2PRPQCzdDci+Y1qqAFHIjgHhYAupdws/OIhkjAL89VNPtS17XnghOvfGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv27dZfqG89EYzv4e9C4c6dSoStbIZ7tWIO25WvZLW3e/Uymrk
	OSzCJb8EnqxN+S8bejohSWfUujDqRx4/Ig5SEbS9k1u3te+4zw1fUBDJIg79iGO4Thl8zkflvee
	bg9zjuATwPlQW5V6jlG3RvOSxy/RslnL9fak8Dmc68c8bnzYT6Rpe6Y7jUa8=
X-Google-Smtp-Source: AGHT+IFmleAzs6h/ycjcn0VigOYLdPhAdOw0gh90cCVW99o0DYePvGNAasuwcBuV4XqAr3kEtRQyNJIIxrAri+bIPKsvETNy3C2q
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:228e:b0:3e5:5e09:4484 with SMTP id
 e9e14a558f8ab-3e6d4160132mr33220915ab.6.1755770130116; Thu, 21 Aug 2025
 02:55:30 -0700 (PDT)
Date: Thu, 21 Aug 2025 02:55:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a6ed12.050a0220.3d78fd.0021.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in nf_reject_fill_skb_dst
From: syzbot <syzbot+b17c05ecb64771a892d1@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	sdf@fomichev.me, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5c69e0b395c1 Merge branch 'stmmac-stop-silently-dropping-b..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=128597a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b2fdcd062d798f6
dashboard link: https://syzkaller.appspot.com/bug?extid=b17c05ecb64771a892d1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12175442580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124c16f0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ef95b68de898/disk-5c69e0b3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70d343b8a3cf/vmlinux-5c69e0b3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/55dad8818bb6/bzImage-5c69e0b3.xz

The issue was bisected to:

commit a890348adcc993f48d1ae38f1174dc8de4c3c5ac
Author: Stanislav Fomichev <sdf@fomichev.me>
Date:   Mon Aug 18 15:40:32 2025 +0000

    net: Add skb_dst_check_unset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d1b7a2580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11d1b7a2580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d1b7a2580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b17c05ecb64771a892d1@syzkaller.appspotmail.com
Fixes: a890348adcc9 ("net: Add skb_dst_check_unset")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1038 at ./include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: CPU: 1 PID: 1038 at ./include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1211 [inline]
WARNING: CPU: 1 PID: 1038 at ./include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Modules linked in:
CPU: 1 UID: 0 PID: 1038 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
RIP: 0010:skb_dst_set include/linux/skbuff.h:1211 [inline]
RIP: 0010:nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Code: 8b 0d 10 6f 8b 08 48 3b 8c 24 e0 00 00 00 75 5d 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 fd ca aa f7 90 <0f> 0b 90 e9 38 ff ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 2b fe
RSP: 0018:ffffc90000a08360 EFLAGS: 00010246
RAX: ffffffff8a14e133 RBX: ffff888079c898c0 RCX: ffff8880266ada00
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90000a08490 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: fffffbfff1f46fc7 R12: ffff88807be46101
R13: dffffc0000000001 R14: 1ffff92000141070 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125d1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f95283b6088 CR3: 000000000df36000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
 nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x40c/0x1920 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x25d/0x340 net/netfilter/nft_chain_filter.c:161
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x206/0x3a0 include/linux/netfilter.h:316
 __netif_receive_skb_one_core net/core/dev.c:5979 [inline]
 __netif_receive_skb+0x143/0x380 net/core/dev.c:6092
 process_backlog+0x60e/0x14f0 net/core/dev.c:6444
 __napi_poll+0xc7/0x360 net/core/dev.c:7494
 napi_poll net/core/dev.c:7557 [inline]
 net_rx_action+0x707/0xe30 net/core/dev.c:7684
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:910 [inline]
 __dev_queue_xmit+0x1d79/0x3b50 net/core/dev.c:4740
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0x11fb/0x16a0 net/ipv6/ip6_output.c:141
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xb96/0x1470 net/ipv6/ndisc.c:512
 ndisc_send_ns+0xcb/0x150 net/ipv6/ndisc.c:670
 addrconf_dad_work+0xaae/0x14b0 net/ipv6/addrconf.c:4282
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
