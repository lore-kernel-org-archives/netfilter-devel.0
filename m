Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21770C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 23:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB62B2073C
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 23:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDXUc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 18:20:32 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52676 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbfLDXUc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 18:20:32 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1icdwb-0008FW-Er; Thu, 05 Dec 2019 00:20:29 +0100
Date:   Thu, 5 Dec 2019 00:20:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests: netfilter: use randomized netns names
Message-ID: <20191204232029.GW795@breakpoint.cc>
References: <20191202173540.12230-1-fw@strlen.de>
 <20191204231404.GA14469@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204231404.GA14469@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Hi,
> 
> On Mon, Dec 02, 2019 at 06:35:40PM +0100, Florian Westphal wrote:
> [...]
> > @@ -532,32 +547,32 @@ EOF
> >  	# ns1 should not have seen packets from ns2, due to masquerade
> >  	expect="packets 0 bytes 0"
> >  	for dir in "in" "out" ; do
> > -		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
> > +		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
> >  		if [ $? -ne 0 ]; then
> > -			bad_counter ns1 ns0$dir "$expect"
> > +			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade 5"
> >  			lret=1
> >  		fi
> >  
> > -		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
> > +		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
> 
> This is confusing. You're fixing a bug and it is correct?

It was a duplicate of the check above.

> >  		if [ $? -ne 0 ]; then
> > -			bad_counter ns2 ns1$dir "$expect"
> > +			bad_counter "$ns0" ns1$dir "$expect" "test_masquerade 6"
> 
> And here as well?

Yes, this should test ns0 did not get packets from ns1.

> [...]
> > @@ -708,28 +723,28 @@ EOF
> >  	# ns0 should have seen packets from ns2, due to masquerade
> >  	expect="packets 1 bytes 84"
> >  	for dir in "in" "out" ; do
> > -		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
> > +		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
> >  		if [ $? -ne 0 ]; then
> > -			bad_counter ns1 ns0$dir "$expect"
> > +			bad_counter "$ns0" ns0$dir "$expect" "test_redirect 4"
> 
> This is actually a bugfix, right?

Yes, test is correct but if it fails it dumped the wrong counter.
