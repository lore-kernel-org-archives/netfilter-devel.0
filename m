From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 1 May 2003 07:48:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501054830.GA15143@oknodo.bof.de>
References: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu> <20030501015802.2CB152C2D9@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
  Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
  Harald Welte <laforge@netfilter.org>,
  Martin Josefsson <gandalf@wlug.westbo.se>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>,
  Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
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

Thanks for the Cc, I have indeed thought about such an approach.

Basically, it is possible for non-NAT conntracks. Those have
what I'd call "mirror" key material. Sort the keys, resulting
in A) a "flipped" bit, and B) first the smaller key, then the
larger, you have broken down both sides of the connection to
the same key (and the flipped bit, giving the direction);
look up the "sorted" key in the hash table, then choose the
real tuple to compare to based on the flipped bit.

Unfortunately, once NAT is set up for a conntrack, the keys
for both connections lose the mirror property. The approach
then becomes a small loss, compared to what we have now.

That means we have a tradeoff based on how we are deployed.
I stopped thinking about it at that point...


As an aside, and independant of the key sorting/flipping,
we could eliminate completely the info struct array we
now have in each conntrack. Interested? Then I'll write
how I envision that.


Finally, regarding the locking, I would like to mention
the memory conservative "sectored locks" approach.
Break the hash table into sectors, about N*NR_CPU
of them. Use one rwlock per sector.  Given an equally
distributing hash function, the probability that two
of our NR_CPU cpus will lock the same sector at the
same time, becomes small with growing N, fast.

This way, a lot less locks than with one-lock-per-chain
or one-lock-per-conntrack can be used, without compromising
concurrency too much.


best regards
  Patrick
