From: Simon Kirby <sim@netnation.com>
Subject: iptables STILL incorrectly using TCP packet contents without
	checking header!
Date: Thu, 31 Mar 2005 10:57:32 -0800
Message-ID: <20050331185732.GA20249@netnation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

Since my post in December, iptables is STILL incorrectly using TCP packet
contents without checking the header.  I bet this is resulting in dropped
connections and other issues all over the place but people aren't easily
able to see why.

Example:

iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset

These two lines will set up a typical stateful TCP firewall that blocks
anything incoming that isn't related to outgoing traffic.  Unfortunately,
it also immediately disconnects any TCP sessions as soon as a corrupted
packet is received.  Why?  Because:

The "state" module checks the TCP checksum.  Good.
The REJECT module uses TCP data without checking the checksum.  Bad.

In fact, a simple "-p tcp --dport 80" also matches without checking the
TCP checksum.  This is bad -- the port could be corrupted!

IMHO:

1: -p tcp needs to verify that the IP header is valid (it probably does
   this already), since the protocol is specified there.

2: -p tcp --dport 80 needs to verify that the IP _AND_ TCP header is
   valid, since the port is in the TCP header.  It does not do this now.

3: REJECT needs to verify that the data it is using in --tcp-reset is
   actually valid, because it can be used with just "-p tcp".  ICMP
   REJECT might also need checking.

Right?  Does this make sense?  Anyone?

(Yes, I'll fix the corrupted packets next..)

Simon-
