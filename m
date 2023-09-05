Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A53C83F3E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351962AbjIEQ0a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354761AbjIEOJZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 10:09:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6821197
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 07:09:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qdWk4-0007X2-KL; Tue, 05 Sep 2023 16:09:20 +0200
Date:   Tue, 5 Sep 2023 16:09:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/5] tests: add feature probing
Message-ID: <20230905140920.GC28401@breakpoint.cc>
References: <20230904090640.3015-1-fw@strlen.de>
 <20230904090640.3015-2-fw@strlen.de>
 <ZPcmZ4nqfG43SuM9@orbyte.nwl.cc>
 <20230905134406.GA28401@breakpoint.cc>
 <ZPc0z92PA6ZNXzM5@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPc0z92PA6ZNXzM5@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Sure, because that's a short-cut for '[ -n false ]'. In what context is
> that problematic?

if [ $HAVE_NFT_foo ] ; then ...
