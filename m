Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F9DC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 16:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0971F20872
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 16:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfJOQJR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:09:17 -0400
Received: from correo.us.es ([193.147.175.20]:57488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfJOQJR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 12:09:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43CECBA1BB
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 18:09:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 349B8B8014
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 18:09:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A5B8B8011; Tue, 15 Oct 2019 18:09:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14AA6B8004;
        Tue, 15 Oct 2019 18:09:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 18:09:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E7A9F42EE38F;
        Tue, 15 Oct 2019 18:09:10 +0200 (CEST)
Date:   Tue, 15 Oct 2019 18:09:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 3/6] set_elem: Validate nftnl_set_elem_set()
 parameters
Message-ID: <20191015160913.cgmyhosz64yu7kfr@salvia>
References: <20191015141658.11325-1-phil@nwl.cc>
 <20191015141658.11325-4-phil@nwl.cc>
 <20191015155244.int6uix23brc4iug@salvia>
 <20191015160255.GX12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015160255.GX12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 06:02:55PM +0200, Phil Sutter wrote:
> On Tue, Oct 15, 2019 at 05:52:44PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 15, 2019 at 04:16:55PM +0200, Phil Sutter wrote:
> [...]
> > > diff --git a/src/set_elem.c b/src/set_elem.c
> > > index 3794f12594079..4225a96ee5a0a 100644
> > > --- a/src/set_elem.c
> > > +++ b/src/set_elem.c
> > > @@ -96,10 +96,20 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
> > >  	s->flags &= ~(1 << attr);
> > >  }
> > >  
> > > +static uint32_t nftnl_set_elem_validate[NFTNL_SET_ELEM_MAX + 1] = {
> > > +	[NFTNL_SET_ELEM_FLAGS]		= sizeof(uint32_t),
> > > +	[NFTNL_SET_ELEM_VERDICT]	= sizeof(int), /* FIXME: data.verdict is int?! */
> > 
> > This is uint32_t, update this before pushing out this.
> 
> Oh, sorry. I missed this note to myself.
> 
> So, should we change union nftnl_data_reg accordingly then?

I'm seeing this is being used from nftables.git as...

        nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_VERDICT, ...
