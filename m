From: Christian Riechmann <riechmann@fgan.de>
Subject: Need some clarification or help
Date: Tue, 20 Apr 2004 20:22:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040420182205.GA2948@rie.rie.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mail@criechmann.de
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

is it possible to read - via ipq_read/ipq_get_packet - a UDP packetr
and after some changes to accept - via ipq_set_verdict with NF_ACCEPT and
shorter length - it as a TCP packet?

Here is what I wish to do:
For the transmission of IP packets (UDP, ICMP, TCP) between two hosts
I want to send these packets through a UDP tunnel.
On the sender I am using iptables to get all the original packets into user
space for their encapsulation and UDP sending.
In the same way on the receiver I use iptables to get those UDP packets
from the sender enclosing the original packets into user space, where
I decapsulate the original packets and wish to inject these by using
ipq_set_verdict with action set to NF_ACCEPT.
This method works for original packets of type ICMP and UDP, but NOT
for TCP packets.
What I can see from my tcpdump logging on the receiver is:
1.That all three types of original packets are ACCEPTED, but tcpdump
  shows some additional bytes (packet length is still the same as given by
  m->data_len upon the ipq_get_packet call, although the ipq_set_verdict
  call get an updated length).
2.Those original packets of type UDP and ICMP can be read by the intended
  receiver programs but those of type TCP are not presented to the
  intended receiver application.

Below I attach those iptables rules I am using.

# Parameter setting:
#  $1:	Iptable operation "A"
#  $2:  Interface name
#  $3:  IP address of this host
#
# Next rule:
#    Send out all BROADCAST packets
#
#iptables -$1 OUTPUT -o $2 -d 128.7.27.255 --destination-port 140 -j ACCEPT
iptables -$1 OUTPUT -o $2 -d 128.7.27.255 -j ACCEPT

#
# Next rule:
#    Show me all locally generated multicast packets before routing
#
iptables -$1 OUTPUT -o $2 -d 224.0.0.0/4 -j QUEUE

#
# Next rule:
#    Show me all locally generated packets before routing
#
iptables -$1 OUTPUT -o $2 -j QUEUE

#
# Next rule:
#    Show me all UDP packets for port 140 arriving from foreign hosts
#
iptables -$1 INPUT -i $2 -p udp --destination-port 140 -j QUEUE

#
# Next rule:
#    DROP all multicast packet sent by any host except the local one
#
iptables -$1 INPUT -i $2 -s ! $3 -d 224.0.0.0/4 -j DROP


Thanks for any help or clarification.

Christian
-- 
Christian Riechmann    E-Mail: riechmann@fgan.de
c/o FGAN/FKIE          Tel: (+49) 228/9435 345,378
Neuenahrer Strasse 20  Fax: (+49) 228/9435 685
D-53343 Wachtberg, Germany
