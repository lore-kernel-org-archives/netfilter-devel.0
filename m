From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 01 May 2003 01:05:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051743903.8213.188.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
	 <1051701556.8213.125.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <1051701556.8213.125.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-30 at 13:19, Martin Josefsson wrote:

> > I think that eliminating ip_conntrack lock might uncover a (potential)
> > bottleneck: the tcp_lock, the lock in conntrack for the predominant
> > protocol of the Internet.
> 
> Yes that will be a problem.
> 
> > By adding a data lock to the conntrack entries can solve that
> > (potential) problem. The data lock would make unnecessary the per
> > conntrack helper locks too (unfortunately the buffers introduced in the
> > zerocopy patch undo that).
> 
> A per conntrack lock is probably the best for solving that bottleneck.

If we have per bucket spinlocks we don't have to have a tcp_lock if I
rememberthe code correctly.
If we go RCU we might need the per conntrack lock.

> I'll write up a small list of things I think we should fix in conntrack.

- Switch to using hlists for the hashtable
- Rearrange struct ip_conntrack to be more cachefriendly if possible
- Add prefetching in list-searching
- Turn protocol_list into an array
- Switch to a better hashfunction
- Remove pointless timer-updating
- Rework locking to be finer grained, start with per bucket spinlocks
  (goal: RCU?)
- Remove tcp_lock if using per bucket spinlocks, otherwise move it into
  the entries
- Remove pointless rehashing of tuples
- Rework overload support (early_drop)
- Avoid as many memory-writes as possible, no need to dirty cachelines if
  we don't have to
- Eliminate listhelp.h and lockhelp.h by request from hch
- Try to shrink struct ip_conntrack

-- 
/Martin
