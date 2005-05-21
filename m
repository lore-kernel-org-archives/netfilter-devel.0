From: Nagy Zoltan <kirk@elte.hu>
Subject: ipt_NOTRACK - icmp redirect problem
Date: Sat, 21 May 2005 06:48:12 +0159
Message-ID: <428EBDA2.10003@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

hi

i've encountered a problem with NOTRACK, if a packet which isn't tracked emits an icmp-redirect,
it appears on lo instead of the in device, and messages appear from kernel like:
Redirect from 192.168.245.100 on lo about 172.16.92.1 ignored.
   Advised path = 0.0.0.0 -> 0.0.0.0, tos 00


ip r f t tx_in
ip r f t tx_out
#ip r f t local

ip l s eth1 up
ip l s eth2 up
ip a f dev eth1
ip a f dev eth2

ip a a 0.0.0.0 dev eth1
#ip a a 192.168.11.100/24 dev eth1
#ip a a 192.168.34.100/24 dev eth2

ip r a 172.16.92.0/24 dev eth1
ip r a 192.168.11.0/24 dev eth1
#ip r a 172.16.92.0/24 dev eth1
#ip r a 192.168.11.0/24 dev eth1
ip ru add iif eth1 table tx_in
ip ru add iif eth2 table tx_out

ip r a 172.16.92.0/24 dev eth1          t tx_in
ip r a 192.168.11.0/24 dev eth1         t tx_in
#ip r a default via 192.168.34.1 dev eth2 t tx_in

iptables -t raw -F
iptables -t raw -A PREROUTING -p icmp -j NOTRACK

#ip r a

echo 1 >/proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/conf/all/log_martians
