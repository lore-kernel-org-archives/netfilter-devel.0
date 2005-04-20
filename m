From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 20 Apr 2005 08:53:08 -0700
Message-ID: <20050420155308.GA7057@linuxace.com>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
	<20050419005847.GA591@linuxace.com> <42666F4C.5080706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42666F4C.5080706@trash.net>
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

On Wed, Apr 20, 2005 at 05:03:40PM +0200, Patrick McHardy wrote:
> offset_before: 1000
> offset_after: -1000
> correction_pos: 1000000
> 
> Sequence number (pre-adjustment): 999500 (retransmit)
> Sequence number (post-adjustment): 1000500
> 
> if (seq - this_way->offset_before != this_way->correction_pos)
> 
> adjusted seq - offset_before = 999500 => passes the test
> adjusted seq - offset_after = 1001500 => not detected as retransmit.
> 
> You assume only identical retransmits of the packet that caused
> the last adjustment. It could also be an older packet or have
> different boundaries. 

Yes, and I believe this is a safe assumption. Take FTP for example.  Packets 
containing the PORT command traverse this function, but not packets containing
the file itself.  If a PORT packet is lost, you will not receive a PORT
packet for a different file before the first is retransmitted.  So it is safe
to assume that the adjustments are occurring sequentially -- not out of order.

So with this assumption, the above example becomes impossible - the 999500
retransmit would have been dealt with prior to a new correction_pos being
set.

This is a very FTP-centric view, but can you think of other protocols helpers
which would not follow this sequential pattern?

> This brings us to a different problem,
> the sequence number at which the correction occured should be
> stored, not the first sequence number contained in the packet.
> But this can be done in a seperate fix.

Given the above assumption, I don't think this is a concern.

Phil
