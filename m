From: Mark Huang <mlhuang@CS.Princeton.EDU>
Subject: Re: [PATCH] Fix ipt_ULOG panics on SMP kernels
Date: Fri, 11 Aug 2006 12:45:31 -0400
Message-ID: <44DCB42B.7010009@cs.princeton.edu>
References: <44DB5F4E.2080608@cs.princeton.edu> <44DCAE2E.8040006@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000303060308090302000002"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44DCAE2E.8040006@trash.net>
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
--------------000303060308090302000002
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> If you could add a similar fix to
> net/bridge/netfilter/ebt_ulog.c and net/netfilter/nfnetlink_log.c
> and send me a Signed-off-by: line I'll push it in 2.6.18. Thanks.

Done.

Regards,

--Mark

--------------000303060308090302000002
Content-Type: text/x-patch;
 name="ipt_ULOG.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_ULOG.patch"

Fix kernel panic on various SMP machines. The culprit is a null
ub->skb in ulog_send(). If ulog_timer() has already been scheduled on
one CPU and is spinning on the lock, and ipt_ulog_packet() flushes the
queue on another CPU by calling ulog_send() right before it exits,
there will be no skbuff when ulog_timer() acquires the lock and calls
ulog_send(). Cancelling the timer in ulog_send() doesn't help because
it has already been scheduled and is running on the first CPU.

Similar problem exists in ebt_ulog.c and nfnetlink_log.c.

Signed-off-by: Mark Huang <mlhuang@cs.princeton.edu>

Index: linux-2.6/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
RCS file: /cvs/linux-2.6/net/ipv4/netfilter/ipt_ULOG.c,v
retrieving revision 1.1.3.6
retrieving revision 1.7
diff -u -r1.1.3.6 -r1.7
--- linux-2.6/net/ipv4/netfilter/ipt_ULOG.c	27 Jul 2006 20:49:21 -0000	1.1.3.6
+++ linux-2.6/net/ipv4/netfilter/ipt_ULOG.c	10 Aug 2006 17:50:14 -0000	1.7
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
Index: linux-2.6/net/bridge/netfilter/ebt_ulog.c
===================================================================
RCS file: /cvs/linux-2.6/net/bridge/netfilter/ebt_ulog.c,v
retrieving revision 1.1.3.2
diff -u -r1.1.3.2 ebt_ulog.c
--- linux-2.6/net/bridge/netfilter/ebt_ulog.c	27 Jul 2006 20:49:20 -0000	1.1.3.2
+++ linux-2.6/net/bridge/netfilter/ebt_ulog.c	11 Aug 2006 16:40:16 -0000
@@ -79,6 +79,9 @@
 	if (ub->qlen > 1)
 		ub->lastnlh->nlmsg_type = NLMSG_DONE;
 
+	if (!ub->skb)
+		return;
+
 	NETLINK_CB(ub->skb).dst_group = nlgroup + 1;
 	netlink_broadcast(ebtulognl, ub->skb, 0, nlgroup + 1, GFP_ATOMIC);
 
Index: linux-2.6/net/netfilter/nfnetlink_log.c
===================================================================
RCS file: /cvs/linux-2.6/net/netfilter/nfnetlink_log.c,v
retrieving revision 1.1.3.1
diff -u -r1.1.3.1 nfnetlink_log.c
--- linux-2.6/net/netfilter/nfnetlink_log.c	27 Jul 2006 20:49:21 -0000	1.1.3.1
+++ linux-2.6/net/netfilter/nfnetlink_log.c	11 Aug 2006 16:40:16 -0000
@@ -369,6 +369,9 @@
 	if (inst->qlen > 1)
 		inst->lastnlh->nlmsg_type = NLMSG_DONE;
 
+	if (!inst->skb)
+		return 0;
+
 	status = nfnetlink_unicast(inst->skb, inst->peer_pid, MSG_DONTWAIT);
 	if (status < 0) {
 		UDEBUG("netlink_unicast() failed\n");

--------------000303060308090302000002--
