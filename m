From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 19:23:48 +0100
Message-ID: <200503211923.48964.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
	<20050321180812.GA14954@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050321180812.GA14954@linuxace.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > Would it be possible to dump the internal conntrack tables
> > once the error occurs? Then we would at least know what
> > is filling the table up. Is there some kind of debug macro
> > I could add before the printk("conntrack table full") code?
>
> No easy way.  Last week I posted a patch which would have made
> this possible by creating a 'cleaned' list, but since you cannot
> upgrade kernels, you could not use this anyway.

But I can still patch kernels ;-)

> > Any other ideas?
>
> I'm still studying the root cause and have narrowed it down
> somewhat, but no patch yet.
>
> > I'll try to reproduce the problem in a test environment,
> > but it will be hard to narrow the cause down.
>
> What's the traffic pattern on this box?  In my testing I've
> never seen such high rates of leakage.

IIRC the box makes heavy use of SNAT/DNAT for port forwarding.
I'll try to get a copy of the firewall rules tomorrow and
test it locally here.

Is there an easy way to see if it leaked conntracks?
Should the information in /proc/slabinfo be somewhat proportional
to the number of connections/lines in /proc/net/ip_conntrack?

Thomas
