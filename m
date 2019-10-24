Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B702CCA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 15:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922FC20684
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 15:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405186AbfJXP4m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:56:42 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58832 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391584AbfJXP4m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 11:56:42 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iNfTb-0004eV-E3; Thu, 24 Oct 2019 17:56:39 +0200
Date:   Thu, 24 Oct 2019 17:56:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] py: add missing output flags.
Message-ID: <20191024155639.GR26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20191022205855.22507-1-jeremy@azazel.net>
 <20191022205855.22507-3-jeremy@azazel.net>
 <20191023203833.aidczbpuxokywu6i@salvia>
 <20191024092052.GP26123@orbyte.nwl.cc>
 <20191024093505.pup5mktqrdbriwpz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024093505.pup5mktqrdbriwpz@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Oct 24, 2019 at 11:35:05AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 24, 2019 at 11:20:52AM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Wed, Oct 23, 2019 at 10:38:33PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 22, 2019 at 09:58:53PM +0100, Jeremy Sowden wrote:
> > > > `terse` and `numeric_time` are missing from the `output_flags` dict.
> > > > Add them and getters and setters for them.
> > > 
> > > LGTM.
> > > 
> > > @Phil, is this fine with you? I let you decide on this.
> > 
> > I just pushed it. Could you please update Patchwork? I'm not allowed to.
> > 
> > > BTW, would it make sense at some point to remove all the getter/setter
> > > per option and use the setter/getter flags approach as in libnftables?
> > 
> > Well, from a compat standpoint we can't remove them. The benefit of
> > those setter/getter methods is the clean interface (user's don't have to
> > memorize flag names) and the semantics of returning the old value. The
> > latter comes in handy when changing flags temporarily.
> 
> Probably some transitioning? ie. add the generic set/get flag
> interface. Update clients of this (Eric's code) to use. Leave the old
> interfaces for a while there to make sure people have time to migrate.
> Then remove them.

Sounds good!

> Anyway, I'm fine if you prefer this more verbose interface for python,
> no issue.

Main goal was to keep the bit-fiddling away from users, but a method
which accepts an array of flag names (or flag values) and does the
binary OR'ing should serve fine, too.

> > One could change the private __{g,s}et_output_flag() methods though and
> > make them similar to {g,s}et_debug() methods which probably resemble the
> > syntax you're looking for.
> 
> Hm, not sure what you mean.

I was referring to get_debug() and set_debug() methods of class
Nftables. The getter returns an array of debug flag names, the setter
accepts either a single flag name/value or an array of those.

Cheers, Phil
