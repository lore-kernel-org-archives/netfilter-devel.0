Return-Path: <SRS0=kGcq=BX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3376EC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Aug 2020 03:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C4B2053B
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Aug 2020 03:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHMDpY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Aug 2020 23:45:24 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56564 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgHMDpY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Aug 2020 23:45:24 -0400
Received: by mail-io1-f71.google.com with SMTP id q20so3123910iod.23
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2020 20:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5fOerBOgtCPzRD6DaJSK75fAycF0jkD27NVs0k5zNK8=;
        b=pss8H6Q8UZLz++42bL1IBDFeKI5ialwNLs4Yw3rDnNDPf86FeNRH56Xh5TUV2BWScl
         iGGgIxOS0znjkJjTXgeE3gAELql1mgWIiMOT074XBeP7nTw2EDutUiWXEcvoJlaJ4aFz
         RAWdcO2qrHPIphRiBSxD99FPzch6v27oMotOhKRkX6BGTRm/tFqyI0pTQ0iJAnqNhSRk
         yBFepeG3E9nHPfxGD64OwV8wmveDGDekxwiWgXyXl4ZlYYnA+MoVK+d9DKLL0KLyPkxC
         q+Hs6gAvaWsdb1jcfvj49nImDCr3MdR92TUcv9Z3Yd7jScJIarDcbHN9wkjk/pyjEi8w
         /5kA==
X-Gm-Message-State: AOAM533zNZPWY9pM5yBF+LsfNAr9IfDCZePuwoMwT8Gm6YuGDlELzya0
        UT+6lJhlSwlplUnG2MrAHHkqlB9xnixA/Fa/8cpa2Ioz/Nax
X-Google-Smtp-Source: ABdhPJxz4SQu4A4rdaQz1JJUS90biGgjK7Mm9sZZE4NzvdVqRmeRD40WWpsBvRjHG3bQJOxi3NZRYHnot5kBb62meeUF8lLcp2uq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:42:: with SMTP id i2mr2552973ilr.184.1597290323164;
 Wed, 12 Aug 2020 20:45:23 -0700 (PDT)
Date:   Wed, 12 Aug 2020 20:45:23 -0700
In-Reply-To: <000000000000ece9db05ac4054e8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000050c61e05acba22b6@google.com>
Subject: Re: WARNING in compat_do_ebt_get_ctl
From:   syzbot <syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    fb893de3 Merge tag 'tag-chrome-platform-for-v5.9' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1742b31c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fedc63022bf07e
dashboard link: https://syzkaller.appspot.com/bug?extid=5accb5c62faa1d346480
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13280fd6900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1409f4a6900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com

------------[ cut here ]------------
Buffer overflow detected (80 < 137)!
WARNING: CPU: 0 PID: 6853 at include/linux/thread_info.h:134 copy_overflow include/linux/thread_info.h:134 [inline]
WARNING: CPU: 0 PID: 6853 at include/linux/thread_info.h:134 check_copy_size include/linux/thread_info.h:143 [inline]
WARNING: CPU: 0 PID: 6853 at include/linux/thread_info.h:134 copy_to_user include/linux/uaccess.h:151 [inline]
WARNING: CPU: 0 PID: 6853 at include/linux/thread_info.h:134 compat_do_ebt_get_ctl+0x47e/0x500 net/bridge/netfilter/ebtables.c:2270
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6853 Comm: syz-executor171 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:copy_overflow include/linux/thread_info.h:134 [inline]
RIP: 0010:check_copy_size include/linux/thread_info.h:143 [inline]
RIP: 0010:copy_to_user include/linux/uaccess.h:151 [inline]
RIP: 0010:compat_do_ebt_get_ctl+0x47e/0x500 net/bridge/netfilter/ebtables.c:2270
Code: ba fd ff ff 4c 89 f7 e8 60 07 a2 fa e9 ad fd ff ff e8 36 18 62 fa 4c 89 e2 be 50 00 00 00 48 c7 c7 40 b9 0e 89 e8 94 1f 33 fa <0f> 0b e9 dc fd ff ff 41 bc f2 ff ff ff e9 4f fe ff ff e8 3b 07 a2
RSP: 0018:ffffc90005667ae8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 1ffff92000accf5e RCX: 0000000000000000
RDX: ffff88809458a280 RSI: ffffffff815dbce7 RDI: fffff52000accf4f
RBP: ffffffff8a8faa60 R08: 0000000000000001 R09: ffff8880ae6318e7
R10: 0000000000000000 R11: 0000000035383654 R12: 0000000000000089
R13: 0000000020000000 R14: ffffc90005667d80 R15: ffffc90005667b20
 do_ebt_get_ctl+0x2b4/0x790 net/bridge/netfilter/ebtables.c:2317
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1778 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1757
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:3884
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2179
 __do_sys_getsockopt net/socket.c:2194 [inline]
 __se_sys_getsockopt net/socket.c:2191 [inline]
 __ia32_sys_getsockopt+0xb9/0x150 net/socket.c:2191
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f91569
Code: 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffdae08c EFLAGS: 00000292 ORIG_RAX: 000000000000016d
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000082 RSI: 0000000020000000 RDI: 0000000020000100
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

