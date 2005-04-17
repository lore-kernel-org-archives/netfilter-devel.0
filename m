From: NIIBE Yutaka <gniibe@fsij.org>
Subject: TCP Connection tracking and SYN/ACK/PSH
Date: Sun, 17 Apr 2005 19:37:18 +0900
Message-ID: <20050417193718.6a7f0809.gniibe@fsij.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ukai@debian.or.jp
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

I got a problem with netfilter connection tracking for TCP.
Kernel version is 2.6.9 (of Debian sarge).

Linux 2.6 cannot connect to (a version of) MELCO Wireless Print
Server.  It is because MELCO Wireless Print Server responds SYN/ACK/PSH, 
when it gets SYN.  And Linux connection tracking for TCP cannot handle
SYN/ACK/PSH.

I found that there is a discussion about SYN/ACK/PSH:
http://www.linuxforum.com/forums/index.php?s=6af41cf69e81a2cde189f6b7168ed535&showtopic=137778&st=0&#entry600234

It seems that it is same issue.

I attach (formatted) output of tcpdump at the end of this message.
Please note the packets with flags SP and ack.

The model of MELCO Wireless Print Server was:
-------------------------------
Server Name    :  WS-363251
Server Model   :  LPV2-WS11GC
F/W Version    :  0.10
-------------------------------

The iptables were:
-------------------------------
# iptables -L
Chain INPUT (policy DROP)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED 
ACCEPT     icmp --  anywhere             anywhere            icmp echo-reply 
ACCEPT     icmp --  anywhere             anywhere            icmp destination-unreachable 
ACCEPT     icmp --  anywhere             anywhere            icmp echo-request 
ACCEPT     icmp --  anywhere             anywhere            icmp time-exceeded 
ACCEPT     udp  --  anywhere             anywhere            udp spt:netbios-ns dpts:1024:65535 

Chain FORWARD (policy DROP)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
-------------------------------

I think that the protocol stack of MELCO Wireless Print Server is
broken or at least, unusual.  But following patch fixes this issue...

--- net/ipv4/netfilter/ip_conntrack_proto_tcp.c~	2004-10-19 06:55:29.000000000 +0900
+++ net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-04-17 18:06:10.000000000 +0900
@@ -754,6 +754,7 @@ static u8 tcp_valid_flags[(TH_FIN|TH_SYN
 {
 	[TH_SYN]			= 1,
 	[TH_SYN|TH_ACK]			= 1,
+	[TH_SYN|TH_PUSH|TH_ACK]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,
------------

Here is the output of tcpdump, 192.168.2.5 is Linux box,
192.168.2.70 is MELCO server.
-------------------------------
16:55:10.649183 IP (tos 0x10, ttl  64, id 26625, offset 0,
		flags [DF], length: 60)
	192.168.2.5.34139 > 192.168.2.70.telnet:
	S [tcp sum ok] 1185703014:1185703014(0) win 5840
	<mss 1460,sackOK,timestamp 277089383 0,nop,wscale 2>
16:55:10.657457 IP (tos 0x0, ttl  30, id 5214, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
16:55:11.829212 IP (tos 0x0, ttl  30, id 5215, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
16:55:13.648646 IP (tos 0x10, ttl  64, id 26627, offset 0,
		flags [DF], length: 60)
	192.168.2.5.34139 > 192.168.2.70.telnet:
	S [tcp sum ok] 1185703014:1185703014(0) win 5840
	<mss 1460,sackOK,timestamp 277092383 0,nop,wscale 2>
16:55:13.655225 IP (tos 0x0, ttl  30, id 5216, offset 0,
		flags [none], length: 40)
	192.168.2.70.telnet > 192.168.2.5.34139:
	. [tcp sum ok] 1:1(0) ack 1 win 1024
16:55:13.836717 IP (tos 0x0, ttl  30, id 5217, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
16:55:15.839199 IP (tos 0x0, ttl  30, id 5218, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
16:55:19.647731 IP (tos 0x10, ttl  64, id 26629, offset 0,
		flags [DF], length: 60)
	192.168.2.5.34139 > 192.168.2.70.telnet:
	S [tcp sum ok] 1185703014:1185703014(0) win 5840
	<mss 1460,sackOK,timestamp 277098383 0,nop,wscale 2>
16:55:19.655215 IP (tos 0x0, ttl  30, id 5220, offset 0,
		flags [none], length: 40)
	192.168.2.70.telnet > 192.168.2.5.34139:
	. [tcp sum ok] 1:1(0) ack 1 win 1024
16:55:19.837037 IP (tos 0x0, ttl  30, id 5222, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
16:55:27.830395 IP (tos 0x0, ttl  30, id 5228, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
16:55:31.645907 IP (tos 0x10, ttl  64, id 26631, offset 0,
		flags [DF], length: 60)
	192.168.2.5.34139 > 192.168.2.70.telnet:
	S [tcp sum ok] 1185703014:1185703014(0) win 5840
	<mss 1460,sackOK,timestamp 277110383 0,nop,wscale 2>
16:55:31.657868 IP (tos 0x0, ttl  30, id 5231, offset 0,
		flags [none], length: 40)
	192.168.2.70.telnet > 192.168.2.5.34139:
	. [tcp sum ok] 1:1(0) ack 1 win 1024
16:55:43.834948 IP (tos 0x0, ttl  30, id 5239, offset 0,
		flags [none], length: 44)
	192.168.2.70.telnet > 192.168.2.5.34139:
	SP [tcp sum ok] 8419755:8419755(0) ack 1185703015 win 1024 <mss 1024>
-------------------------------
-- 
