Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F86C00523
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 09:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1819220705
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 09:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgAHJxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 04:53:43 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47238 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgAHJxn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 04:53:43 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ip81x-0002OX-N8; Wed, 08 Jan 2020 10:53:37 +0100
Date:   Wed, 8 Jan 2020 10:53:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+0be5fe9e46479a332a4a@syzkaller.appspotmail.com>
Cc:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, gregkh@linuxfoundation.org, info@metux.net,
        jeremy@azazel.net, kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: general protection fault in hash_ip4_uadt
Message-ID: <20200108095337.GY795@breakpoint.cc>
References: <000000000000d47ca7059b9d5016@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d47ca7059b9d5016@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot <syzbot+0be5fe9e46479a332a4a@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=11b2e656e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
> dashboard link: https://syzkaller.appspot.com/bug?extid=0be5fe9e46479a332a4a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114d8eb9e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1157d076e00000

#syz dup: general protection fault in hash_ipportnet4_uadt
