Return-Path: <SRS0=ZKiM=DX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF54C433E7
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 15:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE27207C4
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 15:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395483AbgJPP24 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Oct 2020 11:28:56 -0400
Received: from correo.us.es ([193.147.175.20]:51156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395234AbgJPP2z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Oct 2020 11:28:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB0F7DA388
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 17:28:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC8FFDA791
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 17:28:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1DA4DA78D; Fri, 16 Oct 2020 17:28:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B851DA704;
        Fri, 16 Oct 2020 17:28:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 16 Oct 2020 17:28:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6F7AA42EE38E;
        Fri, 16 Oct 2020 17:28:50 +0200 (CEST)
Date:   Fri, 16 Oct 2020 17:28:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore
 calls
Message-ID: <20201016152850.GA1416@salvia>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-4-phil@nwl.cc>
 <20201012125450.GA26934@salvia>
 <20201013100803.GW13016@orbyte.nwl.cc>
 <20201013101502.GA29142@salvia>
 <20201014094640.GA13016@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201014094640.GA13016@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 14, 2020 at 11:46:40AM +0200, Phil Sutter wrote:
> On Tue, Oct 13, 2020 at 12:15:02PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 13, 2020 at 12:08:03PM +0200, Phil Sutter wrote:
> > [...]
> > > On Mon, Oct 12, 2020 at 02:54:50PM +0200, Pablo Neira Ayuso wrote:
> > > [...]
> > > > Patch LGTM, thanks Phil.
> > > > 
> > > > What I don't clearly see yet is what scenario is triggering the bug in
> > > > the existing code, if you don't mind to explain.
> > > 
> > > See the test case attached to the patch: An other iptables-restore
> > > process may add references (i.e., jumps) to a chain the own
> > > iptables-restore process wants to delete. This should not be a problem
> > > because these references are added to a chain that is being flushed by
> > > the own process as well. But if that chain doesn't exist while the own
> > > process fetches kernel's ruleset, this flush job is not created.
> > 
> > Let me rephrase this:
> > 
> > 1) process A fetches the ruleset, finds no chain C (no flush job then)
> > 2) process B adds new chain C, flush job is present
> > 3) process B adds the ruleset
> > 4) process A appends rules to the existing chain C (because there is
> >    no flush job)
> > 
> > Is this the scenario? If so, I wonder why the generation ID is not
> > helping to refresh and retry.
> 
> Not quite, let me try to put this more clearly:
> 
> * Dump A:
>   | *filter
>   | :FOO - [0:0] # flush chain FOO
>   | -X BAR       # remove chain BAR
>   | COMMIT
> 
> * Dump B:
>   | *filter
>   | -A FOO -j BAR # reference BAR from a rule in FOO
>   | COMMIT
> 
> * Kernel ruleset:
>   | *filter
>   | :BAR - [0:0]
>   | COMMIT
> 
> * Process A:
>   * read dump A
>   * fetch cache
> 
> * Process B:
>   * read dump B
>   * fetch ruleset
>   * commit to kernel
> 
> * Process A:
>   * skip flush chain FOO job: not present
>   * add delete chain BAR job: chain exists
>   * commit fails (genid outdated)
>   * refresh transaction:
>     * delete chain BAR job remains active
>     * genid updated
>   * commit fails: can't remove chain BAR: EBUSY

Makes sense. Thanks a lot for explaining. Probably you can include
this in the commit description for the record.

> I realize the test case is not quite effective, ruleset should be
> emptied upon each iteration of concurrent restore job startup.

Please, update the test and revamp.
