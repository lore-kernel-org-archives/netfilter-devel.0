Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D98C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34B42054F
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389009AbfETMsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:48:41 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35452 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388262AbfETMsk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:48:40 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hShiX-0000Vb-I8; Mon, 20 May 2019 14:48:37 +0200
Date:   Mon, 20 May 2019 14:48:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 4/4] nft: keep old cache around until batch is
 refreshed in case of ERESTART
Message-ID: <20190520124837.GB31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190519115121.32490-1-pablo@netfilter.org>
 <20190519115121.32490-4-pablo@netfilter.org>
 <20190519164508.GL4851@orbyte.nwl.cc>
 <20190520120018.GA31548@orbyte.nwl.cc>
 <20190520120620.nxxl65syr2b7eal7@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520120620.nxxl65syr2b7eal7@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 20, 2019 at 02:06:20PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Sun, May 19, 2019 at 06:45:08PM +0200, Phil Sutter wrote:
> > [...]
> > > The only way to make the above work is by keeping the original cache
> > > copy around until mnl_batch_talk has finally succeeded or failed with
> > > something else than ERESTART.
> > 
> > How about a completely different approach:
> > 
> > If memory serves right (and from reading the related Red Hat ticket),
> > the actual problem we're trying to solve is that iptables-nft-restore
> > creates NFT_MSG_DELTABLE only if that table exists already at the point
> > of parsing but another client might create it in the mean time before
> > committing.
> > 
> > My idea for solving this was to unconditionally create NFT_MSG_NEWTABLE
> > followed by NFT_MSG_DELTABLE - in case the table exists, the first one
> > is a noop; in case the table doesn't exist, the second one won't provoke
> > an error message from kernel space.
> 
> Does that work even work?
> new table x
> del table x
> add rule to x // table was deleted?
> 
> Or are you talking about a new/del/new sequence?

Oh, yes of course. Existing iptables-nft-restore does:

1) delete table x if exists
2) add table x
3) add table x content

My idea is to:

+ 0) add table x
- 1) delete table x if exists
+ 1) delete table x
  2) add table x
  3) add table x content

> If it works, ok/fine, but it seems ugly.

Did you consider rule insert with index in your batch replay logic? I
did when duplicating it for nft, but decided it's not worth it and
people using 'add rule ... index IDX' have been warned already anyway.

> > Since NFT_MSG_DELTABLE removes the table recursively, we don't need to
> > care about any content added by the other client.
> 
> Yes, we can't do this in the --noflush case though.

My state from our last talk about it was "--noflush users are screwed
anyway". :)

> > Or is this about a generic solution for all commands not just
> > iptables-nft-restore (without --noflush)?
> 
> Its for ipt-nft-restore, including --noflush.
> 
> It would be good though to also speed up 'iptables-nft -A' later on
> by eliding cache completely.

The problem is that we can't unconditionally create NFT_MSG_NEWCHAIN
because that will reset the chain policy if non-default. So we need at
least a cache containing tables and chains, even for that simple rule
append command.

Cheers, Phil
