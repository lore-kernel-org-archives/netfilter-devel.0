Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49904C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27AAA2245B
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfKSWU0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:20:26 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37208 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfKSWUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 17:20:25 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXBrD-0007LH-KP; Tue, 19 Nov 2019 23:20:23 +0100
Date:   Tue, 19 Nov 2019 23:20:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/py: Set a fixed timezone in nft-test.py
Message-ID: <20191119222023.GH8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
References: <20191116213218.14698-1-phil@nwl.cc>
 <20191118183459.qkqztuc5pn4fezzn@salvia>
 <db71e3276085bccce877215254bbfc21@juaristi.eus>
 <20191119221236.jfedafspmixjnivw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191119221236.jfedafspmixjnivw@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 19, 2019 at 11:12:36PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 19, 2019 at 12:06:23PM +0100, Ander Juaristi wrote:
> > El 2019-11-18 19:34, Pablo Neira Ayuso escribió:
> > > Hi Phil,
> > > 
> > > On Sat, Nov 16, 2019 at 10:32:18PM +0100, Phil Sutter wrote:
> > > > Payload generated for 'meta time' matches depends on host's timezone
> > > > and
> > > > DST setting. To produce constant output, set a fixed timezone in
> > > > nft-test.py. Choose UTC-2 since most payloads are correct then, adjust
> > > > the remaining two tests.
> > > 
> > > This means that the ruleset listing for the user changes when daylight
> > > saving occurs, right? Just like it happened to our tests.
> > 
> > It shouldn't, as the date is converted to a timestamp that doesn't take DST
> > into account (using timegm(3), which is Linux-specific).
> > 
> > The problem is that payloads are hard-coded in the tests.
> > 
> > Correct me if I'm missing something.
> 
> I see, so it's just the _snprintf() function in the library. I
> remember we found another problem with these on big endian, it would
> be probably to move them to libnftables at some point.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Ah, now that I reread your question, I finally got it. And you're right:
If DST occurs, time values will change. This is clear from looking at
hour_type_print(): Whatever the kernel returned gets cur_tm->tm_gmtoff
added to it. Here, this is either 3600 or 7200 depending on whether DST
is active or not.

The other alternative would be to make kernel DST-aware, I don't think
that's the case.

Cheers, Phil
