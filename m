Return-Path: <SRS0=rcIs=DG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AAEC4727C
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 14:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF91206CD
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 14:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgI2Oad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:30:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:44128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2Oad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 10:30:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E61E1AD0F;
        Tue, 29 Sep 2020 14:30:31 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 5BF841E12E9; Tue, 29 Sep 2020 16:30:31 +0200 (CEST)
Date:   Tue, 29 Sep 2020 16:30:31 +0200
From:   Jan Kara <jack@suse.cz>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     syzbot <syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com>,
        adi@adirat.com, alsa-devel@alsa-project.org,
        coreteam@netfilter.org, davem@davemloft.net, jack@suse.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        perex@perex.cz, syzkaller-bugs@googlegroups.com, tiwai@suse.com
Subject: Re: BUG: unable to handle kernel paging request in dqput
Message-ID: <20200929143031.GP10896@quack2.suse.cz>
References: <00000000000067becf05b03d8dd6@google.com>
 <s5htuvjpujt.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htuvjpujt.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun 27-09-20 09:07:02, Takashi Iwai wrote:
> On Sat, 26 Sep 2020 22:48:15 +0200,
> syzbot wrote:
> > 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    98477740 Merge branch 'rcu/urgent' of git://git.kernel.org..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17930875900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=af502ec9a451c9fc
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f816042a7ae2225f25ba
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133783ab900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bb5973900000
> > 
> > The issue was bisected to:
> > 
> > commit 1d0f953086f090a022f2c0e1448300c15372db46
> > Author: Ioan-Adrian Ratiu <adi@adirat.com>
> > Date:   Wed Jan 4 22:37:46 2017 +0000
> > 
> >     ALSA: usb-audio: Fix irq/process data synchronization
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=133362c3900000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=10b362c3900000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=173362c3900000
> 
> This commit looks really irrelevant from the Oops code path.
> It must be a different reason.

Yeah, it seems the bisection got confused because it hit a different error
during the bisection. Looking at the original oops, I think the actual
reason of a crash is that quota file got corrupted in a particular way.
Quota code is not very paranoid when checking on disk contents. I'll work
on adding more sanity checks to quota code...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
