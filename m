From: Michael Gundlach <gundlach@cs.uga.edu>
Subject: PREROUTING doesn't catch all packets?
Date: Wed, 19 Feb 2003 14:18:30 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030219141830.A8641@cs.uga.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi again everyone,

I have the following iptables rules on my bridging Linux box:

iptables -t nat -F
iptables -t nat -A PREROUTING -j QUEUE
iptables -t nat -A OUTPUT -j QUEUE

I then have a box connected to one NIC of the bridge telnet to a box
connected to the other NIC of the bridge.  I use libipq to catch all
packets, print them out, and reinject them.

If I understand things correctly, all packets coming in on either bridge
interface pass through the PREROUTING hook, so I should see every single
one.  However, all I see (aka, all that ipq_read catches) is the SYN packet
from the client to the server.

Worse yet, when I add
  iptables -A FORWARD -j QUEUE
to the list, I see every packet - and the SYN packet twice.  So all packets
hit the FORWARD chain, but only the SYN packet hits the PREROUTING chain!

Am I misusing the nat table or something?  Shouldn't I be able to see all
packets?  (I need to use PREROUTING for an application that is modifying
the destination IP of incoming packets, so "use the FORWARDING chain
instead" isn't a sufficient answer.)

Thanks for your help, everybody.

Michael
