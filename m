Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45686C43603
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 15:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22268206E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 15:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfLPPCE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 10:02:04 -0500
Received: from correo.us.es ([193.147.175.20]:45078 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbfLPPCD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 10:02:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD7A1E8E96
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 16:01:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDA13DA70C
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 16:01:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2A1DDA709; Mon, 16 Dec 2019 16:01:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96635DA707;
        Mon, 16 Dec 2019 16:01:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 16:01:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 78E704265A5A;
        Mon, 16 Dec 2019 16:01:57 +0100 (CET)
Date:   Mon, 16 Dec 2019 16:01:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] typeof incremental enhancements
Message-ID: <20191216150158.clh27hvid7pi7ldg@salvia>
References: <20191216124222.356618-1-pablo@netfilter.org>
 <20191216124749.GR795@breakpoint.cc>
 <20191216130034.256a44juaeey7umf@salvia>
 <20191216140336.GS795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216140336.GS795@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 16, 2019 at 03:03:36PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The listing path should be easier, since it's just parsing the TLVs
> > instead of invoking the nft parsing and evaluation phases.
> > 
> > > If you think its the way to go, then ok, I can rework it but
> > > I will be unable to add the extra steps for other expression types
> > > for some time I fear.
> > 
> > If you send a v3 including this work, I'll finishing the remaining
> > expressions.
> 
> Ok, will respin.

Thanks!

> > One more thing regarding your patchset is:
> > 
> >         integer,128
> > 
> > If the typeof works for all of the existing selectors, then I think
> > there is not need to expose this raw type, right?
> 
> How would you handle the 'udate missing' case?
>
> If its not a problem to display a non-restoreable ruleset
> (e.g. unspecific 'type integer' shown as set keys) in that case
> then the interger,width part can be omitted indeed.
> 
> Let me know.  For concatenations, we will be unable to show
> a proper ruleset without the udata info anyway (concatentations
> do not work at the moment for non-specific types anyway though).

Indeed, what scenario are you considering that set udata might be
missing?

We could still print it in such a case, even if we cannot parse it if
you are willing to deal with. Just to provide some information to the
user.
