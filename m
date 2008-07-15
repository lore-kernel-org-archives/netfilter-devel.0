From: Patrick McHardy <kaber@trash.net>
Subject: Re: 02/13 [NETFILTER]: Use unsigned types for hooknum and pf vars
Date: Tue, 15 Jul 2008 11:55:58 +0200
Message-ID: <487C742E.7030208@trash.net>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101524070.27323@fbirervta.pbzchgretzou.qr> <487B53F8.5080006@trash.net> <alpine.LNX.1.10.0807151010030.13215@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52782 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYGOJ4B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 05:56:01 -0400
In-Reply-To: <alpine.LNX.1.10.0807151010030.13215@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-07-14 15:26, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> commit ffffffffffffffffffffffffffffffffffffffff
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Sat Apr 12 08:24:12 2008 +0200
>>>
>>> [NETFILTER]: Use unsigned types for hooknum and pf vars
>>>     and (try to) consistently use u_int8_t for the L3 family.
>>>
>>> +extern struct xt_match *xt_find_match(u_int8_t af, const char *name,
>>> +				      u8 revision);
>> It would have been cleaner to at least consistently use u_int8_t/u8
>> within one function. Alternatively I'd prefer the u8 type since
>> people usually use that in new patches, so over time we'd get rid
>> of the type inconsistencies.
> 
> If you really want to get rid of type inconsistencies in the source,
> the C99 stdint types should be used. In retrospect, defining our own
> types like [us](8|16|32) are not really needed, much less for new code.

Thats what netfilter used initially. But as I said, people
usually use the u{8,16,32} types for networking and there's
little point in fighting against that. So please either use
u8 everywhere or at least don't mix the types in the same
function.
