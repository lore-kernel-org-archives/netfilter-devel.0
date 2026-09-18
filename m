Received: from mail-oa2-f8.google.com (mail-oa2-f8.google.com [74.125.231.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D4A274B53
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789691390; cv=none; b=dhCudAISq4fqXrkC/sy754dMhJKk3lhEpbo1iI8aJEajoBX1GQeO6u0V7zzAnHL+VSQIp2Ky8JIKzEkWMpSn6zRmkZNoJ9hs+mqfJgJo+c5nkfMi8kqTaHn69Chm1fwQxY7jOjrZWnwOLJr1Jt/U7QsgKtscwLMOHSRz7kCl3CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789691390; c=relaxed/simple;
	bh=iZkcCY1qux46h/yYRscH8n6naf9L6e4Y1k0uaC4/yfs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LxpgV4GwNQgL1UEEYtchUL6ULve+5tlchPKakBKLPJbe7Dsf5ElL7HZf6WDtCz8kjIvR6ZUE8dLycAxCXPh3jAsa0eTInRbyS8KvZm9Rny6IONfOmVgAjrfCnqQEc62XJB8vCC8Bd6M8MFVZXjGqKpek+Lic+Cbad5BZGcJ6Hvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f8.google.com with SMTP id 586e51a60fabf-46683b030d9so125477fac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 17:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789691387; x=1790296187;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63iMA5C5dpzJOq5uyh8ePlxGGheh8OuECdRYwFgpXMQ=;
        b=X9tYCmgvwuLRy65aJjGAv07nFeHa18pQwx3iTYv6DnlmuJMDA4LbNSIFZD3wa1NYTs
         jyQLylZoJT43II7gQ9kQMPwsM/UbT+HqOzIEIIDl6kLLIAj/ksV+TXwSNcEutjJtUEnG
         6vCuDC0G+j+w0rYFggoWhiw1RG3tItqwr/RGZjK5V8eLCwMnocqMUFRkqLUm28w4ZlON
         Ib68N6ya5IPNPW+DNUL1XRluUChefQBADssalHLslh7rJJeo/p/z4DiXwCnKrJFcis4b
         sujWR/G02LgnZYQCkUJgQhALUTocgxcOYO+MEj2WNyTMgUldYeERb5PEa1lVXJayPfqd
         SWrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQry48KntX10cyOiAtlvFHzy8uW5ssNEAAKebEXhUlo2N4yS9bhDr2wGUB1I7orlJGj9OjU2SiBqIEv71En1k=@vger.kernel.org
X-Gm-Message-State: AFuF++mkDVLxZj0mvD0h611ty2aOsXbNsJXAsjTGDeaK2ZYA21UUzujT
	3+Cn5ZudYpCONAblIpPEe1Xg8A4wwFuu1Sc0DTgRsPM+HWIQN7otMdt/Lxb6B7mp4zWZ4A22Cnl
	u8H7I8wEyeDpBlh6gR71/u5gCmtIwGu4pIs2sqGj4BYfkTZEdxUw/n6pqRyo=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3109:b0:6b7:46fa:1697 with SMTP id
 006d021491bc7-6ca9bf49b9fmr773832eaf.44.1789691387231; Thu, 17 Sep 2026
 17:29:47 -0700 (PDT)
Date: Thu, 17 Sep 2026 17:29:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aac85fb.87c06881.1db2b3.001d.GAE@google.com>
Subject: [syzbot] [netfilter?] INFO: task hung in nf_tables_valid_genid (3)
From: syzbot <syzbot+83439cb981624bd8d068@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0f23d56f17fd Merge tag 'linux_kselftest-next-7.3-rc1' of g..
git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux master
console output: https://syzkaller.appspot.com/x/log.txt?x=10289c8e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78e810c74248bbb
dashboard link: https://syzkaller.appspot.com/bug?extid=83439cb981624bd8d068
compiler:       arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11be9905580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-0f23d56f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/29f1f81851f8/vmlinux-0f23d56f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d12ab50ae201/zImage-0f23d56f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+83439cb981624bd8d068@syzkaller.appspotmail.com

INFO: task syz.1.416:5203 blocked for more than 430 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.416       state:D stack:0     pid:5203  tgid:5199  ppid:3693   task_flags:0x400140 flags:0x00000001
Call trace: 
[<81b71894>] (__schedule) from [<81b72d2c>] (__schedule_loop kernel/sched/core.c:7311 [inline])
[<81b71894>] (__schedule) from [<81b72d2c>] (schedule+0x2c/0xec kernel/sched/core.c:7326)
 r10:ed691a94 r9:ed691a9c r8:00000002 r7:60000013 r6:852b7ebc r5:858abd40
 r4:858abd40
[<81b72d00>] (schedule) from [<81b72e70>] (schedule_preempt_disabled+0x18/0x24 kernel/sched/core.c:7383)
 r5:858abd40 r4:852b7eb8
[<81b72e58>] (schedule_preempt_disabled) from [<81b75fe8>] (__mutex_lock_common kernel/locking/mutex.c:726 [inline])
[<81b72e58>] (schedule_preempt_disabled) from [<81b75fe8>] (__mutex_lock.constprop.0+0x50c/0xa48 kernel/locking/mutex.c:821)
[<81b75adc>] (__mutex_lock.constprop.0) from [<81b765f8>] (__mutex_lock_slowpath+0x14/0x18 kernel/locking/mutex.c:1164)
 r10:81e7de58 r9:85301000 r8:0000003c r7:852b7eb8 r6:852b7e80 r5:85301000
 r4:00000000
[<81b765e4>] (__mutex_lock_slowpath) from [<81b76638>] (mutex_lock+0x3c/0x40 kernel/locking/mutex.c:319)
[<81b765fc>] (mutex_lock) from [<817d505c>] (nf_tables_valid_genid+0x3c/0x70 net/netfilter/nf_tables_api.c:11512)
[<817d5020>] (nf_tables_valid_genid) from [<8179b5cc>] (nfnetlink_rcv_batch+0x138/0x9b8 net/netfilter/nfnetlink.c:421)
 r7:00000014 r6:82e3d2cc r5:ed691b68 r4:84bac240
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline])
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv+0x128/0x15c net/netfilter/nfnetlink.c:665)
 r10:86239d84 r9:85301000 r8:0000003c r7:00000014 r6:85778480 r5:00000000
 r4:833d2a80
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline])
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast+0x270/0x380 net/netlink/af_netlink.c:1345)
 r8:833d2a80 r7:85e32940 r6:0000003c r5:853dc464 r4:853dc400
