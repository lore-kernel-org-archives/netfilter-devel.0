Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABF5CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 10:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbjJQKJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 06:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbjJQKJr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 06:09:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438F88E;
        Tue, 17 Oct 2023 03:09:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qsh19-0007UK-8J; Tue, 17 Oct 2023 12:09:39 +0200
Date:   Tue, 17 Oct 2023 12:09:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [net-next PATCH v2] net: skb_find_text: Ignore patterns
 extending past 'to'
Message-ID: <20231017100939.GC10901@breakpoint.cc>
References: <20231017093906.26310-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017093906.26310-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Assume that caller's 'to' offset really represents an upper boundary for
> the pattern search, so patterns extending past this offset are to be
> rejected.
> 
> The old behaviour also was kind of inconsistent when it comes to
> fragmentation (or otherwise non-linear skbs): If the pattern started in
> between 'to' and 'from' offsets but extended to the next fragment, it
> was not found if 'to' offset was still within the current fragment.
> 
> Test the new behaviour in a kselftest using iptables' string match.

Reviewed-by: Florian Westphal <fw@strlen.de>
