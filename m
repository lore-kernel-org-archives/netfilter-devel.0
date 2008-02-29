From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Does Redirect/NAT change the destination port of reverse tuple
 ?
Date: Fri, 29 Feb 2008 12:29:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802291227300.15270@fbirervta.pbzchgretzou.qr>
References: <005101c87ac0$c0d34580$4279d080$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49227 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbYB2L3Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:29:24 -0500
In-Reply-To: <005101c87ac0$c0d34580$4279d080$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


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
