Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A3AC0044D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 17:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E43BE20736
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 17:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgCKRR5 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:17:57 -0400
Received: from correo.us.es ([193.147.175.20]:54116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730197AbgCKRR4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 13:17:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9784D819AF
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 18:17:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88516DA3C4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 18:17:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 869FDDA3C3; Wed, 11 Mar 2020 18:17:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B96BCDA38D;
        Wed, 11 Mar 2020 18:17:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 18:17:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9AE8A42EF42A;
        Wed, 11 Mar 2020 18:17:30 +0100 (CET)
Date:   Wed, 11 Mar 2020 18:17:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 18/18] tests: py: add variable binop RHS tests.
Message-ID: <20200311171752.cjv5kd6arsog4gia@salvia>
References: <20200303094844.26694-1-jeremy@azazel.net>
 <20200303094844.26694-19-jeremy@azazel.net>
 <20200310023913.uebkl7uywu4gkldn@salvia>
 <20200310093008.GA166204@azazel.net>
 <20200311132613.c2onkaxo7uizzofs@salvia>
 <20200311143535.GA184442@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200311143535.GA184442@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 11, 2020 at 02:35:35PM +0000, Jeremy Sowden wrote:
> On 2020-03-11, at 14:26:13 +0100, Pablo Neira Ayuso wrote:
> > Do you think it would be to keep back this one from the nf-next tree
> > until you evaluate an alternative way to extend nft_bitwise?
> >
> > commit 8d1f378a51fcf2f5e44e06ff726a91c885d248cc
> > Author: Jeremy Sowden <jeremy@azazel.net>
> > Date:   Mon Feb 24 12:49:31 2020 +0000
> >
> >     netfilter: bitwise: add support for passing mask and xor values in registers.
> 
> If we do move away from converting all boolean op's to:
> 
>   d = (s & m) ^ x
> 
> then it seems unlikely that the new attributes will be used.

I see.

> For me, it depends whether you rebase nf-next.  I'm guessing not.  In
> that case, I probably wouldn't bother reverting the patch now, since
> it's not big or invasive, and it wouldn't much matter if it went into
> 5.6 and got removed in a later patch-set.

OK. I'm considering to rebase given this patch is not yet into
net-next, unless anyone here is opposed to this in order to pass a
pull-request with no add-patch-then-revert.

Regarding the new extension, we only have to be careful when updating
userspace, so only new code uses the new bitwise extension you make.
Old code will still use the old boolean approach:

    d = (s & m) ^ x

So only the payload with non-constant right-hand side will be using
your new extension for nft_bitwise.

For libnftnl, I'm inclined to revert.

Let me know, thanks.
