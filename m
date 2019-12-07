Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E03C43603
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 18:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9971D24670
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 18:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfLGSjA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Dec 2019 13:39:00 -0500
Received: from correo.us.es ([193.147.175.20]:47568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfLGSi7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Dec 2019 13:38:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C61CB4A2B9D
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2019 19:38:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B212FDA70A
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2019 19:38:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7AD8DA703; Sat,  7 Dec 2019 19:38:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C08EDA705;
        Sat,  7 Dec 2019 19:38:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Dec 2019 19:38:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 791CE41E4800;
        Sat,  7 Dec 2019 19:38:54 +0100 (CET)
Date:   Sat, 7 Dec 2019 19:38:55 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: bogus lookup/get on
 consecutive elements in named sets
Message-ID: <20191207183855.wrmvz55zqom4zcwj@salvia>
References: <20191205180706.134232-1-pablo@netfilter.org>
 <20191205220408.GG14469@orbyte.nwl.cc>
 <20191206192647.h3htnpq3b4qmlphs@salvia>
 <20191206193938.7jceb5dvi2zwkm2g@salvia>
 <20191207110307.GK14469@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207110307.GK14469@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 07, 2019 at 12:03:07PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Dec 06, 2019 at 08:39:38PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Dec 06, 2019 at 08:26:47PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Dec 05, 2019 at 11:04:08PM +0100, Phil Sutter wrote:
> > > > Hi Pablo,
> > > > 
> > > > On Thu, Dec 05, 2019 at 07:07:06PM +0100, Pablo Neira Ayuso wrote:
> > > > > The existing rbtree implementation might store consecutive elements
> > > > > where the closing element and the opening element might overlap, eg.
> > > > > 
> > > > > 	[ a, a+1) [ a+1, a+2)
> > > > > 
> > > > > This patch removes the optimization for non-anonymous sets in the exact
> > > > > matching case, where it is assumed to stop searching in case that the
> > > > > closing element is found. Instead, invalidate candidate interval and
> > > > > keep looking further in the tree.
> > > > > 
> > > > > This patch fixes the lookup and get operations.
> > > > 
> > > > I didn't get what the actual problem is?
> > > 
> > > The lookup/get results false, while there is an element in the rbtree.
> > > Moreover, the get operation returns true as if a+2 would be in the
> > > tree. This happens with named sets after several set updates, I could
> > > reproduce the issue with several elements mixed with insertion and
> > > deletions in one batch.
> > 
> > To extend the problem description: The issue is that the existing
> > lookup optimization (that only works for the anonymous sets) might not
> > reach the opening [ a+1, ... element if the closing ... , a+1) is
> > found in first place when walking over the rbtree. Hence, walking the
> > full tree in that case is needed.
> 
> Ah! Thanks a lot for your elaborations. It was really hard to grasp what
> all this is about from the initial commit message. :)

I'll append this to the description before applying, no problem,
thanks for asking.

> Sometimes I wonder if we should do more set optimizations under the hood
> when adding elements. Right now, we don't touch existing ones although
> it would make sense. And we could be more intelligent for example if a
> set contains 20-30 and a user adds 25-35.

Yes, if 'automerge' is set on, then nft should start doing some more
intelligent stuff. Basically the idea is: check if this interval
overlaps with an existing one, if so transaction looks like this:

        [ delete 25-35 | add 20-35 ]

With the existing transaction infrastructure in place, I think it
should not be too hard. There's already a routine to check for
overlaps. If this is a data mapping, this needs to be careful to not
merge intervals that have different data on the right hand side.

There's another problem, I think incremental userspace cache is still
incomplete. I can probably scratch time and look into this, this might
not happen before 2020 though.

Thanks.
