From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Sun, 03 Apr 2005 21:26:22 +0200
Message-ID: <4250435E.1090309@trash.net>
References: <20050402202438.GA2968@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050402202438.GA2968@linuxace.com>
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

Phil Oester wrote:
> In adjust_tcp_sequence, we track the sequence number of any adjustments
> in the correction_pos variable.  The seq stored is based upon the left
> side of the window of the NAT box -- not of the original sender.
> 
> Later, in ip_nat_seq_adjust, we compare the correction_pos variable to
> the seq of the original sender to determine whether this is a new packet
> or a retransmission (i.e. should we apply offset_before or offset_after).
> So we are comparing the post-adjustment seq to a pre-adjustment seq.
> 
> The solution is to store the client's seq number in correction_pos instead
> of the seq of the NAT box.  The below makes this change, as well as cleans up a
> number of broken DEBUGP statements and a couple of u32->u16 casts.  

Great work Phil. One question though: You want to store the pre-adjusted
sequence number. What if the packet is a retransmission and
offset_before has been applied? If I understand correctly, depending
on the delta between offset_after and offset_before, this might cause
the before(...) test to give a false positive and screw up the state.
In case I'm wrong, could you a patch containing only the necessary
changes? I think the final fix for this problem should go in -stable,
ideally it would only be a single line "seq -= this_way->offset_after".

Regards
Patrick

> +	adjustedseq = seq - this_way->offset_after;
>  	if (this_way->offset_before == this_way->offset_after
> -	    || before(this_way->correction_pos, seq)) {
> -		    this_way->correction_pos = seq;
> +	    || before(this_way->correction_pos, adjustedseq)) {
> +		    this_way->correction_pos = adjustedseq;
>  		    this_way->offset_before = this_way->offset_after;
>  		    this_way->offset_after += sizediff;
>  	}
>  	UNLOCK_BH(&ip_nat_seqofs_lock);
>  
> -	DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
> +	DEBUGP("adjust_tcp_sequence: Seq_offset after: ");
>  	DUMP_OFFSET(this_way);
>  }
