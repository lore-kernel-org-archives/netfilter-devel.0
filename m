From: Steve D <stevedy2003@yahoo.com>
Subject: multiport extension --ports parameter problem
Date: Thu, 14 Aug 2003 04:23:29 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030814112329.63994.qmail@web80710.mail.yahoo.com>
References: <20030813234901.19712.96716.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030813234901.19712.96716.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi:

I'm doing a test on the multiport extension of
iptables and it seemed the --ports parameter did not
funtion the same as described in the man page.My test
procedure is as follows:

1. set iptables rules:
  iptables -F
  iptables --policy FORWARD DROP
  iptables -A FORWARD -p udp --ports 5 -j ACCEPT

2. send a udp packet with source port=5, destination
port=5, and the packet was accepted. (This test case
functioned the same as in the man page.)

3. send a udp packet with source port=5, destination
port=10, and the packet was accepted. (This test case
did not function the same as in the man page.)

4. send a udp packet with source port=10, destination
port=5, and the packet was accepted. (This test case
did not function the same as in the man page.)

5. send a udp packet with source port=10, destination
port=10, and the packet was dropped. (This test case
functioned the same as in the man page.)


As a conclusion, a packet is accepted if either the
source port or the destination port is one of the
given ports. In the man page, it says a packet is
accepted if the source port and the destination port
are the same and equal to one of the given ports.

Could anybody tell me if this is a reported bug, or
there is something wrong with my test plan? Thanks!

Steve

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
