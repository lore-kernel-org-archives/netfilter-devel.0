From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: new iptables policy match
Date: Wed, 11 Jan 2006 17:17:58 +0100
Message-ID: <BAY103-F18706C52D2ACDEFC5D91E6B2240@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello.
I'm testing the new iptables policy match on a snapshot kernel 
(2.6.15-git7).
This is my simple network diagram:

eth1                  eth0                                     eth0          
           eth1
10.1.2.0/24===172.16.1.247..[ipsec tunnel]..172.16.1.226===10.1.1.0/24
-----2.6.15-git7 linux box-----                         --------2.4/KLIPS 
box----------

I have setup a simple ipsec tunnel between the two linux boxes. So far, so 
good.
I'm pinging from 10.1.2.1 (a system connected to the 10.1.2.0/24 net) to 
10.1.1.1
(a system connected to the 10.1.1.0/24 net). This is iptables -L -v output:

root@Calimero:/tmp/RACOON# iptables -L -v
Chain INPUT (policy ACCEPT 70672 packets, 15M bytes)
pkts bytes target     prot opt in     out     source               
destination

Chain FORWARD (policy DROP 0 packets, 0 bytes)
pkts bytes target     prot opt in     out     source               
destination
   19  1140 ACCEPT     all  --  any    any     anywhere             anywhere 
            policy match dir out pol ipsec strict [0] [1] [2] [3] mode 
tunnel tunnel-dst 10.1.1.0/24 tunnel-src 10.1.2.0/24
    0     0 DROP       all  --  any    any     anywhere             anywhere 
            policy match dir in pol ipsec strict [0] [1] [2] [3] mode tunnel 
tunnel-dst 10.1.2.0/24 tunnel-src 10.1.1.0/24
    0     0 ACCEPT     all  --  any    any     10.1.2.0/24          
10.1.1.0/24
   19  1140 ACCEPT     all  --  any    any     10.1.1.0/24          
10.1.2.0/24

Chain OUTPUT (policy ACCEPT 39941 packets, 7146K bytes)
pkts bytes target     prot opt in     out     source               
destination

As you can see the 2nd rule should drop ipsec packets but they aren't 
dropped:
I'm getting back the echo reply packets from 10.1.1.1 to 10.1.2.1
Also the 3rd rule counter doesn't increment.
Deleting the 1st and 2nd rule counter are fine:

root@Calimero:/tmp/RACOON# iptables -L -v
Chain INPUT (policy ACCEPT 73891 packets, 15M bytes)
pkts bytes target     prot opt in     out     source               
destination

Chain FORWARD (policy DROP 0 packets, 0 bytes)
pkts bytes target     prot opt in     out     source               
destination
   66  3960 ACCEPT     all  --  any    any     10.1.2.0/24          
10.1.1.0/24
   66  3960 ACCEPT     all  --  any    any     10.1.1.0/24          
10.1.2.0/24

Chain OUTPUT (policy ACCEPT 41881 packets, 7285K bytes)
pkts bytes target     prot opt in     out     source               
destination

I know that this patches are "work in progress" and my apologies if this is
a know problem, but I would like to know is this is a know issue.
PS: I'm using iptables v1.3.4-20060109 on Slackware 10.2
