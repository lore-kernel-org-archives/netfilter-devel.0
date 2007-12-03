From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Mon, 3 Dec 2007 15:19:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712031517070.21880@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr>
 <474A7628.6050605@trash.net> <474A8F3B.8020209@ufomechanic.net>
 <474AE7DA.9050302@trash.net> <474AF57A.3090100@ufomechanic.net>
 <474B6284.6010104@trash.net> <474BE470.2050209@ufomechanic.net>
 <474C158D.9050004@trash.net> <474C1CC6.1050401@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46800 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXLCOTK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:19:10 -0500
In-Reply-To: <474C1CC6.1050401@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Nov 27 2007 13:33, Amin Azez wrote:
>>>> The version Jan posted doesn't match on mac but on IP address.
>>>
>>> It should be refusing to match mac if the ip's do match in the --gateway
>>> match, because if the IP matches then the host is being addressed
>>> directly and not as a gateway.
>>> That's why it also checks IP.
>>>
>>> +    if (memcmp(&info->gateway_v4, &neigh->primary_key, tbl->key_len) != 0)
>>> +        return false;
>>>
>>> It checks mac as the primary key of the neighbour table.
>>
>> The primary key is the IP address.
>
>thats true :-) Shame!
>I can't even remember code I wrote 5 months back!
>
>So....
>
>And so unless Jan has a strong case, I think you are right that this
>adds nothing extra that routing realms have, and possible causes some
>surprises in some non-routing conditions.
>
>Although I still prefer it in routing cases, I admit there is no strong
>case that you should prefer it.

So, does this make xt_gateway "obsolete enough" for me to drop it from
my trees?
