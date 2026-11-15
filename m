Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794781357;
	b=D/N3tzjz9A4nm52a8abA2p8sWszlWuIiyhfs9b/vQ45rJdGmS9xIuHPKFprXqpqeoLxs
	 EcKOZrO9O6hOoTMl0VYvQkHE8t4UrYEUECfD+rLpJ9C2TyD6tptYJ2hHCMS2D/4jWotfU
	 elND6DlYgQNLSd2fYLNgGvViVr6+CYjMCTAGaRv3FV+bot59fEIYM2p28ahv+sYm9vfFq
	 IIeWjHywKr6KdUX6H26uiamJN5OpGIMjbtNM2oweDIsFzoxKdfEiqo2CDP3RqTo/4wZsm
	 7VppRj5TwCB/uGsgrxRDPIcjWaTwa9D81Yeark73FIq+MS3nJzPt/D/d3Po74k5dICw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794781357;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=j48R735f118eJ59p+9MBsl6aHMwkGoc0F1+DYRBFwdk=;
	b=kVeAcOZlrYWTIps86vsegdRlgVznJlDogVjlcXVr/f9YdN2s5h7XJsipsV9spQyI37jK
	 qGcQAxDjnGhdyUohxIMB6sKzzP/kB6IpU1oETwsLl854SNDhV0/vzT+wZHI/RBm8ET/XJ
	 +1pWjPVIBPmdFw8mQmHSd+7KjXDTl4f85mp+Go19xN8VVzxyS9UIu5yDSveFy5kG5oc6N
	 /GI/6jPS5nDAfrm7PtCfyjLm1GmHLKZ3zdhC/m2+DMlQbyE9gWwfinocOK6v9vHEk/MPG
	 Q/lqCbJ2+tNsEaywz0OqkcO8gE/hHsPetntqaQ8+WAcc9ySLUk1RvHqBH6Dbt9/kyQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.161.69
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B3A606A323
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 22:22:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94B3A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-71aca016fdcso2186761eaf.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 14:22:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794781356; x=1795386156;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j48R735f118eJ59p+9MBsl6aHMwkGoc0F1+DYRBFwdk=;
        b=dZcVmnCRfEvaPjxdsppYoCiXlyn35wdIezIUjy9Te5E6bkBdtwV1yShRBwLtM7zGad
         Kl22B5ZlJswm2pyGZGkeODBbukysnvpViFVUwLPFdyhFuBUj7/TPxgQMJHpS9Ov0riqn
         onLa7LKqbGQwVWGK3kagDAwrThDXZW/Jm9WiIZgL3yP79xhUYOPPylnHz4k80uzyjy/J
         BCXL0uKxQhdJTJcSCvE4+RTbR/+f+oT3YGWHbOj0DpeiwYBV71q8veLCXFu4fgCtzfgI
         ZVtVXgahfaT67q1srwJQoNy0VDtV8TD0Cu95dgXtw9cPehBwkIYx0qnQvOr6Sj5ZDpXI
         qsUg==
X-Forwarded-Encrypted: i=1; AL+hErGm87FNPBilFZsIU4ORr39fxr/wXah7zvJKjXqyzjKmCdutR951Ri22cftpM/hKfbp+iB/Gkbu0G7Qq0Gj+gqQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z98qW82JWtd3sbfAeQoz0vyE+bNwMSiMTF8fkMUczjaBU3cUp2V
	OVlFqr3oITQqFGuduSgzjeM/jf6kuJZx5yHFCrQtsKOWtORuq0j/IcgZN7jzWiQfwIDjfcoE+nD
	1v2jD4JTWoHkp7e30lJ2erYLb68m76R18KbvitRY9jgSfjVKK0w3Pk1Nhw3s=
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c44b:20b0:71a:f794:49cd with SMTP id
 006d021491bc7-71af7944c7amr136480eaf.65.1794781356552; Sun, 15 Nov 2026
 14:22:36 -0800 (PST)
