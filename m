From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 5/27] Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
Date: Fri, 11 Jan 2008 00:01:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801102357590.425@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022126330.14900@fbirervta.pbzchgretzou.qr>
 <477E4496.4050604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48478 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYAJXBq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:01:46 -0500
In-Reply-To: <477E4496.4050604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 15:37, Patrick McHardy wrote:
>> 
>>     [NETFILTER]: Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
>>     
>>     The kernel parts of the structures do not need to be fixed nor
>>     compat-converted; all other fields already use fixed types, so the
>>     compat code is not needed.
>
> Did you test this? It definitely seems necessary since pointers have
> different size and allignment requirements on 64 bit.

Hm you were right. I removed the compat from hashlimit and promptly got

	invalid size 64 != 52

but then again I wonder why xt_connlimit works without compat.

> In the hashlimit case we have a 4 byte hole before the hinfo pointer
> on 64 bit which is not present on 32 bit, limit uses an unsigned long
> which has different size and also has a hole before the master pointer
> on 64 bit.
>
Even if that hole was not there, it would be

	64 != 56

or so, no?
