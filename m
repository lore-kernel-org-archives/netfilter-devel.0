Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D14DC2BB9A
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 16:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E807022583
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 16:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440110AbgLNQHE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbgLNQGx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 11:06:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCCBC0613D3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2020 08:06:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1koqMV-0007Ib-KR; Mon, 14 Dec 2020 17:06:11 +0100
Date:   Mon, 14 Dec 2020 17:06:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables-nft 3/3] xtables-monitor: print packet first
Message-ID: <20201214160611.GA8710@breakpoint.cc>
References: <20201212151534.54336-1-fw@strlen.de>
 <20201212151534.54336-4-fw@strlen.de>
 <20201214141435.GC28824@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214141435.GC28824@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> >  	switch (nftnl_trace_get_u32(nlt, NFTNL_TRACE_TYPE)) {
> >  	case NFT_TRACETYPE_RULE:
> >  		verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
> > -		printf(":rule:0x%llx:", (unsigned long long)nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE));
> 
> Quite long long line here. ;)
> How about using PRIx64 in the format string to avoid the cast?

Its just being moved from here...

> > -		print_verdict(nlt, verdict);
> >  
> > -		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
> > -			trace_print_rule(nlt, arg);
> >  		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
> >  		    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
> >  			trace_print_packet(nlt, arg);
> > +
> > +		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE)) {
> > +			trace_print_hdr(nlt);
> > +			printf(":rule:0x%llx:", (unsigned long long)nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE));

To this location.  But sure, I can change it.
