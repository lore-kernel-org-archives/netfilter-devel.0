From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: Does Redirect/NAT change the destination port of reverse tuple ?
Date: Fri, 29 Feb 2008 17:30:16 +0530
Message-ID: <006101c87aca$a59e0c00$f0da2400$@com>
References: <005101c87ac0$c0d34580$4279d080$@com> <Pine.LNX.4.64.0802291227300.15270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:46089 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754212AbYB2MAB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:00:01 -0500
In-Reply-To: <Pine.LNX.4.64.0802291227300.15270@fbirervta.pbzchgretzou.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



-----Original Message-----
From: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Jan Engelhardt
Sent: Friday, February 29, 2008 4:59 PM
To: Nishit Shah
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Does Redirect/NAT change the destination port of reverse tuple
?


On Feb 29 2008 16:19, Nishit Shah wrote:
>
>Hi,
>	I have following iptable rule in system.
>
>	iptables -I PREROUTING -t nat -p tcp --dport 443 -j REDIRECT
>--to-ports 3128
>	kernel - 2.6.16.13
>
>	I am using following scenario for load testing
>
>	192.168.206.200 -----> 192.168.121.125 	-----> 	72.14.223.83
>	Client			iptables/proxy server		server
>
>	and I am getting following entry through conntrack binay as well as
>in /proc/net/ip_conntrack
>
>	[NEW] tcp 6 120 NONE src=192.168.206.200 dst=72.14.223.83
>sport=63423 dport=443 packets=1 bytes=48 [UNREPLIED] src=192.168.121.125
>dst=192.168.206.200 sport=3128 dport=46873 packets=0 bytes=0 id=28187887
>
>Now here original and reverse tuples are --> 
>	Original tuple 192.168.206.200:63423->72.14.223.83:443
>	Reply tuple    192.168.121.125:3128->192.168.206.200:46873
>
>So, here destination port of reverse tuple is 46873. Is it correct ?

You could compare with the output of tcpdump to capture the
actual on-wire situation especially regarding port 46873.

In tcpdump output I am seeing packets only with port 63423. No packets with
port 46873. Something like

 192.168.206.200:63423->72.14.223.83:443 Syn
 72.14.223.83:443->192.168.206.200:63423 Syn Ack
 192.168.206.200:63423->72.14.223.83:443 Ack

Also, this happens with heavy load only. In normal conditions destination
port of reverse tuple doesn't change.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

