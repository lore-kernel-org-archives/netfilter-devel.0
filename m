Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AC9C43462
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 17:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A4461182
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 17:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhECRWh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 13:22:37 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:57331 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhECRWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 13:22:20 -0400
Received: by mail-io1-f69.google.com with SMTP id y20-20020a6bd8140000b02903e6787c4986so3788371iob.23
        for <netfilter-devel@vger.kernel.org>; Mon, 03 May 2021 10:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PmToXBImkI7KxfCI+FowXrQSxpirCmDD8jPohkDzvPA=;
        b=Vsl14noazBYuTOUYSdBgdj0c3i7kdWNsCtGbI31YVhSLJKH3Q0NKuEGOzlGP3l3It4
         vEpuXC8waVk/RWTO2UzxNqZ5Wse4qO6/BNf0oKjgoLbY39oHN+ROsV4oCuRXDsTBPixJ
         dhzWSD1Rgv2tGnq0xbtfV5W+E/OlFfnf+qWE7JVM0SCAnZSUTUMvlWuWq8rNiTU59JfI
         /NMfcgd0feri9BRNkknfAltxKBuMVMjNN/9fwelKiLsBg/+Jm5A1VYObtOa/XS7kboYl
         a0jBezmtYMvP/mxp2S5XhA8h5kaGHAUCash76Rib07OGLB8+0ZwHb8jGH8ZAA+dBvWWM
         b+vg==
X-Gm-Message-State: AOAM5329NW45w/ZbaXyjaTDHxVI43COTyTFUB2L3xe+16E2yNumnXwny
        QnMiVqiFJ3XseS3GssE5wbW+W9VgRkYFh0zv1QrMKVaJ20TR
X-Google-Smtp-Source: ABdhPJzBdcLciDhmBdRBkgDQi4x+AqgpCqFyNzSauL8Nx0gPbD+rJVhAFXy7De2cTBWgubGJ7Sti4UHJJzxbOmvqTgkrF+p8qS2+
MIME-Version: 1.0
X-Received: by 2002:a92:d682:: with SMTP id p2mr16658854iln.75.1620062486429;
 Mon, 03 May 2021 10:21:26 -0700 (PDT)
Date:   Mon, 03 May 2021 10:21:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000485d705c17031fd@google.com>
Subject: [syzbot] bpf test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+854457fa0d41f836cd0e@syzkaller.appspotmail.com>
To:     ast@kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f80f88f0 selftests/bpf: Fix the snprintf test
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=16fd921ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57b4b78935781045
dashboard link: https://syzkaller.appspot.com/bug?extid=854457fa0d41f836cd0e

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+854457fa0d41f836cd0e@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 1 PID: 9 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 1 PID: 9 Comm: kworker/u4:0 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 78 6d 8a e8 40 4c 8a 01 <0f> 0b e9 e5 00 00 00 e8 59 48 30 fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc90000ce7bc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8881474f6900 RCX: 0000000000000000
RDX: ffff888011d50000 RSI: ffffffff815c8ba5 RDI: fffff5200019cf6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c2a0e R11: 0000000000000000 R12: ffff888028a68f20
R13: 0000000000000000 R14: ffff8880144d9100 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f41d41cb000 CR3: 0000000021c10000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_unregister_net_hook net/netfilter/core.c:502 [inline]
 nf_unregister_net_hooks+0x117/0x160 net/netfilter/core.c:576
 arpt_unregister_table_pre_exit+0x67/0x80 net/ipv4/netfilter/arp_tables.c:1565
 ops_pre_exit_list net/core/net_namespace.c:165 [inline]
 cleanup_net+0x451/0xb10 net/core/net_namespace.c:583
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
