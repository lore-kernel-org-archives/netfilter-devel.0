From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_gateway locks up
Date: Fri, 26 Oct 2007 17:33:01 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710261726360.12896@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
 <4721F4F7.1060602@ufomechanic.net> <Pine.LNX.4.64.0710261617020.12896@fbirervta.pbzchgretzou.qr>
 <4722034C.5020803@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57859 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbXJZPdC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:33:02 -0400
In-Reply-To: <4722034C.5020803@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 26 2007 16:10, Amin Azez wrote:
>>
>> That's because Patrick said it cannot be NULL :-)
>> http://marc.info/?l=netfilter-devel&m=118105659716253&w=2
>>
>> Of course, an oops in an interrupt handler ain't that funny..
>
>Indeed.
>
>But he was right in the planned useful case, are you using it in 
>pre-routing on bridging or something? I can't work out why you would 
>want to use it in PRE_ROUTING, i.e. before a gateway is set, unless you 
>are setting a gateway in pre-routing too. You're not storing a route in 
>the conntrack are you?

No. The experiment behind this was to:

	-t nat -A PREROUTING -i eth1 -d <address of eth0> -p tcp \
	--dport 80 -j REDIRECT --to-port 8000

i.e. that all packets destined for <public ip>:80 go to an alternate 
port. But if eth0 has a dynamic address, that is going to be hard. So 
the idea I had was to match with

	-t nat -A PREROUTING \
	-m gateway --nexthop 127.0.0.1 -p tcp --dport 80

because the routing code would decide so when it sees that the IPv4 
destination <public ip> is actually a 'local' target (ip r l table 
local).
