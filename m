From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 16:56:19 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007161654030.32253@obet.zrqbmnf.qr>
References: <4C402DBD.3010007@quarantainenet.nl> <4C404EAC.7050509@trash.net> <4C4053AB.8050300@quarantainenet.nl> <4C405572.7050106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bas van Sisseren <bas@quarantainenet.nl>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56883 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965774Ab0GPO4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:56:22 -0400
In-Reply-To: <4C405572.7050106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-07-16 14:49, Patrick McHardy wrote:
>> Assume:
>>   eth0 has these addresses:
>>     10.1.0.1, netmask 255.255.255.0  (primary address)
>>     10.2.0.1, netmask 255.255.255.0
>>     10.3.0.1, netmask 255.255.255.0
>>     10.4.0.1, netmask 255.255.255.0
>> 
>>   and redirects from.. say.. port 80 to 8080
>> 
>>   Connections to 10.1.0.1:80 will be redirected to 10.1.0.1:8080
>>   But also all connections to 10.2.0.1:80, 10.3.0.1:80 and
>>   10.4.0.1:80 will be redirected to 10.1.0.1:8080
>> 
>> 
>> With the patch, the connection to 10.2.0.1:80 will be redirected to
>> 10.2.0.1:8080, 10.3.0.1:80 to 10.3.0.1:8080, etc..
>
>OK, so basically you just want to rewrite the port number. An easier
>way to do this without iterating through all addresses would be to
>change userspace and the kernel so you can create REDIRECT rules
>without the IP_NAT_RANGE_MAP_IPS flag. That won't work for forwarded
>packets, but its the simplest solution for the case you describe.

Isn't TPROXY the right thing here if all you want is changing the port 
of delivery? :-)

