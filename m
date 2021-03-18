Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F82C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 12:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF18064F4D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 12:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCRMhr convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhCRMh1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 08:37:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB4EC06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Mar 2021 05:37:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lMru0-00089K-JO; Thu, 18 Mar 2021 13:37:24 +0100
Date:   Thu, 18 Mar 2021 13:37:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 6/6] src: allow arbitary chain name in implicit rule
 add case
Message-ID: <20210318123724.GB22603@breakpoint.cc>
References: <20210316234039.15677-1-fw@strlen.de>
 <20210316234039.15677-7-fw@strlen.de>
 <20210318120019.GH6306@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210318120019.GH6306@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > Another alternative is to deprecate implicit rule add altogether
> > so users would have to move to 'nft add rule ...'.
> 
> Isn't this required for nested syntax? I didn't check, but does your
> arbitrary table/chain name support work also when restoring a ruleset in
> that nested syntax?

Whats 'nested syntax'?

You mean "table bla { chain foo {"?

> Another interesting aspect might be arbitrary set
> names - 'set' is also a valid keyword used in rules, this fact killed my
> approach with start conditions. ;)

Right, arbitrary set names are needed as well, I forgot about them.

It should be possible by using two "set" rules in flex.

One in the INITIAL scope (to handle set bla {), and one in
'rule' or 'expression scope'.

The former would switch to an exclusive start condition (expect
STRING, close condition on '{', just like CHAIN is handled here.

The latter would not change state and just return SET token.
