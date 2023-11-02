Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B17C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 17:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjKBRGn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 13:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjKBRGm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 13:06:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7072D12F
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 10:06:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qyb9O-0007Ga-UF; Thu, 02 Nov 2023 18:06:34 +0100
Date:   Thu, 2 Nov 2023 18:06:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix sets/reset_command_0 for current
 kernels
Message-ID: <ZUPXGnrqVajvEryb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20231102150342.3543-1-phil@nwl.cc>
 <08a7ddd943c17548bbe4a72d6c0aae3110b0d39e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08a7ddd943c17548bbe4a72d6c0aae3110b0d39e.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 04:29:34PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-02 at 16:03 +0100, Phil Sutter wrote:
> >  
> > +# Note: Element expiry is no longer reset since kernel commit
> > 4c90bba60c26
> > +# ("netfilter: nf_tables: do not refresh timeout when resetting
> > element"),
> > +# the respective parts of the test have therefore been commented
> > out.
> 
> Hi Phil,
> 
> do you expect that the old behavior ever comes back?

A recent nfbz comment[1] from Pablo made me doubt the decision is final,
though I may have misread it.

> Why keep the old checks (commented out)? Maybe drop them? We can get it
> from git history.

Should the change be permanent, one should change the tests to assert
the opposite, namely that expires values are unaffected by the reset.

> If you think something is still unclear without them, then instead
> elaborate further in the code comment (thanks for adding a code comment
> in the first place, very useful).

Cheers, Phil
