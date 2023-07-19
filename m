Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45432C0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 09:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjGSJcz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 05:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGSJcy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 05:32:54 -0400
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D4D19A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 02:32:52 -0700 (PDT)
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-3a3b86821fcso855958b6e.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 02:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689759171; x=1692351171;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+s4mQMd3ZNXcWLrOpu5M5FMS0n9iYFfLHy+Wp/G5cf0=;
        b=l4leUmjQHuQ2EkxC6ZMq9ShuLPlu2TlBeqpwSLLRgYwsAs5DQsVh7+ptrt7gKPt96W
         3BlsnJzPLchs6uFQwrK/W7gDtz2/u4onrdhMZ6Agtb08kd6+rBvFDj5MTw22MYjyWFIZ
         W/zXtLjkkkjQdaI1lfXlLYp4z6IaJuVSD1PQCJsrq1atPWWVrDQWbSwPWDWMcTtzjV01
         aFs4LeaDZtqrMSrwJm4Ht7HEmDiM6epui8QxYYnBqgSjkiW4zQGEgc5AG+exbNBxb94Y
         jd8V3wDohDtRqNhCKqyhEUCbtmnQKedzyDZNP8gTuGOk2Q3sb237MS/womexwgjh2Mpe
         gZgw==
X-Gm-Message-State: ABy/qLZikEV1hiOoeDFymhoO44A6B/q+OZdv6R4QBu9UK0cI4yrMLA7l
        sRiaqIRxEQo9/w7vMS+fjH06f9f7huZ0MtaSOopGo+/7Sszw
X-Google-Smtp-Source: APBJJlF7q279ORMZqETk9cuXcfkye2OVaM9R5CcVzBvzCT3dQ/OxB1+4behLfOddQ5HWVpKO8QPgb+B/Ws/lq+Sg4ZjokzccavM6
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2183:b0:3a1:e59f:9ec9 with SMTP id
 be3-20020a056808218300b003a1e59f9ec9mr2721572oib.3.1689759171422; Wed, 19 Jul
 2023 02:32:51 -0700 (PDT)
Date:   Wed, 19 Jul 2023 02:32:51 -0700
In-Reply-To: <000000000000a054ee05bc4b2009@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b2f180600d3b79e@google.com>
Subject: Re: [syzbot] [btrfs?] [netfilter?] BUG: MAX_LOCKDEP_CHAIN_HLOCKS too
 low! (2)
From:   syzbot <syzbot+9bbbacfbf1e04d5221f7@syzkaller.appspotmail.com>
To:     bakmitopiacibubur@boga.indosterling.com, clm@fb.com,
        davem@davemloft.net, dsahern@kernel.org, dsterba@suse.com,
        fw@strlen.de, gregkh@linuxfoundation.org, jirislaby@kernel.org,
        josef@toxicpanda.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e40939bbfc68 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15d92aaaa80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4a2640e4213bc2f
dashboard link: https://syzkaller.appspot.com/bug?extid=9bbbacfbf1e04d5221f7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149b2d66a80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1214348aa80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d87aa312c0e/disk-e40939bb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/22a11d32a8b2/vmlinux-e40939bb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0978b5788b52/Image-e40939bb.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9bbbacfbf1e04d5221f7@syzkaller.appspotmail.com

team3253: Mode changed to "activebackup"
BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
turning off the locking correctness validator.
CPU: 1 PID: 9973 Comm: syz-executor246 Not tainted 6.4.0-rc7-syzkaller-ge40939bbfc68 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/03/2023
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:233
 show_stack+0x2c/0x44 arch/arm64/kernel/stacktrace.c:240
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd0/0x124 lib/dump_stack.c:106
 dump_stack+0x1c/0x28 lib/dump_stack.c:113
 lookup_chain_cache_add kernel/locking/lockdep.c:3794 [inline]
 validate_chain kernel/locking/lockdep.c:3815 [inline]
 __lock_acquire+0x1c44/0x7604 kernel/locking/lockdep.c:5088
 lock_acquire+0x23c/0x71c kernel/locking/lockdep.c:5705
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x48/0x60 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:350 [inline]
 pl011_console_write+0x180/0x708 drivers/tty/serial/amba-pl011.c:2333
 console_emit_next_record kernel/printk/printk.c:2877 [inline]
 console_flush_all+0x5c0/0xb54 kernel/printk/printk.c:2933
 console_unlock+0x148/0x274 kernel/printk/printk.c:3007
 vprintk_emit+0x14c/0x2e4 kernel/printk/printk.c:2307
 vprintk_default+0xa0/0xe4 kernel/printk/printk.c:2318
 vprintk+0x218/0x2f0 kernel/printk/printk_safe.c:50
 _printk+0xdc/0x128 kernel/printk/printk.c:2328
 __netdev_printk+0x1f8/0x39c net/core/dev.c:11273
 netdev_info+0x104/0x150 net/core/dev.c:11320
 team_change_mode drivers/net/team/team.c:619 [inline]
 team_mode_option_set+0x350/0x390 drivers/net/team/team.c:1388
 team_option_set drivers/net/team/team.c:374 [inline]
 team_nl_cmd_options_set+0x7e0/0xdec drivers/net/team/team.c:2663
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x938/0xc1c net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x214/0x3c4 net/netlink/af_netlink.c:2546
 genl_rcv+0x38/0x50 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x660/0x8d4 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x834/0xb18 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0x568/0x81c net/socket.c:2503
 ___sys_sendmsg net/socket.c:2557 [inline]
 __sys_sendmsg+0x26c/0x33c net/socket.c:2586
 __do_sys_sendmsg net/socket.c:2595 [inline]
 __se_sys_sendmsg net/socket.c:2593 [inline]
 __arm64_sys_sendmsg+0x80/0x94 net/socket.c:2593
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
 el0_svc_common+0x138/0x244 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:191
 el0_svc+0x4c/0x160 arch/arm64/kernel/entry-common.c:647
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:665
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
