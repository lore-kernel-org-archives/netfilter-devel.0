From: Horacio =?iso-8859-1?Q?J=2E_Pe=F1a?= <horape@tinuviel.compendium.com.ar>
Subject: what is blocking packets before netfilter?
Date: Sat, 5 Mar 2005 15:47:15 -0300
Message-ID: <20050305184715.GC29199@tinuviel.compendium.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I have:

# iptables -L -n -t mangle -v
Chain INPUT (policy ACCEPT 19862 packets, 1603K bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion
    0     0 LOG        all  --  eth0   *       192.168.2.0/24       0.0.0.0=
/0           LOG flags 0 level 4

# iptables -L -n -t filter -v
Chain INPUT (policy ACCEPT 17061 packets, 1410K bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion
    0     0 LOG        all  --  eth0   *       192.168.2.0/24       0.0.0.0=
/0           LOG flags 0 level 4

# tcpdump -nvvvpe icmp
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96 by=
tes
15:44:34.189337 00:08:a1:6c:39:00 > 00:0a:e6:2d:90:77, ethertype IPv4 (0x08=
00), length 98: IP (tos 0x0, ttl64, id 1016, offset 0, flags [DF], length: =
84) 192.168.2.1 > 10.5.0.1: icmp 64: echo request seq 63491

00:0a:e6:2d:90:77 is my MAC.

/proc/sys/net/ipv4/conf/*/rp_filter are 0.
/proc/sys/net/ipv4/conf/*/forwarding are 1.

What could be eating the packets? Shouldn't iptables see anything that come=
s to the interface?

Thanks,
					HoraPe
---
Horacio J. Pe=F1a
horape@compendium.com.ar
horape@uninet.edu
