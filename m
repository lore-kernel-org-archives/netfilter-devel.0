From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: generate initial table on-demand
Date: Wed, 10 Feb 2010 17:25:49 +0100
Message-ID: <4B72DE0D.1030808@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-5-git-send-email-jengelh@medozas.de> <4B72D198.7040204@trash.net> <alpine.LSU.2.01.1002101708320.12673@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54273 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0BJQZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:25:56 -0500
In-Reply-To: <alpine.LSU.2.01.1002101708320.12673@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-02-10 16:32, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> +void *arpt_alloc_initial_table(const struct xt_table *info)
>>> +{
>>> +	return xt_repldata_mk(arpt, ARPT);
>> I vaguely recall asking for a nicer (more pronouncable) name.
>> xt_alloc_initial_table() perhaps? xt_init_table()?
> 
> Yes you asked for a nicer name. And I gave it one. To quote you and me:
> 
> http://osdir.com/ml/general/2009-08/msg10540.html
> 
> Jan> #define xt_repldata_mk(type, typ2)
> 
> Patrick> I also would prefer a nicer name, something like
> xt_alloc_initial_table().

But it still uses xt_repldata_mk().
