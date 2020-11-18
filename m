Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD653C6379D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 20:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A31A246C7
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 20:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="LT8kyaFU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKRUjV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 15:39:21 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:52857 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgKRUjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 15:39:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605731958; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=VNRDfNHqrcSuNHrDD+RRCVceXbC+dOmHcNeFbakDuuw=;
 b=LT8kyaFU5G1N5Fd3zBwGQhEYV7QbTEIAQto3td2K3J0cCmQTDrW+ci0xSH4NSBJgRQQi3CRu
 0kuxLG3CbGWNT7adtwNDuPQFT5DA/6ibPlb9HpKBERlN2UdXiHhoO2xmJyQ4quokWJSmChet
 zuby0zp3YPbKKdI85INYVHkBEF8=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fb58673d64ea0b703f41a1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 20:39:15
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E9A98C43468; Wed, 18 Nov 2020 20:39:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF2CAC43462;
        Wed, 18 Nov 2020 20:39:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 13:39:12 -0700
From:   subashab@codeaurora.org
To:     Florian Westphal <fw@strlen.de>, Will Deacon <will@kernel.org>
Cc:     pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
In-Reply-To: <20201118131419.GK22792@breakpoint.cc>
References: <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
 <20201118131419.GK22792@breakpoint.cc>
Message-ID: <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have tried the following to ensure the instruction ordering of private
assignment and I haven't seen the crash so far.

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe..2a4f6b3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1389,6 +1389,9 @@ xt_replace_table(struct xt_table *table,
         /* make sure all cpus see new ->private value */
         smp_wmb();

+       /* make sure the instructions above are actually executed */
+       smp_mb();
+
         /*
          * Even though table entries have now been swapped, other CPU's
          * may still be using the old entries...

I had added a debug to store the values of the xt_recseq.sequence in 
ip6t_do_table
after the increment so it probably forced a load in the code order 
rather
than allowing CPU to defer it.

[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/netfilter/ip6_tables.c?h=v5.10-rc4#n282]
	addend = xt_write_recseq_begin();

Otherwise, I would have needed the additional instruction barrier which 
Will noted
in xt_write_recseq_begin() below.

> diff --git a/include/linux/netfilter/x_tables.h
> b/include/linux/netfilter/x_tables.h
> index 5deb099d156d..8ec48466410a 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -376,7 +376,7 @@ static inline unsigned int 
> xt_write_recseq_begin(void)
>  	 * since addend is most likely 1
>  	 */
>  	__this_cpu_add(xt_recseq.sequence, addend);
> -	smp_wmb();
> +	smp_mb();
> 
>  	return addend;
>  }

>> ... you could make this rcu_assign_pointer() and get rid of the 
>> preceding
>> smp_wmb()...
> 
> Yes, it would make sense to add proper rcu annotation as well.
> 
>> >         /* make sure all cpus see new ->private value */
>> >         smp_wmb();
>> 
>> ... and this smp_wmb() is no longer needed because synchronize_rcu()
>> takes care of the ordering.

I assume we would need the following changes to address this.

diff --git a/include/linux/netfilter/x_tables.h 
b/include/linux/netfilter/x_tables.h
index 5deb099..7ab0e4f 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
  	unsigned int valid_hooks;

  	/* Man behind the curtain... */
-	struct xt_table_info *private;
+	struct xt_table_info __rcu *private;

  	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
  	struct module *me;
diff --git a/net/ipv4/netfilter/arp_tables.c 
b/net/ipv4/netfilter/arp_tables.c
index d1e04d2..6a2b551 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -203,7 +203,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,

  	local_bh_disable();
  	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
  	cpu     = smp_processor_id();
  	table_base = private->entries;
  	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
