Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46032C32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1774A217F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgATWM1 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:12:27 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgATWM1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 17:12:27 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1itfHV-0003pe-Rv; Mon, 20 Jan 2020 23:12:25 +0100
Date:   Mon, 20 Jan 2020 23:12:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     sbezverk <sbezverk@gmail.com>, Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: load balancing between two chains
Message-ID: <20200120221225.GI795@breakpoint.cc>
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
 <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
 <20200120213954.GF795@breakpoint.cc>
 <BC7FFB04-4465-4B3B-BA5B-17BEA0FC909B@gmail.com>
 <20200120220012.GH795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200120220012.GH795@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> sbezverk <sbezverk@gmail.com> wrote:
> > Numgen has GOTO directive and not Jump (Phil asked to change it), I thought it means after hitting any chains in numgen the processing will go back to service chain, no?
> > 
> > It is Ubuntu 18.04
> > 
> > sbezverk@kube-4:~$ uname -a
> > Linux kube-4 5.4.10-050410-generic #202001091038 SMP Thu Jan 9 10:41:11 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
> > sbezverk@kube-4:~$ sudo nft --version
> > nftables v0.9.1 (Headless Horseman)
> > sbezverk@kube-4:~$
> > 
> > I also want to remind you that I do NOT use nft cli to program rules, I use nft cli just to see resulting rules.
> 
> In that case, please include "nft --debug=netlink list ruleset".
> 
> It would also be good to check if things work when you add it via nft
> tool.

Oh, and for the fun of it, you could also try this:

chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
	numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-I7XZOUOVPIQW4IXA, 1 : goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ, 16777216 : goto endianbug }
	counter packets 0 bytes 0 } 
        chain endianbug {
		 counter packets 0 bytes 0
	}
 ...

numgen generates a 32bit number in host byte order, so nft internally
converts the keys accordingly (16777216 is htonl(1)).
