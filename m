Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B72EC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 16:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B7D3207F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 16:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgFOQeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 12:34:16 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:43135 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730431AbgFOQeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 12:34:14 -0400
Received: by mail-il1-f200.google.com with SMTP id e5so12433723ill.10
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 09:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+III3aXkFFJ9yP+n6+nxbVUD8k1XkNV3rHdJ7kl4cmA=;
        b=Zru7RKX6eOYuiaFr5tacZLqpcR6Cx0xnh7SsWEMSBHAh0ASRI6cdGOD7ojogV6ciTN
         SW/y6Wt5GPcjU/rvxDqXgBnNFgu6+O3utr5OYjTWqMzew64Cxz4Nv0XJoW6KmnNZLt9F
         RzvmVkaBnCpHFxATYG66WhfeEcBmO45BFH0in4VfHOJoqlyp50HqCzzEKiEF5Cu0XcEr
         zfFogHW/KolJMBfQUZzBpCrxpTv9XSiUh9xolXg3skgPzD+L7BPfHWN9U9UkIMp5hzG8
         MUisqi2e15asUiVsQKhgyD0hdL3r4ObB+aT9NQtVRc1ovKeatysU7esatdyuQeer4ZhB
         nAVA==
X-Gm-Message-State: AOAM530rdA032Oer+D0+1+cgWXi5pTr+LJtFEjTdqyrpg0CjpBUnsTwB
        PninBy/MP9/PxY+rU0IqoYsg+2VPPjfMuRxqGrHX0/+9CW8Z
X-Google-Smtp-Source: ABdhPJwkaSk9fTYxMx00zMVPbdegfiCe67Vlh96qINLM3EuYiwpOVW9Op+ePl2kJhMwEmUQm3lSgM7MV3rjICFG3IN/kQr2LazaA
MIME-Version: 1.0
X-Received: by 2002:a5d:914d:: with SMTP id y13mr28424979ioq.48.1592238852886;
 Mon, 15 Jun 2020 09:34:12 -0700 (PDT)
Date:   Mon, 15 Jun 2020 09:34:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003955f505a821ffda@google.com>
Subject: KMSAN: uninit-value in hash_ip6_del
From:   syzbot <syzbot+81b3ea575b0ab527b8b4@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, glider@google.com, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f0d5ec90 kmsan: apply __no_sanitize_memory to dotraplinkag..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17927f2e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86e4f8af239686c6
dashboard link: https://syzkaller.appspot.com/bug?extid=81b3ea575b0ab527b8b4
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+81b3ea575b0ab527b8b4@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __read_once_size include/linux/compiler.h:206 [inline]
BUG: KMSAN: uninit-value in hash_ip6_del+0x92b/0x1d30 net/netfilter/ipset/ip_set_hash_gen.h:1069
CPU: 1 PID: 19407 Comm: syz-executor.1 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __read_once_size include/linux/compiler.h:206 [inline]
 hash_ip6_del+0x92b/0x1d30 net/netfilter/ipset/ip_set_hash_gen.h:1069
 hash_ip6_uadt+0x8e6/0xad0 net/netfilter/ipset/ip_set_hash_ip.c:267
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1732
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1820
 ip_set_udel+0xf9/0x110 net/netfilter/ipset/ip_set_core.c:1854
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __compat_sys_sendmsg net/compat.c:658 [inline]
 __do_compat_sys_sendmsg net/compat.c:665 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:662
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:662
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3bf/0x6d0 arch/x86/entry/common.c:398
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fe3dd9
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f5dde0cc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000200002c0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ip6_netmask include/linux/netfilter/ipset/pfxlen.h:49 [inline]
 hash_ip6_netmask net/netfilter/ipset/ip_set_hash_ip.c:185 [inline]
 hash_ip6_uadt+0x9df/0xad0 net/netfilter/ipset/ip_set_hash_ip.c:263
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1732
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1820
 ip_set_udel+0xf9/0x110 net/netfilter/ipset/ip_set_core.c:1854
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __compat_sys_sendmsg net/compat.c:658 [inline]
 __do_compat_sys_sendmsg net/compat.c:665 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:662
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:662
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3bf/0x6d0 arch/x86/entry/common.c:398
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 ip_set_get_ipaddr6+0x26a/0x300 net/netfilter/ipset/ip_set_core.c:325
 hash_ip6_uadt+0x450/0xad0 net/netfilter/ipset/ip_set_hash_ip.c:255
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1732
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1820
 ip_set_udel+0xf9/0x110 net/netfilter/ipset/ip_set_core.c:1854
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __compat_sys_sendmsg net/compat.c:658 [inline]
 __do_compat_sys_sendmsg net/compat.c:665 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:662
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:662
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3bf/0x6d0 arch/x86/entry/common.c:398
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2802 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4436
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __compat_sys_sendmsg net/compat.c:658 [inline]
 __do_compat_sys_sendmsg net/compat.c:665 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:662
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:662
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3bf/0x6d0 arch/x86/entry/common.c:398
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