[<8176bd88>] (netlink_unicast) from [<8176c2d0>] (netlink_sendmsg+0x1c8/0x444 net/netlink/af_netlink.c:1900)
 r10:00000000 r9:00000000 r8:00000000 r7:86239c00 r6:0000003c r5:833d2a80
 r4:ed691f28
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (sock_sendmsg_nosec net/socket.c:800 [inline])
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (__sock_sendmsg+0x44/0x78 net/socket.c:815)
 r10:0000c050 r9:00000000 r8:ed691dd4 r7:00000000 r6:84d12cc0 r5:ed691f28
 r4:00000000
[<8162f780>] (__sock_sendmsg) from [<81630864>] (____sys_sendmsg+0x238/0x2c4 net/socket.c:2709)
 r7:00000000 r6:00000000 r5:84d12cc0 r4:ed691f28
[<8163062c>] (____sys_sendmsg) from [<81630c64>] (___sys_sendmsg+0x9c/0xd0 net/socket.c:2763)
 r10:00000128 r9:20000cc0 r8:0000c050 r7:00000000 r6:84d12cc0 r5:ed691f28
 r4:00000000
[<81630bc8>] (___sys_sendmsg) from [<81632e3c>] (__sys_sendmsg+0x8c/0xe0 net/socket.c:2795)
 r9:858abd40 r8:861daf00 r7:0000c050 r6:20000cc0 r5:861daf01 r4:00000003
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (__do_sys_sendmsg net/socket.c:2800 [inline])
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (sys_sendmsg+0x14/0x18 net/socket.c:2798)
 r8:8020029c r7:00000128 r6:003563b0 r5:00000000 r4:00000000
