From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 19:34:57 +0100
Message-ID: <499B0351.5070101@trash.net>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net> <alpine.LRH.2.00.0902171029560.25041@q7.q7.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Joe Pruett <joey@clean.q7.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62295 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZBQSe7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:34:59 -0500
In-Reply-To: <alpine.LRH.2.00.0902171029560.25041@q7.q7.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joe Pruett wrote:
>> Packets in both tunnel and transport mode traverse the netfilter hooks
>> after decapsulation and before encapsulation. From a users POV there
>> should be nothing special about it.
> 
> i don't see that behaviour on rhel/centos 5 kernels.  could this have 
> changed since 2.6.18?  for tunnel mode, it looks to me like the ip-ip 
> module is what causes traffic to be seen after decrypt/decap, and i just 
> don't see anything like that for transport mode.
> 
> i'll do some more experiments.

IIRC the IPsec support was merged around 2.6.17, but that might be wrong.
