From: Luca Raggi <llr@raggi.org>
Subject: Re: SNAT & default route
Date: Mon, 23 Jun 2003 09:23:08 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E19UU5v-0004Ln-00@raggi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Chris Wilson" <chris@netservers.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Chris;

Thanks for your answer!

> > - Using MARK, CONNMARK, and fwmark to select an iproute2 table with the
> >   right default gateway. While the marks are set correctly (for both 
> > packet
> >   N=1 and packets N>=2), in the end the routing decision is apparently
> >   discarded, and the main default is used anyways (for all values of N.)
> >   This only happens for forwarded/SNAT'ed packets, however. Locally
> >   originating packets and non-SNAT'ed forwarded packets get routed
> >   correctly (via "ip rule from"'s that point to the same tables that the
> >   higher-priority "ip rule fwmark"'s point to.)
> 
> I haven't tried this with CONNMARK, but I know that iproute+MARK works 
> because I've used it. Can you post examples of what rules you are using?

Be happy to. Since they're a bit hairy, let me try to explain the gist
of it first. The basic plan is:

1. Set mark to one of three values in mangle/PREROUTING.
2. Have the routing code use the mark to pick the appropriate
   gateway/device.
3. Have nat/POSTROUTING use the mark to pick the appropriate source IP
   to SNAT to.

However, this is complicated by the need to use the same gateway/device 
for all packets of a TCP connection, since the choice of outbound 
provider is based on load conditions that are likely to change, but the 
route needs to remain consistent. The revised plan is:

1. Begin mangle/PREROUTING with a "CONNMARK restore". For estabilished
   TCP connections that have been SNAT'ed, this will set the mark to
   the value it had for the first packet, as per 2 & 3 below. The
   CONNMARK restore is harmless to other connections, leaving the mark
   unset for those.
2. If the mark is yet unset at this point in mangle/PREROUTING, and we
   determine that this is the first packet of a connection we wish to
   SNAT, then set it to one of three values.
3. Begin nat/PREROUTING with a "CONNMARK save". This chain is bypassed
   by all SNAT'ed packets but the first, so the mark is saved at most
   once per connection.
4. Have the routing code use the mark to pick the appropriate
   gateway/device.
5. Have nat/POSTROUTING use the mark to pick the appropriate source IP
   to SNAT to.

Without further adoo, here are the rules:

iptables -t mangle -N MARKPICKER
iptables -t mangle -A MARKPICKER -m lbalance --test 0 -j MARK --set-mark 
0x11
iptables -t mangle -A MARKPICKER -m lbalance --test 1 -j MARK --set-mark 
0x12
iptables -t mangle -A MARKPICKER -m lbalance --test 2 -j MARK --set-mark 
0x13
# catch-all, were all three tests to fail:
iptables -t mangle -A MARKPICKER -m mark ! --mark 0x10/0x10 -j MARK 
--set-mark 0x11
...
iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark
iptables -t mangle -A PREROUTING -i lo -j ACCEPT
iptables -t mangle -A PREROUTING -i eth0 -m lbalance --record 0
iptables -t mangle -A PREROUTING -i eth1 -m lbalance --record 1
iptables -t mangle -A PREROUTING -i eth2 -m lbalance --record 2
iptables -t mangle -A PREROUTING -s 10.64.0.0/12 -m mark ! --mark 
0x10/0x10 -j MARKPICKER
...
iptables -t nat -A PREROUTING -j CONNMARK --save-mark
...
iptables -t nat -A POSTROUTING -m mark --mark 0x11 -j SNAT --to-source 
$IP1
iptables -t nat -A POSTROUTING -m mark --mark 0x12 -j SNAT --to-source 
$IP2
iptables -t nat -A POSTROUTING -m mark --mark 0x13 -j SNAT --to-source 
$IP3
...
# ...commands to replicate all the routes in the three tables omitted...
ip route add default via $GW1 table t1
ip route add default via $GW2 table t2
ip route add default via $GW3 table t3
...
ip rule add fwmark 17 table t1 priority 100
ip rule add fwmark 18 table t2 priority 100
ip rule add fwmark 19 table t3 priority 100


To verify it all works (at least on the netfilter side), here are the 
counters after a few SNAT'ed connections:


# iptables -t mangle -L -v
Chain PREROUTING (policy ACCEPT 977 packets, 179K bytes)
 pkts bytes target     prot opt in     out     source               
destination         
 1026  184K CONNMARK   all  --  any    any     anywhere             
anywhere           CONNMARK restore 
   49  5087 ACCEPT     all  --  lo     any     anywhere             
anywhere           
   83 20717            all  --  eth0   any     anywhere             
anywhere           lbalance record 0 
  159 38095            all  --  eth1   any     anywhere             
anywhere           lbalance record 1 
  143 62608            all  --  eth2   any     anywhere             
anywhere           lbalance record 2 
  145  9564 MARKPICKER  all  --  any    any     10.64.0.0/12         
anywhere           MARK match !0x10/0x10 

Chain INPUT (policy ACCEPT 3043 packets, 369K bytes)
 pkts bytes target     prot opt in     out     source               
destination         

Chain FORWARD (policy ACCEPT 1280 packets, 195K bytes)
 pkts bytes target     prot opt in     out     source               
destination         

Chain OUTPUT (policy ACCEPT 1956 packets, 373K bytes)
 pkts bytes target     prot opt in     out     source               
destination         

Chain POSTROUTING (policy ACCEPT 953 packets, 236K bytes)
 pkts bytes target     prot opt in     out     source               
destination         

Chain MARKPICKER (1 references)
 pkts bytes target     prot opt in     out     source               
destination         
  103  6949 MARK       all  --  any    any     anywhere             
anywhere           lbalance test 0 MARK set 0x11 
   20  1232 MARK       all  --  any    any     anywhere             
anywhere           lbalance test 1 MARK set 0x12 
   22  1383 MARK       all  --  any    any     anywhere             
anywhere           lbalance test 2 MARK set 0x13 
    0     0 MARK       all  --  any    any     anywhere             
anywhere           MARK match !0x10/0x10 MARK set 0x11 


# iptables -t nat -L -v
Chain PREROUTING (policy DROP 11 packets, 2012 bytes)
 pkts bytes target     prot opt in     out     source               
destination         
  123  9424 CONNMARK   all  --  any    any     anywhere             
anywhere           CONNMARK save 

Chain POSTROUTING (policy ACCEPT 34 packets, 2201 bytes)
 pkts bytes target     prot opt in     out     source               
destination         
    9   540 SNAT       all  --  any    any     anywhere             
anywhere           MARK match 0x11 to:$IP1
   16   960 SNAT       all  --  any    any     anywhere             
anywhere           MARK match 0x12 to:$IP2
   17  1020 SNAT       all  --  any    any     anywhere             
anywhere           MARK match 0x13 to:$IP3

Chain OUTPUT (policy ACCEPT 22 packets, 1625 bytes)
 pkts bytes target     prot opt in     out     source               
destination         


Ugh, that was a mouthful. The key points are:

1. The mark is verifiably getting set in mangle/PREROUTING.
2. The routing code (should) use it in the routing decision to pick
   the table with the right default gw. If it does, the decision is
   getting overridden somewhere later.
3. The mark is verifiably still set to the right value by the
   time we hit nat/POSTROUTING. Since not even the first packet
   is going out the right interface, the problem is endemic and
   not due to CONNMARK somehow not working as expected.


> > - Using the ROUTE target in various places to try to force the correct
> >   behavior. Unfortunately, trying to ROUTE before SNAT'ing bypasses the
> >   SNAT'ing, and ROUTE'ing after the SNAT'ing is apparently impossible,
> >   since there's no chain after the nat/POSTROUTING chain in which to place
> >   the ROUTE rule.
> 
> How about placing your ROUTE rule in mangle/FORWARD? There may be issues 
> with the nat table only seeing the first packet of each connection.

Sorry for conveying the impression that I was putting a ROUTE rule in 
nat/POSTROUTING. In fact all ROUTE rules must be in mangle, and even if I 
were able to put one in nat/POSTROUTING, it couldn't be placed after the 
SNAT since the SNAT is a terminating target, not to mention it'd only 
apply to the first packet just as you say (though it'd be nice to see 
*ONE* packet going out the right interface for a change ;-)

I did try placing it in mangle/FORWARD, and the results were the same as 
when I placed it in mangle/POSTROUTING. Both are processed before 
nat/POSTROUTING, unfortunately.

> If you put the ROUTE rule into mangle/POSTROUTING and the SNAT rule into 
> nat/POSTROUTING, does it prevent the SNAT from being read?

Yep. Glancing at the source, the problem seems to be that unless certain 
conditions are met, the ROUTE target resorts to stealing the packet and 
delivering it manually. Running tcpdump shows a bunch of SYN packets 
going out to the public internet via the right interface, but with a 
10.64.0.0/12 source address :-(

Regards,
Luca Raggi