[<81632e90>] (sys_sendmsg) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xed691fa8 to 0xed691ff0)
1fa0:                   00000000 00000000 00000003 20000cc0 0000c050 00000000
1fc0: 00000000 00000000 003563b0 00000128 00356378 00000000 003d0f00 76f510dc
1fe0: 76f50e88 76f50e78 00018fa0 00130a50
INFO: task syz.1.416:5203 is blocked on a mutex likely owned by task syz.1.416:5201.
task:syz.1.416       state:R  running task     stack:0     pid:5201  tgid:5199  ppid:3693   task_flags:0x400140 flags:0x00000001
Call trace: 
[<8028f53c>] (preempt_count_sub) from [<81b73128>] (preempt_schedule_irq+0x4c/0xa8 kernel/sched/core.c:7558)
[<81b3abac>] (call_with_stack) from [<80200bec>] (__irq_svc+0x8c/0xbc arch/arm/kernel/entry-armv.S:228)
Exception stack(0xed48d818 to 0xed48d860)
d800:                                                       ed48d8b4 82b857b8
d820: 80f0c938 85a0400c 82b857b8 80f0c938 ed48d8b4 8539a700 00000000 00000001
d840: 85094d08 ed48d88c 8493ccc0 ed48d868 80f0ca28 816ac064 80000013 ffffffff
[<816abf4c>] (flow_block_cb_setup_simple) from [<80f0ca28>] (nsim_setup_tc+0xa0/0xdc drivers/net/netdevsim/tc.c:87)
 r9:00000001 r8:00000000 r7:ed48d8e0 r6:85fa9d80 r5:00000000 r4:8539a000
[<80f0c988>] (nsim_setup_tc) from [<817f991c>] (nft_block_offload_cmd+0x80/0xf4 net/netfilter/nf_tables_offload.c:397)
[<817f989c>] (nft_block_offload_cmd) from [<817f9c78>] (nft_chain_offload_cmd net/netfilter/nf_tables_offload.c:451 [inline])
[<817f989c>] (nft_block_offload_cmd) from [<817f9c78>] (nft_flow_block_chain+0x98/0x184 net/netfilter/nf_tables_offload.c:471)
 r7:85fa9d80 r6:00000000 r5:00000000 r4:85fb5300
[<817f9be0>] (nft_flow_block_chain) from [<817fa7bc>] (nft_flow_offload_chain net/netfilter/nf_tables_offload.c:513 [inline])
[<817f9be0>] (nft_flow_block_chain) from [<817fa7bc>] (nft_flow_rule_offload_commit+0x1a4/0x1f4 net/netfilter/nf_tables_offload.c:592)
 r10:ed48dac0 r9:85301000 r8:85301000 r7:ed48d9b8 r6:81e7f1da r5:852b7e88
 r4:8626d880
[<817fa618>] (nft_flow_rule_offload_commit) from [<817eb044>] (nf_tables_commit+0x20c/0x2250 net/netfilter/nf_tables_api.c:10934)
 r10:ed48dac0 r9:85301000 r8:84193100 r7:00000011 r6:833d26c0 r5:852b7ea0
 r4:852b7e84
