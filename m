Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2AAC83F2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244134AbjIEQ1G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354744AbjIEOB6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 10:01:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A29A197
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 07:01:53 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qdWcp-0001LS-C9; Tue, 05 Sep 2023 16:01:51 +0200
Date:   Tue, 5 Sep 2023 16:01:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/5] tests: add feature probing
Message-ID: <ZPc0z92PA6ZNXzM5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230904090640.3015-1-fw@strlen.de>
 <20230904090640.3015-2-fw@strlen.de>
 <ZPcmZ4nqfG43SuM9@orbyte.nwl.cc>
 <20230905134406.GA28401@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905134406.GA28401@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 05, 2023 at 03:44:06PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Mon, Sep 04, 2023 at 11:06:30AM +0200, Florian Westphal wrote:
> > > Running selftests on older kernels makes some of them fail very early
> > > because some tests use features that are not available on older
> > > kernels, e.g. -stable releases.
> > > 
> > > Known examples:
> > > - inner header matching
> > > - anonymous chains
> > > - elem delete from packet path
> > > 
> > > Also, some test cases might fail because a feature isn't
> > > compiled in, such as netdev chains for example.
> > > 
> > > This adds a feature-probing to the shell tests.
> > > 
> > > Simply drop a 'nft -f' compatible file with a .nft suffix into
> > > tests/shell/features.
> > > 
> > > run-tests.sh will load it via --check and will add
> > > 
> > > NFT_TESTS_HAVE_${filename}=$?
> > 
> > Maybe make this:
> > 
> > | truefalse=(true false)
> > | NFT_TESTS_HAVE_${filename}=${truefalse[$?]}
> > 
> > [...]
> > 
> > > [ $NFT_HAVE_chain_binding -eq 1 ] && test_chain_binding
> > 
> > So this becomes:
> > 
> > | $NFT_HAVE_chain_binding && test_chain_binding
> > 
> > Use of true/false appears to work in dash, so might be POSIX sh
> > compatible?
> 
> Can do that, but if [ false ] evaluates to true...

Sure, because that's a short-cut for '[ -n false ]'. In what context is
that problematic?
