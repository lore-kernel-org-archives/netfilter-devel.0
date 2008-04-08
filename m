From: Patrick McHardy <kaber@trash.net>
Subject: Re: 0/8 Netfilter patches (group 2)
Date: Tue, 08 Apr 2008 18:23:00 +0200
Message-ID: <47FB9BE4.5060209@trash.net>
References: <alpine.LNX.1.10.0804081803370.2229@fbirervta.pbzchgretzou.qr> <47FB99CA.5060002@trash.net> <alpine.LNX.1.10.0804081814580.2229@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYDHQXC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:23:02 -0400
In-Reply-To: <alpine.LNX.1.10.0804081814580.2229@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-08 18:14, Patrick McHardy wrote:
>> Small suggestion for improvement (don't worry, your series
>> is fine :)): the best ordering for all these patches would
>> have been:
>>
>> Set 1: boolean conversions
>> Set 2: length match (shouldn't have dependencies)
>> Set 3: recent match (also shouldn't have dependencies)
>> Set 4: prefix table
>> Set 5: TCPMSS target
>> Set 6: ARP-tables patches
> 
> You would not believe it, but it was set-ordered.
> YMMV what makes up a set, though.
> 
> [...]
> Invent house numbering?
> 
>  [patch 12/xx] xt_length
>  [patch 12a/xx] xt_length userspace
>  [patch 13/xx] xt_foobar (kernel only thing)
>  [patch 14/xx] xt_bazzzz
>  [patch 14a/xx] ..
> 
> don't think git likes that :p

:)

Just sending them seperately makes the barriers explicit,
so that makes most sense IMO.
