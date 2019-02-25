Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BFDC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E38362147C
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbfBYLyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:54:08 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfBYLyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 06:54:08 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1gyEpg-00033B-8K; Mon, 25 Feb 2019 12:54:04 +0100
Date:   Mon, 25 Feb 2019 12:54:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW25mLW5l?= =?utf-8?B?eHRd?=
 netfilter: replace modulo operation with bitwise AND
Message-ID: <20190225115404.lul4qhfailu5u4yx@breakpoint.cc>
References: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
 <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
 <9d0a1d65189d4118a2dd6087b817d42e@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d0a1d65189d4118a2dd6087b817d42e@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Li,Rongqing <lirongqing@baidu.com> wrote:
> 
> 
> > -----邮件原件-----
> > 发件人: Florian Westphal [mailto:fw@strlen.de]
> > 发送时间: 2019年2月25日 19:27
> > 收件人: Li,Rongqing <lirongqing@baidu.com>
> > 抄送: netfilter-devel@vger.kernel.org
> > 主题: Re: [PATCH][nf-next] netfilter: replace modulo operation with bitwise
> > AND
> > 
> > Li RongQing <lirongqing@baidu.com> wrote:
> > > CONNTRACK_LOCKS is 1024 and power of 2, so modulo operations can be
> > > replaced with AND (CONNTRACK_LOCKS - 1)
> > >
> > > and bitwise AND operation is quicker than module operation
> > 
> > Uh.  What kind of compiler doesn't figure that out?!
> > 
> > I would prefer to keep it as-is and let compiler do the optimization.
> 
> 
> gcc version 7.3.0 (GCC)
> 
> 
> main()
> {
>     int i=1000000000;
> 
>          i= i % 1024;
> 
>         return i;
> }
> 
> 00000000004004a7 <main>:
>   4004a7:       55                      push   %rbp
>   4004a8:       48 89 e5                mov    %rsp,%rbp
>   4004ab:       c7 45 fc 00 ca 9a 3b    movl   $0x3b9aca00,-0x4(%rbp)
>   4004b2:       8b 45 fc                mov    -0x4(%rbp),%eax
>   4004b5:       99                      cltd
>   4004b6:       c1 ea 16                shr    $0x16,%edx
>   4004b9:       01 d0                   add    %edx,%eax
>   4004bb:       25 ff 03 00 00          and    $0x3ff,%eax

& 1023.

With -O2 gcc emits same code regardless of % 1024 or & 1023.

> Similar patch:
> 
> commit 1a1d74d378b13ad3f93e8975a0ade0980a49d28b
> Author: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date:   Mon Oct 31 20:43:17 2016 +0000
> 
>     nfp: use AND instead of modulo to get ring indexes

But in that case the value isn't known at compile time.

gcc can't know that '= reg1 % reg2' can be rewritten as 'reg1 & (reg2 - 1)'

But it can do it if reg2 is a known constant (and a power of 2).
