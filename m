From: "Shu Tao" <shutao@seas.upenn.edu>
Subject: SNAT/DNAT for ongoing UDP flows
Date: Tue, 18 Feb 2003 23:43:50 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000701c2d7ea$a49a2600$e943829e@mississippi>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

My application scenario is as follows:

A Linux box with Netfilter is connected to two different ISP's and acting
like a
gateway to other computers in the LAN. For some reason it needs to switch
its
outgoing traffic of a UDP flow from one ISP connection to the other.
In the meantime, the switching needs to be transparent to the application
(assume
that the process at the other end is a silly UDP receiver and receives
whatever
packets coming to it as long as the dst port is the same).

The way of doing that seems to either alter the src or dst address of that
flow's packets
so that the routing engine will forward them differently. Is there a way of
doing that
with iptables? Obviously, applying SNAT/DNAT will not affect the packets
unless
the application reinitialize the flow.

Any suggestion? Many thanks in advance.

S.T.
