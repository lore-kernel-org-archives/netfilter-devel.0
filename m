From: Luca Pesce <pesce.luca@gmail.com>
Subject: Questions about early_drop()
Date: Sat, 31 Oct 2009 13:07:18 +0100
Message-ID: <873dce860910310507v756ce39nf68bb102afb28658@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46818 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbZJaMHP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Oct 2009 08:07:15 -0400
Received: by bwz27 with SMTP id 27so4517436bwz.21
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2009 05:07:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
    today I was looking at early_drop() code in nf_conntrack_core.c, and I came
up with some questions, due to the fact that I am not such a netfilter expert...
I am not running the latest kernel:  I am cutting&pasting early_drop()
of my kernel
at the end of this mail, note that compared to 2.6.31.x this is quite different.

1- why does early_drop() increase the ct_general.use count of the ct
to be dropped
before calling death_by_timeout(), and then decreases it with nf_ct_put(ct)? Is
this a way to postpone ct death? What for?

2- I see that 2.6.31.5 version of early_drop() is more complex: it crosses more
than one bucket looking for not assured connections to be killed. I like that
approach, but I was wondering if this is not burning too much CPU when the
conntrack table is overly saturated persistently (and so when this function is
called very often)...any experience about that?
Can I port the whole early_drop() of 2.6.31.5 on my kernel?

3- on 2.6.31.5 version of early_drop(), there are two added checks
before killing
the conntrack:

 if (ct && unlikely(nf_ct_is_dying(ct) ||
				   !atomic_inc_not_zero(&ct->ct_general.use)))
			ct = NULL;
			
I understand that these are to ensure that the ct is not already dying
for itself:
should I add those to early_drop() which I am currently using to avoid races?

4- I was thinking about temporarily modifying the early_drop()
behaviour, only to
see the results of a test tool which tries to create NATed ftp download sessions
with a given connection rate (say X per second) - only to experiment a bit!
With early_drop() as is, after a while there are no NOT_ASSURED
conntracks in the
hastable, so no no new connections are established. If I remove the check on the
ASSURED bit, I would kill a ct regardlessly of its status to make room for the
new one. Would that harm in some way the conntrack code logic?
Again, this would be experimental only - not to be used in real life.

Thanks for your time,
Luca



static int early_drop(struct list_head *chain)
{
	/* Traverse backwards: gives us oldest, which is roughly LRU */
	struct nf_conntrack_tuple_hash *h;
	struct nf_conn *ct = NULL, *tmp;
	int dropped = 0;

	read_lock_bh(&nf_conntrack_lock);
	list_for_each_entry_reverse(h, chain, list) {
		tmp = nf_ct_tuplehash_to_ctrack(h);
		if (!test_bit(IPS_ASSURED_BIT, &tmp->status)) {
			ct = tmp;
			atomic_inc(&ct->ct_general.use);
			break;
		}
	}
	read_unlock_bh(&nf_conntrack_lock);

	if (!ct)
		return dropped;

	if (del_timer(&ct->timeout)) {
		death_by_timeout((unsigned long)ct);
		dropped = 1;
		NF_CT_STAT_INC_ATOMIC(early_drop);
	}
	nf_ct_put(ct);
	return dropped;
}
