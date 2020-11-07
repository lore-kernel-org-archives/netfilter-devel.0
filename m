Return-Path: <SRS0=C+nS=EN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE38C4741F
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Nov 2020 10:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF6F20888
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Nov 2020 10:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgKGKik (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Nov 2020 05:38:40 -0500
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:59160 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726665AbgKGKik (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Nov 2020 05:38:40 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Nov 2020 05:38:40 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 249651801493F
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Nov 2020 10:33:14 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 66342100E7B43;
        Sat,  7 Nov 2020 10:33:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: tooth45_310a6a7272da
X-Filterd-Recvd-Size: 2830
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Sat,  7 Nov 2020 10:33:10 +0000 (UTC)
Message-ID: <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
In-Reply-To: <20201107075550.2244055-1-ndesaulniers@google.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Sat, 07 Nov 2020 02:32:20 -0800
User-Agent: Evolution 3.38.1-1 
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2020-11-06 at 23:55 -0800, Nick Desaulniers wrote:
> Clang is more aggressive about -Wformat warnings when the format flag
> specifies a type smaller than the parameter. Fixes 8 instances of:
> 
> warning: format specifies type 'unsigned short' but the argument has
> type 'int' [-Wformat]

Likely clang's -Wformat message is still bogus.
Wasn't that going to be fixed?

Integer promotions are already done on these types to int anyway.
Didn't we have this discussion last year?

https://lore.kernel.org/lkml/CAKwvOd=mqzj2pAZEUsW-M_62xn4pijpCJmP=B1h_-wEb0NeZsA@mail.gmail.com/
https://lore.kernel.org/lkml/CAHk-=wgoxnmsj8GEVFJSvTwdnWm8wVJthefNk2n6+4TC=20e0Q@mail.gmail.com/
https://lore.kernel.org/lkml/a68114afb134b8633905f5a25ae7c4e6799ce8f1.camel@perches.com/

Look at commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
of unnecessary %h[xudi] and %hh[xudi]")

The "h" and "hh" things should never be used. The only reason for them
being used if if you have an "int", but you want to print it out as a
"char" (and honestly, that is a really bad reason, you'd be better off
just using a proper cast to make the code more obvious).

So if what you have a "char" (or unsigned char) you should always just
print it out as an "int", knowing that the compiler already did the
proper type conversion.

> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
[]
> @@ -50,38 +50,38 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
>  
> 
>  	switch (l4proto->l4proto) {
>  	case IPPROTO_ICMP:
> -		seq_printf(s, "type=%u code=%u id=%u ",
> +		seq_printf(s, "type=%u code=%u id=%hu ",

etc...


