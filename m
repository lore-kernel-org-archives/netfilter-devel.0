Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FC8C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BAB620815
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbfETMGW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:06:22 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56716 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730534AbfETMGW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:06:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hSh3c-0000MC-1O; Mon, 20 May 2019 14:06:20 +0200
Date:   Mon, 20 May 2019 14:06:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables 4/4] nft: keep old cache around until batch is
 refreshed in case of ERESTART
Message-ID: <20190520120620.nxxl65syr2b7eal7@breakpoint.cc>
References: <20190519115121.32490-1-pablo@netfilter.org>
 <20190519115121.32490-4-pablo@netfilter.org>
 <20190519164508.GL4851@orbyte.nwl.cc>
 <20190520120018.GA31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520120018.GA31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Sun, May 19, 2019 at 06:45:08PM +0200, Phil Sutter wrote:
> [...]
> > The only way to make the above work is by keeping the original cache
> > copy around until mnl_batch_talk has finally succeeded or failed with
> > something else than ERESTART.
> 
> How about a completely different approach:
> 
> If memory serves right (and from reading the related Red Hat ticket),
> the actual problem we're trying to solve is that iptables-nft-restore
> creates NFT_MSG_DELTABLE only if that table exists already at the point
> of parsing but another client might create it in the mean time before
> committing.
> 
> My idea for solving this was to unconditionally create NFT_MSG_NEWTABLE
> followed by NFT_MSG_DELTABLE - in case the table exists, the first one
> is a noop; in case the table doesn't exist, the second one won't provoke
> an error message from kernel space.

Does that work even work?
new table x
del table x
add rule to x // table was deleted?

Or are you talking about a new/del/new sequence?

If it works, ok/fine, but it seems ugly.

> Since NFT_MSG_DELTABLE removes the table recursively, we don't need to
> care about any content added by the other client.

Yes, we can't do this in the --noflush case though.

> Or is this about a generic solution for all commands not just
> iptables-nft-restore (without --noflush)?

Its for ipt-nft-restore, including --noflush.

It would be good though to also speed up 'iptables-nft -A' later on
by eliding cache completely.
