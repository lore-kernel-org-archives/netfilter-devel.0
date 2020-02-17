Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4444C34021
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3EC220718
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgBQOkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 09:40:36 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41240 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgBQOkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 09:40:36 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j3hZa-0001aR-2A; Mon, 17 Feb 2020 15:40:34 +0100
Date:   Mon, 17 Feb 2020 15:40:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     sbezverk <sbezverk@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Proposing to add a structure to UserData
Message-ID: <20200217144034.GC19559@breakpoint.cc>
References: <169CDFEB-A792-4063-AEC5-05B1714AED91@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169CDFEB-A792-4063-AEC5-05B1714AED91@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sbezverk <sbezverk@gmail.com> wrote:
> I would like to propose to add some structure to UserData. Currently nft tool uses UserData to carry comments and it prints out whatever is stored in it without much of processing. Since UserData is the only available mechanism to store some metadata for a rule, if it is used, then comments in nft cli get totally screwed up.

Then you are using it wrong :-)

Userdata is structured, its not used only for comments.
Which userdata are you referring to?  We have this for
rules, sets, and elements.

> If we could add attributes to UserData indicating type NFT_USERDATA_COMMENT with length, then we could preserve nft comments and at the same time allow to use UserData for other things.
> What do you think?

As far as I can see what you want is already implemented, for example
rule comments live in NFTNL_UDATA_RULE_COMMENT sub-type.
