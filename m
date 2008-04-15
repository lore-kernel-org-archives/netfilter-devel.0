From: "manuel scheub" <manuprivat@gmx.de>
Subject: Re: AW: Add new target in mangle table
Date: Tue, 15 Apr 2008 11:20:52 +0200
Message-ID: <20080415092052.107670@gmx.net>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
 <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr>
 <20080414163449.293250@gmx.net>
 <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
 <20080415083543.20880@gmx.net>
 <alpine.LNX.1.10.0804151046120.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752390AbYDOJUy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:20:54 -0400
In-Reply-To: <alpine.LNX.1.10.0804151046120.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


-------- Original-Nachricht --------
> Datum: Tue, 15 Apr 2008 10:46:35 +0200 (CEST)
> Von: Jan Engelhardt <jengelh@computergmbh.de>
> An: manuprivat@gmx.de
> CC: netfilter-devel@vger.kernel.org
> Betreff: Re: AW: Add new target in mangle table

> 
> On Tuesday 2008-04-15 10:35, manuprivat@gmx.de wrote:
> >> >> >># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j
> SADDR
> >> >> >>--to-source 10.0.19.2
> >> >> >
> >> >> One question this throws up... how do you know the address is
> >> >> 192.168.0.168?
> >> >
> >> >Actually, I dont know that! It is only an example to show the
> different
> >> >IP-ranges. Excuse my improper representation.
> >> 
> >> The question is more of a technical one-- if you do not know the
> >> source address the client will be using, how can you reliably
> >> mangle the address?
> >
> >I modified the udhcpd from the busybox  - have a look in the attached
> >file.
> >To handle the different cases i wrote a shell script - also attached.
> 
> But if the client uses DHCP, why don't you hand out 10.0.x.x directly?

If the client uses DHCP, i do hand out 10.0.x.x directly! The modified dhcpd listens on all requests, it doesn't matter if it is not a dhcp-request. And for the internal use of the gateway it provides a dhcp-lease, even if the request came from a user with a fix-ip entry.


-- 
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games! 
http://games.entertainment.gmx.net/de/entertainment/games/free
