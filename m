Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61360C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 19:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31E2122DA7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 19:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbfHTT1i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 15:27:38 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTT1h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 15:27:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i09n5-0007GE-90; Tue, 20 Aug 2019 21:27:35 +0200
Date:   Tue, 20 Aug 2019 21:27:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jones Desougi <jones.desougi+netfilter@gmail.com>
Cc:     Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] netfilter: nft_meta: support for time matching
Message-ID: <20190820192735.GW2588@breakpoint.cc>
References: <20190817111753.8756-1-a@juaristi.eus>
 <20190817111753.8756-2-a@juaristi.eus>
 <CAGdUbJFMCT9aXqPKVEVF-vvLzser+58R62mSZRZLRfaR5eJpSQ@mail.gmail.com>
 <18f3faaf-97f8-ef8c-b049-3a461c1c524c@juaristi.eus>
 <CAGdUbJE_ZF3Sa6WMfo_j9JRME9mZteKsGgws31c0i+ASPza=8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdUbJE_ZF3Sa6WMfo_j9JRME9mZteKsGgws31c0i+ASPza=8Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jones Desougi <jones.desougi+netfilter@gmail.com> wrote:
> On Sun, Aug 18, 2019 at 8:22 PM Ander Juaristi <a@juaristi.eus> wrote:
> >
> > On 17/8/19 15:43, Jones Desougi wrote:
> > >> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > >> index 82abaa183fc3..b83b62eb4b01 100644
> > >> --- a/include/uapi/linux/netfilter/nf_tables.h
> > >> +++ b/include/uapi/linux/netfilter/nf_tables.h
> > >> @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
> > >>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> > >>   * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
> > >>   * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> > >> + * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
> > >> + * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
> > >
> > > This would be clearer as NFT_META_TIME_WEEKDAY. Just day can mean a
> > > lot of things.
> > > Matches nicely with the added nft_meta_weekday function too.
> >
> > I agree with you here. Seems to me WEEKDAY is clearer.
> >
> > >
> > >> + * @NFT_META_TIME_HOUR: hour of day (in seconds)
> > >
> > > This isn't really an hour, so why call it that (confuses unit at least)?
> > > Something like NFT_META_TIME_TIMEOFDAY? Alternatively TIMEINDAY.
> > > Presumably the added nft_meta_hour function also derives its name from
> > > this, but otherwise has nothing to do with hours.
> > >
> >
> > But not so sure on this one. TIMEOFDAY sounds to me equivalent to HOUR,
> > though less explicit (more ambiguous).
> 
> HOUR is a unit, much like NS, but its use is quite different with no
> clear hint as to how. Unlike the latter it's also not the unit of the
> value. From that perspective the name comes up empty of meaning. If
> you already know what it means, the name can be put in context, but
> that's not explicit at all.

If the NFT_META_TIME_* names are off, then those for the
frontend are too.

I think
meta time <iso-date>
meta hour <relative to this day>
meta day <weekday>

are fine, and thus so are the uapi enums.

Examples:

meta time < "2019-06-06 17:20:20" drop
meta hour 11:00-17:00 accept
meta day "Sat" drop

What would you suggest as alternatives?
