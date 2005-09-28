From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: CLUSTERIP problem
Date: Wed, 28 Sep 2005 17:01:19 +0300
Message-ID: <20050928140119.GA13135@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


	Hello,

	iptables 1.3.3 (compiled by me), kernel 2.6.12-1.1447_FC4smp (FC4) which is 2.6.12.5
with patches I get this:

[root@uber1 ~]# iptables -A INPUT -d AAA.BBB.CCC.DDD -i eth0.68 -p icmp -j CLUSTERIP --new --hashmode sourceip --clustermac 01:23:45:67:89:AB --total-nodes 2 --local-node 1
[root@uber1 ~]# iptables -vnL
Chain INPUT (policy ACCEPT 32802 packets, 41M bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 CLUSTERIP  icmp --  eth0.68 *       0.0.0.0/0            AAA.BBB.CCC.DDD      CLUSTERIP hashmode=sourceip clustermac=80:96:80:F7:89:AB total_nodes=2 local_node=1

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 14057 packets, 1491K bytes)
 pkts bytes target     prot opt in     out     source               destination
[root@uber1 ~]# dmesg
eth0.68: add 89:ab:02:00:01:00 mcast address to master interface
[root@uber1 ~]#

	"--clustermac 01:23:45:67:89:AB", iptables shows
"clustermac=80:96:80:F7:89:AB" and kernel shows "89:ab:02:00:01:00 mcast
address to master interface"

	where is the problem? I'd like not to change the kernel, because i
use GFS/cluster from it and it's a major pain to recompile _and_ make it
work. TIA for any suggestions.
	please CC me as I'm not on the list.


-- 
 Catalin Muresan
 gpg --keyserver pgp.mit.edu --recv-keys 0xFA75D55C
