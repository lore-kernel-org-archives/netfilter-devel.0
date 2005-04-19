From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Mon, 18 Apr 2005 17:58:47 -0700
Message-ID: <20050419005847.GA591@linuxace.com>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4263108E.1030707@trash.net>
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

On Mon, Apr 18, 2005 at 03:42:38AM +0200, Patrick McHardy wrote:
> We have six cases to consider

No...let's simplify it a bit.  At this point the only debate is over retransmit
handling, since I think we are in agreement that storing the client's seq in
correction_pos (not the adjusted seq) is appropriate.  So that solves 1/2 of 
the puzzle.

Since we now store the correct c_p as noted above, we are guaranteed that
ip_nat_seq_adjust will make the correct determination of whether a packet
is a retransmission.

Now assume a retransmit arrives, has offset_before added to it, and reaches
adjust_tcp_sequence.  With my proposed test:

	if (seq - this_way->offset_before != this_way->correction_pos)

which compares the pre-ip_nat_seq_adjust adjustment to the current c_p, I have
difficulty finding any scenario which this would fail to correctly find a
retransmit.

>  2.3. tcph->seq - offset_after > correction_pos &&
>       tcph->seq - offset_before <= correction_pos
> 
>   In this case we can't determine whether the packet is a retransmission
>   and what the original sequence number was.

I think you are failing to recognize that in the first transmit of a given
packet, offset_before and offset_after are adjusted, so that by the time the
retransmit arrives, the tests are different than they were on the first pass.
That possible?

If not, can you provide some sample seq/o_a/o_b numbers which you believe
would fail this test?  

Phil
