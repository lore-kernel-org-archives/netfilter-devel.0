From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Wed, 02 Jul 2008 16:02:20 +0200
Message-ID: <486B8A6C.9040502@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net> <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl> <486B80F5.7050801@trash.net> <Pine.LNX.4.64.0807021522520.4958@bizon.gios.gov.pl> <486B853A.205@trash.net> <Pine.LNX.4.64.0807021542420.4958@bizon.gios.gov.pl> <486B87FE.90909@trash.net> <alpine.LNX.1.10.0807021556310.20393@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38678 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYGBOCW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:02:22 -0400
In-Reply-To: <alpine.LNX.1.10.0807021556310.20393@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-07-02 15:51, Patrick McHardy wrote:
>>>> Seems you're the first to try module_param_named with a bool :)
>>>> Does this help?
>>> It helps but produces a lot of warnings in other places:
>>>
>>> kernel/printk.c: In function '__check_time':
>>> kernel/printk.c:570: warning: return from incompatible pointer type
>> Ah I see. You're supposed to use an int for the variable and
>> bool only for module_param_named.
> 
> Yes but since we have 'bool' type (though only since recently),
> module_param_bool should also *take* a bool.

It probably should, but module_param preceds the boolean type
in the kernel, so it seems someone wasn't motivated enough to
fix up all the users.

And since this is not related to netfilter in any way, lets
just use it how its supposed to.


