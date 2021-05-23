Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056A6C4707A
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 May 2021 18:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6DE60C3E
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 May 2021 18:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhEWS4C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 May 2021 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbhEWS4C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 May 2021 14:56:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8974C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 23 May 2021 11:54:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lktF9-0000Hi-MW; Sun, 23 May 2021 20:54:31 +0200
Date:   Sun, 23 May 2021 20:54:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/4] netfilter: nf_tables: include table and
 chain name when dumping hooks
Message-ID: <20210523185431.GA31080@breakpoint.cc>
References: <20210521113922.20798-1-fw@strlen.de>
 <20210521113922.20798-5-fw@strlen.de>
 <20210523085228.GA11701@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210523085228.GA11701@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, May 21, 2021 at 01:39:22PM +0200, Florian Westphal wrote:
> >   * @NFTA_HOOK_FUNCTION_NAME: hook function name (NLA_STRING)
> >   * @NFTA_HOOK_MODULE_NAME: kernel module that registered this hook (NLA_STRING)
> > + * @NFTA_HOOK_NFT_CHAIN_INFO: nft chain and table name (NLA_NESTED)
> 
> Probably NFTA_HOOK_CHAIN_INFO ?

I added _NFT_ to avoid ambiguity in case this would be extended
to add xt-legacy chain info.  I can drop the _NFT_, let me know.
