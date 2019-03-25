Return-Path: <SRS0=irZF=R4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61859C4360F
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 08:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3987420830
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 08:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfCYICG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:02:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54017 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729859AbfCYICF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 04:02:05 -0400
Received: by mail-io1-f72.google.com with SMTP id w11so7227497iom.20
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2019 01:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dVZIxEfXukrD5ihgyOeTyg/2nUQwrj0xIEaYunjoTWc=;
        b=H96AY6LdGBttnv9N+zc4krT5Gc1OeZQAc8Id8bhRO3YZ25YB+E8eEpqGKxPLXr1tEo
         T66XLz5PwvODiffWO8atbvw/wzIvXYXGxm1oqLTz5yTC136G3V+AwQSQSR1hvPJJOiVn
         5Umu6NyNB8aaV15qOpN0fl4/tiPSSM3+6vtRjpMzWnh2KsMgMsg2iIrmgSBjuYZxcoMt
         MsbNdAFjW0Hxe7wF2HD7u3qhN2gCvwRzqIEbDWH/s44xPIqHC9U0a9xWASAIsKqJ6ZmR
         GVH4wzxnHox4TwDs0zjCQAC5cMOIzVuaPuZrjDSMwFwwVI7QZWUrOQKlYejYi71uP60v
         oLFQ==
X-Gm-Message-State: APjAAAUE9iBIA6Bj2uX9DU/pV25L54e+wvh7N4IwI53rV1VtgFNXS+ud
        MJfSDOyWkZQlsba9Xlf0PBrrJSGWkRN0Xu9DLwsO3NE9hTVN
X-Google-Smtp-Source: APXvYqw6p4CmPLZawh/6VHBFQ2ri2a2d6Xsjg2vD2NXXV2ea4PepaZNZ2wJpho05PQi1Y8ePpSA/PIMbpM9KwixOj/Bwh3LpJcwj
MIME-Version: 1.0
X-Received: by 2002:a6b:c995:: with SMTP id z143mr14356829iof.74.1553500924863;
 Mon, 25 Mar 2019 01:02:04 -0700 (PDT)
Date:   Mon, 25 Mar 2019 01:02:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8f45a0584e69ea9@google.com>
Subject: KASAN: use-after-free Read in seccomp_notify_release (2)
From:   syzbot <syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, coreteam@netfilter.org,
        daniel@iogearbox.net, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kafai@fb.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, luto@amacapital.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, wad@chromium.org, wenxu@ucloud.cn,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1bdd3dbf Merge tag 'io_uring-20190323' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12ae5b93200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31fb246de2a622
dashboard link: https://syzkaller.appspot.com/bug?extid=b562969adb2e04af3442
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162ca25d200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1733b53b200000

The bug was bisected to:

commit a799aea0988ea0d1b1f263e996fdad2f6133c680
Author: wenxu <wenxu@ucloud.cn>
Date:   Wed Jan 9 02:40:11 2019 +0000

     netfilter: nft_flow_offload: Fix reverse route lookup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dcc517200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12dcc517200000
console output: https://syzkaller.appspot.com/x/log.txt?x=14dcc517200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com
Fixes: a799aea0988e ("netfilter: nft_flow_offload: Fix reverse route  
lookup")

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x2d5e/0x3fb0  
kernel/locking/lockdep.c:3573
Read of size 8 at addr ffff8880a621d080 by task syz-executor365/8267

CPU: 0 PID: 8267 Comm: syz-executor365 Not tainted 5.1.0-rc1+ #35
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __lock_acquire+0x2d5e/0x3fb0 kernel/locking/lockdep.c:3573
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4211
  __mutex_lock_common kernel/locking/mutex.c:925 [inline]
  __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  seccomp_notify_release+0x62/0x280 kernel/seccomp.c:984
  __fput+0x2e5/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x405621
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 19 00 00 c3 48  
83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffe1ebba1e0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000405621
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000003
RBP: 0000000000000064 R08: 00007f28ae4ca700 R09: 0000000000000000
R10: 00007ffe1ebba1f0 R11: 0000000000000293 R12: 00000000006dbc30
R13: 0000000000000002 R14: 00000000006dbc3c R15: 000000000000002d

Allocated by task 8278:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
  kmem_cache_alloc_trace+0x151/0x760 mm/slab.c:3621
  kmalloc include/linux/slab.h:545 [inline]
  kzalloc include/linux/slab.h:740 [inline]
  seccomp_prepare_filter kernel/seccomp.c:453 [inline]
  seccomp_prepare_user_filter kernel/seccomp.c:493 [inline]
  seccomp_set_mode_filter kernel/seccomp.c:1262 [inline]
  do_seccomp+0x743/0x2250 kernel/seccomp.c:1376
  __do_sys_seccomp kernel/seccomp.c:1395 [inline]
  __se_sys_seccomp kernel/seccomp.c:1392 [inline]
  __x64_sys_seccomp+0x73/0xb0 kernel/seccomp.c:1392
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8278:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3821
  seccomp_filter_free kernel/seccomp.c:567 [inline]
  seccomp_filter_free kernel/seccomp.c:563 [inline]
  seccomp_set_mode_filter kernel/seccomp.c:1317 [inline]
  do_seccomp+0xb00/0x2250 kernel/seccomp.c:1376
  __do_sys_seccomp kernel/seccomp.c:1395 [inline]
  __se_sys_seccomp kernel/seccomp.c:1392 [inline]
  __x64_sys_seccomp+0x73/0xb0 kernel/seccomp.c:1392
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a621d000
  which belongs to the cache kmalloc-192 of size 192
The buggy address is located 128 bytes inside of
  192-byte region [ffff8880a621d000, ffff8880a621d0c0)
The buggy address belongs to the page:
page:ffffea0002988740 count:1 mapcount:0 mapping:ffff88812c3f0040 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002981048 ffffea0002988048 ffff88812c3f0040
raw: 0000000000000000 ffff8880a621d000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a621cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a621d000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a621d080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ffff8880a621d100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880a621d180: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
