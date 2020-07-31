Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AB5C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 11:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100C5208E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 11:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbgGaLZn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 07:25:43 -0400
Received: from correo.us.es ([193.147.175.20]:53112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732303AbgGaLZm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 07:25:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 366C74A7060
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 13:25:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23DD9DA78C
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 13:25:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 23119DA78B; Fri, 31 Jul 2020 13:25:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2128DA793;
        Fri, 31 Jul 2020 13:25:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 13:25:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C379F4265A2F;
        Fri, 31 Jul 2020 13:25:37 +0200 (CEST)
Date:   Fri, 31 Jul 2020 13:25:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Eliminate table list from cache
Message-ID: <20200731112537.GA10915@salvia>
References: <20200730135710.23076-1-phil@nwl.cc>
 <20200730192554.GA5322@salvia>
 <20200731112134.GA13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731112134.GA13697@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 01:21:34PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Jul 30, 2020 at 09:25:54PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jul 30, 2020 at 03:57:10PM +0200, Phil Sutter wrote:
> > > The full list of tables in kernel is not relevant, only those used by
> > > iptables-nft and for those, knowing if they exist or not is sufficient.
> > > For holding that information, the already existing 'table' array in
> > > nft_cache suits well.
> > > 
> > > Consequently, nft_table_find() merely checks if the new 'exists' boolean
> > > is true or not and nft_for_each_table() iterates over the builtin_table
> > > array in nft_handle, additionally checking the boolean in cache for
> > > whether to skip the entry or not.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  iptables/nft-cache.c | 73 +++++++++++---------------------------------
> > >  iptables/nft-cache.h |  9 ------
> > >  iptables/nft.c       | 55 +++++++++------------------------
> > >  iptables/nft.h       |  2 +-
> > >  4 files changed, 34 insertions(+), 105 deletions(-)
> > 
> > This diffstat looks interesting :-)
> 
> As promised, I wanted to leverage your change for further optimization,
> but ended up optimizing your code out along with the old one. :D
> 
> > One question:
> > 
> >         c->table[i].exists = true;
> > 
> > then we assume this table is still in the kernel and we don't recheck?
> 
> Upon each COMMIT line, nft_action() calls nft_release_cache(). This will
> also reset the 'exists' value to false.

Thanks for explaining.

I think the chain cache can also be converted to use linux list,
right?

> > I mean, if you pipe command to an open process running
> > iptables-restore (which has been the recommended interface for years
> > to avoid of the overhead of system() invocation and to ensure atomic
> > updates), is there any cache this new approach might get out of sync?
> 
> This is not just a problem of iptables-restore running in a pipe -
> restoring a large ruleset (or just pure coincidence) could lead to the
> same result.
> 
> Playing with 'iptables-nft-restore --noflush' reading from stdin and
> calling 'nft flush ruleset' in a second shell right before entering
> 'COMMIT' leads to funny errors. This is not related to the table list
> elimination though. I'll investigate.

There is a generation number that the userspace sends to the kernel to
validate that it's working with a stale cache to retry. This should
help catch the interference scenario to basically (transparently)
restart from scratch.
