From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Mon, 4 Apr 2005 13:47:16 -0700
Message-ID: <20050404204716.GA4067@linuxace.com>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4250FA72.3020502@trash.net>
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

On Mon, Apr 04, 2005 at 10:27:30AM +0200, Patrick McHardy wrote:
> So in conclusion it seems simply doing "seq -= this_way->offset_after"
> without the seq != this_way->correction_pos check handles all cases
> correctly. Please someone verify I didn't make a mistake. I think a
> comment explaining the cases would also be appropriate.

I think you are only thinking in terms of positive sizediff, while this
is not always the case.  Perhaps easiest to explain by observed example.

ip_nat_seq_adjust: seq 467631623 after co_pos 467631577
Adjusting sequence number from 467631623->467631622
...
ip_nat_mangle_packet: Shrinking packet by 1 from 66 bytes
adjust_tcp_sequence: sizediff = -1
adjust_tcp_sequence: Seq_offset before: offset_before=0, 
	offset_after=-1, correction_pos=467631577
adjust_tcp_sequence: Seq_offset after: offset_before=-1, 
	offset_after=-2, correction_pos=467631623

Given the above, assume we now receive a retransmit of this packet.
467631623 will have offset_before added to it by ip_nat_seq_adjust,
becoming 467631622.  It will then have offset_after subtracted from
it in adjust_tcp_sequence, making it 467631624, which will then
cause a false positive on the before() test.

If we change the example above to a positive sizediff:

ip_nat_seq_adjust: seq 467631623 after co_pos 467631577
Adjusting sequence number from 467631623->467631624
...
ip_nat_mangle_packet: Extending packet by 1 from 66 bytes
adjust_tcp_sequence: sizediff = 1
adjust_tcp_sequence: Seq_offset before: offset_before=0, 
        offset_after=1, correction_pos=467631577
adjust_tcp_sequence: Seq_offset after: offset_before=1, 
        offset_after=2, correction_pos=467631623

Assuming a retransmit in this example,
467631623 will have offset_before added to it by ip_nat_seq_adjust,
becoming 467631624.  It will then have offset_after subtracted from
it in adjust_tcp_sequence, making it 467631622 which will correctly
evaluate as being before correction_pos.

So as it stands, only retransmits on positive sizediff are handled
properly.  But my original check to compensate for this was flawed,
since seq != correction_pos when entering adjust_tcp_sequence - but
it does seem clear we cannot blindly -= offset_after.

I think this will handle all permutations, since it essentially
reverses ip_nat_seq_adjust's adjustment before checking for retransmit.

        if (seq - this_way->offset_before != this_way->correction_pos) {
                seq -= this_way->offset_after;
                if (this_way->offset_before == this_way->offset_after
                    || before(this_way->correction_pos, seq)) {
                        this_way->correction_pos = seq;
                        this_way->offset_before = this_way->offset_after;
                        this_way->offset_after += sizediff;
                }
        }

Ack?

Phil
