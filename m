Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B299DC433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E95D22276
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731833AbgJIKPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 06:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJIKPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 06:15:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BEFC0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 03:15:01 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQpQQ-0000Pw-ND; Fri, 09 Oct 2020 12:14:58 +0200
Date:   Fri, 9 Oct 2020 12:14:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201009101458.GG13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Reindl Harald <h.reindl@thelounge.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia>
 <20201009082953.GD13016@orbyte.nwl.cc>
 <20201009085039.GB7851@salvia>
 <20201009093705.GF13016@orbyte.nwl.cc>
 <0669e18b-661b-efec-fe15-e540290c3219@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0669e18b-661b-efec-fe15-e540290c3219@thelounge.net>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Harald,

On Fri, Oct 09, 2020 at 12:07:57PM +0200, Reindl Harald wrote:
> Am 09.10.20 um 11:37 schrieb Phil Sutter:
> > I guess fundamentally this is due to legacy design which keeps builtin
> > chains in place at all times. We could copy that in iptables-nft, but I
> > like the current design where we just delete the whole table and start
> > from scratch.
> > 
> > Florian made a related remark a while ago about flushing chains with
> > DROP policy: He claims it is almost always a mistake and we should reset
> > the policy to ACCEPT in order to avoid people from locking themselves
> > out. I second that idea, but am not sure if such a change is tolerable
> > at all.
> bad idea!

Why?

> nothing is locking you out just because of a short drop phase, at least 
> not over the past 12 years, that's what tcp retransmits are for

What I had in mind was 'ssh somehost iptables -F INPUT'.

> when you once accept i have someone which should never have been 
> accepted in the conntracking - sorry - but when i say drop i literally 
> mean drop at any point in time

My English language parser failed this part, sorry. :)

Cheers, Phil
