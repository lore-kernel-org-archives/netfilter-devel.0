From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Does conntrack hash accounts device
Date: Thu, 13 Mar 2003 20:39:54 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001b01c2e972$9ab6a5c0$010f430a@elitecore7>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter@lists.netfilter.org>
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

Hi All,
    I wanted to run following setup

192.9.203.57     192.9.203.203         10.0.0.2(eth1)       10.0.0.1
+---------+                        +-----------------+
+-----------------------+
|windows|------------------| Linux router      |---------+----| Cisco Router
WCCP |
+---------+                        +-----------------+            |
+-----------------------+
g/w 192.9.203.203           g/w 10.0.0.1                    | 203.x.x.x g/w
203.x.x.y

|

Internet

In above Cisco router have single Ethernet interface on which I've a
secondary IP 203.x.x.x  and sends request on internet from that secondary IP
address. Now in cisco I've enabled wccp redirects and in Linux box I insmod
ip_wccp.o. I can see packets reaching to my Linux router via wccp protocol.
Now I've following iptables entries only in NAT. filter and mangle tables
are empty with Policies ACCEPT.

[root@manage squid]# iptables -L -nv  -t nat
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
    0     0 REDIRECT   tcp  --  eth1   *       192.9.203.57
24.236.246.226     tcp dpt:80 redir ports 3128
    1    44 LOG        all  --  *      *       0.0.0.0/0
24.236.246.226     LOG flags 0 level 4
    1    44 ACCEPT     tcp  --  eth0   *       192.9.203.57
24.236.246.226     tcp dpt:80
    0     0 REDIRECT   tcp  --  eth0   *       192.9.203.0/24
!192.9.203.203      tcp dpt:80 redir ports 3128

Chain POSTROUTING (policy ACCEPT 1 packets, 204 bytes)
 pkts bytes target     prot opt in     out     source
destination
    1    44 ACCEPT     tcp  --  *      *       192.9.203.57
24.236.246.226     tcp dpt:80
    0     0 MASQUERADE  all  --  *      *       192.9.203.0/24
0.0.0.0/0

Chain OUTPUT (policy ACCEPT 1 packets, 204 bytes)
 pkts bytes target     prot opt in     out     source
destination

If i enable logging in mangle PREROUTING for the packet with destination
24.236.246.226 I get expected results

Mar 13 20:24:40 manage kernel: IN=eth0 OUT=
MAC=00:60:e0:00:d9:07:00:08:a1:32:e3:f2:08:00 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=128 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0
Mar 13 20:24:40 manage kernel: IN=eth1 OUT=
MAC=45:00:00:46:fb:84:00:00:ff:2f:19:ce:cb:58 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=126 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0
Mar 13 20:24:40 manage kernel: IN=eth1 OUT=
MAC=45:00:00:46:fb:85:00:00:ff:2f:19:cd:cb:58 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=124 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0
... ... ...
Mar 13 20:24:40 manage kernel: IN=eth1 OUT=
MAC=45:00:00:46:fb:c2:00:00:ff:2f:19:90:cb:58 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=2 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0


    This mean either way communication is working. Now as mentioned in
iptables nat rule packet arriving on eth1 with src=192.9.203.57 and
dst=www.asdf.com should be redirected to my squid server. but unlikely these
packets are getting dropped. I cannot see this packet if I uses LOG mangle
INPUT for this rule. But yes I can see these packets in mangle POSTROUTING.

Mar 13 20:24:40 manage kernel: IN= OUT=eth1 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=127 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0
Mar 13 20:24:40 manage kernel: IN= OUT=eth1 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=125 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0
... ... ...
Mar 13 20:24:40 manage kernel: IN= OUT=eth1 SRC=192.9.203.57
DST=24.236.246.226 LEN=44 TOS=0x10 PREC=0x00 TTL=121 ID=16609 DF PROTO=TCP
SPT=2131 DPT=80 WINDOW=8192 RES=0x00 SYN URGP=0

    Does it means that connection tracking route and sends packets on
decision or hash maintained with src-ip+dst-ip+src-port+dst-port+... but not
device, right? Is it possible to add one more parameter of device into this
hash?
    Things if bother to you then - I've everywhere rp_filter set to 0.

    Thanks,
--Sumit
