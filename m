Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384BCEB8FB7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 11:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240112AbjIFLrr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 07:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbjIFLrq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 07:47:46 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020C71731;
        Wed,  6 Sep 2023 04:47:40 -0700 (PDT)
Received: from [78.30.34.192] (port=37730 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qdr0R-00HP5I-5r; Wed, 06 Sep 2023 13:47:38 +0200
Date:   Wed, 6 Sep 2023 13:47:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPhm1mf0GaeQUr0e@calendula>
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 01:32:50PM +0200, Phil Sutter wrote:
> On Wed, Sep 06, 2023 at 11:42:02AM +0200, Pablo Neira Ayuso wrote:
> > Deliver audit log from __nf_tables_dump_rules(), table dereference at
> > the end of the table list loop might point to the list head, leading to
> > this crash.
> 
> Ah, of course. Sorry for the mess. I missed the fact that one may just
> call 'reset rules' and have it apply to all existing tables.
> 
> [...]
> > Deliver audit log only once at the end of the rule dump+reset for
> > consistency with the set dump+reset.
> 
> This may seem like number of audit logs is reduced, when it is actually
> increased: With your patch, there will be at least one notification for
> each chain, multiple with large chains (due to skb exhaustion).

With your patch, this is called for each netlink_recvmsg() invocation,
which is more audit logs.

@@ -3540,9 +3544,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 done:
        rcu_read_unlock();
 
-       if (reset && idx > cb->args[0])
-               audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
-
        cb->args[0] = idx;
        return skb->len;
 }

netlink dump is composed of a series of recvmsg() from userspace to
fetch the multiple chunks that represent the rules in this table.
If I read fine above, as the netlink dump makes progress, idx will
always go over cb->args[0], which evaluates true for each recvmsg()
call. With my patch this is less audit logs because audit log is only
delivered once for each chain, not for each recvmsg() call.

So patch description is fine as it is :)

> Not necessarily a problem, but worth mentioning. Also, I wonder if
> one should go the extra mile and add the chain name to log entries.
> I had considered to pass a string like "mytable:123 chain=mychain"
> to audit_log_nfcfg() for that matter, but it's quite a hack.

Agreed. Audit folks can extend this later on according to their needs
in case they need more fine grain reporting.

> > Ensure audit reset access to table under rcu read side lock. The table
> > list iteration holds rcu read lock side, but recent audit code
> > dereferences table object out of the rcu read lock side.
> > 
> > Fixes: ea078ae9108e ("netfilter: nf_tables: Audit log rule reset")
> > Fixes: 7e9be1124dbe ("netfilter: nf_tables: Audit log setelem reset")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Acked-by: Phil Sutter <phil@nwl.cc>
