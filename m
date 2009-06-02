From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFD,patch] ICMP echo conntrack timeout
Date: Tue, 02 Jun 2009 13:46:47 +0200
Message-ID: <4A251127.8000605@netfilter.org>
References: <20090601174352.GH31797@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36023 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZFBMaI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:30:08 -0400
In-Reply-To: <20090601174352.GH31797@fi.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Jan Kasprzak wrote:
> 	Hello, netfilter developers!
> 
> I am trying to delploy a conntrackd-based HA router and (if possible) a
> flow statistics collector. I have discovered that nf_conntrack treats each
> ICMP echo request/reply pair as a separate connection (in
> net/ipv4/netfilter/nf_conntrack_proto_icmp.c:icmp_packet() function).
> This has several problems:
> 
> - excessive conntrackd traffic when the ping is running over the router
> 	(one new "connection" per echo request/reply pair).

Indeed, one event per new ICMP echo packet is too much. This can be also
a way to exhaust resources of the conntrack subsystem.

> - should there be a duplicated ICMP echo reply (such as when when pinging
> 	a cluster IP address), only the first echo reply is seen as
> 	ESTABLISHED, the rest is INVALID.
> 
> - no "per-flow" statistics available, as there is no notion of the "flow"		at all.

Indeed, no packet accounting at all.

> 	I think it would be better to keep the default timeout of
> nf_ct_icmp_timeout even after the echo reply is received. Feel free
> to correct me why early deleting of ICMP conntrack entries is needed,
> or consider applying the following patch.

The only problem that I see is that you patch relaxes the current
checking that we're doing. I mean, for every packet in one direction we
only accept one ICMP reply packet. With your patch, we can accept more
than one packet in the reply direction.

I have a similar patch in my internal tree. It allows only one reply
packet per original and many packet in the original direction as you
want. I'll post it asap so we can discuss on it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
