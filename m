Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9914EC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 12:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKIMLs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 07:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKIMLs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 07:11:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E1310FF9
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 04:11:46 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1osjvk-0007Lo-Dn; Wed, 09 Nov 2022 13:11:44 +0100
Date:   Wed, 9 Nov 2022 13:11:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/2] Support resetting rules' state
Message-ID: <Y2uZAP7d1VEA4BeL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221014214559.22254-1-phil@nwl.cc>
 <Y1fOAZkQU8u81mPf@salvia>
 <Y2qIlYGKGxysxkFN@orbyte.nwl.cc>
 <Y2t97iyVIMEzIF0q@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2t97iyVIMEzIF0q@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 09, 2022 at 11:16:14AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 08, 2022 at 05:49:25PM +0100, Phil Sutter wrote:
[...]
> > IIRC, your request at NFWS was to introduce something like:
> > 
> > - reset table (for 'reset rules table')
> 
> This would require to make two calls, one to NFT_MSG_GETOBJ_RESET and
> another to NFT_MSG_GETRULE_RESET:

Ah yes, there is NFT_OBJECT_UNSPEC which should allow to reset all kinds
of objects at once.

> > - reset chain (for 'reset rules chain')
> 
> This could be implemented with the new NFT_MSG_GETRULE_RESET, which
> already allows to filter with chain.

Yes, it would just be an alias for 'reset rules chain'.

> So these two would only require userspace code, this can be done
> later.

ACK.

> > But the first one may seem like resetting *all* state of a table,
> > including named quotas, counters, etc. while in fact it only resets
> > state in rules.
> 
> Yes, first should reset everything that is stateful and that is
> contained in the table.
> 
> As said, this can be implemented later on from userspace.
> 
> This is addressing all my questions then, I'm going to put this into
> nf-next.

Cool, thanks!

Cheers, Phil
