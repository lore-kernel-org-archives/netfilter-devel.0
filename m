From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: 12 Oct 2002 15:09:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034428150.7595.36.camel@tux>
References: <1034286048.25146.40.camel@tux>
	<Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
	<20021012141737.X13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021012141737.X13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-10-12 at 14:17, Harald Welte wrote:

> > > init_conntrack
> > > 	first:
> > > 		WRITE_LOCK(&ip_conntrack_lock);
> > > 		READ_LOCK(&ip_conntrack_expect_tuple_lock);
> > > 		LIST_FIND
> > 
> > Read-locking ip_conntrack_expect_tuple_lock is unnecessary here then.
> 
> Well, this is correct. But it's an optimiziation based on the assumption
> that there is only one place where we WRITE_LOCK(&expect_tuple_lock),
> which is in turn protected by READ_LOCK(&ip_conntrack_lock).  While this
> is true now, I'm not sure that this is a good idea in general.

Ok then that stays.
 
> > > 	later:
> > > 		WRITE_LOCK(&ip_conntrack_lock);
> > > 		LIST_DELETE
> 
> This is OK, since list_delete doesn't read the tuple/mask inside this expect.

Ok.
 
> > > ip_conntrack_expect_related
> > > 	WRITE_LOCK(&ip_conntrack_lock);
> > > 	LIST_FIND
> > > 	LIST_FIND
> > > 	list_prepend
> 
> This is clearly a bug, but works according to the optimization described 
> above.  I think we should either grab the tuple_lock or at least make 
> a verbose comment in the code describing why we don't grab it.

I'll add a read-lock on the tuple_lock here just to mark that it should
be taken.

All modifications of the liststructure are done under a write-locked
ip_conntrack_lock, the only things that happen under a read-locked
ip_conntrack_lock are a find and a change, nothing that changes the
structure. see below.
 
> > > ip_conntrack_change_expect
> > > 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
> > > 	LIST_FIND
> > >
> > > 	FAILS!! called from nat-helpers which only hold their own locks
> > > 	if any at all.
> 
> No.  The helper's help functions are called from do_bindings, which grab
> a readlock on ip_conntrack_lock before traversing the list of expectations
> matching this packet.  See also my comment above.

Ahh I missed this, the helper is called after exp_for_packet which has
already screwed up the lock-debug.

But we'll need to hold at least a read-lock on the tuple_lock during
that LIST_FIND since we only have a read-lock on ip_conntrack_lock.
and we modify tupe/mask inside this read-locked ip_conntrack_lock but
within a write-lock'd tuple_lock. And since we'll probably need to take
that write-lock anyway we might just as well take it from the beginning.
 
> Please correct me if I'm overlooking something.

I think you got everything covered.

So the lockingrules comes down to this if I've understood things
correctly:

1. All accesses to the expect-list are to be performed with
ip_conntrack_lock held.

2. All list-structure changes are done under a write-locked
ip_conntrack_lock and tuple_lock is not needed.

3. All other accesses are performed under at least a read-locked
ip_conntrack_lock.

4. All read-accesses to tuple/mask data inside the list are performed
under at least a read-locked tuple_lock.

5. All write-accesses to tuple/mask data inside the list are performed
under a write-locked tuple_lock.

Does that sound ok to you?

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
