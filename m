From: Amit Kucheria <akucheria@metricsystems.com>
Subject: best place to tap all packets?
Date: Thu, 05 Jun 2003 09:25:18 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054830319.1607.3.camel@amit.metricsystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Linux-Netfilter-devel Mailing list <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all, 

I wish to capture *all* packets flowing through a Linux system in order
to act upon it (delay, drop, inject additional packets). 

For incoming packets, I need to simply record some
accounting/control/state information from the packets and then send them
on their way up the stack. 

For outgoing packets, I need to queue them and then based on the control
information that I have gathered, drop them, or release them or inject
other packets into the outgoing queues. 

Currently, I see the following choices: 

1. Hack Netfilter to capture these packets and QUEUE/steal(STOLEN) them?
   Then process them in userspace and reinject them if necessary.

Q. What are the latencies experienced in transferring packets to
userspace? Are there numbers available?

2. Create a custom 'slice' to capture packets: 
- For incoming packets this might in net_bh() or maybe a new bottom half
that is scheduled instead of net_bh from netif_rx(). This new BH will
then call net_bh after it is done with its processing. 
- For outgoing packets this could be one of the ip_*_output() routines
in ip_output.c that would pass the packet to my code which would then
pass them to ip_finish_output (or something similar) when the packet
needs to be sent out. 

Does anybody have any comments on this? I am concerned about the
latencies involved in moving all packets to userspace using netfilter. 

Q. Is it possible to queue packets inside the kernel some place using
netfilter? Maybe my kernel module could then process these packets.

Q. Whats the best way to capture ARP packets?

Thanks for you time.

Regards,
Amit
-- 
----------------------------------------------------------------------
Amit Kucheria          akucheria@<NOSPAM>metricsystems.com
Metric Systems Corp.   2320 Cousteau Court, Suite 201, Vista, CA 92083
----------------------------------------------------------------------