[<817eae38>] (nf_tables_commit) from [<8179bc68>] (nfnetlink_rcv_batch+0x7d4/0x9b8 net/netfilter/nfnetlink.c:574)
 r10:81e7de58 r9:81e7e028 r8:84193100 r7:00000011 r6:857782d8 r5:ed48db68
 r4:833d2d80
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline])
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv+0x128/0x15c net/netfilter/nfnetlink.c:665)
 r10:86239d84 r9:85301000 r8:000000ac r7:00000014 r6:85778240 r5:00000000
 r4:833d26c0
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline])
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast+0x270/0x380 net/netlink/af_netlink.c:1345)
 r8:833d26c0 r7:85e32940 r6:000000ac r5:853dc464 r4:853dc400
[<8176bd88>] (netlink_unicast) from [<8176c2d0>] (netlink_sendmsg+0x1c8/0x444 net/netlink/af_netlink.c:1900)
 r10:00000000 r9:00000000 r8:00000000 r7:86239c00 r6:000000ac r5:833d26c0
 r4:ed48df28
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (sock_sendmsg_nosec net/socket.c:800 [inline])
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (__sock_sendmsg+0x44/0x78 net/socket.c:815)
 r10:00000000 r9:00000000 r8:ed48ddd4 r7:00000000 r6:84d12cc0 r5:ed48df28
 r4:00000000
[<8162f780>] (__sock_sendmsg) from [<81630864>] (____sys_sendmsg+0x238/0x2c4 net/socket.c:2709)
 r7:00000000 r6:00000000 r5:84d12cc0 r4:ed48df28
[<8163062c>] (____sys_sendmsg) from [<81630c64>] (___sys_sendmsg+0x9c/0xd0 net/socket.c:2763)
 r10:00000128 r9:2000c2c0 r8:00000000 r7:00000000 r6:84d12cc0 r5:ed48df28
 r4:00000000
[<81630bc8>] (___sys_sendmsg) from [<81632e3c>] (__sys_sendmsg+0x8c/0xe0 net/socket.c:2795)
 r9:84193100 r8:861daf00 r7:00000000 r6:2000c2c0 r5:861daf01 r4:00000003
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (__do_sys_sendmsg net/socket.c:2800 [inline])
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (sys_sendmsg+0x14/0x18 net/socket.c:2798)
 r8:8020029c r7:00000128 r6:00356310 r5:00000000 r4:00000000
[<81632e90>] (sys_sendmsg) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xed48dfa8 to 0xed48dff0)
dfa0:                   00000000 00000000 00000003 2000c2c0 00000000 00000000
dfc0: 00000000 00000000 00356310 00000128 003562d8 00000000 00000001 76f720dc
dfe0: 76f71e88 76f71e78 00018fa0 00130a50
INFO: task syz.3.417:5204 blocked for more than 430 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.417       state:D stack:0     pid:5204  tgid:5200  ppid:3691   task_flags:0x400140 flags:0x00000001
Call trace: 
[<81b71894>] (__schedule) from [<81b72d2c>] (__schedule_loop kernel/sched/core.c:7311 [inline])
[<81b71894>] (__schedule) from [<81b72d2c>] (schedule+0x2c/0xec kernel/sched/core.c:7326)
 r10:ed695ab4 r9:ed695abc r8:00000002 r7:60000013 r6:82e3d2d0 r5:84186e40
 r4:84186e40
[<81b72d00>] (schedule) from [<81b72e70>] (schedule_preempt_disabled+0x18/0x24 kernel/sched/core.c:7383)
 r5:84186e40 r4:82e3d2cc
[<81b72e58>] (schedule_preempt_disabled) from [<81b75fe8>] (__mutex_lock_common kernel/locking/mutex.c:726 [inline])
[<81b72e58>] (schedule_preempt_disabled) from [<81b75fe8>] (__mutex_lock.constprop.0+0x50c/0xa48 kernel/locking/mutex.c:821)
[<81b75adc>] (__mutex_lock.constprop.0) from [<81b765f8>] (__mutex_lock_slowpath+0x14/0x18 kernel/locking/mutex.c:1164)
 r10:8623a984 r9:85359000 r8:0000003c r7:00000014 r6:833d7840 r5:ed695b68
 r4:833d2f00
