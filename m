Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DB9CA9EA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 08:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68729222BD
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 08:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632907AbfJRIew (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:34:52 -0400
Received: from correo.us.es ([193.147.175.20]:58790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387458AbfJRIev (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 04:34:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82B8DE2C69
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2019 10:34:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D7C5B7FF9
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2019 10:34:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71481B7FF6; Fri, 18 Oct 2019 10:34:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B773A7EFD;
        Fri, 18 Oct 2019 10:34:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Oct 2019 10:34:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6784742EF4E0;
        Fri, 18 Oct 2019 10:34:44 +0200 (CEST)
Date:   Fri, 18 Oct 2019 10:34:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v4 0/8] Improve iptables-nft performance with
 large rulesets
Message-ID: <20191018083446.6jfpunw7coscnui6@salvia>
References: <20191015114152.25254-1-phil@nwl.cc>
 <20191017090332.erwubv7pzxbbowjg@salvia>
 <20191017100816.plzn3tugcu2j2rpl@salvia>
 <20191017170628.GN12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017170628.GN12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 07:06:28PM +0200, Phil Sutter wrote:
> On Thu, Oct 17, 2019 at 12:08:16PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 17, 2019 at 11:03:32AM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 15, 2019 at 01:41:44PM +0200, Phil Sutter wrote:
> > > > Fourth try at caching optimizations implementation.
> > > > 
> > > > Changes since v3:
> > > > 
> > > > * Rebase onto current master after pushing the accepted initial three
> > > >   patches.
> > > > * Avoid cache inconsistency in __nft_build_cache() if kernel ruleset
> > > >   changed since last call.
> > > 
> > > I still hesitate with this cache approach.
> > > 
> > > Can this deal with this scenario? Say you have a ruleset composed on N
> > > rules.
> > > 
> > > * Rule 1..M starts using generation X for the evaluation, they pass
> > >   OK.
> > > 
> > > * Generation is bumped.
> > > 
> > > * Rule M..N is evaluated with a diferent cache.
> > > 
> > > So the ruleset evaluation is inconsistent itself since it is based on
> > > different caches for each rule in the batch.
> > 
> > It might be that rule M fails because a user-defined chain is not
> > found anymore, error reporting will not be consistent on races, and
> > who knows what else.
> > 
> > Anyway, if you want to go for this approach, merge it upstream and
> > let's test how it goes... this batch looks much better indeed than v1,
> > so push it out.
> 
> Yes, let's please give it a try. Fingers crossed, but if it blows up
> I'll either fix it or revert it myself. :)

Thanks Phil, let's do that!
