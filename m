Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83A8C48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACA3F20659
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfFZKrp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:47:45 -0400
Received: from mail.us.es ([193.147.175.20]:35700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfFZKrp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:47:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71D8B80D01
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 12:47:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E7C4202D2
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 12:47:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52786DA4D1; Wed, 26 Jun 2019 12:47:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CA9510219C;
        Wed, 26 Jun 2019 12:47:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 12:47:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2B1FD4265A32;
        Wed, 26 Jun 2019 12:47:41 +0200 (CEST)
Date:   Wed, 26 Jun 2019 12:47:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: Use of oifname in input chains
Message-ID: <20190626104740.vw7xzrkoqd2lwzqh@salvia>
References: <20190625122954.GC9218@orbyte.nwl.cc>
 <20190625194321.e2siqh7jfhldwzgw@salvia>
 <20190626103230.b7eqh2i3ibpkfv52@breakpoint.cc>
 <20190626103746.ag26jczoq7ggkh5b@salvia>
 <20190626104254.cfhkfpagequp6kuv@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626104254.cfhkfpagequp6kuv@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 26, 2019 at 12:42:54PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > new chain C
> > > meta oifname bla added to C
> > > jump added from output to C
> > > jump added from input to C   # should this fail? why?
> > > 
> > > new chain C
> > > jump added from input to C
> > > meta oifname added to C	     # same q: why should this fail?
> > 
> > There's tracking infrastructure for this already in place, right? It's
> > just a matter to check for this from nft_meta_get_validate().
> 
> But what semantics would you add?
> It seems it would 100% break existing rulesets.
> 
> new chain C
> jump added from ouput to C
> meta oifname added to C	   	# allowed? jump from output exists
> jump added from input to C	# disallow this? Why?

To me, it makes no sense to use oifname from the input chain
indirectly, even if this is being used from the C chain.

> ..
> delete jump from output		# disallow?
> 
> This seems rather suicidal to me.

OK, you think there may be people using oifname from the C chain, but
how so? To skip rules that are specific to the output path?

Anyway, I'm fine with leaving things as is, I don't need this. Just in
case you pass by here in the future, the tracking infrastructure
should allow for this.
