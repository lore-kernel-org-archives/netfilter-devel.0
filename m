Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B67EC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11CF207FC
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389220AbfISOzy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:55:54 -0400
Received: from correo.us.es ([193.147.175.20]:41024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388551AbfISOzy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 10:55:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 250B5DA710
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 16:55:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15255A594
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 16:55:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0AB99DA72F; Thu, 19 Sep 2019 16:55:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2342DA72F;
        Thu, 19 Sep 2019 16:55:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 16:55:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 507864265A5A;
        Thu, 19 Sep 2019 16:55:47 +0200 (CEST)
Date:   Thu, 19 Sep 2019 16:55:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919145546.la5gzhjh6yyt5eck@salvia>
References: <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
 <20190919115636.GQ6961@breakpoint.cc>
 <20190919132828.nydpzdt3qqupgtg5@salvia>
 <20190919140144.GS6961@breakpoint.cc>
 <20190919142258.oxv2kzdbl7vj5sqk@salvia>
 <20190919143431.GT6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919143431.GT6961@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 04:34:31PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Sep 19, 2019 at 04:01:44PM +0200, Florian Westphal wrote:
> > > Do you mean NFT_SET_EVAL?
> > 
> > No, I mean there is no NFT_SET_EXT_EXPR handling yet, sorry I forgot
> > the _EXT_ infix.
> > 
> > nft_lookup should invoke the expression that is attached. Control
> > plane code is also missing, there is no way to create the
> > NFT_SET_EXT_EXPR from newsetelem() in nf_tables_api.c.
> 
> Hmm, no, I don't think it should.
> Otherwise lookups on a set that has counters added to it will
> increment the counter values.

ipset can attach counter to elements, so matching lookups bump the
element counter. I think users might want for this in the future, just
to keep this usecase in the radar.

> I think we should leave all munging to nft_dynset.c, i.e. add/update
> in terms of nft frontend set syntax.
> 
> > If NFT_SET_EVAL is set or not from nft_lookup is completely
> > irrelevant, nft_lookup should not care about this flag.
> 
> Right, I will try to reflect that in the commit message.

Thanks.
