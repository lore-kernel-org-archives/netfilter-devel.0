From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv6 0/3] Interface group patches
Date: Fri, 23 Nov 2007 01:10:24 +0100
Message-ID: <47461A70.2010201@trash.net>
References: <200711221537.29396.wolfgang.walter@studentenwerk.mhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-netdev@vger.kernel.org
To: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49592 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXKWAK1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:10:27 -0500
In-Reply-To: <200711221537.29396.wolfgang.walter@studentenwerk.mhn.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Wolfgang Walter wrote:
> From: Patrick McHardy
>> I'm working on the incremental ruleset changing API BTW :)
>> One of the changes will be that interface matching is not
>> a default part of every rule, and without wildcards it will
>> use the ifindex. But since the cost of this feature seems
>> pretty low, I don't see a compelling reason against it.
> 
> Using ifindex instead of string matching the interface name in -i and -o would 
> be a serious problem as it changes the semantics.
> 
> 1) Now you can match a non existing interface. This is certainly used. I.e. 
> with vlan interfaces, ppp etc.
> 2) Now your rule will match an interface even if the ifindex of the interface 
> changes. This is used (i.e. you activate a backup interface and rename it, 
> build new bridges etc.).
> 
> If one wants to use the ifindex instead of a string match on the name one 
> should explicitly request that (i.e. by using "-i =eth0" or something like 
> that).


Don't worry, it will subscribe to netdevice events and adjust the
ifindex when necessary. For userspace its still a device name match.
