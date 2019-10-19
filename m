Return-Path: <SRS0=D3nJ=YM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19587CA9EAC
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Oct 2019 10:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E617221D7C
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Oct 2019 10:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbfJSKP2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Oct 2019 06:15:28 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:46188 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfJSKP2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Oct 2019 06:15:28 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iLlle-0000D9-6N; Sat, 19 Oct 2019 12:15:26 +0200
Date:   Sat, 19 Oct 2019 12:15:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xtables-restore: Fix --table parameter check
Message-ID: <20191019101526.GI26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190920154920.7927-1-phil@nwl.cc>
 <20191018140508.GB25052@breakpoint.cc>
 <20191018144806.GG26123@orbyte.nwl.cc>
 <20191018205808.GC25052@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018205808.GC25052@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 18, 2019 at 10:58:08PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > How did you generate it?  The added code is pure voodoo magic to me,
> > > so I wonder if we can just remove the 'test for -t in iptables-restore
> > > files' code.
> > 
> > Sorry, I didn't mean to create such unreadable code. I guess after
> > managing to wrap my head around to understand the old code, the new one
> > seemed much more clear to me. ;)
> 
> Fair enough, my main point was where the test cases come from, i.e.
> did you see such rule dumps in the wild, or did you create this manually
> to catch all corner cases?
> 
> I see you have a test for things like "-?t", so I wondered where that
> came from.

Ah! Originally this comes from a Red Hat BZ, not sure what reporter
actually tested with but as long as the comment started with a dash and
contained a 't' somewhere it would trigger the bug.

I wrote the test case along with the new implementation, searching for
things that could be mismatched. The '-?t' for instance is to make sure
combined short-options are matched correctly: Since '?' is not a valid
short option (at least not in iptables), this must not match as '-t'
option.

> > What do you think? Or should I respin after adding a bunch of comments
> > to is_table_param() to make it more clear?
> 
> I think thats the best option, I don't have any objections at the check
> per se given older iptables does this too.

I don't quite like this check, hence I don't overly cling to it. As you
see, checking for presence of an option in getopt() format is not easy
and we do that for every option of every rule in a dump. Maybe we should
really just append the explicit table param and accept that user's table
option is not rejected but simply ignored.

Cheers, Phil
