From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 01 May 2003 10:06:05 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501015802.2CB152C2D9@lists.samba.org>
References: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-reply-to: Your message of "Wed, 30 Apr 2003 12:49:11 +0200."
             <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu> you write:
> As usual, it's Rusty's locking patch what triggered me to think over the
> locking issues. In that patch Rusty actually eliminates ip_conntrack
> lock:

Ah, but I think I might have a better trick.  Patrick cc'd since he's
the hashing man.

Can we compromise the hash so that every packet hashes to the same
chain as its reply?

If we can do this without making our hash really suck, we only need one
entry per conntrack (and we then compare both ways).  This means a
smaller table, and hence better cache utilization, as well as simpler
locking.

Thoughts?

> I think that eliminating ip_conntrack lock might uncover a (potential)
> bottleneck: the tcp_lock, the lock in conntrack for the predominant
> protocol of the Internet.
> 
> By adding a data lock to the conntrack entries can solve that
> (potential) problem. The data lock would make unnecessary the per
> conntrack helper locks too (unfortunately the buffers introduced in the
> zerocopy patch undo that).

Yeah, per-entry locks make sense I think.  I can change the helpers to
do an skb_copy (suggested by Alexey) which will be lockless, or just
implement the damn non-linear search.

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
