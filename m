From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: policy routing on locally generated packets [summary]
Date: 27 Aug 2003 16:58:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1061996331.3360.51.camel@henrik.marasystems.com>
References: <Pine.LNX.4.44.0308262141080.16076-100000@filer.marasystems.com>
	 <1061995596.1247.28.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Patrick Schaaf <bof@bof.de>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
In-Reply-To: <1061995596.1247.28.camel@drs0.manchotnetworks.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

ons 2003-08-27 klockan 16.46 skrev lartc@manchotnetworks.net:

> final conclusion:
> to effectively obtain policy routing on locally generated packets, the
> OUTPUT ROUTING process would need to be hooked into netfilter thereby
> letting packets be marked. OUTPUT ROUTING would then use the mark to
> find a routing table via a routing rule.

But it is... The OUTPUT mangle chain is before routing. The exception is
source address assignment on unbound sockets which is part of building
the packet to send. The source IP address assignment is not really a
routing decision but uses the same engine in the kernel.

If you mangle OUTPUT packets in iptables then the packet will be
rerouted if already routed. But the source IP address is already
assigned and will not be automatically changed unless you instruct
iptables to do so via NAT.

Regards
Henrik

-- 
Henrik Nordstrom <hno@marasystems.com>
MARA Systems AB
