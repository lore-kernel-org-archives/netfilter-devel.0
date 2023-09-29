Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAC8E80ABE
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 11:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjI2Lqc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 07:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjI2LqO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 07:46:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41100198A
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 04:45:54 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmBwO-000083-6q; Fri, 29 Sep 2023 13:45:52 +0200
Date:   Fri, 29 Sep 2023 13:45:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <ZRa48F2N2MxbhXSi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
 <20230928185745.GE19098@breakpoint.cc>
 <ZRXOIrxtu5JPN4jA@calendula>
 <20230928192127.GH19098@breakpoint.cc>
 <20230928200751.GA28176@breakpoint.cc>
 <ZRa0Dmyyk2HpABoP@orbyte.nwl.cc>
 <20230929113043.GF28176@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929113043.GF28176@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 29, 2023 at 01:30:43PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Thu, Sep 28, 2023 at 10:07:51PM +0200, Florian Westphal wrote:
> > > I don't really like it though because misbehaving userspace
> > > can lock out writers.
> > 
> > Make them inactive and free only after the dump is done? IIUC,
> > nft_active_genmask() will return true again though after the second
> > update, right?
> 
> Yes, however, in case of update and 'reset dump', we'll set the
> NLM_F_DUMP_INTR flag, so userspace would restart the dump.
> 
> AFAIU, this means the original values of 'already-reset' counters
> are lost given nft will restart the 'reset dump'.
> 
> Alternative is make nft not restart if reset-dump was requested,
> but in that case the dump can be incomplete.

Modification of the data being dump-reset is unsolvable anyway, unless
we can undo the reset. Not having to return EINTR for unrelated
modifications would help already, though may just be yet another
half-ass solution.

I'd honestly just document the unreliability of 'reset rules' and point
at 'reset rule' for a safe variant. (Assuming the non-dump path is
actually safe?!)

Cheers, Phil
