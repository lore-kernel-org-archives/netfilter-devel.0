From: jamal <hadi@cyberus.ca>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: 27 Sep 2004 09:07:53 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096290473.1075.64.camel@jzny.localdomain>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040925075253.GQ3236@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

On Sat, 2004-09-25 at 03:52, Harald Welte wrote:

> > I havent actually run it - can you confirm this is impossible? 
> > if ct_sync was blind i.e it just did what it was told "become master" or
> > "become slave" regardless of who else is master, then it would be more
> > usable - leave policy to whatever tells it to switch.
> 
> well it exactly does this, with an additional security:  A master will
> be downgraded to slave as soon as another master announces itself.  This
> is a security guard against invalid mode of operation.

I think it would be better to separate the election process (who is
master) from the syncing code. For some reason i thought this separation
was there (and that all you had to do was bag some /proc entry). 
i.e if VRRP is the code that makes the decision that it wants you to be
the master, thats how you become master. If someothericandohabetter (eg
forCES) protocol wants you to be the master, thats how you become the
master. There is no point in inventing a new HA scheme.
And if you do it should probably be in user space (there is no
perfomance issues with it) i.e its such a protocol (in user space) that 
should tell your syncing code to send syncs or not.
Unless i missed something fundamental.

cheers,
jamal
