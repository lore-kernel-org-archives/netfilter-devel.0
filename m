From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Mon, 04 Apr 2005 10:27:30 +0200
Message-ID: <4250FA72.3020502@trash.net>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050404044033.GA1847@linuxace.com>
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
> If the retransmitted packet were the same packet as the last one which was
> mangled, the seq will be adjusted by offset_before, which at this point is
> the same adjustment as the first packet received via offset_after. So,
> seq == correction_pos for the retransmitted packet, and this is fairly trivial
> to handle.  This is the only case where I can see before() triggering a false
> positive.

What you are trying to do is to reconstruct the original sequence
number, so lets consider the possible cases:

1. tcph->seq - offset_before <= correction_pos

Since offset_before < offset_after, tcph->seq - offset_after is also
before correction_pos and the original sequence number must have been
tcph->seq - offset_before. In this case the calculated sequence number
is wrong, but no false positive can trigger.

2. tcph->seq - offset_after > correction_pos

Since offset_after > offset_before, tcph->seq - offset_before is also
after correction_pos and the original sequence number must have been
tcph->seq - offset_after. This case is also handled correctly, the
position is updated.

3. tcph->seq - offset_before > this_way->correction_pos &&
    tcph->seq - offset_after <= this_way->correction_pos

In this case we can't determine whether this packet was a retransmission
and what the original sequence number was. Assuming it was offset_after
leaves the case where it really was offset_before handled incorrectly.
In this case it was a retransmit and we don't want to update the state,
using offset_after results in an incorrect sequence number that is
before correction_pos, so this case is also handled correctly.

 > +	if (seq != this_way->correction_pos) {
 > +		seq -= this_way->offset_after;
 > +		if (this_way->offset_before == this_way->offset_after
 > +		    || before(this_way->correction_pos, seq)) {
 > +			this_way->correction_pos = seq;
 > +			this_way->offset_before = this_way->offset_after;
 > +			this_way->offset_after += sizediff;
 > +		}
 >  	}

So in conclusion it seems simply doing "seq -= this_way->offset_after"
without the seq != this_way->correction_pos check handles all cases
correctly. Please someone verify I didn't make a mistake. I think a
comment explaining the cases would also be appropriate.

> As per your request, below is only the bare minimum patch for -stable,
> but the other patch to ip_conntrack_ftp for u16->u32 is likely another good
> candidate for -stable.

Please send an updated patch without the new check and with a comment.
Regarding the u16 patch, I haven't heard of problems related to this
bug, so its not a candidate yet.

> On another note, It would be helpful if you published your tree somewhere so
> patches could be based upon it...then I would not have wasted time sending
> the u16->u32 patch which someone else submitted but which is not yet in 
> mainline or -bk.  Time to consider a -nf snapshot?

Exporting using bitkeeper is painless, for normal diffs I first need to
figure out how to work with triggers. I'll try to do this some time
soon.

Regards
Patrick
