From: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Subject: policy routing on locally generated packets
Date: 25 Aug 2003 14:09:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1061813400.1289.36.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Gentle Developers,

May I first start by extending my sincerest gratitude to all that have
particpated in the netfilter project -- needless to say that it has been
of infinite value to me and many, many users. Thanks, thanks, thanks.


So, there has been some traffic over a period of time on the lartc list
concerning application based routing, which translates more specifically
to the issue of how to do policy based routing of locally generated
packets given that the "routing decision" has been made prior to a
packet traversing the OUTPUT chain.
	
Take for example the following script:

#!/bin/bash
iptables --append OUTPUT --table mangle --match owner \
     --gid-owner 500 --jump MARK --set-mark 0x2

iptables --append OUTPUT --table mangle --match owner \
     --gid-owner 501 --jump MARK --set-mark 0x3

ip rule add fwmark 0x2 table 2
ip route add default dev eth0 src 192.168.0.1 via 192.168.0.254 table 2
ip rule add fwmark 0x3 table 3
ip route add default dev eth0 src 192.168.0.2 via 192.168.0.253 table 3
ip route flush cache
#end_script


This is a sample of source ip routing policy, but one could imagine
routing based on tos, etc. Regrettably, this example will not work as
the default routing table is consulted prior to the marking.

While I'm not a programmer but have dreamt up a new target for the
POSTROUTING chain NAT table:

iptables --append POSTROUTING --table nat --jump rt_lookup


The statement would force a new routing decision to be made using the
properties of the packet as it traverses the nat table, respecting any
marking, tos, etc.

Could any of you be kind enough to offer an analysis of such a new
target, i.e. would it work, would it be terribly complex, ...


Sincerely Yours,

Charles Shick
