From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 30 Apr 2003 13:19:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051701556.8213.125.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-30 at 12:49, Jozsef Kadlecsik wrote:

> > > > Should a lock per contrack entry be considered? This increases the
> > > > concurrency for different connections anyhow.
> > >
> > > Yep, I'm working on such a patch.
> >
> > Care to describe how you are going to build it?
> 
> As usual, it's Rusty's locking patch what triggered me to think over the
> locking issues. In that patch Rusty actually eliminates ip_conntrack
> lock:
> 
> - functionality structures (helpers etc.) are protected by the netproto
>   lock instead
> - expectations (lists and data) are protected by the ip_conntrack_expect
>   lock
> - and per-chain locking introduced in the hash table, protecting the
>   conntrack lists and entries

I was a little scared that you were going to try implementing per
conntrack locks :)

> I think that eliminating ip_conntrack lock might uncover a (potential)
> bottleneck: the tcp_lock, the lock in conntrack for the predominant
> protocol of the Internet.

Yes that will be a problem.

> By adding a data lock to the conntrack entries can solve that
> (potential) problem. The data lock would make unnecessary the per
> conntrack helper locks too (unfortunately the buffers introduced in the
> zerocopy patch undo that).

A per conntrack lock is probably the best for solving that bottleneck.

The conntrack helpers could linearize the packets (NAT code does that
for helpers anyway?) or copy them using skb_copy()?
The linearize will impact performance a little even when not using NAT.

We should try to go RCU later.

I'll write up a small list of things I think we should fix in conntrack.

-- 
/Martin
