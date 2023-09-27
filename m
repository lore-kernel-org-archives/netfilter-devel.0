Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C10E810D0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 11:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjI0Lll (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjI0Lll (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 07:41:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0650FFC
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 04:41:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlSv7-0004gn-9c; Wed, 27 Sep 2023 13:41:33 +0200
Date:   Wed, 27 Sep 2023 13:41:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <20230927114133.GA17767@breakpoint.cc>
References: <20230923110437.GB22532@breakpoint.cc>
 <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
 <ZRFTx6pFYt2tZuSy@calendula>
 <20230925195317.GC22532@breakpoint.cc>
 <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
 <ZRKt31Vs382Z31IO@calendula>
 <ZRLLDbVlYK5c9HX+@orbyte.nwl.cc>
 <ZRLd8MxWZMt3O/Yh@calendula>
 <ZRLjs5Rv91mJWbC0@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRLjs5Rv91mJWbC0@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > However, this is stalling writers and I don't think we need this
> > according to the problem description.
> 
> ACK. Maybe Florian has a case in mind which requires to serialize reset
> and commit?

No, spinlock is fine too, concurrent resets will just burn more cycles.
I did not think we'd have frequent resets which is why I suggegested
reuse of the existing lock, thats all.

No objections to new mutex or spinlock.
