Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447CCCA1008
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 20:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbjIEU2v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 16:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243701AbjIEU2t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 16:28:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33844CDC
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 13:28:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qdcf7-0005FA-8f; Tue, 05 Sep 2023 22:28:37 +0200
Date:   Tue, 5 Sep 2023 22:28:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/5] tests: add feature probing
Message-ID: <ZPePdR4SvdAk7+11@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230904090640.3015-1-fw@strlen.de>
 <20230904090640.3015-2-fw@strlen.de>
 <ZPcmZ4nqfG43SuM9@orbyte.nwl.cc>
 <20230905134406.GA28401@breakpoint.cc>
 <ZPc0z92PA6ZNXzM5@orbyte.nwl.cc>
 <20230905140920.GC28401@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905140920.GC28401@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 05, 2023 at 04:09:20PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Sure, because that's a short-cut for '[ -n false ]'. In what context is
> > that problematic?
> 
> if [ $HAVE_NFT_foo ] ; then ...

Same as if $HAVE_NFT_foo was either 0 or 1?! Obviously, with variables
holding the string "true" or "false", one has to test them either via:

| if $var; then ...

or

| if [ $var == true ]; then ...

I just find code more straightforward which does "if $have_foo; then
..." instead of "if [ $have_foo -ne 1 ]; then ...". The latter makes me
question whether that 1 is positive (as with C) or negative (as with
shell) and whether there are more possible values than two and any but 1
are OK.

Cheers, Phil
