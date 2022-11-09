Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7BFC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 10:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiKIKQT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 05:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiKIKQR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 05:16:17 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10E111D316
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 02:16:17 -0800 (PST)
Date:   Wed, 9 Nov 2022 11:16:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/2] Support resetting rules' state
Message-ID: <Y2t97iyVIMEzIF0q@salvia>
References: <20221014214559.22254-1-phil@nwl.cc>
 <Y1fOAZkQU8u81mPf@salvia>
 <Y2qIlYGKGxysxkFN@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2qIlYGKGxysxkFN@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 08, 2022 at 05:49:25PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Oct 25, 2022 at 01:52:33PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 14, 2022 at 11:45:57PM +0200, Phil Sutter wrote:
> > > In order to "zero" a rule (in the 'iptables -Z' sense), users had to
> > > dump (parts of) the ruleset in stateless form and restore it again after
> > > removing the dumped parts.
> > > 
> > > Introduce a simpler method to reset any stateful elements of a rule or
> > > all rules of a chain/table/family. Affects both counter and quota
> > > expressions.
> > 
> > Patchset LGTM.
> > 
> > For the record, we agreed on the workshop to extend this to:
> > 
> > - add support for this command to table, chain and set objects too.
> > - validate that nft syntax is consistent from userspace with other
> >   existing commands (for example, list).
> 
> Looking into this, I wonder if it might cause confusion with regards to
> stateful objects:
> 
> My original patch implements:
> 
> - reset rule [<fam>] <table> <chain> handle <num>
> - reset rules [<fam>]
> - reset rules table [<fam>] <table>
> - reset rules chain [<fam>] <table> <chain>
> 
> This is relatively consistent with list command, which (e.g.) has:
> 
> - list set [<fam>] <table> <set>
> - list sets [<fam>]
> - list sets table [<fam>] <table>

This also looks consistent with stateful objects:

- reset counter [<fam>] <counter>
- reset counters table [<fam>] table <table>
- reset counters [<fam>]

> IIRC, your request at NFWS was to introduce something like:
> 
> - reset table (for 'reset rules table')

This would require to make two calls, one to NFT_MSG_GETOBJ_RESET and
another to NFT_MSG_GETRULE_RESET:

> - reset chain (for 'reset rules chain')

This could be implemented with the new NFT_MSG_GETRULE_RESET, which
already allows to filter with chain.

So these two would only require userspace code, this can be done
later.

> But the first one may seem like resetting *all* state of a table,
> including named quotas, counters, etc. while in fact it only resets
> state in rules.

Yes, first should reset everything that is stateful and that is
contained in the table.

As said, this can be implemented later on from userspace.

This is addressing all my questions then, I'm going to put this into
nf-next.

Thanks for explaining.
