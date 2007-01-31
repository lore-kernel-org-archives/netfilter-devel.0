From: Jim Herbert <jherbert@spsu.edu>
Subject: Established SNAT packets sometimes marked
 as INVALID
Date: Wed, 31 Jan 2007 17:18:08 -0500 (EST)
Message-ID: <20070131171808.AAS61183@mira.spsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Hi,

We've been running a Linux firewall and using NAT for about 8 years without a hitch, but we've just encountered an issue where internal addresses can only receive partial data from specific external sites.  I've taken a sniff on the public side of our firewall and found that while the initial packets from our internal private subnets do traverse NAT tables, shortly into the conversation they are being marked as INVALID, bypassing the NAT translation and are forwarded to our upstream provider.

In the scenario below, 10.220.2.244 is an IP in our internal private network.  168.28.180.22 is one of several public interfaces on our NAT gateway and 131.146.8.66 is the web site (www.oracle.com) which we are attempting to view.  As you can see, the initial conversation takes place between 168.28.180.22 and 141.146.8.66, but later becomes a conversation between 10.220.2.244 and 141.146.8.66.  I placed a log on the 10.220.2.244 IP and found it was being classified as INVALID at the point it all falls apart.

The firewall is running RHEL4-64 and kernel 2.6.9-42.0.8.ELsmp.  We are using SNAT.  This behavior comes and goes and most oddly, only seems to occur with our Windows clients.  No packets are marked as invalid coming from Linux boxes on the same private source nat'd network.

You can find an ethereal trace from the public side below.  Any help would be greatly appreciated!

               -Jim


  0.000000 168.28.180.22 -> 141.146.8.66 TCP 2176 > http [SYN] Seq=0 Len=0 MSS=1420
  0.036603 141.146.8.66 -> 168.28.180.22 TCP http > 2176 [SYN, ACK] Seq=0 Ack=1 Win=8192 Len=0 MSS=1400
  0.045348 168.28.180.22 -> 141.146.8.66 TCP 2176 > http [ACK] Seq=1 Ack=1 Win=1420 Len=0
  0.046871 168.28.180.22 -> 141.146.8.66 HTTP GET / HTTP/1.1
  0.083628 141.146.8.66 -> 168.28.180.22 TCP http > 2176 [ACK] Seq=1 Ack=462 Win=8192 Len=0
  0.085186 141.146.8.66 -> 168.28.180.22 TCP [TCP Window Update] http > 2176 [ACK] Seq=1 Ack=462 Win=6432 Len=0
  0.206846 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.206853 141.146.8.66 -> 168.28.180.22 HTTP HTTP/1.0 302 Moved Temporarily
  0.220444 168.28.180.22 -> 141.146.8.66 TCP 2176 > http [ACK] Seq=462 Ack=885 Win=5680 Len=0
  0.289742 168.28.180.22 -> 141.146.8.66 HTTP GET /index.html HTTP/1.1
  0.326121 141.146.8.66 -> 168.28.180.22 TCP http > 2176 [ACK] Seq=885 Ack=1342 Win=8192 Len=0
  0.326574 141.146.8.66 -> 168.28.180.22 TCP [TCP Window Update] http > 2176 [ACK] Seq=885 Ack=1342 Win=7920 Len=0
  0.357278 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.357286 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.357527 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.370267 168.28.180.22 -> 141.146.8.66 TCP 2176 > http [RST, ACK] Seq=1342 Ack=2285 Win=0 Len=0
  0.370546 168.28.180.22 -> 141.146.8.66 TCP 2176 > http [RST] Seq=1342 Len=0
  0.371427 168.28.180.22 -> 141.146.8.66 TCP 2176 > http [RST] Seq=1342 Len=0
  0.384475 168.28.180.22 -> 141.146.8.66 TCP 2177 > http [SYN] Seq=0 Len=0 MSS=1420
  0.421400 141.146.8.66 -> 168.28.180.22 TCP http > 2177 [SYN, ACK] Seq=0 Ack=1 Win=8192 Len=0 MSS=1400
  0.423763 168.28.180.22 -> 141.146.8.66 TCP 2177 > http [ACK] Seq=1 Ack=1 Win=1420 Len=0
  0.424911 168.28.180.22 -> 141.146.8.66 HTTP GET /admin/oracle.css HTTP/1.1
  0.461773 141.146.8.66 -> 168.28.180.22 TCP http > 2177 [ACK] Seq=1 Ack=705 Win=8192 Len=0
  0.463126 141.146.8.66 -> 168.28.180.22 TCP [TCP Window Update] http > 2177 [ACK] Seq=1 Ack=705 Win=7040 Len=0
  0.464918 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.464926 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.465450 141.146.8.66 -> 168.28.180.22 TCP [TCP segment of a reassembled PDU]
  0.478749 10.220.2.244 -> 141.146.8.66 TCP 2177 > http [ACK] Seq=0 Ack=0 Win=9940 Len=0
  3.463690 141.146.8.66 -> 168.28.180.22 TCP [TCP Retransmission] [TCP segment of a reassembled PDU]
  3.463698 141.146.8.66 -> 168.28.180.22 TCP [TCP Retransmission] [TCP segment of a reassembled PDU]
  3.465999 168.28.180.22 -> 141.146.8.66 ICMP Destination unreachable (Host unreachable)
  3.469295 10.220.2.244 -> 141.146.8.66 TCP [TCP Dup ACK 28#1] 2177 > http [ACK] Seq=0 Ack=0 Win=9940 Len=0
  3.469688 10.220.2.244 -> 141.146.8.66 TCP [TCP Dup ACK 28#2] 2177 > http [ACK] Seq=0 Ack=0 Win=9940 Len=0




---
Jim Herbert
Director of IT Systems, Networks, & Security
Southern Polytechnic State University
