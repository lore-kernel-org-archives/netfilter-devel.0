From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: PATCH: extra conntrack stats
Date: Fri, 02 May 2003 15:31:50 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502065752.5AB7D2C056@lists.samba.org>
References: <1051780007.8215.200.camel@tux.rsn.bth.se>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-reply-to: Your message of "01 May 2003 11:06:48 +0200."
             <1051780007.8215.200.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <1051780007.8215.200.camel@tux.rsn.bth.se> you write:
> On Thu, 2003-05-01 at 02:06, Rusty Russell wrote:
> > If we can do this without making our hash really suck, we only need one
> > entry per conntrack (and we then compare both ways).  This means a
> > smaller table, and hence better cache utilization, as well as simpler
> > locking.
> > 
> > Thoughts?
> 
> As Patrick already pointed out, it gets ugly wrt. NAT, the reply tuple
> can be quite diffrent.

Yes, you're both right, I'm stupid.  Scratch this "great idea".

> > Yeah, per-entry locks make sense I think.  I can change the helpers to
> > do an skb_copy (suggested by Alexey) which will be lockless, or just
> > implement the damn non-linear search.
> 
> The question is... how do you free such an entry with the guarantee that
> there are no waiters? It's probably possible but I can't see a clean
> nice way to do it.

Reference counts.  Currently, you delete from the hash, then dec
reference count (hash reference holds one reference count).  With RCU,
you'd do delete from hash, and call_rcu(drop_refcount) to do the
atomic_dec_and_test after you *know* noone else can reach it.

It's easy to confuse infrastructure protection (ie. protecting the
hash table chains and existence of the elements), with structure
protection (protecting the contents of each structure).  Currently we
use one big lock for both of them, but they're different.

Thanks,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
