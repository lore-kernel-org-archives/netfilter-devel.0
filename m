From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 01 May 2003 14:05:52 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501050235.F0DCE2C04F@lists.samba.org>
References: <1051743903.8213.188.camel@tux.rsn.bth.se>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
In-reply-to: Your message of "01 May 2003 01:05:03 +0200."
             <1051743903.8213.188.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <1051743903.8213.188.camel@tux.rsn.bth.se> you write:
> On Wed, 2003-04-30 at 13:19, Martin Josefsson wrote:
> - Switch to using hlists for the hashtable

OK.  Please implement hlist_for_each_entry(), though, a-la
list_for_each_entry.

> - Rearrange struct ip_conntrack to be more cachefriendly if possible

Leave 'til last, I think, since that structure will be changing
anyway.  Most important is that next ptr and tuple are at the start
(ie. only one cacheline per hash chain entry).

> - Add prefetching in list-searching

Can be done, but it's a micro-optimization and you'd want to check
carefully that recent gcc's don't do this anyway.

> - Turn protocol_list into an array

Or hardcode the three builtins and use the list for others.

> - Switch to a better hashfunction

Yes!  See comments below on secret hashing...

> - Remove pointless timer-updating

We could revisit this altogether: go for one timer which sweeps the
hash chains and an "expiry" date on each one.  You end up with some
icky deletion issues, but...

> - Rework locking to be finer grained, start with per bucket spinlocks
>   (goal: RCU?)

Well, might as well go straight to RCU for the infrastructure
locking.  

It's a little tricky.  RCU can be used for the read side, but since
writes are not uncommon (I always guesstimated 1 in 10), we still
probably want per-chain locks.  Hmm, actually, since that bloats the
hash, let's start with one lock and see how it goes.

The protection of the conntrack objects themselves should become a
lock per conntrack I think.  We currently use the timer lock as a form
of synchronization: if we have a conntrack.lock we should use that.

> - Remove tcp_lock if using per bucket spinlocks, otherwise move it into
>   the entries

Agreed: use conntrack.lock.

> - Remove pointless rehashing of tuples

Hmmm, does this happen?

> - Rework overload support (early_drop)

OK, you've probably seen my "hash with secret key" scheme.
Unfortunately, it relies on being able to grab the network brlock to
stop all activity while it redoes the hash.  But Dave is removing the
brlock, so this becomes more tricky (ie. readers have to be aware that
there could be two hash tables, ick).

It might still be worth it though (this same trick would allow us to
resize the hash through /proc).  Needs more thought.

> - Avoid as many memory-writes as possible, no need to dirty cachelines if
>   we don't have to

Well, yes, but it's usually secondary after correctness.

> - Eliminate listhelp.h and lockhelp.h by request from hch

Yeah, list.h is more sophisticated now, and we have lock debugging

> - Try to shrink struct ip_conntrack

Ignoring NAT for the moment, and using a 32-bit arch:

	struct nf_conntrack ct_general;
8 bytes: hard to shrink.

	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
2 x 28 bytes: we can get rid of one.

	unsigned long status;
8 bytes. Needs to be ulong for bitops.

	struct timer_list timeout;
48 bytes: could be one ulong (time for expiry).

	struct list_head sibling_list;
8 bytes.  Hard to remove without getting tricky...
	
	unsigned int expecting;
4 bytes. Maybe could merge this with upper bits of status, maybe...

	struct ip_conntrack_expect *master;
4 bytes. Needed.

	struct ip_conntrack_helper *helper;
4 bytes.  Needed.

	struct nf_ct_info infos[IP_CT_NUMBER];
7 * 4 bytes.  We could eliminate this by adding an skb field to hold
the state.

	union ip_conntrack_proto proto;
8 bytes, will get bigger with tcp tracking.

	union ip_conntrack_help help;
16 bytes, could use flags in status for ftp's seq_aft_nl_set and cut
to 8 bytes.

So, we're about 192 bytes.  We could get to 80 bytes.

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