[<81b765e4>] (__mutex_lock_slowpath) from [<81b76638>] (mutex_lock+0x3c/0x40 kernel/locking/mutex.c:319)
[<81b765fc>] (mutex_lock) from [<8179b570>] (nfnl_lock net/netfilter/nfnetlink.c:96 [inline])
[<81b765fc>] (mutex_lock) from [<8179b570>] (nfnetlink_rcv_batch+0xdc/0x9b8 net/netfilter/nfnetlink.c:392)
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline])
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv+0x128/0x15c net/netfilter/nfnetlink.c:665)
 r10:8623a984 r9:85359000 r8:0000003c r7:00000014 r6:83137b00 r5:00000000
 r4:833d7840
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline])
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast+0x270/0x380 net/netlink/af_netlink.c:1345)
 r8:833d7840 r7:8506b300 r6:0000003c r5:851e5c64 r4:851e5c00
[<8176bd88>] (netlink_unicast) from [<8176c2d0>] (netlink_sendmsg+0x1c8/0x444 net/netlink/af_netlink.c:1900)
 r10:00000000 r9:00000000 r8:00000000 r7:8623a800 r6:0000003c r5:833d7840
 r4:ed695f28
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (sock_sendmsg_nosec net/socket.c:800 [inline])
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (__sock_sendmsg+0x44/0x78 net/socket.c:815)
 r10:0000c050 r9:00000000 r8:ed695dd4 r7:00000000 r6:84d12f40 r5:ed695f28
 r4:00000000
[<8162f780>] (__sock_sendmsg) from [<81630864>] (____sys_sendmsg+0x238/0x2c4 net/socket.c:2709)
 r7:00000000 r6:00000000 r5:84d12f40 r4:ed695f28
[<8163062c>] (____sys_sendmsg) from [<81630c64>] (___sys_sendmsg+0x9c/0xd0 net/socket.c:2763)
 r10:00000128 r9:20000cc0 r8:0000c050 r7:00000000 r6:84d12f40 r5:ed695f28
 r4:00000000
[<81630bc8>] (___sys_sendmsg) from [<81632e3c>] (__sys_sendmsg+0x8c/0xe0 net/socket.c:2795)
 r9:84186e40 r8:861dd080 r7:0000c050 r6:20000cc0 r5:861dd081 r4:00000003
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (__do_sys_sendmsg net/socket.c:2800 [inline])
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (sys_sendmsg+0x14/0x18 net/socket.c:2798)
 r8:8020029c r7:00000128 r6:003563b0 r5:00000000 r4:00000000
[<81632e90>] (sys_sendmsg) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xed695fa8 to 0xed695ff0)
5fa0:                   00000000 00000000 00000003 20000cc0 0000c050 00000000
5fc0: 00000000 00000000 003563b0 00000128 00356378 00000000 003d0f00 76fd10dc
5fe0: 76fd0e88 76fd0e78 00018fa0 00130a50
INFO: task syz.3.417:5204 is blocked on a mutex likely owned by task syz.1.416:5203.
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 29 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
Call trace: 
[<80201998>] (dump_backtrace) from [<80201a8c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:257)
 r7:60000193 r6:60000193 r5:82336570 r4:00000000
[<80201a74>] (show_stack) from [<8021ec68>] (__dump_stack lib/dump_stack.c:94 [inline])
[<80201a74>] (show_stack) from [<8021ec68>] (dump_stack_lvl+0x5c/0x70 lib/dump_stack.c:120)
[<8021ec0c>] (dump_stack_lvl) from [<8021ec94>] (dump_stack+0x18/0x1c lib/dump_stack.c:129)
 r7:00000000 r6:00000113 r5:00000000 r4:00000001
