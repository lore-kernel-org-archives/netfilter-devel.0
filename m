From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 01 May 2003 11:58:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051783095.8214.253.camel@tux.rsn.bth.se>
References: <20030501050235.F0DCE2C04F@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030501050235.F0DCE2C04F@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-05-01 at 06:05, Rusty Russell wrote:
> In message <1051743903.8213.188.camel@tux.rsn.bth.se> you write:
> > On Wed, 2003-04-30 at 13:19, Martin Josefsson wrote:
> > - Switch to using hlists for the hashtable
> 
> OK.  Please implement hlist_for_each_entry(), though, a-la
> list_for_each_entry.

That's the plan.

> > - Rearrange struct ip_conntrack to be more cachefriendly if possible
> 
> Leave 'til last, I think, since that structure will be changing
> anyway.  Most important is that next ptr and tuple are at the start
> (ie. only one cacheline per hash chain entry).

I'll try to do some measurements of this so we know how much we are
talking about.

> > - Turn protocol_list into an array
> 
> Or hardcode the three builtins and use the list for others.

It would probably be faster with just the array, especially for the not
builtin case. The upside of the hardcoding is that it's contained in the
instructioncache.

> > - Switch to a better hashfunction
> 
> Yes!  See comments below on secret hashing...

Jozsef continued the work on this and has come to some conclusions I
think.

> > - Remove pointless timer-updating
> 
> We could revisit this altogether: go for one timer which sweeps the
> hash chains and an "expiry" date on each one.  You end up with some
> icky deletion issues, but...

Patrick made a patch sometime ago that still had the per entry timer but
only updated it with a new timeout once it expired.
The timer-handling code in kernel seems to have rather low overhead even
with lots of timers, it's just that it disables interrupts twice for
each packet, and the fact that the updates are pointless (often updated
to the exact same jiffy as it had before).

> > - Rework locking to be finer grained, start with per bucket spinlocks
> >   (goal: RCU?)
> 
> Well, might as well go straight to RCU for the infrastructure
> locking.  
> 
> It's a little tricky.  RCU can be used for the read side, but since
> writes are not uncommon (I always guesstimated 1 in 10), we still
> probably want per-chain locks.  Hmm, actually, since that bloats the
> hash, let's start with one lock and see how it goes.

Noo, please don't, with one lock for inserts/deletes it could still be
awful during a fairly large DDoS on an SMP machine.
If per-chain locks are too much bloat (many many locks which large
hashtables) I'd say sectored locks like Patrick suggested, but not one
global.

> The protection of the conntrack objects themselves should become a
> lock per conntrack I think.  We currently use the timer lock as a form
> of synchronization: if we have a conntrack.lock we should use that.
> 
> > - Remove tcp_lock if using per bucket spinlocks, otherwise move it into
> >   the entries
> 
> Agreed: use conntrack.lock.

We only read conntrack->proto.tcp twice and update it twice, both things
can be grouped together. I currently know too little about RCU, don't
know if it would be possible to skip the locking here.

> > - Remove pointless rehashing of tuples
> 
> Hmmm, does this happen?

Oh yes, currently we actually rehash the tuple for each entry searched
in the lists. There's a patch in optimization/ in p-o-m that fixes that.
But I think we have more rehashing going on and iirc Patrick made a
patch for that as well.

> > - Rework overload support (early_drop)
> 
> OK, you've probably seen my "hash with secret key" scheme.
> Unfortunately, it relies on being able to grab the network brlock to
> stop all activity while it redoes the hash.  But Dave is removing the
> brlock, so this becomes more tricky (ie. readers have to be aware that
> there could be two hash tables, ick).
> 
> It might still be worth it though (this same trick would allow us to
> resize the hash through /proc).  Needs more thought.

The only time rehashing is a positive thing is when you have one or a
few attacked chain or you manually want to resize it. Otherwise it will
probably just slow things down when the rehash happens. I like to just
give the hashtable a proper size from the beginning.

So we need a way to tell if someone is attacking a chain or if it's just
overload due to poor sizing.

> > - Avoid as many memory-writes as possible, no need to dirty cachelines if
> >   we don't have to
> 
> Well, yes, but it's usually secondary after correctness.

Of course.

> > - Try to shrink struct ip_conntrack
> 
> Ignoring NAT for the moment, and using a 32-bit arch:
> 
> 	struct nf_conntrack ct_general;
> 8 bytes: hard to shrink.
> 
> 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
> 2 x 28 bytes: we can get rid of one.

If we try to change the hashing yes.

> 	unsigned long status;
> 8 bytes. Needs to be ulong for bitops.

4 bytes

> So, we're about 192 bytes.  We could get to 80 bytes.

That'd be nice.

-- 
/Martin
