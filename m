Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B26C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 21:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 056F92071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 21:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfKYVLE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 16:11:04 -0500
Received: from correo.us.es ([193.147.175.20]:41160 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfKYVLE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 16:11:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2FB4DA854
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 22:11:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C34F2DA8E8
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 22:11:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B8EACDA7B6; Mon, 25 Nov 2019 22:11:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57923B7FFE;
        Mon, 25 Nov 2019 22:10:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Nov 2019 22:10:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 318A641E4800;
        Mon, 25 Nov 2019 22:10:58 +0100 (CET)
Date:   Mon, 25 Nov 2019 22:10:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] src: Comment-out code not needed
 since Linux 3.8 in examples/nf-queue.c
Message-ID: <20191125211059.b2k7e52cgllyk53x@salvia>
References: <20191123051657.18308-1-duncan_roe@optusnet.com.au>
 <20191123051657.18308-2-duncan_roe@optusnet.com.au>
 <20191124144547.GB21689@breakpoint.cc>
 <20191124235240.GA19638@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124235240.GA19638@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 25, 2019 at 10:52:40AM +1100, Duncan Roe wrote:
> Hi Floerian,
> 
> On Sun, Nov 24, 2019 at 03:45:47PM +0100, Florian Westphal wrote:
> > Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > > This makes it clear which lines are no longer required.
> > > It also obviates the need to document NFQNL_CFG_CMD_PF_(UN)BIND.
> >
> > Why not simply #if 0 this code?
> 
> Simple reason: I think it's important to have an indicator on each commented-out
> line that it is,in fact, commented-out.
> >
> > Or just delete it, v3.8 was released almost 7 years ago.
> 
> I could do that. But, I'm uneasy about it. There are systems around with very
> old Linuxes - in May last year there was that Tomato Firmware non-issue and the
> embedded environment was at 2.6!
> 
> Your call (or Pablo's) - I'm happy either way.

I think it's fine to remove it.

There will be a commit message describing this is only required by
very old kernel, which should be good enough for people with exotic
environments to catch up I would expect.

Thanks.
