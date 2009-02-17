From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 19:40:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902171940330.999@fbirervta.pbzchgretzou.qr>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net> <alpine.LRH.2.00.0902171029560.25041@q7.q7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Joe Pruett <joey@clean.q7.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZBQSkz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:40:55 -0500
In-Reply-To: <alpine.LRH.2.00.0902171029560.25041@q7.q7.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-17 19:33, Joe Pruett wrote:
>> Joe Pruett wrote:
>>> trying this again on the -devel list.  the basic question i'm trying to
>>> answer is if there really isn't a way to filter esp/ah packets after
>>> decryption/decapsulation in host2host mode.  i've looked at what i think
>>> is the current linus kernel and don't see any changes to esp/ah handling
>>> to address this.  is tunnel mode the only way i can do filtering on the
>>> packets after ah/esp have done their work?
>>
>> Packets in both tunnel and transport mode traverse the netfilter hooks
>> after decapsulation and before encapsulation. From a users POV there
>> should be nothing special about it.
>
> i don't see that behaviour on rhel/centos 5 kernels.  could this have changed
> since 2.6.18?  for tunnel mode, it looks to me like the ip-ip module is what
> causes traffic to be seen after decrypt/decap, and i just don't see anything
> like that for transport mode.

ipip is not used for ipsec.
