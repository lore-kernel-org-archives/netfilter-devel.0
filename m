From: Patrick Schaaf <bof@bof.de>
Subject: Re: SNAT/DNAT for ongoing UDP flows
Date: Wed, 19 Feb 2003 09:10:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030219081041.GA15180@oknodo.bof.de>
References: <000701c2d7ea$a49a2600$e943829e@mississippi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Shu Tao <shutao@seas.upenn.edu>
Content-Disposition: inline
In-Reply-To: <000701c2d7ea$a49a2600$e943829e@mississippi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Feb 18, 2003 at 11:43:50PM -0800, Shu Tao wrote:
> 
> A Linux box with Netfilter is connected to two different ISP's and acting
> like a gateway to other computers in the LAN. For some reason it needs
> to switch its outgoing traffic of a UDP flow from one ISP connection to
> the other.
[...]
> The way of doing that seems to either alter the src or dst address of that
> flow's packets so that the routing engine will forward them differently.

It seems to be that, on the outgoing side, you'd have to switch BOTH
source and destination addresses.

> Is there a way of doing that with iptables? Obviously, applying SNAT/DNAT
> will not affect the packets unless the application reinitialize the flow.

Not quite. Once a rule in the NAT table has selected a particular
NATting, that decision is remembered in the individual connection's
conntrack entry, until that entry times out due to no traffic.
Even if you change the rule in the NAT table, previous connections
run unaffected. This is a consious design decision, lying at the
core of the implementation, and it's the Right Thing(tm) for practically
all real world requirements - except yours :)

So, what you need, is a method to break this permanent association,
or, alternatively, a method to avoid the scenario. I'll start with
that second alternative, and a proposal that should be "portable":

A) use an application level gateway on the firewall machine, or inside
   the firewall machine. If sitting on the firewall itself, you use
   the REDIRECT target to get the packets from the inside to the
   application level gateway. The application level gateway, using
   local IP addresses from ISP-A and ISP-B, can easily make two
   different outgoing connections, without further NATting there.
   The application level proxy is a simple UDP datagram recv/sender.

This would be my preferred solution, unless the kernel/user/kernel
copying is too slow for your application. On a 1Ghz P-III machine
that has no other significant CPU usage, the solution should be good 
for about 10000 packets per second (don't believe me - measure it!)

Back to the other alternative, here are some ways to achive breaking
of the existing conntrack:

B) change NAT table rule, stop traffic for 130 seconds (e.g. by suitable
   DROP rules in the PREROUTING mangle table).  This should work, because
   UDP connections time out after 120 seconds of inactivity. But it's
   probably undesirable to have such a long wait.
C) Look at the ctnetlink extension in patch-o-matic. It should allow you
   (I hope) to explicitly purge individual connection tracking entries
   from userlevel.
D) Write an iptables target extension, probably designed to be used
   in the mangle table PREROUTING chain, which effects the same
   connection tracking purge. It will be interesting to see what
   parameters such a target would have to take.

Hope this helps.

best regards
  Patrick
