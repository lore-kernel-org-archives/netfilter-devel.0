From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Patch] Re: Line numbering broken since bb34082d
Date: Fri, 13 Jun 2008 14:19:40 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806131418320.23098@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0806131107340.23098@fbirervta.pbzchgretzou.qr> <1213354753.30942.7.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43881 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYFMMTl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:19:41 -0400
In-Reply-To: <1213354753.30942.7.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-06-13 12:59, Henrik Nordstrom wrote:
>On fre, 2008-06-13 at 11:14 +0200, Jan Engelhardt wrote:
>
>> `iptables -nvL --lin`, starting with bb34082de, gives a wrong count:
>> 
>> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
>> num   pkts bytes target     prot opt in     out     source               
>> destination         
>> 2        0     0 LOG        all  --  *      *       0.0.0.0/0            
>> 0.0.0.0/0           LOG flags 0 level 4 
>
>Sorry about that. Never tested --line-numbers.
>
>I think the best fix is to drop the +1 from print_firewall(). Patch attached.

Indeed, that is the right thing to do, since with my patch,
iptables -nvL INPUT 1  would still show the 2nd rule.