[<8021ec7c>] (dump_stack) from [<81b5aefc>] (nmi_cpu_backtrace+0x150/0x170 lib/nmi_backtrace.c:122)
[<81b5adac>] (nmi_cpu_backtrace) from [<81b5b050>] (nmi_trigger_cpumask_backtrace+0x134/0x208 lib/nmi_backtrace.c:65)
 r7:82a0b150 r6:83178000 r5:82a1c7b8 r4:ffffffff
[<81b5af1c>] (nmi_trigger_cpumask_backtrace) from [<802300d4>] (arch_trigger_cpumask_backtrace+0x18/0x1c arch/arm/kernel/smp.c:851)
 r9:82a0b2f0 r8:00000002 r7:82a1ce80 r6:82ccce2c r5:00007ec3 r4:00000048
[<802300bc>] (arch_trigger_cpumask_backtrace) from [<81b62b8c>] (trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline])
[<802300bc>] (arch_trigger_cpumask_backtrace) from [<81b62b8c>] (__sys_info lib/sys_info.c:157 [inline])
[<802300bc>] (arch_trigger_cpumask_backtrace) from [<81b62b8c>] (sys_info+0x68/0xa8 lib/sys_info.c:165)
[<81b62b24>] (sys_info) from [<80390a60>] (check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline])
[<81b62b24>] (sys_info) from [<80390a60>] (watchdog+0x3a0/0x848 kernel/hung_task.c:561)
 r5:00007ec3 r4:0000000a
[<803906c0>] (watchdog) from [<802827b4>] (kthread+0x11c/0x154 kernel/kthread.c:436)
 r10:00000000 r9:df819e60 r8:83114000 r7:00000000 r6:803906c0 r5:83178000
 r4:83882900
[<80282698>] (kthread) from [<80200114>] (ret_from_fork+0x14/0x20 arch/arm/kernel/entry-common.S:137)
Exception stack(0xdf8d5fb0 to 0xdf8d5ff8)
5fa0:                                     00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80282698 r4:83882900
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5202 Comm: syz.3.417 Not tainted syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
PC is at flow_block_cb_is_busy net/core/flow_offload.c:325 [inline]
PC is at flow_block_cb_setup_simple+0x118/0x1fc net/core/flow_offload.c:351
LR is at nsim_setup_tc+0xa0/0xdc drivers/net/netdevsim/tc.c:87
pc : [<816ac064>]    lr : [<80f0ca28>]    psr: 80000013
sp : ed055868  ip : 82b428d8  fp : ed05588c
r10: 85fb6948  r9 : 00000001  r8 : 00000000
r7 : 85366700  r6 : ed0558b4  r5 : 80f0c938  r4 : 82b857b8
r3 : 828d2500  r2 : 80f0c938  r1 : 82b857b8  r0 : ed0558b4
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 30c5387d  Table: 86288000  DAC: 00000000
Call trace: 
[<816abf4c>] (flow_block_cb_setup_simple) from [<80f0ca28>] (nsim_setup_tc+0xa0/0xdc drivers/net/netdevsim/tc.c:87)
 r9:00000001 r8:00000000 r7:ed0558e0 r6:85fa9f00 r5:00000000 r4:85366000
[<80f0c988>] (nsim_setup_tc) from [<817f991c>] (nft_block_offload_cmd+0x80/0xf4 net/netfilter/nf_tables_offload.c:397)
[<817f989c>] (nft_block_offload_cmd) from [<817f9c78>] (nft_chain_offload_cmd net/netfilter/nf_tables_offload.c:451 [inline])
[<817f989c>] (nft_block_offload_cmd) from [<817f9c78>] (nft_flow_block_chain+0x98/0x184 net/netfilter/nf_tables_offload.c:471)
 r7:85fa9f00 r6:00000000 r5:00000000 r4:831df0c0
