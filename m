From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: Does Redirect/NAT change the destination port of reverse tuple ?
Date: Fri, 29 Feb 2008 17:43:10 +0530
Message-ID: <006501c87acc$737343b0$5a59cb10$@com>
References: <005101c87ac0$c0d34580$4279d080$@com> <Pine.LNX.4.64.0802291227300.15270@fbirervta.pbzchgretzou.qr> <006101c87aca$a59e0c00$f0da2400$@com> <Pine.LNX.4.64.0802291302510.24056@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:48989 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbYB2MM6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:12:58 -0500
In-Reply-To: <Pine.LNX.4.64.0802291302510.24056@fbirervta.pbzchgretzou.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@computergmbh.de] 
Sent: Friday, February 29, 2008 5:34 PM
To: Nishit Shah
Cc: netfilter-devel@vger.kernel.org
Subject: RE: Does Redirect/NAT change the destination port of reverse tuple
?


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

Yes, It is like you have mentioned. Even In squid I am getting source port
as 46873.
I am putting my load pattern here may be that can help

Client IP - 192.168.206.200 and I am sending random https requests with
incrementing source port every time starting from 1025 to 65535....
 

