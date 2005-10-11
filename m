From: Dan Good <nfdevel@gooddan.com>
Subject: ipq_flush doesn't work with NF_ACCEPT?
Date: Tue, 11 Oct 2005 14:42:22 -0400
Message-ID: <E1EPP4w-0003Ly-00@skip.gooddan.com>
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

Hi everyone,

I'm new to the list and am looking for some help.  I wanted to
try a scenario where, if the user space program reading the
queue died, the remaining packets in the queue would be accepted
instead of dropped.  To that end, I made a small change to
ip_queue.c in __ipq_reset to change the arg to __ipq_flush
from NF_DROP to NF_ACCEPT (diff below, based on linux 2.6.12
version).

The result seems to be that, no matter how many packets are
in the queue, only the first one arrives at the destination.
Please, can anyone shed some light on this?  Thanks.


--- ip_queue.c.bak      Tue Oct 11 14:40:46 2005
+++ ip_queue.c  Tue Oct 11 14:40:56 2005
@@ -169,13 +169,13 @@
 static inline void
 __ipq_reset(void)
 {
        peer_pid = 0;
        net_disable_timestamp();
        __ipq_set_mode(IPQ_COPY_NONE, 0);
-       __ipq_flush(NF_DROP);
+       __ipq_flush(NF_ACCEPT);
 }
 
 static struct ipq_queue_entry *
 ipq_find_dequeue_entry(ipq_cmpfn cmpfn, unsigned long data)
 {
        struct ipq_queue_entry *entry;
