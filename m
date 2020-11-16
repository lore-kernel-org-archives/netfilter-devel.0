Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6152C4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 18:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 829552078E
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 18:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgKPSUc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730441AbgKPSUc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 13:20:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDD4C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 10:20:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kej76-000803-KB; Mon, 16 Nov 2020 19:20:28 +0100
Date:   Mon, 16 Nov 2020 19:20:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     subashab@codeaurora.org
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201116182028.GE22792@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

subashab@codeaurora.org <subashab@codeaurora.org> wrote:
> > > Unfortunately we are seeing it on ARM64 regression systems which
> > > runs a
> > > variety of
> > > usecases so the exact steps are not known.
> > 
> > Ok.  Would you be willing to run some of those with your suggested
> > change to see if that resolves the crashes or is that so rare that this
> > isn't practical?
> 
> I can try that out. Let me know if you have any other suggestions as well
> and I can try that too.
> 
> I assume we cant add locks here as it would be in the packet processing
> path.

Yes.  We can add a synchronize_net() in xt_replace_table if needed
though, before starting to put the references on the old ruleset
This would avoid the free of the jumpstack while skbs are still
in-flight.
