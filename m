Return-Path: <SRS0=19L1=VX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25669C76191
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 02:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDEC122CB9
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 02:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfGZCqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 22:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfGZCqp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 22:46:45 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14462238C;
        Fri, 26 Jul 2019 02:46:42 +0000 (UTC)
Date:   Thu, 25 Jul 2019 22:46:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     syzbot <syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com>
Cc:     bsingharora@gmail.com, coreteam@netfilter.org, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, duwe@suse.de, dvyukov@google.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sumit.semwal@linaro.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in dma_buf_ioctl
Message-ID: <20190725224641.5d8baeb7@oasis.local.home>
In-Reply-To: <00000000000005dbbc058e8c608d@google.com>
References: <000000000000b68e04058e6a3421@google.com>
        <00000000000005dbbc058e8c608d@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 25 Jul 2019 19:34:01 -0700
syzbot <syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com> wrote:

> syzbot has bisected this bug to:
> 
> commit 04cf31a759ef575f750a63777cee95500e410994
> Author: Michael Ellerman <mpe@ellerman.id.au>
> Date:   Thu Mar 24 11:04:01 2016 +0000
> 
>      ftrace: Make ftrace_location_range() global

It's sad that I have yet to find a single syzbot bisect useful. Really?
setting a function from static to global will cause a memory leak in a
completely unrelated area of the kernel?

I'm about to set these to my /dev/null folder.

-- Steve


> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=154293f4600000
> start commit:   abdfd52a Merge tag 'armsoc-defconfig' of git://git.kernel...
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=174293f4600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=134293f4600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d31de3d88059b7fa
> dashboard link: https://syzkaller.appspot.com/bug?extid=b2098bc44728a4efb3e9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12526e58600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161784f0600000
> 
> Reported-by: syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com
> Fixes: 04cf31a759ef ("ftrace: Make ftrace_location_range() global")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

