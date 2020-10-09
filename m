Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBDDC433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 12:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4063822276
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 12:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbgJIMFA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 08:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgJIME5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 08:04:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4822EC0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 05:04:57 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQr8p-0001sL-B1; Fri, 09 Oct 2020 14:04:55 +0200
Date:   Fri, 9 Oct 2020 14:04:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201009120455.GJ13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia>
 <20201009082953.GD13016@orbyte.nwl.cc>
 <20201009085039.GB7851@salvia>
 <20201009093705.GF13016@orbyte.nwl.cc>
 <alpine.DEB.2.23.453.2010091226090.19307@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2010091226090.19307@blackhole.kfki.hu>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 09, 2020 at 12:37:25PM +0200, Jozsef Kadlecsik wrote:
[...]
> I know lots of effort went into backward compatibility, this should be 
> included there too.

Certainly doable. Some hacking turned into quite a mess, though:

When restoring without '--noflush', a chain cache is needed - simply
doable by treating NFT_CL_FAKE differently. Reacting upon a chain policy
of '-' is easy, just lookup the existing chain's policy from cache and
use that. Things then become ugly for not specified chains:
'flush_table' callback really deletes the table. So one has to gather
the existing builtin chains first, check if their policy is non-default
and restore those. If they don't exist though, one has to expect for
them to occur when refreshing the transaction (due to concurrent ruleset
change). So the batch jobs have to be created either way and just set to
'skip' if either table or chain doesn't exist or the policy is ACCEPT.

If alternatively I decide to drop the table delete in 'flush_table', I
need to decide whether a builtin chain should be deleted or not, based
on its policy - which may change, so when refreshing transaction I would
have to turn a chain delete job into a flush rules one. Not nice, so
don't delete builtin chains in the first place. But the next obstacle
comes with user-defined chains: Deleting the existing ones, no problem -
cache is there. But when refreshing the transaction, new ones have to be
expected, so new jobs created.

The potential need to refresh a transaction is really causing
head-aches and the simple approach of dropping the table helped quite a
bit with that. Maybe I could implement some kernel bits to make things
simpler, like "delete all non-base chains" or "create chain if not
existing". But first I need more coffee. %)

Cheers, Phil
