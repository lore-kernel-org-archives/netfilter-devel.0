From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv6 0/3] Interface group patches
Date: Fri, 23 Nov 2007 01:41:43 +0100
Message-ID: <474621C7.7040807@trash.net>
References: <200711221537.29396.wolfgang.walter@studentenwerk.mhn.de> <47461A70.2010201@trash.net> <Pine.LNX.4.64.0711230120560.11776@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
	netfilter-devel@vger.kernel.org, linux-netdev@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50113 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXKWAlp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:41:45 -0500
In-Reply-To: <Pine.LNX.4.64.0711230120560.11776@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> 
> 
> On Fri, 23 Nov 2007, Patrick McHardy wrote:
> 
>> Wolfgang Walter wrote:
>>> From: Patrick McHardy
>>>> I'm working on the incremental ruleset changing API BTW :)
>>>> One of the changes will be that interface matching is not
>>>> a default part of every rule, and without wildcards it will
>>>> use the ifindex. But since the cost of this feature seems
>>>> pretty low, I don't see a compelling reason against it.
>>>
>>> Using ifindex instead of string matching the interface name in -i and 
>>> -o would be a serious problem as it changes the semantics.
>>>
>>> 1) Now you can match a non existing interface. This is certainly 
>>> used. I.e. with vlan interfaces, ppp etc.
>>> 2) Now your rule will match an interface even if the ifindex of the 
>>> interface changes. This is used (i.e. you activate a backup interface 
>>> and rename it, build new bridges etc.).
>>>
>>> If one wants to use the ifindex instead of a string match on the name 
>>> one should explicitly request that (i.e. by using "-i =eth0" or 
>>> something like that).
>>
>>
>> Don't worry, it will subscribe to netdevice events and adjust the
>> ifindex when necessary. For userspace its still a device name match.
> 
> Also for "-i ppp+"?


No, see above :) Its a single device match, for wildcards it will
still use the pattern-based matching.
