From: Igor Fuks <fuks@alarit.com>
Subject: [PATCH] Nexthop match
Date: Sun, 23 Nov 2003 02:42:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <18729960090.20031123024241@alarit.com>
Reply-To: Igor Fuks <fuks@alarit.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------9D9F9326C602D2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

------------9D9F9326C602D2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Attached is a p-o-m patchset containing nexthop match support
for the netfilter.  

This patch adds CONFIG_IP_NF_MATCH_NEXTHOP which allows you to
match firewall rules against address(es) of nexthop of matched packets.

Works for POSTROUTING, FORWARD and OUTPUT chains only.

Options:

--nexthop [!] <ipaddr>[/mask]

Example #1:

iptables -A OUTPUT -m nexthop --nexthop 10.1.1.5 -s 10.1.10.0/24 -j DROP

Means stations in 10.1.10.0/24 net will have not connectivity via 10.1.1.5
neighbour.

Example #2:

Match useful for per peer IP accounting, for example, on Internet eXchanges:

iptables -A FORWARD -m nexthop --nexthop 10.1.1.10
iptables -A FORWARD -m nexthop --nexthop 10.1.1.11
iptables -A FORWARD -m nexthop --nexthop 10.1.1.12
iptables -A FORWARD -m nexthop --nexthop 10.1.1.13

where 10.1.1.10-10.1.1.13 0 are IX peers to account

Example #3:

iptables -t mangle -A POSTROUTING -m nexthop --nexthop 10.1.16.0/24 \
         -j MARK --set-mark 16

Mark all packets going via set of gateways/interfaces identified by nexthop
IP address in 10.1.16.0/24 range

iptables -t mangle -A POSTROUTING -o eth0 \
         -m nexthop --nexthop ! 10.1.64.128/29 -j MARK --set-mark 8

Mark all packets going out via eth0 interface and not via neighbours (peers) 
in 10.1.64.128/29 range

Example #4:

iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o eth1 \
         -m nexthop --nexthop 1.1.1.1 -j SNAT --to-source 1.1.1.10
iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o eth1 \
         -m nexthop --nexthop 2.2.2.2 -j SNAT --to-source 2.2.2.10

where eth1:0 have 1.1.1.10/24 address from ISP 1,
      eth1:1 have 2.2.2.10/24 address from ISP 2,
      1.1.1.1 is nexthop for ISP 1,
      2.2.2.2 is nexthop for ISP 2,
      10.0.0.0/8 is internal network, it needs Internet connectivity via NAT,
      and our system have dynamic routing from both ISPs.
 
                                                 1.1.1.1
                                             +--------- {ISP 1}----+
                          eth1:0 1.1.1.10/24 |                     |
                 eth0                   eth1 |                     |
   {10.0.0.0/8} -----[netfilter router]------+                 {Internet}
                                             |                     |
                          eth1:1 2.2.2.10/24 |    2.2.2.2          |
                                             +--------- {ISP 2}----+


--
Igor Fuks
------------9D9F9326C602D2
Content-Type: application/x-gzip; name="nexthop-pom.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="nexthop-pom.tar.gz"

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
27It27Itf7ryX6Ob868AUAAA


------------9D9F9326C602D2--
