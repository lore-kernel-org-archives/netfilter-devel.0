Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2420C2BB40
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Dec 2020 23:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7317920757
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Dec 2020 23:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgLMX0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Dec 2020 18:26:21 -0500
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:39834 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730631AbgLMX0V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Dec 2020 18:26:21 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id ABDC1180A7FD3;
        Sun, 13 Dec 2020 23:25:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fear65_5806dcd27416
X-Filterd-Recvd-Size: 2900
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun, 13 Dec 2020 23:25:37 +0000 (UTC)
Message-ID: <cf2a184e2264a2b9fd2c8d7f10d524924d417d57.camel@perches.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Sun, 13 Dec 2020 15:25:36 -0800
In-Reply-To: <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
         <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
         <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
         <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
         <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
         <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 2020-12-13 at 11:21 -0800, Tom Rix wrote:
> On 12/2/20 2:34 PM, Nick Desaulniers wrote:
> > On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
> > > On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
> > > 
> > > > Yeah, we could go through and remove %h and %hh to solve this, too, right?
> > > Yup.
> > > 
> > > I think one of the checkpatch improvement mentees is adding
> > > some suggestion and I hope an automated fix mechanism for that.
> > > 
> > > https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
> > + Tom, who's been looking at leveraging clang-tidy to automate such
> > treewide mechanical changes.
> > ex. https://reviews.llvm.org/D91789
> > 
> > See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
> > use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
> > related context.
> 
> I have posted the fixer here
> 
> https://reviews.llvm.org/D93182
> 
> It catches about 200 problems in 100 files, I'll be posting these soon.

Thanks, but see below:
 
> clang-tidy-fix's big difference over checkpatch is using the __printf(x,y) attribute to find the log functions.
> 
> I will be doing a follow-on to add the missing __printf or __scanf's and rerunning the fixer.

scanf should not be tested because the %h use is required there.


