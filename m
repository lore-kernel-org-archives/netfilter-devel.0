From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Sun, 3 Apr 2005 21:40:33 -0700
Message-ID: <20050404044033.GA1847@linuxace.com>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20050403235320.GB28850@linuxace.com>
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


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 03, 2005 at 04:53:20PM -0700, Phil Oester wrote:
> On Sun, Apr 03, 2005 at 09:26:22PM +0200, Patrick McHardy wrote:
> > Great work Phil. One question though: You want to store the pre-adjusted
> > sequence number. What if the packet is a retransmission and
> > offset_before has been applied? If I understand correctly, depending
> > on the delta between offset_after and offset_before, this might cause
> > the before(...) test to give a false positive and screw up the state.
> > In case I'm wrong, could you a patch containing only the necessary
> > changes? I think the final fix for this problem should go in -stable,
> > ideally it would only be a single line "seq -= this_way->offset_after".
> 
> I think you are correct, retransmission would falsely trigger the before.
> Testing a new patch...will likely submit tomorrow.

If the retransmitted packet were the same packet as the last one which was
mangled, the seq will be adjusted by offset_before, which at this point is
the same adjustment as the first packet received via offset_after. So,
seq == correction_pos for the retransmitted packet, and this is fairly trivial
to handle.  This is the only case where I can see before() triggering a false
positive.

As per your request, below is only the bare minimum patch for -stable,
but the other patch to ip_conntrack_ftp for u16->u32 is likely another good
candidate for -stable.

On another note, It would be helpful if you published your tree somewhere so
patches could be based upon it...then I would not have wasted time sending
the u16->u32 patch which someone else submitted but which is not yet in 
mainline or -bk.  Time to consider a -nf snapshot?

Phil


Signed-off-by: Phil Oester <kernel@linuxace.com>



--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ftpstable

diff -ru linux-orig/net/ipv4/netfilter/ip_nat_helper.c linux-stable/net/ipv4/netfilter/ip_nat_helper.c
--- linux-orig/net/ipv4/netfilter/ip_nat_helper.c	2005-03-02 02:37:49.000000000 -0500
+++ linux-stable/net/ipv4/netfilter/ip_nat_helper.c	2005-04-04 00:22:28.929366600 -0400
@@ -76,11 +76,14 @@
 	 * correction, record it: we don't handle more than one
 	 * adjustment in the window, but do deal with common case of a
 	 * retransmit */
-	if (this_way->offset_before == this_way->offset_after
-	    || before(this_way->correction_pos, seq)) {
-		    this_way->correction_pos = seq;
-		    this_way->offset_before = this_way->offset_after;
-		    this_way->offset_after += sizediff;
+	if (seq != this_way->correction_pos) {
+		seq -= this_way->offset_after;
+		if (this_way->offset_before == this_way->offset_after
+		    || before(this_way->correction_pos, seq)) {
+			this_way->correction_pos = seq;
+			this_way->offset_before = this_way->offset_after;
+			this_way->offset_after += sizediff;
+		}
 	}
 	UNLOCK_BH(&ip_nat_seqofs_lock);
 

--uAKRQypu60I7Lcqm--
