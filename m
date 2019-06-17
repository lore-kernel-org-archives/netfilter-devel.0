Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C2CC31E5D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBA12084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfFQQ3W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:29:22 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33470 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFQQ3W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 12:29:22 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hcuVU-00022r-CU; Mon, 17 Jun 2019 18:29:20 +0200
Date:   Mon, 17 Jun 2019 18:29:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 2/5] tests: shell: cannot use handle for non-existing
 rule in kernel
Message-ID: <20190617162920.GU31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190617122518.10486-1-pablo@netfilter.org>
 <20190617122518.10486-2-pablo@netfilter.org>
 <20190617160030.GS31548@orbyte.nwl.cc>
 <20190617160657.qrl2vx5dn5zomk6l@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617160657.qrl2vx5dn5zomk6l@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jun 17, 2019 at 06:06:57PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 17, 2019 at 06:00:30PM +0200, Phil Sutter wrote:
[...]
> > My initial implementation of intra-transaction rule references made
> > this handle guessing impossible, but your single point cache
> > fetching still allowed for it (hence why I dropped my patch with a
> > similar change).
> 
> Hm. I think we should not guess the handle that the kernel assigns.
> 
> In a batch, handles do not exist. We could expose the
> intra-transaction index if needed to the user. But I don't see a
> use-case for this.
> 
> I think we should leave the handle as a reference to already existing
> rules in the kernel.

Yes, it's an ugly hack that should never have worked in the first place,
I fully agree. Yet that it stops working indicates user space starts
doing more than it has to - IMHO relying upon the kernel verifier is
desirable. At least it allows for much better handling of large
rulesets.

Cheers, Phil
