From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: strange INVALID SYN in ip_conntrack (tcp window tracking
 enabled) in 2.4.27 kernel
Date: Fri, 17 Dec 2004 12:32:08 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412171215330.26459@blackhole.kfki.hu>
References: <41C2BDF7.6080509@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>, chris@tac.ch
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <41C2BDF7.6080509@tac.ch>
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

On Fri, 17 Dec 2004, Roberto Nibali wrote:

> I just wanted to know if this is a known feature of the conntrack code. When I
> issue a local redirect ssh command, I get an ACCEPT followed by an INVALID on
> the SYN packet but the connection still works (kernel 2.4.27).
>
> # /foobar/bin/sshc www@172.23.139.11 -o BatchMode=yes -2 -q -f -N -p 2345 -R
> 1513:127.0.0.1:1514
>
> # tail -f /var/log/kernlog
> Dec 17 11:18:41 s_int@foobar tfx3: fw-tcp2fw [110] a:ACCEPT s:NEW
> f:INPUT IN=eth0 OUT= SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1059
> DPT=2345 SYN
> Dec 17 11:18:41 s_int@foobar ip_conntrack_tcp: INVALID: invalid SYN
> (ignored) SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1059 DPT=2345
> SYN OPT (020405B40402080A0085041F0000000001030300)

Please dump the traffic and send the corresponding log lines. (It seems to
be a retransmitted SYN, which is harmless.)

> The connection is established and the traffic works through the tunnel, but I'm
> curious as to what could actually create those two lines. I've straced the call
> but haven't found anything odd in particular.
>
> ip_ct_tcp_log_invalid is set. Reading ip_conntrack_proto_tcp.c I learn that this
> can be because we're in TCP_CONNTRACK_IGNORE state (sIG). According to the comment:
>
>          /* This SYN/ACK acknowledges a SYN that we earlier ignored
>           * as invalid. This means that the client and the server
>           * are both in sync, while the firewall is not. We kill
>           * this session and block the SYN/ACK so that the client
>           * cannot but retransmit its SYN and thus initiate a
>           * clean new session.
>           */

That path covers multiple cases and the comment refers to ignored SYN/ACK
packets :-) .

> The strange thing is that I even when I believe to be in sNO state on the packet
> filter the connections is made to I get this message. I know I can safely ignore
> it but I'm wondering why it is like that.

You can't be in sNO state: if the assumption is valid (i.e. that's a
resent SYN) then the connection is in sSR or above.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
