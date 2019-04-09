Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FB9C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 23:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9897F2133D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 23:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfDIXTb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 19:19:31 -0400
Received: from mail.us.es ([193.147.175.20]:48254 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfDIXTb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 19:19:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 205E012082E
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2019 01:19:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 160CFDA70F
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2019 01:19:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0B783DA70C; Wed, 10 Apr 2019 01:19:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2AD2DA703;
        Wed, 10 Apr 2019 01:19:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 10 Apr 2019 01:19:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CEB5D4265A31;
        Wed, 10 Apr 2019 01:19:25 +0200 (CEST)
Date:   Wed, 10 Apr 2019 01:19:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        arturo@netfilter.org
Subject: Re: [PATCH nft] evaluate: disallow anonymous set with empty elements
Message-ID: <20190409231925.uancubapdemhdpqn@salvia>
References: <20190409105936.23422-1-pablo@netfilter.org>
 <20190409135925.GQ4851@orbyte.nwl.cc>
 <20190409140326.zme4ik6ozqbnf544@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409140326.zme4ik6ozqbnf544@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 04:03:26PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Could we maybe find a middle ground where nft still does these
> > optimizations but prints warnings so users are notified? We might even
> > introduce -W flag to customize behaviour (-W all (default), -W error
> > (strict mode), -W none (suppress any non-fatal output on stderr)).
> 
> I like this proposal.
> 
> One of the broken tproxy test cases (it prints warning) does this:
> 
> ip daddr 0.0.0.0/0

Yes, sorry, that's my fault.

> .. and that is always true and could be removed.
> Different "problem" of course, but it shows that there is ample
> opportunity for pruning irrelevant expressions.
> 
> And breaking scripts every time we decide that something is
> "silly" is a bad decision, imo.

Agreed, this case is slightly bit corner case as they should _not_ be
doing enclosing single element in brackets in their scripts. But I get
your point, better adopt a more conservative approach ;-)

> I suspect users will complain about { 1.2.3.4 } being illegal
> "just because".

I'll explore the warning idea, it can be an initial step before we can
fully disallow this, so users don't complain about sudden breakage :-)

Thanks for your feedback!
