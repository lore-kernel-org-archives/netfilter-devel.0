From: nedco <nedco@unacs.bg>
Subject: some udp packets are not droped due to heavy spoof attack
Date: Fri, 05 Mar 2004 22:02:17 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078524137.2349.10.camel@cold>
Reply-To: nedco@unacs.bg
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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




Hi,

i try to filter some traffic but some of the packets are miss :(


Linux version 2.6.3
iptables v1.2.9
udp traffic is about 4-6MByte per second 

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
pkts bytes target     prot opt   in     out     source          
destination
8502 8944K LOG       udp  --     eth1   *       0.0.0.0/0           
0.0.0.0/0            udp dpt:22       LOG flags 0 level 4
8502 8944K DROP      udp  --     eth1   *       0.0.0.0/0           
0.0.0.0/0            udp dpt:22


Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.185
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=59138 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.90
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=52483 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.142
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=45824 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.150
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=16384 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.104
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=45568 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.216
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=47107 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.91
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=53762 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.109
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=46594 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.13
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=62467 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.65
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=11522 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.126
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=1025 DPT=22 LEN=1032 
Feb 27 09:54:21 shaper kernel: IN=eth1 OUT=eth0 SRC=212.5.150.178
DST=66.193.175.152 LEN=1052 TOS=0x00 PREC=0x00 TTL=126 ID=256 PROTO=UDP
SPT=46083 DPT=22 LEN=1032 



after this router i put other router and i have 
tcpdump -n udp port 22 -c 200
tcpdump: verbose output suppressed, use -v or -vv for full protocol
decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
14:46:35.531086 IP 212.5.150.47.62977 > 66.193.175.152.22: UDP, length:
1024
14:46:35.531201 IP 212.5.150.42.19969 > 66.193.175.152.22: UDP, length:
1024
14:46:37.608255 IP 212.5.150.45.27906 > 66.193.175.152.22: UDP, length:
1024
14:46:37.608345 IP 212.5.150.35.20482 > 66.193.175.152.22: UDP, length:
1024
14:46:39.685715 IP 212.5.150.44.26881 > 66.193.175.152.22: UDP, length:
1024
14:46:39.685798 IP 212.5.150.34.13568 > 66.193.175.152.22: UDP, length:
1024


for me iptables miss some packets 
or is there some other problem 

Is anyone have a idea how to solve this problem?
10x in advance 
