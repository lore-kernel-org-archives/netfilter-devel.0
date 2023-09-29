Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DBCE7F154
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 11:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjI2Lat (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 07:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjI2Las (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 07:30:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAC594
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 04:30:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qmBhj-0005eP-OF; Fri, 29 Sep 2023 13:30:43 +0200
Date:   Fri, 29 Sep 2023 13:30:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <20230929113043.GF28176@breakpoint.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
 <20230928185745.GE19098@breakpoint.cc>
 <ZRXOIrxtu5JPN4jA@calendula>
 <20230928192127.GH19098@breakpoint.cc>
 <20230928200751.GA28176@breakpoint.cc>
 <ZRa0Dmyyk2HpABoP@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRa0Dmyyk2HpABoP@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Sep 28, 2023 at 10:07:51PM +0200, Florian Westphal wrote:
> > I don't really like it though because misbehaving userspace
> > can lock out writers.
> 
> Make them inactive and free only after the dump is done? IIUC,
> nft_active_genmask() will return true again though after the second
> update, right?

Yes, however, in case of update and 'reset dump', we'll set the
NLM_F_DUMP_INTR flag, so userspace would restart the dump.

AFAIU, this means the original values of 'already-reset' counters
are lost given nft will restart the 'reset dump'.

Alternative is make nft not restart if reset-dump was requested,
but in that case the dump can be incomplete.
