From: =?iso-8859-2?q?Micha=B3_Margula?= <alchemyx@uznam.net.pl>
Subject: Floods
Date: Sun, 14 Mar 2004 19:30:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403141930.29602.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello!

	I have problem, quite big one. I don't know how to deal with it. Tried=20
everything i know. I have a 2 x Xeon 2.66 server with 1 Gig ram. Everything=
=20
based on Intel e100 and e1000 NICs. That server is my firewall and gateway.

I have common problem - viruses, worms and so on. It degrades server=20
performance quite much. I am using connlimit.

=2Dp tcp --syn -m connlimit --connlimit-above 100 -j DROP

It was working fine until today. I was hit by UDP flood coming from one of =
our=20
100mbit networks. I found that person and disconnected, but that is not=20
solution. Event "-t raw" didnt' help.

Altough after removing ip_conntrack from kernel everything goes fine. But i=
=20
can't stop using conntrack, because of SNAT, DNAT and REDIRECT targets.

What do you recommend? Unfortunately connlimit does not work with UDP packe=
ts=20
(no wonder - UDP is conection less). What should I do? I even thought about=
=20
switch to FreeBSD (sic! :<).

Help, please!

=2D-=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
