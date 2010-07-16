From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 14:49:54 +0200
Message-ID: <4C405572.7050106@trash.net>
References: <4C402DBD.3010007@quarantainenet.nl> <4C404EAC.7050509@trash.net> <4C4053AB.8050300@quarantainenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Bas van Sisseren <bas@quarantainenet.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36304 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576Ab0GPMtz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:55 -0400
In-Reply-To: <4C4053AB.8050300@quarantainenet.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 16.07.2010 14:42, schrieb Bas van Sisseren:
> Hello Patrick,
> 
> In most situations, all addresses are known in advance (although we have
> some situations where we both have a static address and a dhcp'ed address on
> the same interface).

At least in the cases where the addresses are known in advance, you can
handle this through the ruleset.

> The problem is that we can't tell the other end to use the first address on
> the interface. Some systems use the first address, others use the second
> address. When a connection is set up from the remote system to the second
> address, the original REDIRECT redirects the connection to the configured
> port-number on the first address.
> 
> It seems way more logical to me to keep the destination address the same and
> only change the port number if the destination address is locally configured
> on that interface.
> 
> 
> Assume:
>   eth0 has these addresses:
>     10.1.0.1, netmask 255.255.255.0  (primary address)
>     10.2.0.1, netmask 255.255.255.0
>     10.3.0.1, netmask 255.255.255.0
>     10.4.0.1, netmask 255.255.255.0
> 
>   and redirects from.. say.. port 80 to 8080
> 
>   Connections to 10.1.0.1:80 will be redirected to 10.1.0.1:8080
>   But also all connections to 10.2.0.1:80, 10.3.0.1:80 and
>   10.4.0.1:80 will be redirected to 10.1.0.1:8080
> 
> 
> With the patch, the connection to 10.2.0.1:80 will be redirected to
> 10.2.0.1:8080, 10.3.0.1:80 to 10.3.0.1:8080, etc..

OK, so basically you just want to rewrite the port number. An easier
way to do this without iterating through all addresses would be to
change userspace and the kernel so you can create REDIRECT rules
without the IP_NAT_RANGE_MAP_IPS flag. That won't work for forwarded
packets, but its the simplest solution for the case you describe.
