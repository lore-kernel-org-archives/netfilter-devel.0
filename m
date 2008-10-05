From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 23:42:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
 <20081005.132850.34376215.davem@davemloft.net>
 <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51166 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbYJEVmZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:42:25 -0400
In-Reply-To: <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 5 Oct 2008, Jan Engelhardt wrote:

> On Sunday 2008-10-05 16:33, Jan Engelhardt wrote:
> >On Sunday 2008-10-05 16:28, David Miller wrote:
> >>> On Sun, 5 Oct 2008, Jan Engelhardt wrote:
> >>> 
> >>> > I'd like to go for $(always lowercase extension name)_{mt,tg}.c if 
> >>> > noone objects.
> >>> > Or, when obvious extensions get combined maybe (like xt_mark and xt_MARK),
> >>> > just mark.c and the issue is all gone.
> >>> 
> >>> I think match/target combined in one file is the best way to go. As they 
> >>> cover the same realm (match some quantity of something and change it), 
> >>> they do fit together.
> >>
> >>This also makes sense to me.
> >
> >Before I start moving code, would we may want to combine more modules
> >into one file at this point besides xt_FOO and xt_foo only?
> (Probably not.)

If restructuring is on the way, then it should cover all possible parts.
Just my quick thoughts, with suggested module names:

addr/packet type matches in one module (addrtype):
	addrtype, pkttype

mark modules, targets in one module (route):
	connmark, mark, realm
	CLASSIFY, CONNMARK, MARK

conntrack related modules in one module (conntrack): 
	conntrack, helper, state

IPv4/IPv6 header matching and modifying in one module (iphdr):
	dscp, length, tos, ttl
	DSCP, TOS, TTL

IPv6 extension headers matching and modifying in one module (exthdr):
	dst, frag, hbh, hl, ipv6hdr, mh, rt
	HL

TCP header matching and modifying in one module (tcphdr):
	ecn, tcpmss
	ECN, TCPMSS, TCPOPTSTRIP

ipsec in one module (ipsec)
	ah, esp, policy

security markings in one module: (secmark):
	CONNSECMARK, SECMARK	

Something similar should be done with the different type of 
limit/statistics modules as well.

> Funny thing is, only when you try you see more problems a-coming.
> Like, Kconfig option names. Keep/Lose
> NETFILTER_XT_{MATCH,TARGET}_CONNMARK, and query users for a new one?

Definitely yes. Kconfig is overloaded with netfilter targets/matches and 
if matches/targets are collapsed into a single file, then Kconfig options 
should be unified, as in your sample patch.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
