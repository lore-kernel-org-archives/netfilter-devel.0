Return-Path: <SRS0=tTqd=EO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460A6C55179
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 10:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13BAE206ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 10:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgKHKK3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Nov 2020 05:10:29 -0500
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:49930 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726206AbgKHKK3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Nov 2020 05:10:29 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id EA59A1730869;
        Sun,  8 Nov 2020 10:10:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bone67_5b0d737272e3
X-Filterd-Recvd-Size: 3142
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sun,  8 Nov 2020 10:10:25 +0000 (UTC)
Message-ID: <5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Sun, 08 Nov 2020 02:10:24 -0800
In-Reply-To: <alpine.DEB.2.21.2011080829080.4909@felia>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
         <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
         <alpine.DEB.2.21.2011080829080.4909@felia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 2020-11-08 at 08:34 +0100, Lukas Bulwahn wrote:
> On Sat, 7 Nov 2020, Joe Perches wrote:
> > On Fri, 2020-11-06 at 23:55 -0800, Nick Desaulniers wrote:
> > > Clang is more aggressive about -Wformat warnings when the format flag
> > > specifies a type smaller than the parameter. Fixes 8 instances of:
> > > 
> > > warning: format specifies type 'unsigned short' but the argument has
> > > type 'int' [-Wformat]
> > 
> > Likely clang's -Wformat message is still bogus.
> > Wasn't that going to be fixed?
> > 
> > Integer promotions are already done on these types to int anyway.
> > Didn't we have this discussion last year?
> > 
> > https://lore.kernel.org/lkml/CAKwvOd=mqzj2pAZEUsW-M_62xn4pijpCJmP=B1h_-wEb0NeZsA@mail.gmail.com/
> > https://lore.kernel.org/lkml/CAHk-=wgoxnmsj8GEVFJSvTwdnWm8wVJthefNk2n6+4TC=20e0Q@mail.gmail.com/
> > https://lore.kernel.org/lkml/a68114afb134b8633905f5a25ae7c4e6799ce8f1.camel@perches.com/
> > 
> > Look at commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
> > of unnecessary %h[xudi] and %hh[xudi]")
> > 
> > The "h" and "hh" things should never be used. The only reason for them
> > being used if if you have an "int", but you want to print it out as a
> > "char" (and honestly, that is a really bad reason, you'd be better off
> > just using a proper cast to make the code more obvious).
> > 
> Joe, would this be a good rule to check for in checkpatch?
> 
> Can Dwaipayan or Aditya give it a try to create a suitable patch to add 
> such a rule?

$ git grep -P '"[^"]*%[\d\.\*\-]*h+[idux].*"'

I suppose so.
Please avoid warning on scanf and its variants and the asm bits though.

> Dwaipayan, Aditya, if Joe thinks it is worth a rule, it is "first come, 
> first serve" for you to take that task. 


