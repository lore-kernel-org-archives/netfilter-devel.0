From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 01 May 2003 11:06:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051780007.8215.200.camel@tux.rsn.bth.se>
References: <20030501015802.2CB152C2D9@lists.samba.org>
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
In-Reply-To: <20030501015802.2CB152C2D9@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-05-01 at 02:06, Rusty Russell wrote:
> In message <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu> you write:
> > As usual, it's Rusty's locking patch what triggered me to think over the
> > locking issues. In that patch Rusty actually eliminates ip_conntrack
> > lock:
> 
> Ah, but I think I might have a better trick.  Patrick cc'd since he's
> the hashing man.
> 
> Can we compromise the hash so that every packet hashes to the same
> chain as its reply?
> 
> If we can do this without making our hash really suck, we only need one
> entry per conntrack (and we then compare both ways).  This means a
> smaller table, and hence better cache utilization, as well as simpler
> locking.
> 
> Thoughts?

As Patrick already pointed out, it gets ugly wrt. NAT, the reply tuple
can be quite diffrent.

> > I think that eliminating ip_conntrack lock might uncover a (potential)
> > bottleneck: the tcp_lock, the lock in conntrack for the predominant
> > protocol of the Internet.
> > 
> > By adding a data lock to the conntrack entries can solve that
> > (potential) problem. The data lock would make unnecessary the per
> > conntrack helper locks too (unfortunately the buffers introduced in the
> > zerocopy patch undo that).
> 
> Yeah, per-entry locks make sense I think.  I can change the helpers to
> do an skb_copy (suggested by Alexey) which will be lockless, or just
> implement the damn non-linear search.

The question is... how do you free such an entry with the guarantee that
there are no waiters? It's probably possible but I can't see a clean
nice way to do it.

-- 
/Martin
