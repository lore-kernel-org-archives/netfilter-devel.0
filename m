Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768D4C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 12:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348259AbiFOMGX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 08:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348258AbiFOMGW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 08:06:22 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6126A3A181
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 05:06:21 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id j5-20020a922005000000b002d1c2659644so8286273ile.8
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 05:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SQRqdyBS5GYy4GpODuyHGqNva931cnDO98b1lW741uo=;
        b=BglG59B6AGuJkXXfyUaHhOOSQL6H5FjXNBHYZ4dIOBMLB0ZAZsXv9Q21ahkvmtLUdt
         pFpQnLUrZTIOosDuuyR4VTs82VgnEm149ZWOu0loggaGtevFpYX1NN8kfMc0mFADUWPy
         btrncdwNCsqd0zVMXPKA7WcT9zyQFzncLvEHaD6sN5EBCtvyoQA56WerEx6Z3Blc7kFo
         2pVWeAhnoVs4/u4+STIE9YWHaIAKUFZUykXNJszU+VXZA29mHenGqYPEjcr+vsmZg4Zz
         /PaQilxry5CiSKAQIzkFHW9109QBHlhD3EYEV1huVz8YFsmlKEWAotjEJt9Fivi84uYl
         GdOQ==
X-Gm-Message-State: AJIora9wHlaocu0DmlkA/bvL7hIOXA2n1HDA28h+BausmP7TUIn0qUWb
        9W0RrJQ1bluJm6Rbel3CTjfMpex+LPQw6dy5vmYeAXBpgT8R
X-Google-Smtp-Source: AGRyM1vgz6DywQ5LIER5aht2TYbGKL63x0LF8UTr2RJ9mHbfUwMViiUuObKfS5XlRwO4oPduneVXeTRKIXwSv1vkKTm5G1Iipqv8
MIME-Version: 1.0
X-Received: by 2002:a92:c94e:0:b0:2d3:be50:3e2f with SMTP id
 i14-20020a92c94e000000b002d3be503e2fmr5821129ilq.143.1655294780765; Wed, 15
 Jun 2022 05:06:20 -0700 (PDT)
Date:   Wed, 15 Jun 2022 05:06:20 -0700
In-Reply-To: <0000000000002ecf9805df3af808@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000067fcb705e17b59da@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in cttimeout_net_exit
From:   syzbot <syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    6ac6dc746d70 Merge branch 'mlx5-next' of git://git.kernel...
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15095107f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
dashboard link: https://syzkaller.appspot.com/bug?extid=92968395eedbdbd3617d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e777bff00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12613a87f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted 5.19.0-rc1-syzkaller-00373-g6ac6dc746d70 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__list_del_entry_valid+0x81/0xf0 lib/list_debug.c:51
Code: 0f 84 b5 a6 41 05 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 b6 a6 41 05 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 51 49 8b 14 24 48 39 ea 0f 85 6a a6 41 05 49 8d 7d
RSP: 0018:ffffc90000107bc0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801759b310 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff879e16e1 RDI: ffff88801759b328
RBP: ffff88801759b320 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff88801759b328
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5555f6a01d CR3: 0000000074e46000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry include/linux/list.h:134 [inline]
 list_del include/linux/list.h:148 [inline]
 cttimeout_net_exit+0x211/0x540 net/netfilter/nfnetlink_cttimeout.c:618
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:162
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid+0x81/0xf0 lib/list_debug.c:51
Code: 0f 84 b5 a6 41 05 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 b6 a6 41 05 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 51 49 8b 14 24 48 39 ea 0f 85 6a a6 41 05 49 8d 7d
RSP: 0018:ffffc90000107bc0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801759b310 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff879e16e1 RDI: ffff88801759b328
RBP: ffff88801759b320 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff88801759b328
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5555f6a01d CR3: 0000000025f1e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	0f 84 b5 a6 41 05    	je     0x541a6bb
   6:	48 b8 22 01 00 00 00 	movabs $0xdead000000000122,%rax
   d:	00 ad de
  10:	49 39 c4             	cmp    %rax,%r12
  13:	0f 84 b6 a6 41 05    	je     0x541a6cf
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	4c 89 e2             	mov    %r12,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	75 51                	jne    0x81
  30:	49 8b 14 24          	mov    (%r12),%rdx
  34:	48 39 ea             	cmp    %rbp,%rdx
  37:	0f 85 6a a6 41 05    	jne    0x541a6a7
  3d:	49                   	rex.WB
  3e:	8d                   	.byte 0x8d
  3f:	7d                   	.byte 0x7d

