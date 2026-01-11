Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88A313AD1C
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 11:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768131335; cv=none; b=lGWinruvrpn88uXro+ajUXFigI/xyF+a226WbV9rBrblGWhgYpWuhGDZF0Jn1bcSZfvPikQGTJpMezT/ruMf0A0kX9goLcCbzCfNuCRlXS/0i3a8LqQhYCz9XWONluX2y5bpKjOVr1QsAHD3Y+gDoBOUjS74Z1UKJmcuAjMJGy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768131335; c=relaxed/simple;
	bh=57BcdOaqkoFKPalZF4kb0yJgHs3b9diZQObKah5jSlc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=A0qhIIgut92I9w01DqlmMuPmd7kdZ+qdbslsqKLwGStMbiNjob+GZlNjd6RKrx3SaswmqM/mMMLaP6InIWqpDLS4/5YhVk8tRePLKMNKK+L/hrohUFzBLiLKK+sVBn186U2bYJYmt8dARXrsAD7OSZPvzVlitvOkbX6v+t6UjuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7c70268301aso5705133a34.3
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 03:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768131332; x=1768736132;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e6/jbbz9zla6XH3ASE7oZUGg6+DGatjynlVS29Ut1C4=;
        b=BbtXKULRpWYO6LD7uBzVAZhNJmdBdp2FTsXHQc59qgeZ11SHwzqPRIFtMyOXb5G2ql
         gLrytlWoYhfRdxGkmhCmft9u6yR0uHEhXKYesFWSCcnKGQIcFgQkyjuiVZqNhjCZgfav
         LA2HYYQQKriw61t0ZKRUFSEYKsg6j4UjY7s0ISabYsBwcrLcMOe1zMkXhckdaR5pCjUQ
         ReN7zTJJ0SO9RUBn+KQ4xON2EGLBBP/jlu/4B931A32bBLTjo/FKy7GVT623PfXbW0t8
         +fxJ+3kaYEKkTxSwNnn2/2lXWbt3bdXlahcvKqZLAllHS7nQnGqQ2XWaY96XbZfMtutB
         OL9A==
X-Forwarded-Encrypted: i=1; AJvYcCVJWHXLqLEnjXlmhqtrigZSxbYD/KwQ90yF7asiGcrJiTpb+AxjTwRLdhrV8D0Vt1RYn8v9ULV8jsUAkLNPMeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGL7CEuwCHB291KFgskOgSCyZZ7nNYowG/P7SA41pgTRIXMUW0
	6dNrtq2ljf9vDvJ3pIj2Bi1SdgoiNtpuIahlXEqYFeJeUvs5PBwwLL4Wgqvn1TDwFy6NmEFJ+p0
	cbvf3ggA2wkJ1mvfTjkh+8u5ZjB+3FXsNrHgVNHSsL+vcoKNFR7n7CafxKv8=
X-Google-Smtp-Source: AGHT+IF5i7Jc2Pa1QYeaKVHMr6CPYtn8COJ+T1hzZC+wx4RdujTrnmDfLa5f3mA+Im/hXS8NEru2miJEsnZGT4S9Wm9P0AxBkoiA
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:780e:b0:659:9a49:8e66 with SMTP id
 006d021491bc7-65f54f5abefmr5235655eaf.54.1768131332560; Sun, 11 Jan 2026
 03:35:32 -0800 (PST)
Date: Sun, 11 Jan 2026 03:35:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69638b04.050a0220.eaf7.0063.GAE@google.com>
Subject: [syzbot] [bridge?] [netfilter?] WARNING in br_nf_local_in (2)
From: syzbot <syzbot+9c5dd93a81a3f39325c2@syzkaller.appspotmail.com>
To: bridge@lists.linux.dev, coreteam@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, fw@strlen.de, horms@kernel.org, idosch@nvidia.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f417b7ffcbef Add linux-next specific files for 20260109
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12f625fa580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63a1fc1b4011ac76
dashboard link: https://syzkaller.appspot.com/bug?extid=9c5dd93a81a3f39325c2
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1f048080a918/disk-f417b7ff.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfd5ea190c96/vmlinux-f417b7ff.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db24c176e0df/bzImage-f417b7ff.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9c5dd93a81a3f39325c2@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: net/bridge/br_netfilter_hooks.c:602 at br_nf_local_in+0x40e/0x470 net/bridge/br_netfilter_hooks.c:602, CPU#1: ksoftirqd/1/23
Modules linked in:
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:br_nf_local_in+0x40e/0x470 net/bridge/br_netfilter_hooks.c:602
Code: 38 69 eb f7 e9 4b fc ff ff 44 89 e1 80 e1 07 38 c1 0f 8c a8 fc ff ff 4c 89 e7 e8 1d 69 eb f7 e9 9b fc ff ff e8 d3 98 84 f7 90 <0f> 0b 90 48 89 df e8 b7 2b 00 00 e9 5b fd ff ff e8 bd 98 84 f7 90
RSP: 0000:ffffc900001d6f38 EFLAGS: 00010246
RAX: ffffffff8a3c21ed RBX: ffff8880792ba140 RCX: ffff88801d6ddac0
RDX: 0000000000000100 RSI: 0000000000000002 RDI: 0000000000000001
RBP: 0000000000000002 R08: ffff88807903e183 R09: 1ffff1100f207c30
R10: dffffc0000000000 R11: ffffed100f207c31 R12: 0000000000000000
R13: ffff8880792ba1a8 R14: 1ffff1100f257435 R15: ffff88807903e180
FS:  0000000000000000(0000) GS:ffff888125d07000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa503fb1000 CR3: 0000000078d26000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x251/0x390 include/linux/netfilter.h:316
 br_handle_frame_finish+0x15c6/0x1c90 net/bridge/br_input.c:235
 br_nf_hook_thresh net/bridge/br_netfilter_hooks.c:-1 [inline]
 br_nf_pre_routing_finish+0x1364/0x1af0 net/bridge/br_netfilter_hooks.c:425
 NF_HOOK+0x61b/0x6b0 include/linux/netfilter.h:318
 br_nf_pre_routing+0xeb7/0x1470 net/bridge/br_netfilter_hooks.c:534
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:291 [inline]
 br_handle_frame+0x96e/0x14f0 net/bridge/br_input.c:442
 __netif_receive_skb_core+0x95f/0x2f90 net/core/dev.c:6026
 __netif_receive_skb_one_core net/core/dev.c:6137 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6252
 process_backlog+0x54f/0x1340 net/core/dev.c:6604
 __napi_poll+0xae/0x320 net/core/dev.c:7668
 napi_poll net/core/dev.c:7731 [inline]
 net_rx_action+0x64a/0xe00 net/core/dev.c:7883
 handle_softirqs+0x22b/0x7c0 kernel/softirq.c:626
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1067
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x389/0x480 kernel/kthread.c:467
 ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
