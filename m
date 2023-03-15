Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1578BC61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 12:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCOMHj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCOMHj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 08:07:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48C012B291
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 05:06:35 -0700 (PDT)
Date:   Wed, 15 Mar 2023 13:06:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netfilter-devel@vger.kernel.org, abdelrahmanhesham94@gmail.com,
        ja@ssi.bg
Subject: Re: [PATCH v4] netfilter: nf_flow_table: count offloaded flows
Message-ID: <ZBG0qQV7uvj26ReX@salvia>
References: <20230228101413.tcmse45valxojb2u@SvensMacbookPro.hq.voleatech.com>
 <ZBGugrmYyUeyTLqr@salvia>
 <20230315114533.p5nrnjimlg2jktpe@SvensMacbookPro.hq.voleatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230315114533.p5nrnjimlg2jktpe@SvensMacbookPro.hq.voleatech.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 15, 2023 at 12:45:33PM +0100, Sven Auhagen wrote:
> On Wed, Mar 15, 2023 at 12:39:46PM +0100, Pablo Neira Ayuso wrote:
> > Hi Sven,
> 
> Hi Pablo,
> 
> > 
> > On Tue, Feb 28, 2023 at 11:14:13AM +0100, Sven Auhagen wrote:
> > > Add a counter per namespace so we know the total offloaded
> > > flows.
> > 
> > Thanks for your patch.
> > 
> > I would like to avoid this atomic operation in the packet path, it
> > should be possible to rewrite this with percpu counters.
> > 
> 
> Isn't it possible though that a flow is added and then removed
> on two different CPUs and I might end up with negative counters
> on one CPU?

I mean, keep per cpu counters for addition and deletions. Then, when
dumping you could collected them and provide the number.

We used to have these stats for conntrack in:

/proc/net/stat/nf_conntrack

but they were removed, see 'insert' and 'delete', they never get
updated anymore. conntrack is using atomic for this: cnet->count, but
it is required for the upper cap (maximum number of entries).

> > But, you can achieve the same effect with:
> > 
> >   conntrack -L | grep OFFLOAD | wc -l
> > 
> 
> Yes, we are doing that right now but when we have like
> 10 Mio. conntrack entries this ends up beeing a very long
> and expensive operation to get the number of offloaded
> flows. It would be really beneficial to know it without
> going through all conntrack entries.
> 
> > ?

Yes, with such a large number of entries, conntrack -L is not
convenient.
