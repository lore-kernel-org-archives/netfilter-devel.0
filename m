Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC21C07E9D
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Sep 2022 15:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiIZPHq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbiIZPGj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2022 11:06:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678D7EBD47;
        Mon, 26 Sep 2022 06:38:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ocoJe-0005aZ-MP; Mon, 26 Sep 2022 15:38:34 +0200
Date:   Mon, 26 Sep 2022 15:38:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <20220926133834.GE12777@breakpoint.cc>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
 <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
 <20220926100800.GB12777@breakpoint.cc>
 <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
 <20220926130808.GD12777@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926130808.GD12777@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > On Mon 26-09-22 12:08:00, Florian Westphal wrote:
> > > Michal Hocko <mhocko@suse.com> wrote:
> > > > +		old_tbl = rht_dereference_rcu(ht->tbl, ht);
> > > > +		size = tbl->size;
> > > > +
> > > > +		data = ERR_PTR(-EBUSY);
> > > > +
> > > > +		if (rht_grow_above_75(ht, tbl))
> > > > +			size *= 2;
> > > > +		/* Do not schedule more than one rehash */
> > > > +		else if (old_tbl != tbl)
> > > > +			return data;
> > > > +
> > > > +		data = ERR_PTR(-ENOMEM);
> > > > +
> > > > +		rcu_read_unlock();
> > > > +		new_tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> > > > +		rcu_read_lock();
> > > 
> > > I don't think this is going to work, there can be callers that
> > > rely on rcu protected data structures getting free'd.
> > 
> > The caller of this function drops RCU for each retry, why should be the
> > called function any special?
> 
> I was unfortunately never able to fully understand rhashtable.

Obviously.

> AFAICS the rcu_read_lock/unlock in the caller is pointless,
> or at least dubious.

Addedum, I can't read:

void *rhashtable_insert_slow(struct rhashtable *ht, const void *key,
		                             struct rhash_head *obj)
{
       void *data;

       do {
		rcu_read_lock();
		data = rhashtable_try_insert(ht, key, obj);
	       	rcu_read_unlock();
										        }
	} while (PTR_ERR(data) == -EAGAIN);
}

... which is needed to prevent a lockdep splat in
rhashtable_try_insert() -- there is no guarantee the caller already
has rcu_read_lock().

> To the best of my knowledge there are users of this interface that
> invoke it with rcu read lock held, and since those always nest, the
> rcu_read_unlock() won't move us to GFP_KERNEL territory.
> 
> I guess you can add a might_sleep() and ask kernel to barf at runtime.

I did and it triggers.  Caller is inet_frag_find(), triggered
via 'ping -s 60000 $addr'.
