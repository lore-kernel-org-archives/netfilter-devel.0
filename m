From: Roberto Nibali <ratz@tac.ch>
Subject: strange INVALID SYN in ip_conntrack (tcp window tracking enabled)
 in 2.4.27 kernel
Date: Fri, 17 Dec 2004 12:07:35 +0100
Message-ID: <41C2BDF7.6080509@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: chris@tac.ch
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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

I just wanted to know if this is a known feature of the conntrack code. When I 
issue a local redirect ssh command, I get an ACCEPT followed by an INVALID on 
the SYN packet but the connection still works (kernel 2.4.27).

# /foobar/bin/sshc www@172.23.139.11 -o BatchMode=yes -2 -q -f -N -p 2345 -R 
1513:127.0.0.1:1514

# tail -f /var/log/kernlog
Dec 17 11:18:41 s_int@foobar tfx3: fw-tcp2fw [110] a:ACCEPT s:NEW
f:INPUT IN=eth0 OUT= SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1059
DPT=2345 SYN
Dec 17 11:18:41 s_int@foobar ip_conntrack_tcp: INVALID: invalid SYN
(ignored) SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1059 DPT=2345
SYN OPT (020405B40402080A0085041F0000000001030300)

The connection is established and the traffic works through the tunnel, but I'm 
curious as to what could actually create those two lines. I've straced the call 
but haven't found anything odd in particular.

ip_ct_tcp_log_invalid is set. Reading ip_conntrack_proto_tcp.c I learn that this 
can be because we're in TCP_CONNTRACK_IGNORE state (sIG). According to the comment:

         /* This SYN/ACK acknowledges a SYN that we earlier ignored
          * as invalid. This means that the client and the server
          * are both in sync, while the firewall is not. We kill
          * this session and block the SYN/ACK so that the client
          * cannot but retransmit its SYN and thus initiate a
          * clean new session.
          */

 From a TCP state transition point of view I reopen a new connection and thus 
I've checked the /* ORIGINAL */ table which mentions following possible sIG 
transitions under /*syn*/:

  *      sSR -> sIG      Late retransmitted SYN?
  *      sES -> sIG      Error: SYNs in window outside the SYN_SENT state
  *                      are errors. Receiver will reply with RST
  *                      and close the connection.
  *                      Or we are not in sync and hold a dead connection.
  *      sFW -> sIG
  *      sCW -> sIG
  *      sLA -> sIG

The strange thing is that I even when I believe to be in sNO state on the packet 
filter the connections is made to I get this message. I know I can safely ignore 
it but I'm wondering why it is like that.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
