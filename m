From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Tue, 5 Apr 2005 21:48:06 -0700
Message-ID: <20050406044806.GA9711@linuxace.com>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20050404204716.GA4067@linuxace.com>
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


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 04, 2005 at 01:47:16PM -0700, Phil Oester wrote:
> So as it stands, only retransmits on positive sizediff are handled
> properly.  But my original check to compensate for this was flawed,
> since seq != correction_pos when entering adjust_tcp_sequence - but
> it does seem clear we cannot blindly -= offset_after.

I've become more convinced that this is the correct approach.  Anticipating
that you will too, below is an updated patch with comments added.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ftpstable

diff -ru linux-orig/net/ipv4/netfilter/ip_nat_helper.c linux-stable/net/ipv4/netfilter/ip_nat_helper.c
--- linux-orig/net/ipv4/netfilter/ip_nat_helper.c	2005-03-02 02:37:49.000000000 -0500
+++ linux-stable/net/ipv4/netfilter/ip_nat_helper.c	2005-04-06 00:42:48.736295496 -0400
@@ -72,15 +72,23 @@
 
 	LOCK_BH(&ip_nat_seqofs_lock);
 
-	/* SYN adjust. If it's uninitialized, or this is after last
-	 * correction, record it: we don't handle more than one
-	 * adjustment in the window, but do deal with common case of a
-	 * retransmit */
-	if (this_way->offset_before == this_way->offset_after
-	    || before(this_way->correction_pos, seq)) {
-		    this_way->correction_pos = seq;
-		    this_way->offset_before = this_way->offset_after;
-		    this_way->offset_after += sizediff;
+	/* SYN adjust. In the case of a retransmit, ip_nat_seq_adjust has
+	 * added offset_before to client's seq, so subtract it to test
+	 * for retransmit here */
+	if (seq - this_way->offset_before != this_way->correction_pos) {
+		/* If it's uninitialized, or this is after last correction,
+		 * record it. We don't handle more than one adjustment in
+		 * the window */
+		seq -= this_way->offset_after;
+		if (this_way->offset_before == this_way->offset_after
+		    || before(this_way->correction_pos, seq)) {
+			/* Since ip_nat_seq_adjust has added
+			 * offset_after, subtract it to store
+			 * the client's seq in correction_pos */
+			this_way->correction_pos = seq;
+			this_way->offset_before = this_way->offset_after;
+			this_way->offset_after += sizediff;
+		}
 	}
 	UNLOCK_BH(&ip_nat_seqofs_lock);
 

--qDbXVdCdHGoSgWSk--
