From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Wed, 26 Jun 2002 20:04:19 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <04f801c21d3b$e5395150$0489cb8a@etbx180>
References: <20020625151007.980D14140@lists.samba.org> <15640.41407.432907.402311@isis.cs3-inc.com> <046a01c21c91$dd980b80$0489cb8a@etbx180> <20020626145011.GC8557@naboo.rchrd.phub.net.cable.rogers.com>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > (strange thing is that ethernet irq's reported by procinfo are 
> >  decreasing when the machine is overloaded. It suppose that it 
> >  means either that irq's are not even caught by the kernel/driver, 
> >  which is quite worrying, or either that irq's counters refer to 
> >  'processessed' interrupts)
> 
> are you using a driver which uses the irq mitigation interface of 2.4.x
> or the NAPI of 2.5.x ?

no. (is it available for non Gigabit ethernets?). I'm using 3c905-TX.

one explanation could be that, SYN packets are 'lost'/not processed, and
there are thus no additional SYN/ACK,ACK (at least), and thus no extra 
flow (each connection was made of about 10 packets). Since packets 
don't get forwarded, the same applies for the other interface. 
It means also that most retransmissions get lost.

> 
> > Harld: could you ask to your kernel specialist what is the weakpoint of
> > kmem_cache_alloc()? (locks, allocs, ...), and how we could possibly
> > improve it (batch alloc, but isn't it already the case?)
> 
> I don't think that the slab allocator is the bottleneck. please show me
> profiling data pointing this out.
> 

yesss, facts... but in the mean time, grabbing info/experience/feelings 
from 'non involved' people could be instructive. what do they say?

> - Harald Welte

kr,
-jmhe-
