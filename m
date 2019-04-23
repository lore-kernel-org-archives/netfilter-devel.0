Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F680C282DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 21:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2085218DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 21:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lQkWoNFI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfDWVkJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 17:40:09 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35942 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfDWVkJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 17:40:09 -0400
Received: by mail-yw1-f67.google.com with SMTP id g29so954824ywk.3
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 14:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MdmvEj+n6hSc3mUnr0mQlioQHIH+hrZlMmC4IF8KYV4=;
        b=lQkWoNFIKmtKk5OrhMzxf15cq1HVeVoGltWB4PKcuuLuP35gGHcH1EVqUWxdqMqivR
         1Slu2HezbIyMqAHWHeSGC6DG078Q/zBCCRs5WiJN6k/pSH0LGp4LDd9deaXkX9E3Tb/g
         VRxfe5/A4/2j2VK6sAc4DE8Sn+0tHrys+eRaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MdmvEj+n6hSc3mUnr0mQlioQHIH+hrZlMmC4IF8KYV4=;
        b=e6lqtkuSw3HzQtWQELd2kilrHaZ42RZyPbgmjdzxoknbhVJ2idw4rxkbcgX3PQcTWN
         yWi1LkiYGqpS6JDeO2uEMoOHpIXNhwIYvQG8P2wgMkDmoXuaXSEszYbmvW9kl+Dh/GCW
         jZ6+/5i6VsWoQiBLVTsyuqSc6jtyKxAmXTi/gk4SZxjKTZkpZ/+7RdqNPV63GblUkUb8
         L70LMzTIB7KtPwR2rdhbomEfXqOZPLjjCWH3wVdeDUqY87kzw2q8aP18jvGZXL8t1sol
         5C0BqfIwY55OjiCbppNHh4HCslEY1j8P9KulPKNu899oJ/bhPGIM4ZJ/nDQAj/JacK//
         MEkw==
X-Gm-Message-State: APjAAAV/EUXxfLGZNNVrTtEE+Qll9HKIDV4+EEqNx/iWycY5OpnEFmnN
        rdrYKd/Q0Vx/M6XxgJsWqV8jdyC/Y5I=
X-Google-Smtp-Source: APXvYqzwfcZMIIioKBTSrP4KyjC2AAhbVi/+E7zj4BFy8XHUi/umyM/NRfyaNISuxUhRb5Msz1mMxQ==
X-Received: by 2002:a81:65d6:: with SMTP id z205mr9816586ywb.313.1556055607448;
        Tue, 23 Apr 2019 14:40:07 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id s127sm8833453yws.66.2019.04.23.14.40.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 14:40:06 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id v2so3977014ybm.12
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 14:40:05 -0700 (PDT)
X-Received: by 2002:a25:5145:: with SMTP id f66mr8815829ybb.151.1556055605431;
 Tue, 23 Apr 2019 14:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c8f45a0584e69ea9@google.com>
In-Reply-To: <000000000000c8f45a0584e69ea9@google.com>
From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 23 Apr 2019 14:39:52 -0700
X-Gmail-Original-Message-ID: <CAGXu5jLBd-u=ywxiEjmrLMj9TMRVnLOHHKfWKQ_fEosDFjPoog@mail.gmail.com>
Message-ID: <CAGXu5jLBd-u=ywxiEjmrLMj9TMRVnLOHHKfWKQ_fEosDFjPoog@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in seccomp_notify_release (2)
To:     Tycho Andersen <tycho@tycho.ws>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        coreteam@netfilter.org, Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Will Drewry <wad@chromium.org>, wenxu@ucloud.cn,
        Yonghong Song <yhs@fb.com>,
        syzbot <syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 25, 2019 at 1:02 AM syzbot
<syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    1bdd3dbf Merge tag 'io_uring-20190323' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12ae5b93200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31fb246de2a622
> dashboard link: https://syzkaller.appspot.com/bug?extid=b562969adb2e04af3442
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162ca25d200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1733b53b200000
>
> The bug was bisected to:
>
> commit a799aea0988ea0d1b1f263e996fdad2f6133c680
> Author: wenxu <wenxu@ucloud.cn>
> Date:   Wed Jan 9 02:40:11 2019 +0000
>
>      netfilter: nft_flow_offload: Fix reverse route lookup

This bisection looks bogus?

