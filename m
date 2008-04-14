From: manuprivat@gmx.de
Subject: Re: AW: Add new target in mangle table
Date: Mon, 14 Apr 2008 17:44:35 +0200
Message-ID: <20080414154435.40330@gmx.net>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
 <alpine.LNX.1.10.0804140921290.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755862AbYDNPoh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:44:37 -0400
In-Reply-To: <alpine.LNX.1.10.0804140921290.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >>>Hi developers,
> >>>
> >>>I encountered difficulties during integrating a new target in mangle
> >>>table (iptables-1.4.0 (from www.netfilter.org), kernel-2.6.23 (from
> >>>www.kernel.org)). 
> >>>I have a master from iptables-1.2.9 and kernel-2.6.3. But there were
> too
> >>>many differences and changes be made.
> >>>The idea behind to add the target is, that a user who has a fix-ip
> entry
> >>>in his network settings can be handled from a gateway, for which the
> new
> >>>targets should be implemented. for example:
> >>>
> >>># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
> >>>--to-source 10.0.19.2
> >>
> >>This looks pretty much like RAWNAT, as posted in 
> >>http://marc.info/?l=netfilter-devel&m=120024054521550&w=2 .
> >>
> >Excuse me, but I didn?t get the solution for the RAWNAT issue.
> >Maybe it refers to that I'm not so familiar with the netfilter stuff.
> >
> >Is it possible to realize my issue, or do I have problems with the
> >conntrack?
> 
> Could you describe the target a bit closer? I did not quite get what you 
> mean by "user who has a fixed IP address can be handled(?) from [by?] a 
> gateway". Because your code (SADDR) does seem to only change the source 
> address, I guessed it is equivalent to RAWSNAT.
> 
> 
> 
> >Where can I find the source code for the RAWNAT target.
> 
> It is in a git repository at 
> http://dev.computergmbh.de/gitweb.cgi?p=xtables-addons (there is also 
> the git:// URL for cloning), and http://tinyurl.com/4qoylk would give 
> you a snapshot in tar format.


yes, i think it is equivalent to RAWSNAT and RAWDNAT. I'll try to solve the problem with the RAWNAT target. Thank you very much.

"user who has a fixed IP address can be handled(?) from [by?] a gateway"
Sorry for the imprecise information. The issue is that I have a gateway (normal pc with 2 NICs, LAN1=WAN, LAN2=internal NET) where users can get an access to the internet. The gateway has a self made user management implemented. All the users in the internal net are handled with IPs 
gateway:10.0.2.1<->user-dhcp-lease:10.0.2.2, gateway:10.0.3.1<->user-dhcp-lease:10.0.3.2,...  and so on. 
If a user has an fix-ip entry in his notebook, actually it's not possible to communicate with. For this issue I need a feature which i call ip-plug'n'play. Somewhere in the raw or mangle table I would like to change the source/destination address for the internal user management of the gateway. hope, it's a bit clearer now.
-- 
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games! 
http://games.entertainment.gmx.net/de/entertainment/games/free
