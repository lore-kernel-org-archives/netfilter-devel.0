From: James Morris <jmorris@intercode.com.au>
Subject: ECN target bug report (fwd)
Date: Mon, 9 Dec 2002 11:52:27 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0212091152190.26086-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

---------- Forwarded message ----------
Date: Sat, 07 Dec 2002 14:14:42 +0100
From: Andrea Rossato <mailing_list@istitutocolli.org>
To: netfilter@lists.netfilter.org
Subject: ECN target bug report

below you will find a coupe of emails sent to this list at the end of 
september.

the first one states that there is a problem with tcp checksum in the 
case a packet had been stripped of ecn bits. The problem was also 
reported by Graham Murray in Agust.

the answer was that this is due to tcpdump getting a cloned copy of the 
packet:
now, if I send tcp packet stripped with -ecn-tcp-remove to a box and i 
dump packets there, tcp checksum is incorrect and the box will be not 
respondig. If I remove the rule, packets are getting there with the 
correct checksum and the box responds.

What's interesting is that if I put these rules:

iptables -A OUTPUT -t mangle -o ppp0 -p tcp -d my.host.org --dport 80 -j 
ECN --ecn-tcp-remove
iptables -A OUTPUT -o ppp0 -p tcp -d my.host.org --dport 80 -m unclean 
-j DROP

packets will be actually dropped! something strange for being normal, 
isn't it? or iptables treats as unclean ecn stripped packets, and this 
is supposed to be normal? anyway iptables seems not to be the only one, 
so ECN target is actually preatty useless.

(using linux-2.4.20 and iptables-1.2.7a)

Thanks for you attention.
Andrea



> Subject:-j ECN --ecn-tcp-remove seems to be mangling the TCP checksum...
> From: netfilter@horizon.com
> Date: 27 Sep 2002 06:27:53 -0000
> To: netfilter@lists.netfilter.org

> bash-2.05b# iptables -t mangle -A fix-ecn -d 1.1.1.1 -p tcp -j ECN --ecn-tcp-remove
> bash-2.05b# echo 1 > /proc/sys/net/ipv4/tcp_ecn ; telnet 1.1.1.1 80
> 01:52:20.662338 science.horizon.com.11058 > 1.1.1.1.www: S [bad tcp cksum bf40!] 2655433521:2655433521(0) win 5840 <mss 1460,sackOK,timestamp 14290984 0,nop,wscale 0> (DF) [tos 0x10]  (ttl 64, id 41753, len 60)
>                          4510 003c a319 4000 4006 716c c023 6401
>                          0101 0101 2b32 0050 9e46 b331 0000 0000
>                          a002 16d0 3c55 0000 0204 05b4 0402 080a
>                          00da 1028 0000 0000 0103 0300
> 
> Now I'll turn tcp_ecn off again:
> bash-2.05b# echo 0 > /proc/sys/net/ipv4/tcp_ecn ; telnet 1.1.1.1 80
> 01:52:36.771155 science.horizon.com.11059 > 1.1.1.1.www: S [tcp sum ok] 2671050014:2671050014(0) win 5840 <mss 1460,sackOK,timestamp 14292595 0,nop,wscale 0> (DF) [tos 0x10]  (ttl 64, id 60269, len 60)
>                          4510 003c eb6d 4000 4006 2918 c023 6401
>                          0101 0101 2b33 0050 9f34 fd1e 0000 0000
>                          a002 16d0 2bed 0000 0204 05b4 0402 080a
>                          00da 1673 0000 0000 0103 0300
> 
> Notice the bad tcp checksum in the third case.

> Subject: Re: -j ECN --ecn-tcp-remove seems to be mangling the TCP checksum...
> From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
> Date: Mon, 30 Sep 2002 11:55:56 +0200 (CEST)
> To: netfilter@horizon.com
> CC: netfilter@lists.netfilter.org

>>> Is this a bug?  The ipt_ECN.c file is
>>> ipt_ECN.c,v 1.4 2002/08/05 19:36:51 laforge Exp
> 
> No it is not. Do the same with a remote host.
> Send a ECNstripped packets to some other host, and tcpdump there.
> The checksum will be ok.
> It is the problem with tcpdump getting a cloned copy of the packet,
> read the RR's FIXME notes in netfilter sources about it.
> 
> I noticed that too, once, and thought it's a checksum calculation bug.
> Maciej Soltysiak
