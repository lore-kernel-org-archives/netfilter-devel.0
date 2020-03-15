Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF333C10DCE
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 05:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966FC20722
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 05:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCOFXv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 01:23:51 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41332 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727875AbgCOFXv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 01:23:51 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jDGyy-0003hV-Vn; Sun, 15 Mar 2020 01:18:21 +0100
Date:   Sun, 15 Mar 2020 01:18:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        johan.hedberg@gmail.com, kadlec@netfilter.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, max.chou@realtek.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: BUG: corrupted list in __nf_tables_abort
Message-ID: <20200315001820.GD979@breakpoint.cc>
References: <0000000000001ba488059c65d352@google.com>
 <0000000000007f2c5b05a0d8f312@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000007f2c5b05a0d8f312@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot <syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com> wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit 34682110abc50ffea7e002b0c2fd7ea9e0000ccc
> Author: Max Chou <max.chou@realtek.com>
> Date:   Wed Nov 27 03:01:07 2019 +0000
> 
>     Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113e9919e00000
> start commit:   d5d359b0 Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
> dashboard link: https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168a1611e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162f0376e00000
> 
> If the result looks correct, please mark the bug fixed by replying with:

Looks wrong, better candidate:

#syz fix: netfilter: nf_tables: autoload modules from the abort path
