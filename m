Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5B7C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8969E206E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgFVOEy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbgFVOEy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:04:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCEEC061573
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:04:53 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jnN46-0003R4-B7; Mon, 22 Jun 2020 16:04:50 +0200
Date:   Mon, 22 Jun 2020 16:04:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables user space performance benchmarks published
Message-ID: <20200622140450.GZ23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Reindl Harald <h.reindl@thelounge.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Harald,

On Mon, Jun 22, 2020 at 03:34:24PM +0200, Reindl Harald wrote:
> Am 22.06.20 um 14:42 schrieb Pablo Neira Ayuso:
> > Hi Phil,
> > 
> > On Fri, Jun 19, 2020 at 04:11:57PM +0200, Phil Sutter wrote:
> >> Hi Pablo,
> >>
> >> I remember you once asked for the benchmark scripts I used to compare
> >> performance of iptables-nft with -legacy in terms of command overhead
> >> and caching, as detailed in a blog[1] I wrote about it. I meanwhile
> >> managed to polish the scripts a bit and push them into a public repo,
> >> accessible here[2]. I'm not sure whether they are useful for regular
> >> runs (or even CI) as a single run takes a few hours and parallel use
> >> likely kills result precision.
> > 
> > So what is the _technical_ incentive for using the iptables blob
> > interface (a.k.a. legacy) these days then?
> > 
> > The iptables-nft frontend is transparent and it outperforms the legacy
> > code for dynamic rulesets.
> 
> it is not transparent enough because it don't understand classical ipset

It does! You can use ipsets with iptables-nft just as before. If your
experience differs, that's a bug we should fix.

> my shell scripts creating the ruleset, cahins and ipsets can be switched
> from iptables-legacy to iptables-nft and before the reboot despite the
> warning that both are loaded it *looked* more or less fine comparing the
> rulset from both backends
> 
> i gave it one try and used "iptables-nft-restore" and "ip6tables-nft",
> after reboot nothing worked at all

Not good. Did you find out *why* nothing worked anymore? Would you maybe
care to share your script and ruleset with us?

> via console i called "firewall.sh" again wich would delete all rules and
> chains followed by re-create them, no success and errors that things
> already exist

That sounds weird, if it reliably drops everything why does it complain
with EEXIST?

> please don't consider to drop iptables-legacy, it just works and im miss
> a compelling argument to rework thousands of hours

I'm not the one to make that call, but IMHO the plan is for
iptables-legacy to become irrelevant *before* it is dropped from
upstream repositories. So as long as you are still using it (and you're
not an irrelevant minority ;) nothing's at harm.

Cheers, Phil