[<817f9be0>] (nft_flow_block_chain) from [<817fa7bc>] (nft_flow_offload_chain net/netfilter/nf_tables_offload.c:513 [inline])
[<817f9be0>] (nft_flow_block_chain) from [<817fa7bc>] (nft_flow_rule_offload_commit+0x1a4/0x1f4 net/netfilter/nf_tables_offload.c:592)
 r10:ed055ac0 r9:85359000 r8:85359000 r7:ed0559b8 r6:81e7f1da r5:85fb2c08
 r4:8626d580
[<817fa618>] (nft_flow_rule_offload_commit) from [<817eb044>] (nf_tables_commit+0x20c/0x2250 net/netfilter/nf_tables_api.c:10934)
 r10:ed055ac0 r9:85359000 r8:858a8000 r7:00000011 r6:833d3540 r5:85fb2c20
 r4:85fb2c04
[<817eae38>] (nf_tables_commit) from [<8179bc68>] (nfnetlink_rcv_batch+0x7d4/0x9b8 net/netfilter/nfnetlink.c:574)
 r10:81e7de58 r9:81e7e028 r8:858a8000 r7:00000011 r6:85769298 r5:ed055b68
 r4:833d29c0
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline])
[<8179b494>] (nfnetlink_rcv_batch) from [<8179bf74>] (nfnetlink_rcv+0x128/0x15c net/netfilter/nfnetlink.c:665)
 r10:8623a984 r9:85359000 r8:000000ac r7:00000014 r6:85769200 r5:00000000
 r4:833d3540
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline])
[<8179be4c>] (nfnetlink_rcv) from [<8176bff8>] (netlink_unicast+0x270/0x380 net/netlink/af_netlink.c:1345)
 r8:833d3540 r7:8506b300 r6:000000ac r5:851e5c64 r4:851e5c00
[<8176bd88>] (netlink_unicast) from [<8176c2d0>] (netlink_sendmsg+0x1c8/0x444 net/netlink/af_netlink.c:1900)
 r10:00000000 r9:00000000 r8:00000000 r7:8623a800 r6:000000ac r5:833d3540
 r4:ed055f28
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (sock_sendmsg_nosec net/socket.c:800 [inline])
[<8176c108>] (netlink_sendmsg) from [<8162f7c4>] (__sock_sendmsg+0x44/0x78 net/socket.c:815)
 r10:00000000 r9:00000000 r8:ed055dd4 r7:00000000 r6:84d12f40 r5:ed055f28
 r4:00000000
[<8162f780>] (__sock_sendmsg) from [<81630864>] (____sys_sendmsg+0x238/0x2c4 net/socket.c:2709)
 r7:00000000 r6:00000000 r5:84d12f40 r4:ed055f28
[<8163062c>] (____sys_sendmsg) from [<81630c64>] (___sys_sendmsg+0x9c/0xd0 net/socket.c:2763)
 r10:00000128 r9:2000c2c0 r8:00000000 r7:00000000 r6:84d12f40 r5:ed055f28
 r4:00000000
[<81630bc8>] (___sys_sendmsg) from [<81632e3c>] (__sys_sendmsg+0x8c/0xe0 net/socket.c:2795)
 r9:858a8000 r8:861dd080 r7:00000000 r6:2000c2c0 r5:861dd081 r4:00000003
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (__do_sys_sendmsg net/socket.c:2800 [inline])
[<81632db0>] (__sys_sendmsg) from [<81632ea4>] (sys_sendmsg+0x14/0x18 net/socket.c:2798)
 r8:8020029c r7:00000128 r6:00356310 r5:00000000 r4:00000000
[<81632e90>] (sys_sendmsg) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xed055fa8 to 0xed055ff0)
5fa0:                   00000000 00000000 00000003 2000c2c0 00000000 00000000
5fc0: 00000000 00000000 00356310 00000128 003562d8 00000000 00000001 76ff20dc
5fe0: 76ff1e88 76ff1e78 00018fa0 00130a50


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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
