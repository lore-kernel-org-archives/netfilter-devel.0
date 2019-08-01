Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DA3C19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4A09214DA
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfHAMar (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:30:47 -0400
Received: from correo.us.es ([193.147.175.20]:33140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfHAMar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 08:30:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6F268FB369
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2019 14:30:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FFFFFF6CC
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2019 14:30:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 55681A738; Thu,  1 Aug 2019 14:30:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63B3FD1929;
        Thu,  1 Aug 2019 14:30:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 01 Aug 2019 14:30:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 388DB4265A2F;
        Thu,  1 Aug 2019 14:30:43 +0200 (CEST)
Date:   Thu, 1 Aug 2019 14:30:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/5] xtables-monitor: Support ARP and bridge
 families
Message-ID: <20190801123040.rljiffbbux3bajls@salvia>
References: <20190731163915.22232-1-phil@nwl.cc>
 <20190731163915.22232-5-phil@nwl.cc>
 <20190801112050.nqig4dbncyx4gfdz@salvia>
 <20190801120048.GS14469@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801120048.GS14469@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 01, 2019 at 02:00:48PM +0200, Phil Sutter wrote:
> On Thu, Aug 01, 2019 at 01:20:50PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 31, 2019 at 06:39:14PM +0200, Phil Sutter wrote:
> >  @@ -565,6 +574,8 @@ static const struct option options[] = {
> > >  	{.name = "counters", .has_arg = false, .val = 'c'},
> > >  	{.name = "trace", .has_arg = false, .val = 't'},
> > >  	{.name = "event", .has_arg = false, .val = 'e'},
> > > +	{.name = "arp", .has_arg = false, .val = '0'},
> > > +	{.name = "bridge", .has_arg = false, .val = '1'},
> > 
> > Probably?
> > 
> > -A for arp.
> > -B for bridge.
> > 
> > so users don't have to remember? -4 and -6 are intuitive, I'd like
> > these are sort of intuitive too in its compact definition.
> > 
> > Apart from that, patchset looks good to me.
> 
> I had something like that (-a and -b should still be free), but then
> discovered that for rules there was '-0' prefix in use when printing arp
> family rules. Should I change these prefixes also or leave them as -0
> and -1? I guess most importantly they must not clash with real
> parameters.

You can just leave them as is if this is the way this is exposed in
rules. Not sure what the logic behing -0 and -1 is, this is not
mapping to NFPROTO_* definitions, so it looks like something it's been
pulled out of someone's hat :-)

I think users will end up using --arp and --bridge for this. I myself
will not remember this -0 and -1 thing.

Feel free to explore any possibility, probably leaving the existing -0
and -1 in place if you're afraid of breaking anything, add aliases and
only document the more intuitive one. If you think this is worth
exploring, of course.

Thanks!
