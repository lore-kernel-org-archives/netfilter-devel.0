Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE32CC41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 09:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 515F5206A1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 09:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJFJl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:41:26 -0400
Received: from correo.us.es ([193.147.175.20]:36620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgJFJlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 05:41:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FCFEBA1A9
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 11:41:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D9B1DA796
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 11:41:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1BC19DA789; Tue,  6 Oct 2020 11:41:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3E9CDA78D;
        Tue,  6 Oct 2020 11:41:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Oct 2020 11:41:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C5BC541E4801;
        Tue,  6 Oct 2020 11:41:21 +0200 (CEST)
Date:   Tue, 6 Oct 2020 11:41:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Optimize class-based IP prefix matches
Message-ID: <20201006094121.GA17201@salvia>
References: <20201002090334.29788-1-phil@nwl.cc>
 <20201006085621.GA16275@salvia>
 <20201006093744.GL29050@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201006093744.GL29050@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 06, 2020 at 11:37:44AM +0200, Phil Sutter wrote:
> On Tue, Oct 06, 2020 at 10:56:21AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 02, 2020 at 11:03:34AM +0200, Phil Sutter wrote:
> > > Payload expression works on byte-boundaries, leverage this with suitable
> > > prefix lengths.
> > 
> > Interesing. But it kicks in the raw payload expression in nftables.
> > 
> > # nft list ruleset
> > table ip filter {
> >         chain INPUT {
> >                 type filter hook input priority filter; policy accept;
> >                 @nh,96,24 8323072 counter packets 0 bytes 0
> >         }
> > 
> > Would you send a patch for nftables too? There is already approximate
> > offset matching in the tree, it should not be too hard to amend.
> 
> I had a quick look but it didn't seem trivial to me. It is in
> payload_expr_complete() where a template lookup happens based on
> expression offset and length which fails due to the unexpected length.
> Is this the right place to adjust or am I wrong?
> 
> Strictly speaking, this is just a lack of feature in nftables and
> nothing breaks due to it. Do you still want to block the iptables change
> for it?

Not block. Just get things aligned. This is a bit of a step back in
the integration between iptables-nft and nft IMO.

I will have a look.
