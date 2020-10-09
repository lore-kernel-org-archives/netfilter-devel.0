Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEE1C433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 362C922258
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgJIJhI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgJIJhH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 05:37:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F0EC0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 02:37:07 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQopl-0008KW-9k; Fri, 09 Oct 2020 11:37:05 +0200
Date:   Fri, 9 Oct 2020 11:37:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201009093705.GF13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia>
 <20201009082953.GD13016@orbyte.nwl.cc>
 <20201009085039.GB7851@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009085039.GB7851@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 09, 2020 at 10:50:39AM +0200, Pablo Neira Ayuso wrote:
[...]
> Semantics for this are: Flush out _everything_ (existing rules and
> non-chains) but only leave existing basechain policies in place as is.
> 
> I wonder if this is intentional or a side effect of the --noflush support.
> 
> I'm Cc'ing Jozsef, maybe he remembers. Because you're reaching my
> boundaries on the netfilter history for this one :-)

FWIW, I searched git history and can confirm the given behaviour is like
that at least since Dec 2000 and commit ae1ff9f96a803 ("make
iptables-restore and iptables-save work again!")!

iptables-legacy-restore does:

| if (noflush == 0) {
|         DEBUGP("Cleaning all chains of table '%s'\n",
|                 table);
|         cb->for_each_chain(cb->flush_entries, verbose, 1,
|                         handle);
|
|         DEBUGP("Deleting all user-defined chains "
|                "of table '%s'\n", table);
|         cb->for_each_chain(cb->delete_chain, verbose, 0,
|                         handle);
| }

(Third parameter to for_each_chain decides whether builtins are included or
not.)

I guess fundamentally this is due to legacy design which keeps builtin
chains in place at all times. We could copy that in iptables-nft, but I
like the current design where we just delete the whole table and start
from scratch.

Florian made a related remark a while ago about flushing chains with
DROP policy: He claims it is almost always a mistake and we should reset
the policy to ACCEPT in order to avoid people from locking themselves
out. I second that idea, but am not sure if such a change is tolerable
at all.

Cheers, Phil
