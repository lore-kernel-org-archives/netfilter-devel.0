Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EB3C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48AC820748
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgAPOxK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:53:10 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35436 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726371AbgAPOxK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 09:53:10 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1is6WA-000628-Ub; Thu, 16 Jan 2020 15:53:06 +0100
Date:   Thu, 16 Jan 2020 15:53:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: BUG: corrupted list in nft_obj_del
Message-ID: <20200116145306.GS795@breakpoint.cc>
References: <000000000000bc757e059c36db18@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000bc757e059c36db18@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot <syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    8b792f84 Merge branch 'mlxsw-Various-fixes'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1766b349e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
> dashboard link: https://syzkaller.appspot.com/bug?extid=6ca99af7e70e298bd09d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168b95e1e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f29b3ee00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com
> 
> list_del corruption, ffff8880a46b1500->prev is LIST_POISON2

#syz fix: netfilter: nf_tables: fix flowtable list del corruption
