Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6976EC433B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 May 2021 07:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD8061406
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 May 2021 07:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhEAH7G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 May 2021 03:59:06 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35626 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbhEAH7G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 May 2021 03:59:06 -0400
Received: by mail-il1-f199.google.com with SMTP id x7-20020a056e021ca7b029016344dffb7bso555627ill.2
        for <netfilter-devel@vger.kernel.org>; Sat, 01 May 2021 00:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V6CoVXrou85PCbE3OFabws+tjrhLI+Hm1V8ygTXVsoU=;
        b=MOuLHt+a1itMgpdP+9Rz+anr2fToJya22MaPM6rtwJhjumrHpkDfsW70RI770Xoa3G
         wKeYNSWSURUngtqzZsVOMQxBiFO3q1jC2pQWwHy6G/XLk1RQNHs9Xxn8UlRjnBU+GyTg
         WV13q4RfUK+D8JxmKNSBreSCUoSUe8NAnJ47t+AttBiYn/rJsGdboHO3WXKbIDgr5zEO
         WDxMUxmCaNuRvCvrvfmtUY0Tea+swPqLvEgZgeKJb1SrfLTd7t43an3uv7SckN3WC5HK
         t5iwnwgmaPhixTug8XaTH41BMGrwP3+eRyQ/JnFG5Ly8u0AoaT30ym/+AQYb1ROMgUJX
         xnog==
X-Gm-Message-State: AOAM532iYITSaf843aqe7SSsW2OgS+YwPIRkz5gMo3HYpZ0H0uFqRcpq
        vC8yhnHF/Umklk1u9pvaU38Ajixip2qwW4WUO7pq5YLhbxzo
X-Google-Smtp-Source: ABdhPJypGJw5aoqBi/5x0cHc2iY+k3seJpZ4P/QqUK4QubnvK3hhK2CpLUim2n7SOWCDfXODH67Onwsg9Dd2RWI+McF0WO+31iFt
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c24:: with SMTP id m4mr7566857ilh.279.1619855895319;
 Sat, 01 May 2021 00:58:15 -0700 (PDT)
Date:   Sat, 01 May 2021 00:58:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003a5d4c05c140175f@google.com>
Subject: [syzbot] linux-next test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    74f961f4 Add linux-next specific files for 20210430
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=156e6f15d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acf3aa1c9f3e62f8
dashboard link: https://syzkaller.appspot.com/bug?extid=dcccba8a1e41a38cb9df

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 0 PID: 224 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 0 PID: 224 Comm: kworker/u4:5 Not tainted 5.12.0-next-20210430-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 4d 6e 8a e8 e8 5b 8a 01 <0f> 0b e9 e5 00 00 00 e8 99 dd 2c fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc900015bfbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880243de500 RCX: 0000000000000000
RDX: ffff888012df3900 RSI: ffffffff815cc9f5 RDI: fffff520002b7f6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c685e R11: 0000000000000000 R12: ffff88802e9c0f20
R13: 0000000000000000 R14: ffff888019fb2180 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc78cbbe010 CR3: 0000000012d10000 CR4: 00000000001506f0
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
