From: Mark Huang <mlhuang@CS.Princeton.EDU>
Subject: [PATCH] Fix ipt_ULOG panics on SMP kernels
Date: Thu, 10 Aug 2006 12:31:10 -0400
Message-ID: <44DB5F4E.2080608@cs.princeton.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020609070602050803020506"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------020609070602050803020506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've run into the same kernel panic as these reports:

https://lists.gnumonks.org/pipermail/ulogd/2005-August/000776.html
http://lists.netfilter.org/pipermail/netfilter/2006-January/064509.html
https://lists.gnumonks.org/pipermail/ulogd/2006-April/000853.html

On various SMP machines. The culprit is a null ub->skb in ulog_send(). I believe
that this can occur for the following reason. If ulog_timer() has already been
scheduled on one CPU and is spinning on the lock, and ipt_ulog_packet() flushes
the queue on another CPU by calling ulog_send() right before it exits (because
the threshold is reached), there will be no skbuff when ulog_timer() acquires
the lock and calls ulog_send(). Cancelling the timer in ulog_send() doesn't help
   because it has already been scheduled and is running on the first CPU.

There are two solutions that I can see: re-allocate ub->skb at the end of
ipt_ulog_packet(), just like it does toward the beginning of the function. But
the problem will still happen if the allocation fails. The second solution,
implemented by the attached patch, is to just return from ulog_send() if ub->skb
is null.

Regards,

--Mark


--------------020609070602050803020506
Content-Type: text/x-patch;
 name="ipt_ULOG.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_ULOG.patch"

Index: linux-2.6/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
RCS file: /cvs/linux-2.6/net/ipv4/netfilter/ipt_ULOG.c,v
retrieving revision 1.6
diff -u -r1.6 ipt_ULOG.c
--- linux-2.6/net/ipv4/netfilter/ipt_ULOG.c	27 Jul 2006 22:00:49 -0000	1.6
+++ linux-2.6/net/ipv4/netfilter/ipt_ULOG.c	10 Aug 2006 16:30:42 -0000
@@ -120,6 +120,11 @@
 	if (ub->qlen > 1)
 		ub->lastnlh->nlmsg_type = NLMSG_DONE;
 
+	if (!ub->skb) {
+		DEBUGP("ipt_ULOG: ulog_send: nothing to send\n");
+		return;
+	}
+
 	NETLINK_CB(ub->skb).dst_group = nlgroupnum + 1;
 	DEBUGP("ipt_ULOG: throwing %d packets to netlink group %u\n",
 		ub->qlen, nlgroupnum + 1);


--------------020609070602050803020506--
