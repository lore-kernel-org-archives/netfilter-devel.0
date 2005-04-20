From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 20 Apr 2005 10:24:06 -0700
Message-ID: <20050420172406.GB7057@linuxace.com>
References: <20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
	<20050419005847.GA591@linuxace.com> <42666F4C.5080706@trash.net>
	<20050420155308.GA7057@linuxace.com> <42667E51.3060005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42667E51.3060005@trash.net>
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

On Wed, Apr 20, 2005 at 06:07:45PM +0200, Patrick McHardy wrote:
> IIRC I've seen an FTP client that continued issueing commands during a
> transfer, but I don't remeber which one exactly.

At this moment, multi-file FTP is broken for all clients -- should we fix
this first, and worry about potential statistical outliers later?

> >So with this assumption, the above example becomes impossible - the 999500
> >retransmit would have been dealt with prior to a new correction_pos being
> >set.
> 
> You forget about the network, which can duplicate, delay and reorder
> packets. If we don't handle this is it will screw up the state.

I'm aware of that, but again I claim that it is irrelevant in this case
because the PORT commands will not be processed out of order (even if the
data packets are), and thus the adjustments will occur sequentially.

> >This is a very FTP-centric view, but can you think of other protocols 
> >helpers
> >which would not follow this sequential pattern?
> 
> No, but this function should do the right thing anyway.

Agreed, but IMHO my approach is currently the best available fix for a problem
which is affecting many people.  If further testing shows it can be improved,
that is great -- but I certainly don't think it's any worse than the current
broken behaviour.

> >>This brings us to a different problem,
> >>the sequence number at which the correction occured should be
> >>stored, not the first sequence number contained in the packet.
> >>But this can be done in a seperate fix.
> >
> >Given the above assumption, I don't think this is a concern.
> 
> It is. Assume a FTP control packet that contains a PORT command
> at some offset. The MTU changes and the packet is retransmitted
> as three seperate packets, with the PORT command contained in the
> third packet. The second packet will be incorrectly adjusted.
> Probably not a common condition, but easy to handle correctly,
> so why not.

Ok, another statistical outlier which can be thought about later.

Phil
