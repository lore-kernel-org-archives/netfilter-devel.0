From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 13:14:41 -0800
Message-ID: <20050321211441.GA15155@linuxace.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
	<20050321180812.GA14954@linuxace.com>
	<200503211923.48964.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200503211923.48964.thomas.jarosch@intra2net.com>
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

On Mon, Mar 21, 2005 at 07:23:48PM +0100, Thomas Jarosch wrote:
> > No easy way.  Last week I posted a patch which would have made
> > this possible by creating a 'cleaned' list, but since you cannot
> > upgrade kernels, you could not use this anyway.
> 
> But I can still patch kernels ;-)

OK, I'll send along a 2.4.21 -> 2.6.11 patch shortly ;-)

> IIRC the box makes heavy use of SNAT/DNAT for port forwarding.
> I'll try to get a copy of the firewall rules tomorrow and
> test it locally here.
> 
> Is there an easy way to see if it leaked conntracks?
> Should the information in /proc/slabinfo be somewhat proportional
> to the number of connections/lines in /proc/net/ip_conntrack?

Yes, the numbers should be in the same ballpark.  Conntracks are being
cleaned from the lists (i.e. /proc/net/ip_conntrack), but never being
destroyed.  In my testing this is caused by a process not freeing
the skb.  What kinds of processes are running on this box?

Phil
