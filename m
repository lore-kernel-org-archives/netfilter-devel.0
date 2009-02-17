From: Joe Pruett <joey@clean.q7.com>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 10:33:31 -0800 (PST)
Message-ID: <alpine.LRH.2.00.0902171029560.25041@q7.q7.com>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from q7.q7.com ([207.173.201.42]:51474 "EHLO q7.q7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZBQSdg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:33:36 -0500
In-Reply-To: <499B0097.4000505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Joe Pruett wrote:
>>  trying this again on the -devel list.  the basic question i'm trying to
>>  answer is if there really isn't a way to filter esp/ah packets after
>>  decryption/decapsulation in host2host mode.  i've looked at what i think
>>  is the current linus kernel and don't see any changes to esp/ah handling
>>  to address this.  is tunnel mode the only way i can do filtering on the
>>  packets after ah/esp have done their work?
>
> Packets in both tunnel and transport mode traverse the netfilter hooks
> after decapsulation and before encapsulation. From a users POV there
> should be nothing special about it.

i don't see that behaviour on rhel/centos 5 kernels.  could this have 
changed since 2.6.18?  for tunnel mode, it looks to me like the ip-ip 
module is what causes traffic to be seen after decrypt/decap, and i just 
don't see anything like that for transport mode.

i'll do some more experiments.
