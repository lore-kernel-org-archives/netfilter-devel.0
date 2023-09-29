Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEB9E732D0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 10:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjI2KNN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 06:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjI2KNM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 06:13:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAB6C0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 03:13:10 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmAUe-0007HM-4M; Fri, 29 Sep 2023 12:13:08 +0200
Date:   Fri, 29 Sep 2023 12:13:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 1/8] netfilter: nf_tables: Don't allocate
 nft_rule_dump_ctx
Message-ID: <ZRajNJ+66J0qM4DQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-2-phil@nwl.cc>
 <20230928190044.GF19098@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928190044.GF19098@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 09:00:44PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Eliminate the direct use of netlink_callback::args when dumping rules by
> > casting nft_rule_dump_ctx over netlink_callback::ctx as suggested in
> > the struct's comment.
> > 
> > The value for 's_idx' has to be stored inside nft_rule_dump_ctx now and
> > make it hold the 'reset' boolean as well.
> > 
> > Note how this patch removes the zeroing of netlink_callback::args[1-5] -
> > none of the rule dump callbacks seem to make use of them.
> 
> Do you think we can fix the reset race in -next instead of -nf?
> 
> If yes, you could detach preparation patches like this one and
> split the series in several batches.

Yes, I noticed this series is no longer the "add some spinlock to
prevent races" it was in the beginning.

TBH, I chose nf mostly because nf-next lacked a commit I needed. But
it's there now, so v3 will address nf-next.

Thanks, Phil
