From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 06 Oct 2008 00:00:22 +0200
Message-ID: <48E938F6.8080108@trash.net>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55074 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbYJEWA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:00:27 -0400
In-Reply-To: <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> If restructuring is on the way, then it should cover all possible parts.
> Just my quick thoughts, with suggested module names:
>
> addr/packet type matches in one module (addrtype):
> 	addrtype, pkttype
>
> mark modules, targets in one module (route):
> 	connmark, mark, realm
> 	CLASSIFY, CONNMARK, MARK
>   

CONNMARK and connmark needs to be separated from MARK etc. because
they depend on the conntrack module.

> conntrack related modules in one module (conntrack): 
> 	conntrack, helper, state
>
> IPv4/IPv6 header matching and modifying in one module (iphdr):
> 	dscp, length, tos, ttl
> 	DSCP, TOS, TTL
>
> IPv6 extension headers matching and modifying in one module (exthdr):
> 	dst, frag, hbh, hl, ipv6hdr, mh, rt
> 	HL
>
> TCP header matching and modifying in one module (tcphdr):
> 	ecn, tcpmss
> 	ECN, TCPMSS, TCPOPTSTRIP
>
> ipsec in one module (ipsec)
> 	ah, esp, policy
>
> security markings in one module: (secmark):
> 	CONNSECMARK, SECMARK	
>
> Something similar should be done with the different type of 
> limit/statistics modules as well.
>
>   
>> Funny thing is, only when you try you see more problems a-coming.
>> Like, Kconfig option names. Keep/Lose
>> NETFILTER_XT_{MATCH,TARGET}_CONNMARK, and query users for a new one?
>>     
>
> Definitely yes. Kconfig is overloaded with netfilter targets/matches and 
> if matches/targets are collapsed into a single file, then Kconfig options 
> should be unified, as in your sample patch.

Agreed, but please keep the old options around (doing just a select
on the new ones) for one or two releases.
