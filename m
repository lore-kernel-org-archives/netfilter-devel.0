From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 26 Aug 2004 12:00:06 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0408261015001.16945@blackhole.kfki.hu>
References: <1092407190.2402.120.camel@nienna.balabit>
	<20040819110646.GJ3921@sunbeam.de.gnumonks.org>
	<1092917551.2425.28.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1092917551.2425.28.camel@nienna.balabit>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Aug 2004, KOVACS Krisztian wrote:

> > >      3. There are a few things in the connection tracking code which
> > >         are incompatible with replication "by design". For example,
> > >         the expectfn() function in the expectation structure is such:
> > >         simply, there is no way to replicate a stand-alone function
> > >         pointer which could point to any arbitrary function.
> >
> > Yes, indeed.  we could look up the symbol name in the symbol table and
> > replicate that ;)   Crude hack, but it would work.
>
>   Unfortunately I don't think it would work... AFAIK there is no symbol
> table information in 2.4 kernels and usually these functions are
> declared as static anyway. Moreover, take a look at the H.323 helper, it
> uses this expectfn function to set the helper of the conntrack to an
> unregistered helper structure... I think there is no point in making
> ct_sync overly complicated; these helpers should be fixed instead. (I
> don't know why the H.323 does things this way, but it is completely
> hopeless to replicate things like this.)

We could add the expect function to the ip_conntrack_helper structure and
identify it by the helper name in the update messages. The unregistered
helper in the H.323 conntrack/nat module could be registered with an
invalid, never matching port and let the expect function handle it as
before (because the real port is dynamic). I think that'd be sufficient in
solving the replication problem.

Unfortunately we cannot fix the H.323 protocol. :-)

> > > 	 One more example could be TCP window tracking, I don't think we
> > > 	 have the necessary bandwidth and CPU time to send an update
> > > 	 message after each and every received TCP packet... Any idea
> > > 	 how we could solve these problems?
> >
> > We already do this since the timeout is updated with every packet.  So
> > at this point, I see not much difference.  Jozsef and I agreed some time
> > in the past, that if we don't replicate all the window information, in
> > the event of a slave being propagated to master, the new master should
> > disable windowtracking or switch into a lazy mode.
>
>   Indeed, the timeout is updated with every packet. However, we do not
> generate an update message for IPCT_REFRESH events at the moment. On the
> other hand, we replicate the timeout changes when a state change occurs
> as well, so I don't worry about incorrect (relative) timeout values at
> all.

That's still fine with TCP window tracking. Just as Harald wrote, we can
switch to lazy mode on the slaves. But to be honest, that is the least
verified part of the window tracking code.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
