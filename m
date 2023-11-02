Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18549C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 08:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbjKBIFA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 04:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbjKBIE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 04:04:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AEB111
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 01:04:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyShC-0006DL-8a; Thu, 02 Nov 2023 09:04:54 +0100
Date:   Thu, 2 Nov 2023 09:04:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/7] json: drop messages "warning: stmt ops chain
 have no json callback"
Message-ID: <20231102080454.GA23579@breakpoint.cc>
References: <20231031185449.1033380-1-thaller@redhat.com>
 <20231031185449.1033380-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031185449.1033380-3-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> This message purely depends on the internal callbacks and at the program
> code. This is not useful. What is the user going to do with this warning?

Report a bug.

> Maybe there is a bug here, but then we shouldn't print a warning but fix
> the bug.

How on earth do we do that, fix a bug before we know its there?

> For example, calling `nft -j list ruleset` after test "tests/shell/testcases/chains/0041chain_binding_0"
> will trigger messages like:
> 
>   warning: stmt ops chain have no json callback
>   warning: stmt ops chain have no json callback

That means that chain ops needs a bug fix as they do not support
json output?
