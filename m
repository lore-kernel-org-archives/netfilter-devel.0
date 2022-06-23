Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F08C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 15:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiFWP5B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 11:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiFWP5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 11:57:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7672E0A5
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 08:57:00 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1o4PCU-0008FT-NY; Thu, 23 Jun 2022 17:56:58 +0200
Date:   Thu, 23 Jun 2022 17:56:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] rule: collapse set element commands
Message-ID: <YrSNSliA1c3I5Ftv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220620090346.1021786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620090346.1021786-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:46AM +0200, Pablo Neira Ayuso wrote:
> Robots might generate a long list of singleton element commands such as:
> 
>   add element t s { 1.0.1.0/24 }
>   ...
>   add element t s { 1.0.2.0/23 }
> 
> collapse them into one single command before the evaluation step, ie.
> 
>   add element t s { 1.0.1.0/24, ..., 1.0.2.0/23 }
> 
> this speeds up overlap detection and set element automerge operations in
> this worst case scenario.
> 
> Since 3da9643fb9ff9 ("intervals: add support to automerge with kernel
> elements"), the new interval tracking relies on mergesort. The pattern
> above triggers the set sorting for each element.
> 
> This patch adds a list to cmd objects that store collapsed commands.
> Moreover, expressions also contain a reference to the original command,
> to uncollapse the commands after the evaluation step.
> 
> These commands are uncollapsed after the evaluation step to ensure error
> reporting works as expected (command and netlink message are mapped
> 1:1).
> 
> For the record:
> 
> - nftables versions <= 1.0.2 did not perform any kind of overlap
>   check for the described scenario above (because set cache only contained
>   elements in the kernel in this case). This is a problem for kernels < 5.7
>   which rely on userspace to detect overlaps.
> 
> - the overlap detection could be skipped for kernels >= 5.7.
> 
> - The extended netlink error reporting available for set elements
>   since 5.19-rc might allow to remove the uncollapse step, in this case,
>   error reporting does not rely on the netlink sequence to refer to the
>   command triggering the problem.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
