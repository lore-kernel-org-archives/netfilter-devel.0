Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25047CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0558A21D7C
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633172AbfJRKDp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:03:45 -0400
Received: from correo.us.es ([193.147.175.20]:35880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389081AbfJRKDp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 06:03:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 379001C4424
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2019 12:03:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 253C94C3BF
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2019 12:03:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1AB9CDA72F; Fri, 18 Oct 2019 12:03:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09BFCB7FF9;
        Fri, 18 Oct 2019 12:03:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Oct 2019 12:03:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DD68742EF4E4;
        Fri, 18 Oct 2019 12:03:38 +0200 (CEST)
Date:   Fri, 18 Oct 2019 12:03:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/8] xtables-restore: Introduce rule counter
 tokenizer function
Message-ID: <20191018100341.waqo6prlji26ydhs@salvia>
References: <20191017224836.8261-1-phil@nwl.cc>
 <20191017224836.8261-4-phil@nwl.cc>
 <20191018081124.obynzh3xbpo5k4gf@salvia>
 <20191018095054.GC26123@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018095054.GC26123@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 18, 2019 at 11:50:54AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Oct 18, 2019 at 10:11:24AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 18, 2019 at 12:48:31AM +0200, Phil Sutter wrote:
> > > The same piece of code appears three times, introduce a function to take
> > > care of tokenizing and error reporting.
> > > 
> > > Pass buffer pointer via reference so it can be updated to point to after
> > > the counters (if found).
> > > 
> > > While being at it, drop pointless casting when passing pcnt/bcnt to
> > > add_argv().
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > If you get to consolidate more common code between xml and native
> > parsers, probably you can add a xtables-restore.c file to store all
> > these functions are common, just an idea for the future.
> 
> I get the point, but we have xtables-restore.c already. Though it
> contains *tables-nft-restore code. I would add to xshared.c until we
> decide it's large enough to split (currently ~750 lines). AFAICT, this
> is the only source file included in both xtables-*-multi binaries. Other
> than that, I could extend libxtables to really share code but it's
> probably not worth it.

OK. No libxtables for this, I'd suggest. This is a library and we
would need to deal with libversion if you expose this API, xshared.c
is fine, I was just wondering if splitting it to encapsulate all
shared parsing code in another file could be useful at some point.