However, I _can_ trigger the problem on this kernel version with this
config. (And not with Linus's latest tree.)

The PoC is identical to the prior report[1] that we thought was fixed.
Perhaps the fix didn't actually fix it? (I mean
a811dc61559e0c8003f1086c2a4dc8e4d5ae4cb8) But it's been silent for 29
days now, so I'm not sure what's going on.

Tycho are you able to reproduce this on the older tree?

-Kees

[1] https://groups.google.com/forum/#!msg/syzkaller-bugs/BPWo-3V1M2k/0keafXgOCQAJ

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dcc517200000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=12dcc517200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14dcc517200000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com
> Fixes: a799aea0988e ("netfilter: nft_flow_offload: Fix reverse route
> lookup")
>
> ==================================================================
> BUG: KASAN: use-after-free in __lock_acquire+0x2d5e/0x3fb0
> kernel/locking/lockdep.c:3573
> Read of size 8 at addr ffff8880a621d080 by task syz-executor365/8267
>
> CPU: 0 PID: 8267 Comm: syz-executor365 Not tainted 5.1.0-rc1+ #35
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
>   kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
>   __lock_acquire+0x2d5e/0x3fb0 kernel/locking/lockdep.c:3573
>   lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4211
>   __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>   __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
>   mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
>   seccomp_notify_release+0x62/0x280 kernel/seccomp.c:984
>   __fput+0x2e5/0x8d0 fs/file_table.c:278
>   ____fput+0x16/0x20 fs/file_table.c:309
>   task_work_run+0x14a/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
>   prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>   do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x405621
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 19 00 00 c3 48
> 83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48
> 89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007ffe1ebba1e0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000405621
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000003
> RBP: 0000000000000064 R08: 00007f28ae4ca700 R09: 0000000000000000
> R10: 00007ffe1ebba1f0 R11: 0000000000000293 R12: 00000000006dbc30
> R13: 0000000000000002 R14: 00000000006dbc3c R15: 000000000000002d
>
> Allocated by task 8278:
>   save_stack+0x45/0xd0 mm/kasan/common.c:75
>   set_track mm/kasan/common.c:87 [inline]
>   __kasan_kmalloc mm/kasan/common.c:497 [inline]
>   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
>   kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
>   kmem_cache_alloc_trace+0x151/0x760 mm/slab.c:3621
>   kmalloc include/linux/slab.h:545 [inline]
>   kzalloc include/linux/slab.h:740 [inline]
>   seccomp_prepare_filter kernel/seccomp.c:453 [inline]
>   seccomp_prepare_user_filter kernel/seccomp.c:493 [inline]
>   seccomp_set_mode_filter kernel/seccomp.c:1262 [inline]
>   do_seccomp+0x743/0x2250 kernel/seccomp.c:1376
>   __do_sys_seccomp kernel/seccomp.c:1395 [inline]
>   __se_sys_seccomp kernel/seccomp.c:1392 [inline]
>   __x64_sys_seccomp+0x73/0xb0 kernel/seccomp.c:1392
>   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 8278:
>   save_stack+0x45/0xd0 mm/kasan/common.c:75
>   set_track mm/kasan/common.c:87 [inline]
>   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
>   kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
>   __cache_free mm/slab.c:3498 [inline]
>   kfree+0xcf/0x230 mm/slab.c:3821
>   seccomp_filter_free kernel/seccomp.c:567 [inline]
>   seccomp_filter_free kernel/seccomp.c:563 [inline]
>   seccomp_set_mode_filter kernel/seccomp.c:1317 [inline]
>   do_seccomp+0xb00/0x2250 kernel/seccomp.c:1376
>   __do_sys_seccomp kernel/seccomp.c:1395 [inline]
>   __se_sys_seccomp kernel/seccomp.c:1392 [inline]
>   __x64_sys_seccomp+0x73/0xb0 kernel/seccomp.c:1392
>   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8880a621d000
>   which belongs to the cache kmalloc-192 of size 192
> The buggy address is located 128 bytes inside of
>   192-byte region [ffff8880a621d000, ffff8880a621d0c0)
> The buggy address belongs to the page:
> page:ffffea0002988740 count:1 mapcount:0 mapping:ffff88812c3f0040 index:0x0
> flags: 0x1fffc0000000200(slab)
> raw: 01fffc0000000200 ffffea0002981048 ffffea0002988048 ffff88812c3f0040
> raw: 0000000000000000 ffff8880a621d000 0000000100000010 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8880a621cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8880a621d000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff8880a621d080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                     ^
>   ffff8880a621d100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   ffff8880a621d180: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches



-- 
Kees Cook
