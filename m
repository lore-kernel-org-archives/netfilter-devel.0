Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E22C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C396526C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhCIVZF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 16:25:05 -0500
Received: from correo.us.es ([193.147.175.20]:37498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhCIVYr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 16:24:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06F77E34C1
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 22:24:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8C43DA78A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 22:24:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD6AEDA73D; Tue,  9 Mar 2021 22:24:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FF7EDA704;
        Tue,  9 Mar 2021 22:24:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Mar 2021 22:24:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 71EDB42DF564;
        Tue,  9 Mar 2021 22:24:43 +0100 (CET)
Date:   Tue, 9 Mar 2021 22:24:43 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, fmyhr@fhmtech.com,
        stefanh@hafenthal.de
Subject: Re: [PATCH RFC nf-next 0/2] ct helper object name matching
Message-ID: <20210309212443.GA13962@salvia>
References: <20210309210134.13620-1-pablo@netfilter.org>
 <20210309211817.GG10808@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309211817.GG10808@breakpoint.cc>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 09, 2021 at 10:18:17PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > From nftables, existing (inconsistent) syntax can be left in place for
> > backward compatibility. The new proposed syntax would more explicitly
> > refer to match the user wants to do, e.g.
> > 
> > 	ct helper name set "ftp-21"
> 
> That would be same as 'ct helper set "ftp-21" that we use at the
> moment, i.e. this generates same byte code, correct?

Yes.

> > 	ct helper name "ftp-21"
> 
> I see, kernel ct extension gains a pointer to the objref name.
> 
> > For NFT_CT_HELPER_TYPE (formerly NFT_CT_HELPER), syntax would be:
> > 
> > 	ct helper type "ftp"
> 
> That would be the 'new' name for existing 'ct helper', so same bytecode,
> correct?

Yes.

> > It should be also possible to support for:
> > 
> > 	ct helper type set "ftp"
> 
> IIRC another argument for objref usage was that this won't work
> with set infra.

Right. The (missing) implicit object support would make it fit into
the set infrastructure.

> > via implicit object, this infrastructure is missing in the kernel
> > though, the idea would be to create an implicit object that is attached
> > to the rule.  Such object would be released when the rule is removed.
> 
> Ah, I see.
> 
> Yes, that would work.
> 
> > Let me know.
> 
> Looks good to me.

Thanks for reviewing.
