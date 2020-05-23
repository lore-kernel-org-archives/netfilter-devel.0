Return-Path: <SRS0=NxHY=7F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3274FC433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 May 2020 07:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FC120723
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 May 2020 07:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387673AbgEWH3S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 May 2020 03:29:18 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:46011 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387622AbgEWH3R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 May 2020 03:29:17 -0400
Received: by mail-io1-f71.google.com with SMTP id y6so8889066iol.12
        for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2020 00:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=URfabu0vKqV63BojTfHzXnf8eicb+TRu6nrD2d8nH2k=;
        b=c9/S/lrlb2hnDpLk5+GrBC137ZNgSX1rVxpmWTnrpbVTAbbn4kyarjL7kVfqYwT+XD
         7JK2yUt6BmhNenvpj3mkYQZpb6L8yfW/9FBN425LVnf35E4rw2kXvUGMa+Gb9c3lfWk5
         HMLctEcHGcPXmJA2PRZ6zNC8W5Nshyt86coTyKQDOvTgev/wn/SNboFcYZakE5rvvcHi
         nZZoKUlx3K3vPpRP0f60mc6StYOi6QhgtSpkvaQyjrwF8wLk7BQt/zIiik8NJyd8F7jk
         KlmQSffKKIN2oj3ezlxMRFPE020dnsu/NXE9ppeBqsTnGxds7NY95TuSGVF4B6QSSUWB
         dfEA==
X-Gm-Message-State: AOAM531RtFfdwBlTXpwpUvO3SWGI8Fu2j/PdXnl0FRWPmS5YPez7njb/
        EKKpn8NjZRp7lYVm3QI1P3ViP30+94Nb4pH2s9xMsw3rjPlu
X-Google-Smtp-Source: ABdhPJzT1xMSR3A/6kdLMBO8+9MhM93wKRvEnOM9aUfxdZt/EIFb5VDRurnOGG8bUyI0mrkFcQpEoDi4FOfr2clDJcuXvFXQr+lC
MIME-Version: 1.0
X-Received: by 2002:a02:8529:: with SMTP id g38mr66142jai.143.1590218956131;
 Sat, 23 May 2020 00:29:16 -0700 (PDT)
Date:   Sat, 23 May 2020 00:29:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fef2d505a64bb3d7@google.com>
Subject: WARNING: proc registration bug in clusterip_tg_check (2)
From:   syzbot <syzbot+35e9c587ab6de655a1b3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d2f8825a Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10eed272100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c33c7f7c5471fd39
dashboard link: https://syzkaller.appspot.com/bug?extid=35e9c587ab6de655a1b3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+35e9c587ab6de655a1b3@syzkaller.appspotmail.com

------------[ cut here ]------------
proc_dir_entry 'ipt_CLUSTERIP/127.0.0.1' already registered
WARNING: CPU: 1 PID: 21213 at fs/proc/generic.c:363 proc_register+0x2bc/0x4e0 fs/proc/generic.c:362
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 21213 Comm: syz-executor.2 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:proc_register+0x2bc/0x4e0 fs/proc/generic.c:362
Code: 08 4c 8b 74 24 28 48 8b 6c 24 20 74 08 48 89 ef e8 a9 35 d1 ff 48 8b 55 00 48 c7 c7 c4 82 e9 88 48 89 de 31 c0 e8 b4 50 65 ff <0f> 0b 48 c7 c7 c0 00 33 89 e8 c6 b6 2b 06 48 8b 44 24 30 42 8a 04
RSP: 0018:ffffc900196af938 EFLAGS: 00010246
RAX: 516b049ad9e30c00 RBX: ffff88805557e8e4 RCX: 0000000000040000
RDX: ffffc9000d311000 RSI: 000000000001758c RDI: 000000000001758d
RBP: ffff88805a697e98 R08: ffffffff815cd2b9 R09: ffffed1015d26660
R10: ffffed1015d26660 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000009 R14: ffff88805a697e54 R15: ffff88805a697dc0
 proc_create_data+0x1d0/0x240 fs/proc/generic.c:551
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:281 [inline]
 clusterip_tg_check+0xa5b/0x10e0 net/ipv4/netfilter/ipt_CLUSTERIP.c:502
 xt_check_target+0x6c6/0xb10 net/netfilter/x_tables.c:1019
 check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
 find_check_entry net/ipv4/netfilter/ip_tables.c:553 [inline]
 translate_table+0x17b0/0x20e0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
 do_ipt_set_ctl+0x28b/0x4c0 net/ipv4/netfilter/ip_tables.c:1672
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x2be/0x2e0 net/netfilter/nf_sockopt.c:115
 __sys_setsockopt+0x564/0x710 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2148 [inline]
 __se_sys_setsockopt net/socket.c:2145 [inline]
 __x64_sys_setsockopt+0xb1/0xc0 net/socket.c:2145
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa4aaf69c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000501e00 RCX: 000000000045ca29
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000078bfa0 R08: 0000000000000260 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a3f R14: 00000000004cd086 R15: 00007fa4aaf6a6d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