@@ -649,7 +649,7 @@ static struct xt_counters *alloc_counters(const 
struct xt_table *table)
  {
  	unsigned int countersize;
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);

  	/* We need atomic snapshot of counters: rest doesn't change
  	 * (other than comefrom, which userspace doesn't care
@@ -673,7 +673,7 @@ static int copy_entries_to_user(unsigned int 
total_size,
  	unsigned int off, num;
  	const struct arpt_entry *e;
  	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	struct xt_table_info *private = rcu_access_pointer(table->private);
  	int ret = 0;
  	void *loc_cpu_entry;

@@ -1330,7 +1330,7 @@ static int compat_copy_entries_to_user(unsigned 
int total_size,
  				       void __user *userptr)
  {
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);
  	void __user *pos;
  	unsigned int size;
  	int ret = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c 
b/net/ipv4/netfilter/ip_tables.c
index f15bc21..64d0fb7 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -258,7 +258,7 @@ ipt_do_table(struct sk_buff *skb,
  	WARN_ON(!(table->valid_hooks & (1 << hook)));
  	local_bh_disable();
  	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
  	cpu        = smp_processor_id();
  	table_base = private->entries;
  	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
@@ -791,7 +791,7 @@ static struct xt_counters *alloc_counters(const 
struct xt_table *table)
  {
  	unsigned int countersize;
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);

  	/* We need atomic snapshot of counters: rest doesn't change
  	   (other than comefrom, which userspace doesn't care
@@ -815,7 +815,7 @@ copy_entries_to_user(unsigned int total_size,
  	unsigned int off, num;
  	const struct ipt_entry *e;
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);
  	int ret = 0;
  	const void *loc_cpu_entry;

@@ -1543,7 +1543,7 @@ compat_copy_entries_to_user(unsigned int 
total_size, struct xt_table *table,
  			    void __user *userptr)
  {
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);
  	void __user *pos;
  	unsigned int size;
  	int ret = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c 
b/net/ipv6/netfilter/ip6_tables.c
index 2e2119b..db27e29 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -280,7 +280,7 @@ ip6t_do_table(struct sk_buff *skb,

  	local_bh_disable();
  	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
  	cpu        = smp_processor_id();
  	table_base = private->entries;
  	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
@@ -807,7 +807,7 @@ static struct xt_counters *alloc_counters(const 
struct xt_table *table)
  {
  	unsigned int countersize;
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);

  	/* We need atomic snapshot of counters: rest doesn't change
  	   (other than comefrom, which userspace doesn't care
@@ -831,7 +831,7 @@ copy_entries_to_user(unsigned int total_size,
  	unsigned int off, num;
  	const struct ip6t_entry *e;
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);
  	int ret = 0;
  	const void *loc_cpu_entry;

@@ -1552,7 +1552,7 @@ compat_copy_entries_to_user(unsigned int 
total_size, struct xt_table *table,
  			    void __user *userptr)
  {
  	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = 
rcu_access_pointer(table->private);
  	void __user *pos;
  	unsigned int size;
  	int ret = 0;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe..2e6c09c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1367,7 +1367,7 @@ xt_replace_table(struct xt_table *table,

  	/* Do the substitution. */
  	local_bh_disable();
-	private = table->private;
+	private = rcu_access_pointer(table->private);

  	/* Check inside lock: is the old number correct? */
  	if (num_counters != private->number) {
@@ -1379,15 +1379,8 @@ xt_replace_table(struct xt_table *table,
  	}

  	newinfo->initial_entries = private->initial_entries;
-	/*
-	 * Ensure contents of newinfo are visible before assigning to
-	 * private.
-	 */
-	smp_wmb();
-	table->private = newinfo;

-	/* make sure all cpus see new ->private value */
-	smp_wmb();
+	rcu_assign_pointer(table->private, newinfo);

  	/*
  	 * Even though table entries have now been swapped, other CPU's
@@ -1442,12 +1435,12 @@ struct xt_table *xt_register_table(struct net 
*net,
  	}

  	/* Simplifies replace_table code. */
-	table->private = bootstrap;
+	rcu_assign_pointer(table->private, bootstrap);

  	if (!xt_replace_table(table, 0, newinfo, &ret))
  		goto unlock;

-	private = table->private;
+	private = rcu_access_pointer(table->private);
  	pr_debug("table->private->number = %u\n", private->number);

  	/* save number of initial entries */
@@ -1470,7 +1463,8 @@ void *xt_unregister_table(struct xt_table *table)
  	struct xt_table_info *private;

  	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
+	private = rcu_access_pointer(table->private);
+	RCU_INIT_POINTER(table->private, NULL);
  	list_del(&table->list);
  	mutex_unlock(&xt[table->af].mutex);
  	audit_log_nfcfg(table->name, table->af, private->number,

