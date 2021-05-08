Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315EEC433ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 14:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB58B61059
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 14:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhEHOsH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 May 2021 10:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhEHOsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 May 2021 10:48:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7DFC061574;
        Sat,  8 May 2021 07:47:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lfOEL-0006F5-EK; Sat, 08 May 2021 16:46:57 +0200
Date:   Sat, 8 May 2021 16:46:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
Message-ID: <20210508144657.GC4038@breakpoint.cc>
References: <0000000000008ce91e05bf9f62bc@google.com>
 <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
> 
> Is this also fixed by "netfilter: arptables: use pernet ops struct
> during unregister"?
> The warning is the same, but the stack is different...

No, this is a different bug.

In both cases the caller attempts to unregister a hook that the core
can't find, but in this case the caller is nftables, not arptables.

