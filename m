From: "Nedko Nedev" <nedco@unacs.bg>
Subject: iptables dropping wrong packets
Date: Wed, 5 Mar 2003 19:56:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001901c2e340$848891b0$8268493e@coldunacs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org




Hi,

looks like some of correct packes are droped

table mangle

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source
destination

1    36142    16M ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0         TOS match 0x00
2     168K    54M ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0         TOS match 0x10
3       27       1782 LOG            all  --  *      *       0.0.0.0/0
0.0.0.0/0         LOG  flags 0 level 4
4       27       1782 DROP         all  --  *      *       0.0.0.0/0
0.0.0.0/0


in log we can see packets with TOS 0x0  also packets with TOS 0x10

Mar  5 04:32:10 proliant kernel: IN=eth0 OUT=eth1 SRC=62.176.73.4
DST=62.176.105.30 LEN=76 TOS=0x00 PREC=0xC0
Mar  5 04:32:15 proliant kernel: IN=eth0 OUT=eth1 SRC=62.176.73.4
DST=62.176.105.30 LEN=76 TOS=0x00 PREC=0xC0
Mar  5 04:32:18 proliant kernel: IN=eth1 OUT=eth0 SRC=212.5.149.252
DST=212.5.134.3 LEN=87 TOS=0x00 PREC=0xC0
Mar  5 04:32:19 proliant kernel: IN=eth0 OUT=eth2 SRC=62.176.73.4
DST=62.176.106.69 LEN=88 TOS=0x00 PREC=0xC0
Mar  5 04:32:19 proliant kernel: IN=eth0 OUT=eth1 SRC=62.176.73.4
DST=62.176.105.30 LEN=76 TOS=0x00 PREC=0xC0
Mar  5 04:32:29 proliant kernel: IN=eth0 OUT=eth2 SRC=195.230.9.159
DST=62.176.106.69 LEN=48 TOS=0x00 PREC=0x8
Mar  5 04:32:31 proliant kernel: IN=eth0 OUT=eth1 SRC=62.176.73.4
DST=62.176.105.30 LEN=76 TOS=0x00 PREC=0xC0
Mar  5 04:32:32 proliant kernel: IN=eth0 OUT=eth2 SRC=195.230.9.159
DST=62.176.106.69 LEN=48 TOS=0x00 PREC=0x8

mandrake Linux version 2.4.19-16mdksmp, iptables v1.2.6a
Is there some solution?
10x in advance
Nedko
