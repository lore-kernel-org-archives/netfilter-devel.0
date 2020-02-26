Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFE2C4BA0E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 12:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6837B24684
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 12:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBZMLB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 07:11:01 -0500
Received: from correo.us.es ([193.147.175.20]:59880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgBZMLB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 07:11:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB600D2DA1A
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 13:10:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFBEFDA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 13:10:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A537DFC53D; Wed, 26 Feb 2020 13:10:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9D14DA72F;
        Wed, 26 Feb 2020 13:10:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 13:10:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ACA6F42EF42C;
        Wed, 26 Feb 2020 13:10:49 +0100 (CET)
Date:   Wed, 26 Feb 2020 13:10:56 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200226121056.p323ce6wzrn77mby@salvia>
References: <20200225153435.17319874@redhat.com>
 <20200225202143.tqsfhggvklvhnsvs@salvia>
 <20200225213815.3c0a1caa@redhat.com>
 <20200225205847.s5pjjp652unj6u7v@salvia>
 <20200226115924.461f2029@redhat.com>
 <20200226111056.5fultu3onan2vttd@salvia>
 <20200226121924.4194f31d@redhat.com>
 <20200226113443.vudkkqzxj5qussqz@salvia>
 <20200226123926.3c5b1831@redhat.com>
 <20200226125407.6f5bfa5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226125407.6f5bfa5e@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 26, 2020 at 12:54:07PM +0100, Stefano Brivio wrote:
> On Wed, 26 Feb 2020 12:39:26 +0100
> Stefano Brivio <sbrivio@redhat.com> wrote:
> 
> > On Wed, 26 Feb 2020 12:34:43 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > > I mean, to catch elements that represents subsets/supersets of another
> > > element (like in this example above), pipapo would need to make a
> > > lookup for already matching rules for this new element?  
> > 
> > Right, and that's what those two pipapo_get() calls in
> > nft_pipapo_insert() do.
> 
> Specifically, on re-reading your question: those find sets including
> the subset that we would be about to insert, and forbid the insertion.
> 
> But, given an already existing proper subset with none of the bounds
> overlapping ("more specific entry", by any measure), they won't return
> it, so insertion can proceed.

Thanks for explaining.

I see, the bounds are not found by pipapo_get(), they are not included
in the existing (subset) element range. We would need to tests for all
the existing (inner) elements in the range to catch for subsets.
