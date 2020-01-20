Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C566C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 13:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696D921835
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 13:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgATNWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:22:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35445 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATNWH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 08:22:07 -0500
Received: from [154.119.55.242] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1itWy2-0005zt-Dn; Mon, 20 Jan 2020 13:19:46 +0000
Date:   Mon, 20 Jan 2020 14:19:31 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     syzbot <syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, akpm@linux-foundation.org, allison@lohutok.net,
        arnd@arndb.de, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net,
        christian@brauner.io, coreteam@netfilter.org, davem@davemloft.net,
        elena.reshetova@intel.com, florent.fourcot@wifirst.fr,
        fw@strlen.de, geert@linux-m68k.org, hare@suse.com,
        heiko.carstens@de.ibm.com, hpa@zytor.com, info@metux.net,
        jcmvbkbc@gmail.com, jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@netfilter.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux@armlinux.org.uk,
        mareklindner@neomailbox.ch, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, peterz@infradead.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, will@kernel.org, x86@kernel.org
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
Message-ID: <20200120131930.pbhbsrm4bk4lq3d7@wittgenstein>
References: <000000000000bdb5b2059c865f5c@google.com>
 <000000000000c795fa059c884c21@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000c795fa059c884c21@google.com>
User-Agent: NeoMutt/20180716
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 19, 2020 at 05:35:01PM -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit d68dbb0c9ac8b1ff52eb09aa58ce6358400fa939
> Author: Christian Brauner <christian@brauner.io>
> Date:   Thu Jun 20 23:26:35 2019 +0000
> 
>     arch: handle arches who do not yet define clone3
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1456fed1e00000
> start commit:   09d4f10a net: sched: act_ctinfo: fix memory leak
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1656fed1e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1256fed1e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
> dashboard link: https://syzkaller.appspot.com/bug?extid=6491ea8f6dddbf04930e
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141af959e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1067fa85e00000
> 
> Reported-by: syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com
> Fixes: d68dbb0c9ac8 ("arch: handle arches who do not yet define clone3")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

This bisect seems bogus.

Christian
