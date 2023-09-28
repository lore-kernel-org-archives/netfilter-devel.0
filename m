Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B050E732E9
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 20:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjI1UJu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjI1UJt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 16:09:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B16180
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 13:09:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlxKU-0007Vl-JE; Thu, 28 Sep 2023 22:09:46 +0200
Date:   Thu, 28 Sep 2023 22:09:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <20230928200946.GB28176@breakpoint.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
 <20230928185745.GE19098@breakpoint.cc>
 <ZRXOIrxtu5JPN4jA@calendula>
 <fedeecd9-b03-789-bc6c-21a697fc29d@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fedeecd9-b03-789-bc6c-21a697fc29d@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> On Thu, 28 Sep 2023, Pablo Neira Ayuso wrote:
> > One concern might be deadlock due to reordering, but I don't see how
> > that can happen.
> 
> The same problem exists ipset: when a set is listed/saved (dumped), 
> concurrent destroy/rename/swap for the same set must be excluded. As 
> neither spinlock nor mutex helps, a reference counter is used: the start 
> of the dump increases it and by checking it all concurrent events can 
> safely be rejected by returning EBUSY.

Thanks for sharing!

I assume that means that a dumper that starts a dump, and then
goes to sleep before closing the socket/finishing the dump can
block further ipset updates, is that correct?

(I assume so, I don't see a solution that doesn't trade one problem
 for another).
