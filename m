From: UMEZAWA Takeshi <umezawa@deneb.freemail.ne.jp>
Subject: 'state' match and ICMP time-exceeded
Date: Tue, 19 Nov 2002 23:25:02 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DDA49BE0.4A5EUMEZAWA@deneb.freemail.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I found a problem in 'state' match. This problem may affects 'traceroute'
command.


Consider this network:

  +-------+ 
  | host1 |
  +-------+
      | 192.168.0.1
|-----+-------------+----| 192.168.0.0/24
                    | eth0,192.168.0.1
                +-------+
                | host0 |
                +-------+
                    | eth1,192.168.1.1
|-----+-------------+----| 192.168.1.0/24
      | 192.168.1.2
  +-------+ 
  | host2 |
  +-------+

All hosts are Linux kernel 2.4.18 (RedHat 7.3). I try to test kernel
2.5.47 but failed due to build error.


First, I add the following rule in host0:

    [root@host0]# iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

this makes Linux a NAT box. It does work, of course.


Second, I add the following rule:

    [root@host0]# iptables -A OUTPUT -o eth0 -m state --state INVALID \
                      -p icmp --icmp-type time-exceeded -j LOG

and run 'traceroute' command at host1:

    [root@host1]# traceroute 192.168.1.2

then, traceroute first sends some packets whose TTL is one. These
packets are caught by NAT box and the NAT sends ICMP time-exceeded
message back to host1. So, result of 'traceroute' should be like:

    traceroute to 192.168.1.2 (192.168.1.2), 30 hops max, 38 byte packets
     1 192.168.0.1  1.563 ms  1.239 ms  2.036 ms
     2 192.168.1.2  3.066 ms  2.355 ms  2.998 ms

However, these time-exceeded messages match the logging rule and
kernel displays following log although this packet is completely VALID.

    IN= OUT=eth0 SRC=192.168.0.1 DST=192.168.0.2 LEN=66 TOS=0x00 PREC=0xC0
    TTL=255 ID=32423 PROTO=ICMP TYPE=11 CODE=0 [SRC=192.168.0.2 DST=192.168.1.2
    LEN=38 TOS=0x00 TTL=1 ID=16053 PROTO=UDP SPT=1030 DPT=33435 LEN=18 ]

So, if I add the following rule, 'traceroute' reports that first router
does not send ICMP time-exceede message back. This must be a bug.

    [root@host0]# iptables -A INPUT   -m state --state INVALID -j DROP
    [root@host0]# iptables -A OUTPUT  -m state --state INVALID -j DROP
    [root@host0]# iptables -A FORWARD -m state --state INVALID -j DROP

    [root@host1]# traceroute 192.168.1.2
    traceroute to 192.168.1.2 (192.168.1.2), 30 hops max, 38 byte packets
     1 * * * 
     2 192.168.1.2  3.066 ms  2.355 ms  2.998 ms
    [root@host1]#

If no NATing rule is given to host0, this problem does not occur.


  +---------------------------------------------------------------+
 / UMEZAWA Takeshi (FAMILY Given) <umezawa@deneb.freemail.ne.jp> /
+---------------------------------------------------------------+
