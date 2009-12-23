From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Fwd: Re: libnetfilter_conntrack]
Date: Wed, 23 Dec 2009 23:08:49 +0100
Message-ID: <4B3294F1.4010202@netfilter.org>
References: <4B2B4B63.20509@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Zdenek Vasicek <vzdenek@seznam.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZLWWIj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:08:39 -0500
In-Reply-To: <4B2B4B63.20509@seznam.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Zdenek Vasicek wrote:
> Dear authors,
> I would like to ask you about help. I have installed latest version of 
> the libnetfilter_conntrack (libnetfilter_conntrack-0.0.100, 
> libnfnetlink-1.0.0) and I have found that the src and dest address 
> (ipv4) as well as src and dest port are always empty (zero). However, if 
> I look into /proc/net/nf_conntrack, everything is ok. The kernel version 
> is 2.6.32.
> 
> Example:
>  libnetfilter_conntrack-0.0.100/utils/conntrack_dump
>  ipv4     2 tcp      6 431999 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 
> packets=13087 bytes=851624 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 
> packets=14940 bytes=8636188 [ASSURED] mark=0 use=2
> 
>  /proc/net/nf_conntrack
>  ipv4     2 tcp      6 431999 ESTABLISHED src=147.229.13.xx 
> dst=147.229.14.xx sport=40868 dport=22 packets=13236 bytes=861344 
> src=147.229.14.xx dst=147.229.....
> 
> Can you please help me to solve this bug? I didn't have any problems 
> with conntrack and ulog before. I suppose that there must to be 
> incompatibility between kernel and libnetfilter.

There's a similar bug in bugzilla.netfilter.org [1], for some reason the 
kernel is not including the address and the port in the messages sent to 
userspace. Could you send me your .config file?

[1] http://bugzilla.netfilter.org/show_bug.cgi?id=612
