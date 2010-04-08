From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH/RFC 3/5] bridge-netfilter: simplify IP DNAT and fix IP
 DNAT on encapsulated packets
Date: Thu, 08 Apr 2010 15:28:13 +0200
Message-ID: <4BBDD9ED.5050603@trash.net>
References: <4BB207A8.6000608@pandora.be> <4BBDCCAB.8050704@trash.net> <4BBDD9D0.1010402@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37281 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0DHN2O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:28:14 -0400
In-Reply-To: <4BBDD9D0.1010402@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Patrick McHardy wrote:
>> Bart De Schuymer wrote:
>>   
>> Besides patch 5 these all look fine to me. Regarding this one,
>> the individual changes don't seem to strictly depend on each
>> other. Would it be possible to split this up further to make
>> review (and potentially bisections) easier?
>>   
> That should be possible, I think. I'll have a look at it in the near future.

Thanks Bart.
