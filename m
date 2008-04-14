From: manuprivat@gmx.de
Subject: Re: AW: Add new target in mangle table
Date: Mon, 14 Apr 2008 18:34:49 +0200
Message-ID: <20080414163449.293250@gmx.net>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
 <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758145AbYDNQev (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:34:51 -0400
In-Reply-To: <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >>
> >># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
> >>--to-source 10.0.19.2
> >
> One question this throws up... how do you know the address is
> 192.168.0.168?

Actually, I dont know that! It is only an example to show the different IP-ranges. Excuse my improper representation. 
-- 
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games! 
http://games.entertainment.gmx.net/de/entertainment/games/free
