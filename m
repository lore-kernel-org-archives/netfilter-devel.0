Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21F3C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 13:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 847D4206FA
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 13:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbgJBNba (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 09:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgJBNba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 09:31:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B74C0613D0
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2020 06:31:29 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kOL9j-0001S0-LE; Fri, 02 Oct 2020 15:31:27 +0200
Date:   Fri, 2 Oct 2020 15:31:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201002133127.GD29050@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201002120732.GB29050@orbyte.nwl.cc>
 <20201002121558.GA1367@salvia>
 <20201002122852.GC29050@orbyte.nwl.cc>
 <20201002124741.GA2232@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002124741.GA2232@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 02, 2020 at 02:47:41PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 02, 2020 at 02:28:52PM +0200, Phil Sutter wrote:
> > On Fri, Oct 02, 2020 at 02:15:58PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Oct 02, 2020 at 02:07:32PM +0200, Phil Sutter wrote:
> > > > Hi,
> > > > 
> > > > On Fri, Oct 02, 2020 at 01:44:36PM +0200, Arturo Borrero Gonzalez wrote:
> > > > > Previous to this patch, the basechain policy could not be properly configured if it wasn't
> > > > > explictly set when loading the ruleset, leading to iptables-nft-restore (and ip6tables-nft-restore)
> > > > > trying to send an invalid ruleset to the kernel.
> > > > 
> > > > I fear this is not sufficient: iptables-legacy-restore leaves the
> > > > previous chain policy in place if '-' is given in dump file. Please try
> > > > this snippet from a testcase I wrote:
> > > > 
> > > > $XT_MULTI iptables -P FORWARD DROP
> > > > 
> > > > diff -u -Z <($XT_MULTI iptables-save | grep '^:FORWARD') \
> > > >            <(echo ":FORWARD DROP [0:0]")
> > > > 
> > > > $XT_MULTI iptables-restore -c <<< "$TEST_RULESET"
> > > > diff -u -Z <($XT_MULTI iptables-save | grep '^:FORWARD') \
> > > >            <(echo ":FORWARD DROP [0:0]")
> > > 
> > > Hm, this is how it works in this patch right?
> > > 
> > > I mean, if '-' is given, chain policy attribute in the netlink message
> > > is not set, and the kernel sets chain policy to
> > > NFT_CHAIN_POLICY_UNSET.
> > > 
> > > Or am I missing anything?
> > 
> > This is *flushing* iptables-restore. We're dropping the chain first and
> > then reinstall it.
> 
> OK, so this fix only works with --noflush.
> 
> If --noflush is not specified, then it should be possible to extend
> the cache to dump the chains, get the existing policy and use it.

nft_cmd_chain_restore() already sets NFT_CL_CHAINS.

> There is now a phase to evaluate the cache requirements, so you can
> fetch this. Then, from the netlink phase, look up for the existing
> policy in the cache and use it.

After the cache is fetched, nft_table_flush() runs before
nft_chain_restore() does.

> > Another quirk is that iptables-legacy-restore ignores the counters if
> > policy is '-' even if --counters flag was given. (:
> 
> OK, so this needs two more fixed on top of this one.

In Arturo's mail, he doesn't use --noflush. Not sure if this is just his
reproducer or if OpenStack doesn't use --noflush, either. If so, your
fix won't help with his problem.

Arturo, does fixing --noflush suffice for your case? If so, we could
delay the "--flush" case "for later". ;)

Cheers, Phil
