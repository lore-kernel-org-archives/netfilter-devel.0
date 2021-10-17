Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732B6C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 12:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C58B61040
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 12:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbhJQMTb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Oct 2021 08:19:31 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45188 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbhJQMTb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Oct 2021 08:19:31 -0400
Received: from madeliefje.horms.nl (120-114-128-083.dynamic.caiway.nl [83.128.114.120])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 04D6A25AEAA;
        Sun, 17 Oct 2021 23:17:20 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 56ED74421; Sun, 17 Oct 2021 14:17:17 +0200 (CEST)
Date:   Sun, 17 Oct 2021 14:17:17 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 0/4] netfilter: ipvs: remove unneeded hook
 wrappers
Message-ID: <20211017121717.GC8292@vergenet.net>
References: <20211012172959.745-1-fw@strlen.de>
 <c0378ce6-d5d0-6a11-b25f-2f098a2349e@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0378ce6-d5d0-6a11-b25f-2f098a2349e@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 12, 2021 at 11:38:01PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 12 Oct 2021, Florian Westphal wrote:
> 
> > V2: Patch 4/4 had a bug that would enter ipv6 branch for
> > ipv4 packets, fix that.
> > 
> > This series reduces the number of different hook function
> > implementations by merging the ipv4 and ipv6 hooks into
> > common code.
> > 
> > selftests/netfilter/ipvs.sh passes.
> > 
> > Florian Westphal (4):
> >   netfilter: ipvs: prepare for hook function reduction
> >   netfilter: ipvs: remove unneeded output wrappers
> >   netfilter: ipvs: remove unneeded input wrappers
> >   netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers
> 
> 	Patchset v2 looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Thanks Florian,

looks good.

Reviewed-by: Simon Horman <horms@verge.net.au>

Pablo, please consider picking up this series.

