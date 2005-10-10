From: seb@frankengul.org
Subject: Re: num_possible_cpus() usage in iptables
Date: Mon, 10 Oct 2005 10:52:24 +0200
Message-ID: <20051010085224.GC5157@frankengul.org>
References: <20051009.204734.30319051.davem@davemloft.net>
	<20051010081957.GA5091@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051010081957.GA5091@rama.customers.eurospot.com>
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

On Mon, Oct 10, 2005 at 10:19:57AM +0200, Harald Welte wrote:
> On Sun, Oct 09, 2005 at 08:47:34PM -0700, David S. Miller wrote:
> > 
> > Guys, you can't use this interface like that.
> > 
> > It's a _COUNT_ of the number of possible processors, not the number of
> > the higest PHYSICAL cpu index.
> 
> thanks, Dave.  It's very surprising that nobody apparently hit this
> before.  
> 

Well, I did and it's not so surprising.
2 way Sparc used as firewall are quite uncommon.
Moreover, the bug will bite only on special models that have this numbering.
There shouldn't be too much people in this case.
Please consider me as a worst case scenario :).
(SMP + sparc64 + firewall + cpu 0 and 2).

> I'll cook up a patch later today.
> 
> > will return 2.  This is not just theoretical, Ultra60 sparc64 systems
> > have this exact physical cpu numbering.   
> 
> I see :(
