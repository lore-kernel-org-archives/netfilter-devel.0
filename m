From: knash@cs.tcd.ie
Subject: changing iphdr->daddr, packet forwarding IP_QUEUE
Date: Sun, 21 Aug 2005 17:05:56 +0100 (IST)
Message-ID: <1972.134.226.1.62.1124640356.squirrel@webmail.cs.tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hello all,
        I'm writing an application which forwards incoming packets
depending on the applications current view of the network.
Packets are sent to userpace with NF_QUEUE.

So iphdr->daddr is either changed to
1) The address of the next hop
2) or a broadcast address

Having changed iphdr->daddr I recalculate iphdr->check,
and call ipq_set_verdict,

But for some reason the packet seems to be dropped,
It doesn't appear at the NF_POST_ROUTING hook

[192.168.225.3] pings 192.168.225.2,
                iphdr->daddr is set to a broadcast address at
NF_IP_LOCAL_OUT

[192.168.225.1] packet arrives at NF_IP_PRE_ROUTING
                iphdr->daddr is set to 192.168.225.2
                Packet disappears

I've changed the /proc/sys/net/ipv4/ip_forward entry to 1

So I was wondering if any you have tried this before or
have any suggestions for a solution.

Thanks very much for your help,
Kevin


ps: Let us know if I can provide any other information
which could be useful :-)



Some Details
Part of Kernel module which contains the NF hooks
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
unsigned int main_hook(unsigned int hooknum,
		       struct sk_buff **skb,
		       const struct net_device *in,
		       const struct net_device *out,
		       int (*okfn)(struct sk_buff*))
{
	struct iphdr *iph =3D (*skb)->nh.iph;


 	/* Only interested in IP packets */
 	if (iph =3D=3D NULL)
    		return NF_ACCEPT;

	switch(hooknum) {

	case(NF_IP_LOCAL_OUT):
            return NF_QUEUE;
	break;

	case(NF_IP_POST_ROUTING):
	     printk("Dst address is %d\n",iph->daddr);

	     ip_route_me_harder (skb);
	break;

	case(NF_IP_PRE_ROUTING):
	     return NF_QUEUE;
	}
  return NF_ACCEPT;
}



Netfilter modules loaded
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Module                  Size  Used by    Tainted: PF
ip_queue                7404   0  (unused)
iptable_filter          2444   0  (autoclean) (unused)
ip_tables              15776   1  [iptable_filter]


Output off iptables --list
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination


Ouput of netstat -s
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Ip:
    125 total packets received
    0 forwarded
    0 incoming packets discarded
    115 incoming packets delivered
    122 requests sent out
Icmp:
    1 ICMP messages received
    0 input ICMP message failed.
    ICMP input histogram:
        echo requests: 1
    1 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        echo replies: 1
Tcp:
    13 active connections openings
    7 passive connection openings
    0 failed connection attempts
    0 connection resets received
    0 connections established
    111 segments received
    111 segments send out
    0 segments retransmited
    0 bad segments received.
    6 resets sent
Udp:
    10 packets received
    0 packets to unknown port received.
    0 packet receive errors
    10 packets sent
TcpExt:
    ArpFilter: 0
    7 TCP sockets finished time wait in fast timer
    1 delayed acks sent
    6 packets directly queued to recvmsg prequeue.
    224 packets directly received from backlog
    76 packets directly received from prequeue
    13 packets header predicted
    4 packets header predicted and directly queued to user
    TCPPureAcks: 14
    TCPHPAcks: 29
    TCPRenoRecovery: 0
    TCPSackRecovery: 0
    TCPSACKReneging: 0
    TCPFACKReorder: 0
    TCPSACKReorder: 0
    TCPRenoReorder: 0
    TCPTSReorder: 0
    TCPFullUndo: 0
    TCPPartialUndo: 0
    TCPDSACKUndo: 0
    TCPLossUndo: 0
    TCPLoss: 0
    TCPLostRetransmit: 0
    TCPRenoFailures: 0
    TCPSackFailures: 0
    TCPLossFailures: 0
    TCPFastRetrans: 0
    TCPForwardRetrans: 0
    TCPSlowStartRetrans: 0
    TCPTimeouts: 0
    TCPRenoRecoveryFail: 0
    TCPSackRecoveryFail: 0
    TCPSchedulerFailed: 0
    TCPRcvCollapsed: 0
    TCPDSACKOldSent: 0
    TCPDSACKOfoSent: 0
    TCPDSACKRecv: 0
    TCPDSACKOfoRecv: 0
    TCPAbortOnSyn: 0
    TCPAbortOnData: 0
    TCPAbortOnClose: 0
    TCPAbortOnMemory: 0
    TCPAbortOnTimeout: 0
    TCPAbortOnLinger: 0
    TCPAbortFailed: 0
    TCPMemoryPressures: 0
