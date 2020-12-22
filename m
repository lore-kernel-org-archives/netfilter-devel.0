Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3091EC433E6
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Dec 2020 22:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1E92333F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Dec 2020 22:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgLVWux (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 17:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgLVWuw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 17:50:52 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDE8C0613D6;
        Tue, 22 Dec 2020 14:50:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1krqTq-00020j-QX; Tue, 22 Dec 2020 23:50:10 +0100
Date:   Tue, 22 Dec 2020 23:50:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>
Subject: Re: [PATCH nf] netfilter: xt_RATEEST: reject non-null terminated
 string from userspace
Message-ID: <20201222225010.GC9639@breakpoint.cc>
References: <000000000000fcbe0705b70e9bd9@google.com>
 <20201222222356.22645-1-fw@strlen.de>
 <CAHk-=wjB83CZvzp88Axc278L+uSKEdztA9OO7kjx64R7Y9n31A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjB83CZvzp88Axc278L+uSKEdztA9OO7kjx64R7Y9n31A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Dec 22, 2020 at 2:24 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > strlcpy assumes src is a c-string. Check info->name before its used.
> 
> If strlcpy is the only problem, then the fix is to use strscpy(),
> which doesn't have the design mistake that strlcpy has.

It would silence the reproducer, but the checkentry function calls
__xt_rateest_lookup which may 'strcmp(..., maybe_not_zero_terminated)'.
