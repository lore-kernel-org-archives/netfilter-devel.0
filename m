Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88DBC433ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 05:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D41461468
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 05:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhEHFJH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 May 2021 01:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhEHFJF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 May 2021 01:09:05 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29D2C061761
        for <netfilter-devel@vger.kernel.org>; Fri,  7 May 2021 22:08:03 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 76so10705473qkn.13
        for <netfilter-devel@vger.kernel.org>; Fri, 07 May 2021 22:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VHh2q5Yc7r97Dve/989pMjYD555DIbDBE4cHG2Nq7Ng=;
        b=rTdQt/dBeGJdBPfLO/MR46HoLGWLg/E3TmK3wkCdShrYkYueCsJM7KtucpgoI/DqNG
         3r5Xl4IahPmxY3p9NB/rng730oADT40EEH2uOTihWhR+zJybOm8OZ+ZNI6r9Ia+I3HWV
         UqNAotyHwY7YnrmRvv+N+LFkZqGZiEN2pt6JxwtQ9/MDDAZ6C5Fc9MVL5+tLoljdD0FO
         l3bYMv6Fcl21VqPzCELPpVECCadD075eGYEI2iAembic2JM0ze6lEhuqGa+Ifrkp+7bb
         Jgs2U2hcACAQ2SCTkpMnE4FGsuovnnxnUFRyNEVrDYDN+SQLDJRPf48CJ0tJNaclu14Q
         4mVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VHh2q5Yc7r97Dve/989pMjYD555DIbDBE4cHG2Nq7Ng=;
        b=R4GU8VkdUia1dG6gcaBUBiPOO36AkEIPun31nxMwVFii81erlOKGuHIXINxigus0Dc
         5IN1reEwdA2DpqqIq6+pO+yChqiMo9nJg7umjv5Tvj4rPIx74V1IuejNEQx0fdbJv1Y+
         cg8/xXz1Es2Q4LW7dxmRlpmBKqzZVRd2QSR4GbbTZDG+5e3cNkZJYJwXYlzPcaRDVT7k
         arIZ0zftcbqLNnOTkl3dRbNL7u0CrgVl7ehE0Dr1Mg20kKgALz8Ebe+g/rUXQelTGVny
         HRRK0UI8bCper3k90oqJ3UG21uNv5aW4iF3bZKziTjrZDcCnkwbyUKIcFQ01BS1snWwy
         t/wg==
X-Gm-Message-State: AOAM5318q6Ed8bWvyhk2g0iXuSyHKbsnTcCUWiqtHWGFEu1Uz0ruZtac
        htqhTZJF2JxVGtLDYa+vNU9AC5EpPQZliSZy1OxTJA==
X-Google-Smtp-Source: ABdhPJzWLSgzQ2in6NUPNlcKEKAVbbvhi7pv2++EZs8KEyI1wPOKvAukjMt8q44Puf9rw/kc/KLd+ftWodkUhjxzALM=
X-Received: by 2002:a37:c20a:: with SMTP id i10mr13437654qkm.350.1620450482649;
 Fri, 07 May 2021 22:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008ce91e05bf9f62bc@google.com>
In-Reply-To: <0000000000008ce91e05bf9f62bc@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 8 May 2021 07:07:51 +0200
Message-ID: <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
To:     syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 10, 2021 at 4:49 PM syzbot
<syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    cc0626c2 net: smsc911x: skip acpi_device_id table when !CO..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=110a3096d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
> dashboard link: https://syzkaller.appspot.com/bug?extid=154bd5be532a63aa778b
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com

Is this also fixed by "netfilter: arptables: use pernet ops struct
during unregister"?
The warning is the same, but the stack is different...

> hook not found, pf 2 num 0
> WARNING: CPU: 1 PID: 8144 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> Modules linked in:
> CPU: 1 PID: 8144 Comm: syz-executor.0 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 e0 26 6c 8a e8 72 df 87 01 <0f> 0b e9 e5 00 00 00 e8 09 1d 37 fa 44 8b 3c 24 4c 89 f8 48 c1 e0
> RSP: 0018:ffffc9001534f418 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff88802f867a00 RCX: 0000000000000000
> RDX: 0000000000040000 RSI: ffffffff815c5205 RDI: fffff52002a69e75
> RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815bdf9e R11: 0000000000000000 R12: ffff8880272c8f20
> R13: 0000000000000000 R14: ffff88802fa34c00 R15: 0000000000000006
> FS:  00007feaf7d10700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb651f70ca0 CR3: 0000000069f31000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  nf_unregister_net_hook+0xd5/0x110 net/netfilter/core.c:502
>  nf_tables_unregister_hook.part.0+0x131/0x200 net/netfilter/nf_tables_api.c:234
>  nf_tables_unregister_hook net/netfilter/nf_tables_api.c:8122 [inline]
>  nf_tables_commit+0x1d9b/0x4710 net/netfilter/nf_tables_api.c:8122
>  nfnetlink_rcv_batch+0x975/0x21b0 net/netfilter/nfnetlink.c:508
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:580 [inline]
>  nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:598
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x466459
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007feaf7d10188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466459
> RDX: 0000000000000000 RSI: 000000002000c2c0 RDI: 0000000000000003
> RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
> R13: 00007ffe0fcaf04f R14: 00007feaf7d10300 R15: 0000000000022000
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000008ce91e05bf9f62bc%40google.com.
