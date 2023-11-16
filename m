Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841C4C197A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Nov 2023 23:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345563AbjKPXCu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Nov 2023 18:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345551AbjKPXCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2023 18:02:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA30DAD
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2023 15:02:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r3lNl-00018A-0E; Fri, 17 Nov 2023 00:02:45 +0100
Date:   Fri, 17 Nov 2023 00:02:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <20231116230244.GB1206@breakpoint.cc>
References: <20231114160903.409552-1-thaller@redhat.com>
 <20231115082427.GC14621@breakpoint.cc>
 <ZVSVPgRFv9tTF4yQ@calendula>
 <20231115100101.GA23742@breakpoint.cc>
 <ZVSgywZtf8F7nFop@calendula>
 <20231115122105.GD23742@breakpoint.cc>
 <ZVS530oqzSu/cgQS@calendula>
 <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
 <ZVY++RiqayXOZSBQ@calendula>
 <20231116230024.GA1206@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116230024.GA1206@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Thomas,
> > 
> > On Wed, Nov 15, 2023 at 01:36:40PM +0100, Thomas Haller wrote:
> > > On Wed, 2023-11-15 at 13:30 +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > > I see _lots_ of DUMP FAIL with kernel 5.4
> > > 
> > > Hi,
> > > 
> > > Could you provide more details?
> > > 
> > > For example,
> > > 
> > >     make -j && ./tests/shell/run-tests.sh tests/shell/testcases/include/0007glob_double_0 -x
> > >     grep ^ -a -R /tmp/nft-test.latest.*/
> > 
> > # cat [...]/ruleset-diff.json
> > --- testcases/include/dumps/0007glob_double_0.json-nft  2023-11-15 13:27:20.272084254 +0100
> > +++ /tmp/nft-test.20231116-170617.584.lrZzMy/test-testcases-include-0007glob_double_0.1/ruleset-after.json      2023-11-16 17:06:18.332535411 +0100
> > @@ -1 +1 @@
> > -{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x", "handle": 1}}, {"table": {"family": "ip", "name": "y", "handle": 2}}]}
> > +{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x", "handle": 158}}, {"table": {"family": "ip", "name": "y", "handle": 159}}]}
> > 
> > It seems that handles are a problem in this diff.
> 
> Are you running tests with -s option?
> 
> In that case, modules are removed after each test.
> 
> I suspect its because we can then hit -EAGAIN mid-transaction
> because module is missing (again), then replay logic does its
> thing.
> 
> But the handle generator isn't transaction aware,
> so it has advanced vs. the aborted partial transaction.
> 
> I'm not sure what to do here.
> 
> One the one hand those rmmods are plain stupid, but on the other
> hand this adds partial coverage for the rmmod path.
> 
> We could make the handle counter transaction aware to
> "fix" this on kernel side; it should not be too much code.
> 
> What do you think?

Oh, wait, on older kernels the entire handle counter is global,
so "unshare -n" has no effect on it.

But the rmmod scenario explained above happens as well, this
"breaks" json dumps on centos stream 9, which does have the
pernet handle generator fix backported.
