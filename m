From: Roberto Nibali <ratz@tac.ch>
Subject: Re: TCP window tracking patch status query for further design considerations
Date: Tue, 08 Oct 2002 15:55:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA2E3D9.3000700@tac.ch>
References: <Pine.LNX.4.33.0210081210410.23021-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jozsef,

Sorry for the length of the email.

> The problem hasn't still been investigated. :-( I have been totally buried
> with other tasks in the last weeks. :-((

I kind of have a case here where I can reliably generate a hang. It's quite 
complex to reproduce though. So far you need multiple interfaces, some secondary 
IP addresses and a rule that only allows connections to the sshd on the packet 
filter (I think it has nothing to do with the setup though). Then you log in and 
do some work. After a while, it seems like a buffer is getting too big, it 
stalls and I start getting DENIES in the kernlog. Sorry for not being more 
specific but I will try to work out an easy test case so you can debug it.

milk-net_tfxdev:~# show-rules && show-routes
RuleNr     Source           Destination      Table    Special
0          all              all              local    n/a
100        all              all              main     n/a
65000      all              all              1        n/a
Destination        Gateway         Source             Iface    R_Type RT_table 
192.168.0.0/24     0.0.0.0         192.168.0.1        eth1            main 
10.10.1.0/24       0.0.0.0         10.10.1.1          eth2            main 
224.0.0.0/24       0.0.0.0         0.0.0.0/0          all      BL     main 
172.27.0.0/16      0.0.0.0         172.27.232.12      eth0            main 
default            172.27.0.1      172.27.232.12      eth0            1
milk-net_tfxdev:~# ip addr show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
     link/ether 00:01:02:96:f9:05 brd ff:ff:ff:ff:ff:ff
     inet 172.27.232.12/16 brd 172.27.255.255 scope global eth0
milk-net_tfxdev:~# ip neigh show
172.27.0.1 dev eth0 lladdr 00:50:04:ac:5e:33 nud reachable
milk-net_tfxdev:~# netstat -an | grep ESTA
tcp        0     48 172.27.232.12:234       192.168.7.1:39094       ESTABLISHED 
milk-net_tfxdev:~# cat /proc/net/ip_conntrack
tcp      6 432000 ESTABLISHED src=192.168.7.1 dst=172.27.232.12 sport=39094 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=39094 use=1
tcp      6 258780 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45152 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45152 use=1
tcp      6 258906 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45233 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45233 use=1
tcp      6 258696 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45052 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45052 use=1
milk-net_tfxdev:~#
milk-net_tfxdev:~# #new connection request from 192.168.7.1
milk-net_tfxdev:~#
milk-net_tfxdev:~# netstat -an | grep ESTA
tcp        0      0 172.27.232.12:234       192.168.7.1:45835       ESTABLISHED 
tcp        0     48 172.27.232.12:234       192.168.7.1:39094       ESTABLISHED 
milk-net_tfxdev:~# cat /proc/net/ip_conntrack
tcp      6 432000 ESTABLISHED src=192.168.7.1 dst=172.27.232.12 sport=39094 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=39094 use=1
tcp      6 258742 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45152 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45152 use=1
tcp      6 258868 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45233 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45233 use=1
tcp      6 258657 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45052 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45052 use=1
tcp      6 431992 ESTABLISHED src=192.168.7.1 dst=172.27.232.12 sport=45835 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45835 use=1
milk-net_tfxdev:~#
milk-net_tfxdev:~# #some work and then hang
milk-net_tfxdev:~#
milk-net_tfxdev:~# netstat -an | grep ESTA
tcp        0   7776 172.27.232.12:234       192.168.7.1:45835       ESTABLISHED 
tcp        0     48 172.27.232.12:234       192.168.7.1:39094       ESTABLISHED 
milk-net_tfxdev:~# cat /proc/net/ip_conntrack
tcp      6 432000 ESTABLISHED src=192.168.7.1 dst=172.27.232.12 sport=39094 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=39094 use=1
tcp      6 258704 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45152 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45152 use=1
tcp      6 258831 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45233 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45233 use=1
tcp      6 258620 CLOSE_WAIT src=192.168.7.1 dst=172.27.232.12 sport=45052 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45052 use=1
tcp      6 292 ESTABLISHED src=192.168.7.1 dst=172.27.232.12 sport=45835 
dport=234 src=172.27.232.12 dst=192.168.7.1 sport=234 dport=45835 use=1
milk-net_tfxdev:~#

ACCEPT INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=192.168.7.1 DST=172.27.232.12 LEN=44 TOS=0x10 PREC=0x00 TTL=253 ID=23543 DF 
PROTO=TCP SPT=45835 DPT=234 WINDOW=8760 RES=0x00 SYN URGP=0
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44216 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42584 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44219 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42585 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44220 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42586 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44221 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42587 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44223 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42588 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44229 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42589 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44237 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42590 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44288 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42591 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200
DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00 
SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44335 
PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10 
PREC=0x00 TTL=63 ID=42592 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00 
ACK URGP=0 ] MTU=1200

One of the problems could be my routing although I don't think it should have an 
effect on netfilter. It seems as if the packets are coming in from 192.168.7.1 
first but after a while we seem to compare against 172.27.0.1. I have multiple 
layers of networks put on the same interface.

Another problem is that I can work on the new session as long as the things I do 
don't generate a certain size of packets. I can't find out right now what size 
this is because I'm working remote over a ton of other networks. I'll improve 
the test case in future.

RULES:
------
milk-net_tfxdev:~# iptables -t filter -nxv -L
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
     pkts      bytes target     prot opt in     out     source 
destination
        6      264 LOG        tcp  --  *      *       192.168.7.1 
172.27.232.12      state NEW tcp spts:1024:65535 dpt:234 flags:0x3F/0x02 LOG 
flags 0 level 4 prefix `ACCEPT INPUT: '
        6      264 ACCEPT     tcp  --  *      *       192.168.7.1 
172.27.232.12      state NEW tcp spts:1024:65535 dpt:234 flags:0x3F/0x02
     2201   158696 ACCEPT     tcp  --  *      *       0.0.0.0/0 
0.0.0.0/0          state ESTABLISHED
       65    37440 LOG        all  --  *      *       0.0.0.0/0 
0.0.0.0/0          LOG flags 0 level 4 prefix `DENY INPUT: '
       65    37440 DROP       all  --  *      *       0.0.0.0/0 
0.0.0.0/0

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
     pkts      bytes target     prot opt in     out     source 
destination
        0        0 LOG        all  --  *      *       0.0.0.0/0 
0.0.0.0/0          LOG flags 0 level 4 prefix `DENY FORWARD: '
        0        0 DROP       all  --  *      *       0.0.0.0/0 
0.0.0.0/0

Chain OUTPUT (policy ACCEPT 1 packets, 328 bytes)
     pkts      bytes target     prot opt in     out     source 
destination
     2079   462106 ACCEPT     tcp  --  *      *       0.0.0.0/0 
0.0.0.0/0          state ESTABLISHED
        0        0 LOG        all  --  *      *       0.0.0.0/0 
0.0.0.0/0          LOG flags 0 level 4 prefix `DENY OUTPUT: '
        0        0 DROP       all  --  *      *       0.0.0.0/0 
0.0.0.0/0
milk-net_tfxdev:~#


Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
