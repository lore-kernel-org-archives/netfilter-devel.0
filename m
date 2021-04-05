Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0A1C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Apr 2021 21:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64F4B613BD
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Apr 2021 21:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241283AbhDEVoZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 17:44:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60660 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhDEVoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 17:44:25 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 452D262C1A;
        Mon,  5 Apr 2021 23:43:58 +0200 (CEST)
Date:   Mon, 5 Apr 2021 23:44:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: Unused macro
Message-ID: <20210405214414.GA10493@salvia>
References: <f209f7b0-af4c-e41c-b53e-27028b925978@gmail.com>
 <20210404200517.GN13699@breakpoint.cc>
 <57ad16e0-a116-5fe7-4f95-3790fffccb20@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57ad16e0-a116-5fe7-4f95-3790fffccb20@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, Apr 04, 2021 at 10:44:12PM +0200, Alejandro Colomar (man-pages) wrote:
> Hello Florian,
> 
> On 4/4/21 10:05 PM, Florian Westphal wrote:
> > Alejandro Colomar (man-pages) <alx.manpages@gmail.com> wrote:
> >> I was updating the includes on some manual pages, when I found that a
> >> macro used ARRAY_SIZE() without including a header that defines it.
> >> That surprised me, because it would more than likely result in a compile
> >> error, but of course, the macro wasn't being used:
> >>
> >> .../linux$ grep -rn SCTP_CHUNKMAP_IS_ALL_SET
> >> include/uapi/linux/netfilter/xt_sctp.h:80:#define
> >> SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
> >> .../linux$
> > 
> > This is an UAPI header, this macro is used by userspace software, e.g.
> > iptables.
> > 
> 
> Ahh, I see.  Thanks.
> 
> Then we still have the issue that ARRAY_SIZE is not defined in that
> header (see a simple test below).  You should probably include some
> header that provides it.

SCTP_CHUNKMAP_IS_* macros are used from iptables/extensions/xt_sctp.h
(iptables userspace codebase). These macros are also used internally
from net/netfilter/xt_sctp.c. It's using a rather unorthodox trick to
share code between the kernel and userspace, otherwise iptables would
need to keep a copy of this code.

BTW, why do you need xt_sctp.h for the manpages? This header is rather
specific to the match on sctp from the xtables infrastructure, so it's
not so useful from a programmer perspective (manpages) I think.

> But again, if no one noticed this in more than a decade, either no one
> used this macro, or they included other headers in the same file where
> they used the macro.  So I'd still rethink if maybe that macro (and
> possibly others) is really needed.
> 
> Test 1:
> 
> [[
> $ cat test.c
> #include <linux/netfilter/xt_sctp.h>
> 
> int foo(int x)
> {
> 	int a[x];
> 
> 	return ARRAY_SIZE(a);
> }
> $ cc -Wall -Wextra -Werror test.c -S -o test.s
> test.c: In function ‘foo’:
> test.c:7:9: error: implicit declaration of function ‘ARRAY_SIZE’
> [-Werror=implicit-function-declaration]
>     7 |  return ARRAY_SIZE(a);
>       |         ^~~~~~~~~~
> cc1: all warnings being treated as errors
> $
> ]]

I see, this is breaking self-compilation of the headers.

If there a need to remove xt_sctp.h from the ignore-list of the header
self-compilation infrastructure, it should be possible to fix
userspace to keep its own copy and probably add a #warn on the UAPI
header to let other possible consumers of this macro that this macro
will go away at some point.
