Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BA1C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 20:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883F0610C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 20:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhJLUkH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:40:07 -0400
Received: from ink.ssi.bg ([178.16.128.7]:50083 "EHLO ink.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhJLUkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 16:40:07 -0400
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 093163C09C0;
        Tue, 12 Oct 2021 23:38:02 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 19CKc1ZS044603;
        Tue, 12 Oct 2021 23:38:01 +0300
Date:   Tue, 12 Oct 2021 23:38:01 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        horms@verge.net.au
Subject: Re: [PATCH nf-next v2 0/4] netfilter: ipvs: remove unneeded hook
 wrappers
In-Reply-To: <20211012172959.745-1-fw@strlen.de>
Message-ID: <c0378ce6-d5d0-6a11-b25f-2f098a2349e@ssi.bg>
References: <20211012172959.745-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 12 Oct 2021, Florian Westphal wrote:

> V2: Patch 4/4 had a bug that would enter ipv6 branch for
> ipv4 packets, fix that.
> 
> This series reduces the number of different hook function
> implementations by merging the ipv4 and ipv6 hooks into
> common code.
> 
> selftests/netfilter/ipvs.sh passes.
> 
> Florian Westphal (4):
>   netfilter: ipvs: prepare for hook function reduction
>   netfilter: ipvs: remove unneeded output wrappers
>   netfilter: ipvs: remove unneeded input wrappers
>   netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers

	Patchset v2 looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

>  net/netfilter/ipvs/ip_vs_core.c | 166 ++++++--------------------------
>  1 file changed, 32 insertions(+), 134 deletions(-)
> 
> -- 
> 2.32.0

Regards

--
Julian Anastasov <ja@ssi.bg>
