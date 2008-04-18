From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack bug?
Date: Fri, 18 Apr 2008 19:57:14 +0200
Message-ID: <4808E0FA.9020902@netfilter.org>
References: <200804181343.25640.j.stubbs@linkthink.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jason Stubbs <j.stubbs@linkthink.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36365 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758173AbYDRRvK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:51:10 -0400
In-Reply-To: <200804181343.25640.j.stubbs@linkthink.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jason Stubbs wrote:
> Hi,
> 
> While testing patches for IPVS, I found a strange behaviour of conntrack that 
> happens on an unpatched kernel too (2.6.24.4). Given the following rules:
> 
> iptables -A FORWARD -p tcp -d 192.168.1.3 --dport 80 \
>                     -m state --state NEW -j ACCEPT
> iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
> iptables -P FORWARD DROP
> 
> And a network setup where replies from 192.168.1.3 don't go via the same 
> machine - ie, they appear to be being dropped - the following conntrack entry 
> appears when sending only an ACK packet to 192.168.1.3:
> 
> ipv4     2 tcp      6 431684 ESTABLISHED src=192.168.0.104 dst=192.168.1.3 
> sport=12345 dport=80 packets=2 bytes=95 [UNREPLIED] src=192.168.1.3 
> dst=192.168.0.104 sport=80 dport=12345 packets=0 bytes=0 mark=0 use=1
> 
> If a SYN has been sent the following state appears and no traffic (including 
> an ACK) is allowed to pass:
> 
> ipv4     2 tcp      6 119 SYN_SENT src=192.168.0.104 dst=192.168.1.3 
> sport=23456 dport=80 packets=1 bytes=50 [UNREPLIED] src=192.168.1.3 
> dst=192.168.0.104 sport=80 dport=23456 packets=0 bytes=0 mark=0 use=1
> 
> I would think that behaviour to be correct, but an entry appearing when only 
> an ACK packet has been sent seems wrong. Is it a bug or intentional?

Probably cat /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_loose says 1?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
