From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: RE: Does Redirect/NAT change the destination port of reverse tuple
 ?
Date: Fri, 29 Feb 2008 13:04:17 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802291302510.24056@fbirervta.pbzchgretzou.qr>
References: <005101c87ac0$c0d34580$4279d080$@com>
 <Pine.LNX.4.64.0802291227300.15270@fbirervta.pbzchgretzou.qr>
 <006101c87aca$a59e0c00$f0da2400$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50911 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYB2MES (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:04:18 -0500
In-Reply-To: <006101c87aca$a59e0c00$f0da2400$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 29 2008 17:30, Nishit Shah wrote:
>>>Now here original and reverse tuples are --> 
>>>	Original tuple 192.168.206.200:63423->72.14.223.83:443
>>>	Reply tuple    192.168.121.125:3128->192.168.206.200:46873
>>>
>>>So, here destination port of reverse tuple is 46873. Is it correct ?
>>
>>You could compare with the output of tcpdump to capture the
>>actual on-wire situation especially regarding port 46873.
>
>In tcpdump output I am seeing packets only with port 63423. No packets with
>port 46873. Something like
>
> 192.168.206.200:63423->72.14.223.83:443 Syn
> 72.14.223.83:443->192.168.206.200:63423 Syn Ack
> 192.168.206.200:63423->72.14.223.83:443 Ack
>
>Also, this happens with heavy load only. In normal conditions destination
>port of reverse tuple doesn't change.

Then, also check the output of `lsof -Pn` and see if it has
46873.

squid     5770 squid     20u     IPv4      30336                 TCP
192.168.206.200:46873->a.b.c.d:3128 (ESTABLISHED)
