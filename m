From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: extra conntrack stats
Date: Wed, 30 Apr 2003 12:49:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu>
References: <1051655925.8201.59.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1051655925.8201.59.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 30 Apr 2003, Martin Josefsson wrote:

> On Wed, 2003-04-30 at 00:15, Jozsef Kadlecsik wrote:
> > On Sun, 27 Apr 2003, Rolf Fokkens wrote:
> >
> > > Well, after all this panic and calming down something constructive:
> > >
> > > Should a lock per contrack entry be considered? This increases the
> > > concurrency for different connections anyhow.
> >
> > Yep, I'm working on such a patch.
>
> Care to describe how you are going to build it?

As usual, it's Rusty's locking patch what triggered me to think over the
locking issues. In that patch Rusty actually eliminates ip_conntrack
lock:

- functionality structures (helpers etc.) are protected by the netproto
  lock instead
- expectations (lists and data) are protected by the ip_conntrack_expect
  lock
- and per-chain locking introduced in the hash table, protecting the
  conntrack lists and entries

I think that eliminating ip_conntrack lock might uncover a (potential)
bottleneck: the tcp_lock, the lock in conntrack for the predominant
protocol of the Internet.

By adding a data lock to the conntrack entries can solve that
(potential) problem. The data lock would make unnecessary the per
conntrack helper locks too (unfortunately the buffers introduced in the
zerocopy patch undo that).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
