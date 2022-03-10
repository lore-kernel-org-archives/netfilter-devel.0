Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7BFC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 12:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbiCJMM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbiCJMM5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 07:12:57 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDD41480C4
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:11:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nSHe7-0003Z7-8C; Thu, 10 Mar 2022 13:11:55 +0100
Date:   Thu, 10 Mar 2022 13:11:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/4] xshared: Prefer xtables_chain_protos lookup
 over getprotoent
Message-ID: <20220310121155.GF26501@breakpoint.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
 <20220302151807.12185-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302151807.12185-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> When dumping a large ruleset, common protocol matches such as for TCP
> port number significantly slow down rule printing due to repeated calls
> for getprotobynumber(). The latter does not involve any caching, so
> /etc/protocols is consulted over and over again.

> As a simple countermeasure, make functions converting between proto
> number and name prefer the built-in list of "well-known" protocols. This
> is not a perfect solution, repeated rules for protocol names libxtables
> does not cache (e.g. igmp or dccp) will still be slow. Implementing
> getprotoent() result caching could solve this.

Hmm, I think we could just extend xtables_chain_protos[].
Anyway, this looks safe to me, so

Acked-by: Florian Westphal <fw@strlen.de>
