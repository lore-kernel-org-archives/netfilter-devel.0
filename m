Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B8FC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Nov 2022 16:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiKHQta (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Nov 2022 11:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiKHQt3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2022 11:49:29 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E071057B54
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2022 08:49:27 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1osRmv-0003ZB-MK; Tue, 08 Nov 2022 17:49:25 +0100
Date:   Tue, 8 Nov 2022 17:49:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/2] Support resetting rules' state
Message-ID: <Y2qIlYGKGxysxkFN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221014214559.22254-1-phil@nwl.cc>
 <Y1fOAZkQU8u81mPf@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1fOAZkQU8u81mPf@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Oct 25, 2022 at 01:52:33PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 14, 2022 at 11:45:57PM +0200, Phil Sutter wrote:
> > In order to "zero" a rule (in the 'iptables -Z' sense), users had to
> > dump (parts of) the ruleset in stateless form and restore it again after
> > removing the dumped parts.
> > 
> > Introduce a simpler method to reset any stateful elements of a rule or
> > all rules of a chain/table/family. Affects both counter and quota
> > expressions.
> 
> Patchset LGTM.
> 
> For the record, we agreed on the workshop to extend this to:
> 
> - add support for this command to table, chain and set objects too.
> - validate that nft syntax is consistent from userspace with other
>   existing commands (for example, list).

Looking into this, I wonder if it might cause confusion with regards to
stateful objects:

My original patch implements:

- reset rule [<fam>] <table> <chain> handle <num>
- reset rules [<fam>]
- reset rules table [<fam>] <table>
- reset rules chain [<fam>] <table> <chain>

This is relatively consistent with list command, which (e.g.) has:

- list set [<fam>] <table> <set>
- list sets [<fam>]
- list sets table [<fam>] <table>

IIRC, your request at NFWS was to introduce something like:

- reset table (for 'reset rules table')
- reset chain (for 'reset rules chain')

But the first one may seem like resetting *all* state of a table,
including named quotas, counters, etc. while in fact it only resets
state in rules.

Cheers, Phil
