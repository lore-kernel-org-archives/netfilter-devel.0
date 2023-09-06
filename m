Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C6FEB8FB7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 11:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIFLdc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 07:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjIFLdb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 07:33:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22E5173A;
        Wed,  6 Sep 2023 04:32:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qdqmA-0004qv-OA; Wed, 06 Sep 2023 13:32:50 +0200
Date:   Wed, 6 Sep 2023 13:32:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
References: <20230906094202.1712-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906094202.1712-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 11:42:02AM +0200, Pablo Neira Ayuso wrote:
> Deliver audit log from __nf_tables_dump_rules(), table dereference at
> the end of the table list loop might point to the list head, leading to
> this crash.

Ah, of course. Sorry for the mess. I missed the fact that one may just
call 'reset rules' and have it apply to all existing tables.

[...]
> Deliver audit log only once at the end of the rule dump+reset for
> consistency with the set dump+reset.

This may seem like number of audit logs is reduced, when it is actually
increased: With your patch, there will be at least one notification for
each chain, multiple with large chains (due to skb exhaustion). Not
necessarily a problem, but worth mentioning. Also, I wonder if one
should go the extra mile and add the chain name to log entries. I had
considered to pass a string like "mytable:123 chain=mychain" to
audit_log_nfcfg() for that matter, but it's quite a hack.

> Ensure audit reset access to table under rcu read side lock. The table
> list iteration holds rcu read lock side, but recent audit code
> dereferences table object out of the rcu read lock side.
> 
> Fixes: ea078ae9108e ("netfilter: nf_tables: Audit log rule reset")
> Fixes: 7e9be1124dbe ("netfilter: nf_tables: Audit log setelem reset")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
