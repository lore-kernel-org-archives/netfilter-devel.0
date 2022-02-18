Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EF8C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Feb 2022 21:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbiBRVen (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 16:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239900AbiBRVen (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 16:34:43 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99EB5BD04
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2022 13:34:24 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id q5-20020a0566022f0500b00638278a161fso5217674iow.11
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2022 13:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ESDhSXcBKMjopPYZv2w9C93Fs32sPD81EnUFCwe47Z8=;
        b=eKGpbclsyPU2TqikQvAKWig6SzEB5ZgQiCuzUEkH48Hsi3V8zQMwlgGzlefbAhqqOc
         EHZGjdul8AksA7Uhlk7LuQ8QyxDsHIJDEcBjB2Ui5O1fQZPZRDMi36JupyLl78bAMdL7
         tHXjhOLF012OrjBR9DuF3AoGGtZraXeNYVOONVQC+/PHDP3FtUV3xdrGx1MBxmmNIz0u
         RZmK+OPlfxCQ1PiisGs6/Lfpupi2asVI2QTtvnH2RmHAAmGmSep/uVRxytxMpvjvj5X+
         2cDxJcCpIhWvdVu3FevCVzValNr0ks9xtylKKDjjMohQnMuA6zJNw00UIgJGOw4wCWLv
         7k6A==
X-Gm-Message-State: AOAM532X8U9EdYdA0b2+yuYxFlER1s8IW13aATxhG9L4OfAkbER4zBxk
        LZI/1hKBMzJScuLD7i3Uxqs9qeAbOA22fdMbhKmNKXT9KpUE
X-Google-Smtp-Source: ABdhPJwijr18CZvtR9XxK1PvZnkcu5gmF2lHkJyrHt3O3Z8dSibn5LNQzbfbLx58lPYXLyq/i7hG87TE3BFNHiMto1TlRjnzLNL0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190e:b0:2bf:ac1e:b5b7 with SMTP id
 w14-20020a056e02190e00b002bfac1eb5b7mr6853634ilu.304.1645220064174; Fri, 18
 Feb 2022 13:34:24 -0800 (PST)
Date:   Fri, 18 Feb 2022 13:34:24 -0800
In-Reply-To: <0000000000003118ba05d500cce1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080aa2705d851a531@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in nf_nat_setup_info (2)
From:   syzbot <syzbot+cbcd154fce7c6d953d1c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17b02532700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=76f99026248b24e4
dashboard link: https://syzkaller.appspot.com/bug?extid=cbcd154fce7c6d953d1c
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1659ab4c700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1621cbf2700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cbcd154fce7c6d953d1c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in get_unique_tuple net/netfilter/nf_nat_core.c:548 [inline]
BUG: KMSAN: uninit-value in nf_nat_setup_info+0x628/0x4a40 net/netfilter/nf_nat_core.c:642
 get_unique_tuple net/netfilter/nf_nat_core.c:548 [inline]
 nf_nat_setup_info+0x628/0x4a40 net/netfilter/nf_nat_core.c:642
 nfnetlink_parse_nat_setup+0xb86/0xcf0
 ctnetlink_parse_nat_setup+0xde/0x390 net/netfilter/nf_conntrack_netlink.c:1845
 ctnetlink_setup_nat net/netfilter/nf_conntrack_netlink.c:1920 [inline]
 ctnetlink_create_conntrack net/netfilter/nf_conntrack_netlink.c:2325 [inline]
 ctnetlink_new_conntrack+0x1d5d/0x4240 net/netfilter/nf_conntrack_netlink.c:2452
 nfnetlink_rcv_msg+0xe0a/0xf80 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x40c/0x7e0 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x667/0x4740 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x1093/0x1360 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x14d9/0x1720 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 __alloc_pages+0xbbf/0x1090 mm/page_alloc.c:5429
 alloc_pages+0xa08/0xd50
 alloc_slab_page mm/slub.c:1816 [inline]
 allocate_slab+0x29e/0x1b00 mm/slub.c:1961
 new_slab mm/slub.c:2021 [inline]
 ___slab_alloc+0xb52/0x1da0 mm/slub.c:3035
 __slab_alloc mm/slub.c:3122 [inline]
 slab_alloc_node mm/slub.c:3213 [inline]
 slab_alloc mm/slub.c:3255 [inline]
 kmem_cache_alloc+0xbb3/0x11c0 mm/slub.c:3260
 __nf_conntrack_alloc+0x232/0x7f0 net/netfilter/nf_conntrack_core.c:1553
 init_conntrack+0x29b/0x24c0 net/netfilter/nf_conntrack_core.c:1634
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1745 [inline]
 nf_conntrack_in+0x1abc/0x3130 net/netfilter/nf_conntrack_core.c:1903
 ipv4_conntrack_in+0x68/0x80 net/netfilter/nf_conntrack_proto.c:191
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow net/netfilter/core.c:619 [inline]
 nf_hook_slow_list+0x358/0xb40 net/netfilter/core.c:657
 NF_HOOK_LIST include/linux/netfilter.h:343 [inline]
 ip_sublist_rcv+0x1411/0x14a0 net/ipv4/ip_input.c:607
 ip_list_rcv+0x930/0x970 net/ipv4/ip_input.c:644
 __netif_receive_skb_list_ptype net/core/dev.c:5394 [inline]
 __netif_receive_skb_list_core+0xdf9/0x11f0 net/core/dev.c:5442
 __netif_receive_skb_list+0x7e3/0x940 net/core/dev.c:5494
 netif_receive_skb_list_internal+0x848/0xdc0 net/core/dev.c:5585
 gro_normal_list include/net/gro.h:425 [inline]
 napi_complete_done+0x579/0xdc0 net/core/dev.c:5932
 virtqueue_napi_complete drivers/net/virtio_net.c:339 [inline]
 virtnet_poll+0x17a4/0x2340 drivers/net/virtio_net.c:1554
 __napi_poll+0x14c/0xc00 net/core/dev.c:6365
 napi_poll net/core/dev.c:6432 [inline]
 net_rx_action+0x7e2/0x1820 net/core/dev.c:6519
 __do_softirq+0x1ee/0x7c5 kernel/softirq.c:558

CPU: 1 PID: 3471 Comm: syz-executor142 Not tainted 5.17.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================

