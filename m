Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BABC5519F
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC01246B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgKRVKN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRVKN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 16:10:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5A7C0613D4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2020 13:10:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfUiN-0005qU-Ty; Wed, 18 Nov 2020 22:10:07 +0100
Date:   Wed, 18 Nov 2020 22:10:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     subashab@codeaurora.org
Cc:     Florian Westphal <fw@strlen.de>, Will Deacon <will@kernel.org>,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201118211007.GA15137@breakpoint.cc>
References: <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
 <20201118131419.GK22792@breakpoint.cc>
 <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

subashab@codeaurora.org <subashab@codeaurora.org> wrote:
> I have tried the following to ensure the instruction ordering of private
> assignment and I haven't seen the crash so far.
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index af22dbe..2a4f6b3 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1389,6 +1389,9 @@ xt_replace_table(struct xt_table *table,
>         /* make sure all cpus see new ->private value */
>         smp_wmb();
> 
> +       /* make sure the instructions above are actually executed */
> +       smp_mb();
> +

This looks funny, I'd rather have s/smp_wmb/smp_mb instead of yet
another one.

> I assume we would need the following changes to address this.

Yes, something like this.  More comments below.

> diff --git a/include/linux/netfilter/x_tables.h
> b/include/linux/netfilter/x_tables.h
> index 5deb099..7ab0e4f 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -227,7 +227,7 @@ struct xt_table {
>  	unsigned int valid_hooks;
> 
>  	/* Man behind the curtain... */
> -	struct xt_table_info *private;
> +	struct xt_table_info __rcu *private;
> 
>  	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
>  	struct module *me;
> diff --git a/net/ipv4/netfilter/arp_tables.c
> b/net/ipv4/netfilter/arp_tables.c
> index d1e04d2..6a2b551 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -203,7 +203,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
> 
>  	local_bh_disable();
>  	addend = xt_write_recseq_begin();
> -	private = READ_ONCE(table->private); /* Address dependency. */
> +	private = rcu_access_pointer(table->private);

The three _do_table() functions need to use rcu_dereference().

>  	cpu     = smp_processor_id();
>  	table_base = private->entries;
>  	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
> @@ -649,7 +649,7 @@ static struct xt_counters *alloc_counters(const struct
> xt_table *table)
>  {
>  	unsigned int countersize;
>  	struct xt_counters *counters;
> -	const struct xt_table_info *private = table->private;
> +	const struct xt_table_info *private = rcu_access_pointer(table->private);

This looks wrong.  I know its ok, but perhaps its better to add this:

struct xt_table_info *xt_table_get_private_protected(const struct xt_table *table)
{
 return rcu_dereference_protected(table->private, mutex_is_locked(&xt[table->af].mutex));
}
EXPORT_SYMBOL(xt_table_get_private_protected);

to x_tables.c.

If you dislike this extra function, add

#define xt_table_get_private_protected(t) rcu_access_pointer((t)->private)

in include/linux/netfilter/x_tables.h, with a bit fat comment telling
that the xt table mutex must be held.

But I'd rather have/use the helper function as it documents when its
safe to do this (and there will be splats if misused).

> index af22dbe..2e6c09c 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1367,7 +1367,7 @@ xt_replace_table(struct xt_table *table,
> 
>  	/* Do the substitution. */
>  	local_bh_disable();
> -	private = table->private;
> +	private = rcu_access_pointer(table->private);

AFAICS the local_bh_disable/enable calls can be removed too after this,
if we're interrupted by softirq calling any of the _do_table()
functions changes to the xt seqcount do not matter anymore.

>       /*
>        * Even though table entries have now been swapped, other CPU's

We need this additional hunk to switch to rcu for replacement/sync, no?

-       local_bh_enable();
-
-       /* ... so wait for even xt_recseq on all cpus */
-       for_each_possible_cpu(cpu) {
-               seqcount_t *s = &per_cpu(xt_recseq, cpu);
-               u32 seq = raw_read_seqcount(s);
-
-               if (seq & 1) {
-                       do {
-                               cond_resched();
-                               cpu_relax();
-                       } while (seq == raw_read_seqcount(s));
-               }
-       }
+       synchronize_rcu();
