Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0231CC76186
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 19:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6B3D20823
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 19:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfGTTnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 15:43:24 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48682 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbfGTTnY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 15:43:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hovGN-0000q5-0k; Sat, 20 Jul 2019 21:43:23 +0200
Date:   Sat, 20 Jul 2019 21:43:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/2] parser_bison: Get rid of (most) bison compiler
 warnings
Message-ID: <20190720194322.ehyg7jlzqtugnacw@breakpoint.cc>
References: <20190720185226.8876-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720185226.8876-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Shut the complaints about POSIX incompatibility by passing -Wno-yacc to
> bison. An alternative would be to not pass -y, but that caused seemingly
> unsolveable problems with automake and expected file names.
> 
> Fix two warnings about deprecated '%pure-parser' and '%error-verbose'
> statements by replacing them with what bison suggests.
> 
> A third warning sadly left in place: Replacing '%name-prefix' by what
> is suggested leads to compilation errors.

Can you add those warnings to the changelog before pushing?

I don't see them, even without this patch.
