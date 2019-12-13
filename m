Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16261C341C9
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DF624725
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfLMMbb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 07:31:31 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:51368 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbfLMMbb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 07:31:31 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ifk6T-0000TB-5b; Fri, 13 Dec 2019 13:31:29 +0100
Date:   Fri, 13 Dec 2019 13:31:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: enforce options before commands
Message-ID: <20191213123129.GC14465@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191213103246.260989-1-pablo@netfilter.org>
 <20191213104033.GQ795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213104033.GQ795@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 13, 2019 at 11:40:33AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch turns on POSIXLY_CORRECT on the getopt parser to enforce
> > options before commands. Users get a hint in such a case:
> > 
> >  # nft list ruleset -a
> >  Error: syntax error, options must be specified before commands
> >  nft list ruleset -a
> 
> FWIW i like this better than the attempt to sanitize/escape argv[].

I just realize my reordering idea will need to check for flags accepting
parameters as well. With getopt's flexibility, determining if a
parameter is or contains option X quickly blows up into implementing a
poor man's getopt parser itself.

Maybe we should indeed just go with "no flags after first non-flag
allowed" and document that in man page.

Cheers, Phil
