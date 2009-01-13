From: Patrick McHardy <kaber@trash.net>
Subject: Re: Scheduled removals
Date: Tue, 13 Jan 2009 05:44:51 +0100
Message-ID: <496C1C43.3060401@trash.net>
References: <alpine.LSU.2.00.0901060425250.14442@fbirervta.pbzchgretzou.qr> <496AC7E4.6080204@trash.net> <alpine.LSU.2.00.0901120703390.21692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47158 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZAMEox (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:44:53 -0500
In-Reply-To: <alpine.LSU.2.00.0901120703390.21692@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-01-12 05:32, Patrick McHardy wrote:
>>> as per Documentation/feature-removal-schedule.txt, some legacy code is ripe
>>> for removal. Now while pursuing this I wondered whether the struct definitions
>>> for the old code in the header files (e.g. in linux/netfilter/xt_CONNMARK.h)
>>> can also be removed or whether people will argue that doing so would
>>> unnecessarily cause dismay on behalf the potential users (of which there are
>>> not any). I am not aware of any users, and neither is Search Engine Google, so
>>> I'd just take the bait and kill it. Vetoes?
>> Every time I'm searching I do find some users of at least some
>> iptables headers. Maybe not this specific one, but that doesn't
>> mean much, fact is there might be users.
>>
>> That being said, I'd be fine removing both the functionality
>> and the headers after a sufficiently long period. I'm not
>> really confident that the period has indeed be long enough
>> though. When did we schedule this for removal?
> 
> January 2008.

OK, lets remove it in 2.6.30. At that point it should have been
almost 1.5 years, which seems to be enough.
