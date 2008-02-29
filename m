From: "Nishit Shah" <nishit@elitecore.com>
Subject: Does Redirect/NAT change the destination port of reverse tuple ?
Date: Fri, 29 Feb 2008 16:19:26 +0530
Message-ID: <005101c87ac0$c0d34580$4279d080$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:58359 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755518AbYB2KtB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:49:01 -0500
Received: from unknown (HELO elitecore3) ([203.88.135.197])
          (envelope-sender <nishit@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 29 Feb 2008 10:28:19 -0000
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
	I have following iptable rule in system.

	iptables -I PREROUTING -t nat -p tcp --dport 443 -j REDIRECT
--to-ports 3128
	kernel - 2.6.16.13

	I am using following scenario for load testing

	192.168.206.200 -----> 192.168.121.125 	-----> 	72.14.223.83
	Client			iptables/proxy server		server

	and I am getting following entry through conntrack binay as well as
in /proc/net/ip_conntrack

	[NEW] tcp 6 120 NONE src=192.168.206.200 dst=72.14.223.83
sport=63423 dport=443 packets=1 bytes=48 [UNREPLIED] src=192.168.121.125
dst=192.168.206.200 sport=3128 dport=46873 packets=0 bytes=0 id=28187887

Now here original and reverse tuples are --> 
	Original tuple 192.168.206.200:63423->72.14.223.83:443
	Reply tuple    192.168.121.125:3128->192.168.206.200:46873

So, here destination port of reverse tuple is 46873. Is it correct ?

Rgds,
Nishit Shah

