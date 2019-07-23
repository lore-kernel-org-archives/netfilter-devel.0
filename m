Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF897C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE53121738
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfGWNwv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 09:52:51 -0400
Received: from mail.us.es ([193.147.175.20]:41484 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfGWNwv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 09:52:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C43A69653
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 15:52:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E58A1474
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 15:52:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DB1EADA708; Tue, 23 Jul 2019 15:52:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D61EDA708;
        Tue, 23 Jul 2019 15:52:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 15:52:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4774440705C4;
        Tue, 23 Jul 2019 15:52:46 +0200 (CEST)
Date:   Tue, 23 Jul 2019 15:52:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] src: evaluate: return immediately if no op was
 requested
Message-ID: <20190723135244.x77dihvyf4nplbku@salvia>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-4-fw@strlen.de>
 <20190721184901.n5ea7kpn246bddnb@salvia>
 <20190721185040.5ueush32pe7zta2k@breakpoint.cc>
 <20190722212556.gnxhgqlnrqt2epgg@salvia>
 <20190723131142.GN22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723131142.GN22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 03:11:42PM +0200, Phil Sutter wrote:
> On Mon, Jul 22, 2019 at 11:25:56PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Jul 21, 2019 at 08:50:40PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Sun, Jul 21, 2019 at 02:14:07AM +0200, Florian Westphal wrote:
> > > > > This makes nft behave like 0.9.0 -- the ruleset
> > > > > 
> > > > > flush ruleset
> > > > > table inet filter {
> > > > > }
> > > > > table inet filter {
> > > > >       chain test {
> > > > >         counter
> > > > >     }
> > > > > }
> > > > > 
> > > > > loads again without generating an error message.
> > > > > I've added a test case for this, without this it will create an error,
> > > > > and with a checkout of the 'fixes' tag we get crash.
> > > > > 
> > > > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351
> > > > > Fixes: e5382c0d08e3c ("src: Support intra-transaction rule references")
> > > > 
> > > > This one is causing the cache corruption, right?
> > > 
> > > There is no cache corruption.  This patch makes us enter a code
> > > path that we did not take before.
> > 
> > Sorry, I mean, this is a cache bug :-)
> > 
> > cache_flush() is cheating, it sets flags to CACHE_FULL, hence this
> > enters this codepath we dit not take before. This propagates from the
> > previous logic, as a workaround.
> > 
> > I made this patch, to skip the cache in case "flush ruleset" is
> > requested.
> > 
> > This breaks testcases/transactions/0024rule_0, which is a recent test
> > from Phil to check for intra-transaction references, I don't know yet
> > what makes this code unhappy with my changes.
> > 
> > Phil, would you help me have a look at what assumption breaks? Thanks.
> 
> Sorry, I don't get it. What is happening in the first place? Florian
> writes, a lookup happens in the wrong table and it seems
> chain_evaluate() doesn't add the chain to cache. Yet I don't understand
> why given patch fixes the problem.

Just sent a patch for this.
