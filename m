Return-Path: <SRS0=MXD6=UM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,LONGWORDS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E34C31E45
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 20:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1A62133D
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 20:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfFMUGH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 16:06:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34251 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfFMUGG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 16:06:06 -0400
Received: by mail-io1-f69.google.com with SMTP id m1so376iop.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2019 13:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fTeNhai0mS18F7TiUfjGBUnTFzhDlzYxtb4kYhkI0+w=;
        b=UWSIPjunWXRL5/DIlYFr++nEnqApobigmZYU7wqaJ7HGRzoncprZK4DQbdSmJ54KJZ
         hi8WE7eyz1SN9ZaOpo3Y4z6vhTxo7y/Q+IoOv0M5FbTc0iQk9eLTC3teMb1TwfkxxRiY
         +UvDxw3+a8yX7h8raU6lOYxUj5UOjNPW5cvP2KUg/iVhb9j+Kr4wxk9bEawULm2yhMnP
         wyymxGpnEDAPLcbUPm6v+keHxaxOwpXoHwL+qW4/XWfJYqIdiw/N0dWR8TE4YjICk+CW
         5JGt2XcYQ7OOJzREYuA7NLDdKDakMLIHH0V5Z/OpeUTtR5xurafG4qpGLqv1GxmtzxPY
         M3HA==
X-Gm-Message-State: APjAAAXDZZl950K9UF1TFzphUQdJrqcY9pXYil6gdkTSpKeVV1m/xRBg
        Y5a1VhuHvJD5tSBq5EXKRTcyQgntiP6khbh9DLJZtLkTB+/J
X-Google-Smtp-Source: APXvYqytre2bZOUkRPQjlMhqxUppIjegxCF0br5X8Pc7T1m80El+m5soGdn4Lc2P9HAmegL0Had4RnWBRV3slQuYRRO7GesX4191
MIME-Version: 1.0
X-Received: by 2002:a6b:fb0f:: with SMTP id h15mr5578999iog.266.1560456365280;
 Thu, 13 Jun 2019 13:06:05 -0700 (PDT)
Date:   Thu, 13 Jun 2019 13:06:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005718ef058b3a0fcf@google.com>
Subject: memory leak in __nf_hook_entries_try_shrink
From:   syzbot <syzbot+c51f73e78e7e2ce3a31e@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b076173a Merge tag 'selinux-pr-20190612' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16694f1ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb38d33cd06d8d48
dashboard link: https://syzkaller.appspot.com/bug?extid=c51f73e78e7e2ce3a31e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105a958ea00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=103c758ea00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c51f73e78e7e2ce3a31e@syzkaller.appspotmail.com

uting program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888114d72100 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 34.950s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 10 ac bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 c0 97 bb 82 ff ff ff ff  ................
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff8881149c1300 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 34.950s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
     00 00 00 00 00 00 00 00 60 ab bb 82 ff ff ff ff  ........`.......
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff888114d72100 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 35.840s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 10 ac bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 c0 97 bb 82 ff ff ff ff  ................
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff8881149c1300 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 35.840s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
     00 00 00 00 00 00 00 00 60 ab bb 82 ff ff ff ff  ........`.......
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff888114d72100 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 36.710s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 10 ac bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 c0 97 bb 82 ff ff ff ff  ................
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff8881149c1300 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 36.710s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
     00 00 00 00 00 00 00 00 60 ab bb 82 ff ff ff ff  ........`.......
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff888114d72100 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 37.620s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 10 ac bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 c0 97 bb 82 ff ff ff ff  ................
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff8881149c1300 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 37.620s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
     00 00 00 00 00 00 00 00 60 ab bb 82 ff ff ff ff  ........`.......
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff888114d72100 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 38.520s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 10 ac bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 c0 97 bb 82 ff ff ff ff  ................
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

BUG: memory leak
unreferenced object 0xffff8881149c1300 (size 96):
   comm "syz-executor612", pid 7562, jiffies 4295030081 (age 38.520s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
     00 00 00 00 00 00 00 00 60 ab bb 82 ff ff ff ff  ........`.......
   backtrace:
     [<000000002349b43d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000002349b43d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002349b43d>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000002349b43d>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000de813aaf>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000de813aaf>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<00000000cec1340e>] kmalloc_node include/linux/slab.h:590 [inline]
     [<00000000cec1340e>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<00000000a4c48a93>] kvmalloc include/linux/mm.h:648 [inline]
     [<00000000a4c48a93>] kvzalloc include/linux/mm.h:656 [inline]
     [<00000000a4c48a93>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<000000005e33ea2c>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<00000000d6d9e401>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<0000000088eec2d6>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<0000000097cabb81>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000bcda760a>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7106
     [<000000006e3b1c82>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<00000000088bffab>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000c13ea88b>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000af9ef24e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:103
     [<0000000063f14104>] unshare_nsproxy_namespaces+0x7f/0x100  
kernel/nsproxy.c:202
     [<000000008e6e2f35>] ksys_unshare+0x236/0x490 kernel/fork.c:2692
     [<0000000078236ca3>] __do_sys_unshare kernel/fork.c:2760 [inline]
     [<0000000078236ca3>] __se_sys_unshare kernel/fork.c:2758 [inline]
     [<0000000078236ca3>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2758

executing program
executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
