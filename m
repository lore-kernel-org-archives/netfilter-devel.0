Return-Path: <SRS0=x4zc=76=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB5BC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 20:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE54207E8
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 20:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgFQUHJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 16:07:09 -0400
Received: from correo.us.es ([193.147.175.20]:60402 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgFQUHJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 16:07:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5C46DBC01
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2020 22:07:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7673DA84D
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2020 22:07:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD0F6DA73F; Wed, 17 Jun 2020 22:07:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CC24DA73F;
        Wed, 17 Jun 2020 22:07:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Jun 2020 22:07:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7EB5342EE38F;
        Wed, 17 Jun 2020 22:07:05 +0200 (CEST)
Date:   Wed, 17 Jun 2020 22:07:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] nft_set_pipapo: Drop useless assignment of
 scratch map index on insert
Message-ID: <20200617200705.GA31049@salvia>
References: <033bc756cdecd4e8cbe01be3bcd50e59a844665c.1592167414.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033bc756cdecd4e8cbe01be3bcd50e59a844665c.1592167414.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 14, 2020 at 11:42:07PM +0200, Stefano Brivio wrote:
> In nft_pipapo_insert(), we need to reallocate scratch maps that will
> be used for matching by lookup functions, if they have never been
> allocated or if the bucket size changes as a result of the insertion.
> 
> As pipapo_realloc_scratch() provides a pair of fresh, zeroed out
> maps, there's no need to select a particular one after reallocation.
> 
> Other than being useless, the existing assignment was also troubled
> by the fact that the index was set only on the CPU performing the
> actual insertion, as spotted by Florian.
> 
> Simply drop the assignment.
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")

Hm.

It has a Fixes: tag.

Probably route this through nf.git instead?

Thanks.
