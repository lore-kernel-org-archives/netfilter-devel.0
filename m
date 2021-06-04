Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DEEC4708F
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 07:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B136141D
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 07:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhFDHeB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 03:34:01 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:46016 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhFDHeB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 03:34:01 -0400
Received: by mail-il1-f200.google.com with SMTP id s18-20020a92cbd20000b02901bb78581beaso5861612ilq.12
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jun 2021 00:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2tz0X9F41gyVCNtIQhviwlFR2aUQZipHVATshl7l/Ec=;
        b=KgjFx6DTOabqBqs1IXtHaOTNlLmvOnVBzxZfJnRGiz07sLBBi/oZ5QW8mQD/3zzhXv
         RS9BWhbM7bCtRWDeUZ61hkU1LSlIy47E+WbQftIkLKtULt2/EwyjER8nyQs9GkSUqNtz
         Xhd82fXHnYaMvaAwLrfYK/8/hojfF27anMdO9avU1omiQZj9CrZYLnblMYp7b6upTWui
         St4OXR4en7W06Ur4i/ZfR24sDdAll8xPIj0khSZJnab9It722I49D1y0jtkfzP6OHBMm
         tTO/fT0Sn8LFN54PLDyirtxn63rgLJahGJWkD3OgUQIOBeqtFvFoMKApC7qWs3x3OpWN
         v44Q==
X-Gm-Message-State: AOAM533gtw7MSh/j7lgv6y7iSXTntx7GWB6Ytw0y8nMQDNCywIQA6xNa
        xyxBICPQs4b3re4S/fkBiv/cZQcDfjp0frgpF1FPFizjdgxe
X-Google-Smtp-Source: ABdhPJy2WOKJwjYNauYY3nNUk1lkuFKLsJ45T0Zcc4wdDK6FTSWUMhuOMjEe2Nrl5GHKQUmPxYbnbFDfvrsYRUD7JJn+kkRXJNcy
MIME-Version: 1.0
X-Received: by 2002:a05:6638:211:: with SMTP id e17mr2966879jaq.72.1622791935096;
 Fri, 04 Jun 2021 00:32:15 -0700 (PDT)
Date:   Fri, 04 Jun 2021 00:32:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d6019e05c3ebb005@google.com>
Subject: [syzbot] KMSAN: uninit-value in translate_table (2)
From:   syzbot <syzbot+761644ed2ba863e99b41@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, glider@google.com, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6099c9da x86: entry: speculatively unpoison pt_regs in do_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1609edefd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6842a91012889c
dashboard link: https://syzkaller.appspot.com/bug?extid=761644ed2ba863e99b41
compiler:       Debian clang version 11.0.1-2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+761644ed2ba863e99b41@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in check_entry_size_and_hooks net/ipv4/netfilter/ip_tables.c:599 [inline]
BUG: KMSAN: uninit-value in translate_table+0xdbf/0x3c40 net/ipv4/netfilter/ip_tables.c:685
CPU: 0 PID: 12412 Comm: syz-executor.0 Not tainted 5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 check_entry_size_and_hooks net/ipv4/netfilter/ip_tables.c:599 [inline]
 translate_table+0xdbf/0x3c40 net/ipv4/netfilter/ip_tables.c:685
 translate_compat_table net/ipv4/netfilter/ip_tables.c:1463 [inline]
 compat_do_replace net/ipv4/netfilter/ip_tables.c:1517 [inline]
 do_ipt_set_ctl+0x446a/0x56a0 net/ipv4/netfilter/ip_tables.c:1624
 nf_setsockopt+0x59e/0x600 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0x651f/0x8ab0 net/ipv4/ip_sockglue.c:1435
 tcp_setsockopt+0x239/0x270 net/ipv4/tcp.c:3643
 sock_common_setsockopt+0x16c/0x1b0 net/core/sock.c:3263
 __sys_setsockopt+0x94c/0xd80 net/socket.c:2117
 __do_sys_setsockopt net/socket.c:2128 [inline]
 __se_sys_setsockopt+0xdd/0x100 net/socket.c:2125
 __ia32_sys_setsockopt+0x62/0x80 net/socket.c:2125
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x77/0xd0 arch/x86/entry/common.c:168
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:211
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7ff0549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55ea5fc EFLAGS: 00000296 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000040 RSI: 00000000200008c0 RDI: 000000000000027c
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node+0xa3c/0x1440 mm/slub.c:4116
 kmalloc_node include/linux/slab.h:577 [inline]
 kvmalloc_node+0x201/0x3d0 mm/util.c:587
 kvmalloc include/linux/mm.h:785 [inline]
 xt_alloc_table_info+0xce/0x1c0 net/netfilter/x_tables.c:1178
 translate_compat_table net/ipv4/netfilter/ip_tables.c:1427 [inline]
 compat_do_replace net/ipv4/netfilter/ip_tables.c:1517 [inline]
 do_ipt_set_ctl+0x2978/0x56a0 net/ipv4/netfilter/ip_tables.c:1624
 nf_setsockopt+0x59e/0x600 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0x651f/0x8ab0 net/ipv4/ip_sockglue.c:1435
 tcp_setsockopt+0x239/0x270 net/ipv4/tcp.c:3643
 sock_common_setsockopt+0x16c/0x1b0 net/core/sock.c:3263
 __sys_setsockopt+0x94c/0xd80 net/socket.c:2117
 __do_sys_setsockopt net/socket.c:2128 [inline]
 __se_sys_setsockopt+0xdd/0x100 net/socket.c:2125
 __ia32_sys_setsockopt+0x62/0x80 net/socket.c:2125
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x77/0xd0 arch/x86/entry/common.c:168
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:211
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