Date: Sun, 15 Nov 2026 14:22:36 -0800
In-Reply-To: <674b53e8.050a0220.253251.00e0.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afa30ac.920b2b3a.148c65.0047.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_sendmmsg (7)
From: syzbot <syzbot+53e660acb94e444b9d63@syzkaller.appspotmail.com>
To: andrii@kernel.org, anna-maria@linutronix.de, ast@kernel.org, 
	bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, 
	edumazet@kernel.org, frederic@kernel.org, horms@kernel.org, jmaloy@redhat.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	pabeni@redhat.com, pablo@netfilter.org, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, tipc-discussion@lists.sourceforge.net, 
	tung.quang.nguyen@est.tech
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ad3fc05c7e65 arm64: suspend: Only track cpuidle context fo..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1344e44d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e8e6c1701ad8af2
dashboard link: https://syzkaller.appspot.com/bug?extid=53e660acb94e444b9d63
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16190411580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1730444d580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a30beb3b2b82/disk-ad3fc05c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2eaac3d8da90/vmlinux-ad3fc05c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/212a161a069b/Image-ad3fc05c.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53e660acb94e444b9d63@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [syz.0.42:5008]
Modules linked in:
irq event stamp: 7423
hardirqs last  enabled at (7422): [<ffff8000869575f4>] irqentry_exit_to_kernel_mode_after_preempt include/linux/irq-entry-common.h:511 [inline]
hardirqs last  enabled at (7422): [<ffff8000869575f4>] __arm64_exit_to_kernel_mode+0xe4/0x140 arch/arm64/kernel/entry-common.c:99
hardirqs last disabled at (7423): [<ffff800086954144>] __el1_irq arch/arm64/kernel/entry-common.c:566 [inline]
hardirqs last disabled at (7423): [<ffff800086954144>] el1_interrupt+0x28/0x60 arch/arm64/kernel/entry-common.c:582
softirqs last  enabled at (2824): [<ffff800084c751c0>] spin_unlock_bh include/linux/spinlock.h:407 [inline]
softirqs last  enabled at (2824): [<ffff800084c751c0>] release_sock+0x150/0x228 net/core/sock.c:3950
softirqs last disabled at (2830): [<ffff800084c894d0>] spin_lock_bh include/linux/spinlock.h:353 [inline]
softirqs last disabled at (2830): [<ffff800084c894d0>] lock_sock_nested+0x70/0x110 net/core/sock.c:3927
CPU: 0 UID: 0 PID: 5008 Comm: syz.0.42 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 03400005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x138/0xb5c kernel/locking/qspinlock.c:219
lr : queued_spin_lock_slowpath+0x144/0xb5c kernel/locking/qspinlock.c:219
sp : ffff80009b9174e0
x29: ffff80009b917580 x28: ffff0000c8151d90 x27: 1fffe0001944c94b
x26: 1fffe0001902a3b2 x25: ffff0000c8151d80 x24: dfff800000000000
x23: ffff700013722ea0 x22: ffff700013722ec0 x21: ffff0000ca264a58
x20: ffff0000ca264a60 x19: ffff0000ca264a50 x18: ffff800123625000
x17: ffff0001ace95387 x16: ffff0000c8151d94 x15: 0000000020007000
x14: 00000000005e6a88 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: ffff60001944c94b x9 : 0000000000000000
x8 : 0000000000000001 x7 : ffff800084c894d0 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80008697b308
x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000001
Call trace:
 __cmpwait_case_8 arch/arm64/include/asm/cmpxchg.h:231 [inline] (P)
 __cmpwait arch/arm64/include/asm/cmpxchg.h:259 [inline] (P)
 queued_spin_lock_slowpath+0x138/0xb5c kernel/locking/qspinlock.c:219 (P)
 queued_spin_lock include/asm-generic/qspinlock.h:115 [inline]
 do_raw_spin_lock+0x21c/0x2d0 kernel/locking/spinlock_debug.c:116
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:183 [inline]
 _raw_spin_lock_bh+0x50/0x60 kernel/locking/spinlock.c:205
 spin_lock_bh include/linux/spinlock.h:353 [inline]
 lock_sock_nested+0x70/0x110 net/core/sock.c:3927
 lock_sock include/net/sock.h:1717 [inline]
 tipc_sendstream+0x54/0x88 net/tipc/socket.c:1550
 sock_sendmsg_nosec net/socket.c:800 [inline]
 __sock_sendmsg+0xc8/0x188 net/socket.c:818
 ____sys_sendmsg+0x3f8/0x6c8 net/socket.c:2715
 ___sys_sendmsg+0x198/0x224 net/socket.c:2769
 __sys_sendmmsg+0x204/0x580 net/socket.c:2858
 __do_sys_sendmmsg net/socket.c:2885 [inline]
 __se_sys_sendmmsg net/socket.c:2882 [inline]
 __arm64_sys_sendmmsg+0xac/0xc8 net/socket.c:2882
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5009 Comm: syz.0.42 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : should_resched arch/arm64/include/asm/preempt.h:80 [inline]
pc : __local_bh_enable_ip+0x150/0x234 kernel/softirq.c:480
lr : __local_bh_enable_ip+0x14c/0x234 kernel/softirq.c:478
sp : ffff800096516740
x29: ffff800096516740 x28: ffff800096516b80 x27: 000000007a3a32f3
x26: ffff0000dd3d8780 x25: ffff800096516800 x24: ffff700012ca2d00
x23: dfff800000000000 x22: 1fffe000191a6b11 x21: ffff800086493f3c
x20: 0000000000000201 x19: ffff0000c8d35888 x18: 00000000ffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: ffff800080d84024
x14: 00000000027c6219 x13: 0000000000000001 x12: 0000000000000003
x11: ffff80008b386328 x10: 0000000000000003 x9 : 0000000000000001
x8 : 0000000002d1a4ce x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000008 x3 : ffff8000801546f4
x2 : 0000000000000002 x1 : ffff0000c8d35880 x0 : ffff80012364b000
Call trace:
 __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
 arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
 __local_bh_enable_ip+0x150/0x234 kernel/softirq.c:478 (P)
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:237 [inline]
 _raw_spin_unlock_bh+0x3c/0x4c kernel/locking/spinlock.c:245
 spin_unlock_bh include/linux/spinlock.h:407 [inline]
 tipc_skb_peek_port net/tipc/msg.h:1235 [inline]
 tipc_sk_rcv+0x2ec/0x13f0 net/tipc/socket.c:2506
 tipc_node_xmit+0x1c8/0xb9c net/tipc/node.c:1708
 tipc_node_xmit_skb+0x10c/0x178 net/tipc/node.c:1773
 tipc_sk_rcv+0x11c0/0x13f0 net/tipc/socket.c:2537
 tipc_node_xmit+0x1c8/0xb9c net/tipc/node.c:1708
 tipc_sk_push_backlog+0x3a0/0x788 net/tipc/socket.c:1314
 tipc_sk_filter_connect net/tipc/socket.c:2260 [inline]
 tipc_sk_filter_rcv+0xcb8/0x1fa4 net/tipc/socket.c:2379
 tipc_sk_enqueue net/tipc/socket.c:2460 [inline]
 tipc_sk_rcv+0x5b0/0x13f0 net/tipc/socket.c:2512
 tipc_node_xmit+0x1c8/0xb9c net/tipc/node.c:1708
 tipc_node_xmit_skb net/tipc/node.c:1773 [inline]
 tipc_node_distr_xmit+0x264/0x370 net/tipc/node.c:1788
 tipc_sk_backlog_rcv+0x17c/0x23c net/tipc/socket.c:2427
 sk_backlog_rcv include/net/sock.h:1194 [inline]
 __release_sock+0x174/0x2c0 net/core/sock.c:3341
 release_sock+0x174/0x228 net/core/sock.c:3940
 tipc_release+0xca8/0x10d0 net/tipc/socket.c:652
 __sock_release+0xa0/0x1d4 net/socket.c:735
 sock_close+0x24/0x38 net/socket.c:1529
 __fput+0x338/0x74c fs/file_table.c:512
 fput_close_sync+0x10c/0x278 fs/file_table.c:618
 filp_close_sync+0x7c/0xb4 fs/open.c:1573
 __range_close fs/file.c:919 [inline]
 __do_sys_close_range fs/file.c:1003 [inline]
 __se_sys_close_range fs/file.c:954 [inline]
 __arm64_sys_close_range+0x898/0xbdc fs/file.c:954
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x19c/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
