From: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Subject: Re: policy routing on locally generated packets [summary]
Date: 27 Aug 2003 16:46:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1061995596.1247.28.camel@drs0.manchotnetworks.net>
References: <Pine.LNX.4.44.0308262141080.16076-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Patrick Schaaf <bof@bof.de>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0308262141080.16076-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi all, 

well, here's a stab at the summary of this thread, and hopefully a
salient solution:

issues arising from the following situation: 

[probably too big a diagram for the actual samples :-)]

             +------------------------------+ 
lan_a --->   | eth0        alice       eth2 | ----> isp_a 
             |                              | 
lab_b --->   | eth1                    eth3 | ----> isp_b 
             +------------------------------+ 

here's alice's ifconfig 
eth0   191.168.0.254/24 
eth1   192.168.1.254/24 
eth1:1 192.168.1.100/24
eth2   64.12.187.24/8 
eth2:1 64.12.187.25/8 
eth3   149.174.32.7/16 
eth3:1 149.174.32.8/16 

here's alice's default routing table: 
192.168.0.0/24 dev eth0  scope link 
192.168.1.0/24 dev eth1  scope link 
64.12.187.24/8 dev eth2  scope link 
149.174.32.7/16 dev eth3 scope link 
127.0.0.0/8 dev lo  scope link 


we would like that all applications (and their protocols) running under
userid 500 is routed to isp_b: 
 
(A)
iptables --append OUTPUT --table mangle --match owner \ 
         --uid-owner 500 --jump MARK --set-mark 0x2 
ip route add default dev eth3 src 149.174.32.7 table 2 
ip route flush cache 


conclusion: (A) doesn't work because OUTPUT ROUTING did a route lookup
without repsect to the fwmark -- lookup happend before the marking.

(B) 
ip route delete 192.168.1.0/24 dev eth1
ip route add 192.168.1.0/24 dev eth1 src 192.168.1.100
ip route flush cache

conclusion: (B) uses ip src address 192.168.1.100 for all
tcp/ip/udp/icmp communication. OUTPUT ROUTING used the src address
specified in the route.


final conclusion:
to effectively obtain policy routing on locally generated packets, the
OUTPUT ROUTING process would need to be hooked into netfilter thereby
letting packets be marked. OUTPUT ROUTING would then use the mark to
find a routing table via a routing rule. OUTPUT ROUTING would get the
route key fields using the "best" destination route within the routing
table, or use the default routing table if no suitable route was found.
(Cedric -- this would include the iif key therefore obviating/including
your patch through ip route commands)


iptables --append OUTROUTE --table mangle (expressions) \
         --jump MARK --set-mark 0x2


fwmark allows for 32 bits of precision, and it would be hard to imagine
that one would need more than that to implement a routing policy;
therfore, only table mangle need be present (imho) -- it offers plenty
of granularity.

resource issues -- since the fwmark is already part of the route key, it
can be placed in cache as usual.

thoughts, comments, ??

many thanks for all your help.


charles
