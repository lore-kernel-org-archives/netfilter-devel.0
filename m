Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1C4EE14BC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbjIFRIr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 13:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjIFRIq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 13:08:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB9013E;
        Wed,  6 Sep 2023 10:08:42 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qdw1A-0008FZ-FF; Wed, 06 Sep 2023 19:08:40 +0200
Date:   Wed, 6 Sep 2023 19:08:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPhm1mf0GaeQUr0e@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 01:47:34PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 06, 2023 at 01:32:50PM +0200, Phil Sutter wrote:
> > On Wed, Sep 06, 2023 at 11:42:02AM +0200, Pablo Neira Ayuso wrote:
> > > Deliver audit log from __nf_tables_dump_rules(), table dereference at
> > > the end of the table list loop might point to the list head, leading to
> > > this crash.
> > 
> > Ah, of course. Sorry for the mess. I missed the fact that one may just
> > call 'reset rules' and have it apply to all existing tables.
> > 
> > [...]
> > > Deliver audit log only once at the end of the rule dump+reset for
> > > consistency with the set dump+reset.
> > 
> > This may seem like number of audit logs is reduced, when it is actually
> > increased: With your patch, there will be at least one notification for
> > each chain, multiple with large chains (due to skb exhaustion).
> 
> With your patch, this is called for each netlink_recvmsg() invocation,
> which is more audit logs.
> 
> @@ -3540,9 +3544,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  done:
>         rcu_read_unlock();
>  
> -       if (reset && idx > cb->args[0])
> -               audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
> -
>         cb->args[0] = idx;
>         return skb->len;
>  }
> 
> netlink dump is composed of a series of recvmsg() from userspace to
> fetch the multiple chunks that represent the rules in this table.
> If I read fine above, as the netlink dump makes progress, idx will
> always go over cb->args[0], which evaluates true for each recvmsg()
> call. With my patch this is less audit logs because audit log is only
> delivered once for each chain, not for each recvmsg() call.

Here's a simple example:

| for table in t1 t2; do
| 	echo "add table $table"
| 	for chain in c1 c2 c3; do
| 		echo "add chain $table $chain"
| 		echo "add rule $table $chain counter accept"
| 		echo "add rule $table $chain counter accept"
| 		echo "add rule $table $chain counter accept"
| 	done
| done | nft -f -
| nft reset rules
| nft reset rules table t1

Before your patch, audit NETFILTER_CFG messages are:

| type=NETFILTER_CFG msg=audit(1694018800.149:1917): table=(null):5 family=0 entries=18 op=nft_reset_rule pid=6558 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694018848.399:1918): table=t1:5 family=2 entries=9 op=nft_reset_rule pid=6565 subj=kernel comm="nft"

(Note the NULL table name pointer in the first one.)

With your patch applied, these are the respective audit messages:

| type=NETFILTER_CFG msg=audit(1694020131.459:3): table=t1:2 family=2 entries=3 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.459:3): table=t1:2 family=2 entries=6 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.459:3): table=t1:2 family=2 entries=9 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.459:3): table=t2:2 family=2 entries=12 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.459:3): table=t2:2 family=2 entries=15 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.459:3): table=t2:2 family=2 entries=18 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.489:4): table=t1:2 family=2 entries=3 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.489:4): table=t1:2 family=2 entries=6 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.489:4): table=t1:2 family=2 entries=9 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.489:4): table=t2:2 family=2 entries=12 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.489:4): table=t2:2 family=2 entries=15 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020131.489:4): table=t2:2 family=2 entries=18 op=nft_reset_rule pid=3119 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020206.579:5): table=t1:2 family=2 entries=3 op=nft_reset_rule pid=3126 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020206.579:5): table=t1:2 family=2 entries=6 op=nft_reset_rule pid=3126 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020206.579:5): table=t1:2 family=2 entries=9 op=nft_reset_rule pid=3126 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020206.609:6): table=t1:2 family=2 entries=3 op=nft_reset_rule pid=3126 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020206.609:6): table=t1:2 family=2 entries=6 op=nft_reset_rule pid=3126 subj=kernel comm="nft"
| type=NETFILTER_CFG msg=audit(1694020206.609:6): table=t1:2 family=2 entries=9 op=nft_reset_rule pid=3126 subj=kernel comm="nft"

The last six come from the 'reset rules table t1' command. While on one
hand it looks like nftables fits only three rules into a single skb,
your fix seems to have a problem in that it doesn't subtract s_idx from
*idx.

Cheers, Phil
