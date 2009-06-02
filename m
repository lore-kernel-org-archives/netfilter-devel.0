From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFD,patch] ICMP echo conntrack timeout
Date: Tue, 02 Jun 2009 14:10:57 +0200
Message-ID: <4A2516D1.30900@trash.net>
References: <20090601174352.GH31797@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37860 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZFBMLA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:11:00 -0400
In-Reply-To: <20090601174352.GH31797@fi.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
> 
> - should there be a duplicated ICMP echo reply (such as when when pinging
> 	a cluster IP address), only the first echo reply is seen as
> 	ESTABLISHED, the rest is INVALID.
> 
> - no "per-flow" statistics available, as there is no notion of the "flow"		at all.
> 
> 	I think it would be better to keep the default timeout of
> nf_ct_icmp_timeout even after the echo reply is received. Feel free
> to correct me why early deleting of ICMP conntrack entries is needed,
> or consider applying the following patch.

I think this patch makes sense, it also improves behaviour in cases with
asymetric MTUs where a fragmentation required is sent after the reply
passed through conntrack and conntrack can't associate it to the already
gone connection anymore.

Unless someone has concerns I'm missing, I'll apply this.
