From: Krzysztof Rusocki <kszysiu@iceberg.elsat.net.pl>
Subject: only first TCP SYN packet consulted in nat table chains - bug or feature?
Date: Mon, 21 Jun 2004 22:06:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621200651.GB1323@iceberg.elsat.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I have a Linux 2.4.27-pre2 based nat box,
which also alters TCPMSS of packets it
passes through.

For really long period of time I used
rule created by the following iptables combo:

iptables -t nat -A POSTROUTING -o ppp0 -p tcp --tcp-flags SYN,RST SYN \
	-m tcpmss --mss 1453: -j TCPMSS --set-mss 1452

However, quite recently I discovered
that first TCP SYN packet's MSS is altered
and latter SYN packets (in case of retransmission)
have MSS unchanged (1460 - ether).

Relevant tcpdump output (ppp0) follows:
19:23:33.178771 83.27.53.238.1206 > 1.2.3.4.45454: S [tcp sum ok]
	1844185893:1844185893(0) win 5840
	<mss 1452,sackOK,timestamp 54616709 0,nop,wscale 0> (DF)
	[tos 0x10]  (ttl 63, id 27040, len 60)   
19:23:36.177492 83.27.53.238.1206 > 1.2.3.4.45454: S [tcp sum ok]
	1844185893:1844185893(0) win 5840
	<mss 1460,sackOK,timestamp 54619709 0,nop,wscale 0> (DF)
	[tos 0x10]  (ttl 63, id 27041, len 60)   
19:23:42.175696 83.27.53.238.1206 > 1.2.3.4.45454: S [tcp sum ok]
	1844185893:1844185893(0) win 5840
	<mss 1460,sackOK,timestamp 54625709 0,nop,wscale 0> (DF)
	[tos 0x10]  (ttl 63, id 27042, len 60)

I'm just being curious here - is this a bug or feature?

For the time being I have changed that rule to use
mangle table...


Cheers,
Krzysztof
