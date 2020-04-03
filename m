Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EF4C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 12:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDE5C20659
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 12:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390866AbgDCMue (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:50:34 -0400
Received: from correo.us.es ([193.147.175.20]:41806 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgDCMue (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 08:50:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 798A6F23B0
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2020 14:50:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 698CCFA4F4
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2020 14:50:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5F05FD2B1F; Fri,  3 Apr 2020 14:50:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E85DDA7B2;
        Fri,  3 Apr 2020 14:50:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 Apr 2020 14:50:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E44AF42EF42B;
        Fri,  3 Apr 2020 14:50:29 +0200 (CEST)
Date:   Fri, 3 Apr 2020 14:50:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH] segtree: bail out on concatenations
Message-ID: <20200403125029.pb2emvu24aspprw5@salvia>
References: <20200402214941.60097-1-pablo@netfilter.org>
 <20200403120351.cxhcdcwfpylven4k@salvia>
 <20200403142705.59f2e7d7@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403142705.59f2e7d7@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 03, 2020 at 02:27:05PM +0200, Stefano Brivio wrote:
> On Fri, 3 Apr 2020 14:03:51 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Thu, Apr 02, 2020 at 11:49:41PM +0200, Pablo Neira Ayuso wrote:
> > > This patch adds a lazy check to validate that the first element is not a
> > > concatenation. The segtree code does not support for concatenations,
> > > bail out with EOPNOTSUPP.
> > >
> > >  # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> > >  Error: Could not process rule: Operation not supported
> > >  add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> > >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >
> > > Otherwise, the segtree code barfs with:
> > >
> > >  BUG: invalid range expression type concat  
> > 
> > Hm.
> > 
> > I'm afraid this patch is not enough, the following ruleset crashes
> > in old kernels with recent nft:
> > 
> > flush ruleset
> > 
> > table inet filter {
> >         set test {
> >                 type ipv4_addr . ipv4_addr . inet_service
> >                 flags interval,timeout
> >                 elements = { 1.1.1.1 . 2.2.2.2 . 30 ,
> >                              2.2.2.2 . 3.3.3.3 . 40 ,
> >                              3.3.3.3 . 4.4.4.4 . 50 }
> >         }
> > 
> >         chain output {
> >                 type filter hook output priority 0; policy accept;
> >                 ip saddr . ip daddr . tcp dport @test counter
> >         }
> > }
> 
> First off, sorry, it didn't occur to me to run new tests on older
> kernels. :/
> 
> I can't quickly run that on some older kernel right now. For my
> understanding, where is it crashing?

When listing via

        nft list ruleset

The segtree does not know how to handle this concatenation.

The only way I found to prevent this error is to bail out when adding
the set, ie. old kernel checks that NFT_SET_CONCAT is not supported,
hence it bails out.

I'm going to prepare patches to submit this to nf.git.
