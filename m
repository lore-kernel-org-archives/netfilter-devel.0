From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Mon, 18 Apr 2005 03:42:38 +0200
Message-ID: <4263108E.1030707@trash.net>
References: <20050402202438.GA2968@linuxace.com>
	<4250435E.1090309@trash.net>	<20050403235320.GB28850@linuxace.com>	<20050404044033.GA1847@linuxace.com>
	<4250FA72.3020502@trash.net>	<20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050406044806.GA9711@linuxace.com>
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
> On Mon, Apr 04, 2005 at 01:47:16PM -0700, Phil Oester wrote:
> 
>>So as it stands, only retransmits on positive sizediff are handled
>>properly.  But my original check to compensate for this was flawed,
>>since seq != correction_pos when entering adjust_tcp_sequence - but
>>it does seem clear we cannot blindly -= offset_after.
> 
> 
> I've become more convinced that this is the correct approach.  Anticipating
> that you will too, below is an updated patch with comments added.

I have a strong feeling that it is wrong. As you correctly pointed
out, my previous attempt to argue about its correctness was based on
the wrong assumption that offset_before < offset_after, while this is
only one possible case. So let's try again.

The sequence number is adjusted like this:

         if (after(ntohl(tcph->seq), this_way->correction_pos))
                 newseq = ntohl(tcph->seq) + this_way->offset_after;
         else
                 newseq = ntohl(tcph->seq) + this_way->offset_before;

and we need the original sequence number to determine whether this
is a retransmission and, if not, to store it as new correction_pos:

         /* SYN adjust. If it's uninitialized, or this is after last
          * correction, record it: we don't handle more than one
          * adjustment in the window, but do deal with common case of a
          * retransmit */
         if (this_way->offset_before == this_way->offset_after
             || before(this_way->correction_pos, seq)) {
                     this_way->correction_pos = seq;
                     this_way->offset_before = this_way->offset_after;
                     this_way->offset_after += sizediff;
         }

We have six cases to consider (2.3. is the interesting one):

1. offset_before < offset_after
  1.1. tcph->seq - offset_before <= correction_pos

   Since offset_before < offset_after, tcph->seq - offset_after is also
   before correction_pos and the original sequence number must have been
   tcph->seq - offset_before.

   Using offset_after results in an incorrect sequence number, but the
   packet is still correctly identified as a retransmission.

  1.2. tcph->seq - offset_after > correction_pos

   Since offset_before < offset_after, tcph->seq - offset_before is also
   after correction_pos and the original sequence number must have been
   tcph->seq - offset_after.

   Using offset_after is obviously correct.

  1.3. tcph->seq - offset_before > correction_pos &&
       tcph->seq - offset_after <= correction_pos

   In this case we can't determine whether the packet is a retransmission
   and what the original sequence number was.

   Using offset_after results in an incorrect sequence number when
   really offset_before was used, but the packet is still correctly
   detected as a retransmission.

2. offset_after < offset_before
  2.1. tcph->seq - offset_after <= correction_pos

   Since offset_after < offset_before, tcph->seq - offset_before is also
   before correction_pos and the original sequence number must have been
   tcph->seq - offset_before.

   Using offset_after results in an incorrect sequence number, but the
   packet is still correctly identified as a retransmission.

  2.2. tcph->seq - offset_before > correction_pos

   Since offset_after < offset_before, tcph->seq - offset_after is also
   after correction_pos and the original sequence number must have been
   tcph->seq - offset_after.

   Using offset_after is obviously correct.

  2.3. tcph->seq - offset_after > correction_pos &&
       tcph->seq - offset_before <= correction_pos

   In this case we can't determine whether the packet is a retransmission
   and what the original sequence number was.

   Using offset_after results in an incorrect sequence number when
   really offset_before was used. Unlike in 1.3., in this case the
   packet is (by precondition) _not_ correctly identified as
   a retransmission and causes a false positive.


It is impossible to handle the last case without more information,
since it is correct in some cases, in some it isn't.

So it looks like we need to store this information in the skb. We
don't have much choice, nfcache and about 29 bits in nfctinfo are
available. nfctinfo could be split in two u16 fields to avoid changes
to lots of unrelated code, nfcache should die IMO.

Any other ideas?

Regards
Patrick
