Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B918FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 09:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbiAFJlJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 04:41:09 -0500
Received: from mail.netfilter.org ([217.70.188.207]:34764 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiAFJlJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 04:41:09 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9FD8964282;
        Thu,  6 Jan 2022 10:38:21 +0100 (CET)
Date:   Thu, 6 Jan 2022 10:41:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, sbrivio@redhat.com,
        etkaar <lists.netfilter.org@prvy.eu>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: allocate pcpu scratch maps
 on clone
Message-ID: <Yda5MMa1KnH/WnEo@salvia>
References: <20220105131954.23666-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220105131954.23666-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 05, 2022 at 02:19:54PM +0100, Florian Westphal wrote:
> This is needed in case a new transaction is made that doesn't insert any
> new elements into an already existing set.
> 
> Else, after second 'nft -f ruleset.txt', lookups in such a set will fail
> because ->lookup() encounters raw_cpu_ptr(m->scratch) == NULL.
> 
> For the initial rule load, insertion of elements takes care of the
> allocation, but for rule reloads this isn't guaranteed: we might not
> have additions to the set.

Applied, thanks
