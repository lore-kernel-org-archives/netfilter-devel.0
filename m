From: Patrick McHardy <kaber@trash.net>
Subject: Re: Code cleanups
Date: Mon, 15 Feb 2010 17:23:26 +0100
Message-ID: <4B7974FE.3060704@trash.net>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <alpine.LSU.2.01.1002102209360.24621@obet.zrqbmnf.qr> <4B796976.7050805@trash.net> <alpine.LSU.2.01.1002151653020.27775@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0BOQX3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:23:29 -0500
In-Reply-To: <alpine.LSU.2.01.1002151653020.27775@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-02-15 16:34, Patrick McHardy wrote:
>>>> the next patch pack is mostly about cleanups, and there is one
>>>> commit for improving debug a little.
>>>> Pull URL will be posted once the previous request has been
>>>> merged, but I am already posting them now for review.
>>>>
>>>> The following changes since commit e3eaa9910b380530cfd2c0670fcd3f627674da8a:
>>>> are available in the git repository at:
>>> 	git://dev.medozas.de/linux master
>> This doesn't apply cleanly anymore due to the mangle table
>> fixes from Alexey.
> 
> 
> Rebased, see below.
> 
> 
> The following changes since commit 98e6d2d5ee26bf56850a10eb64139c68fb09ba19:
>   Jan Engelhardt (1):
>         netfilter: xt_recent: inform user when hitcount is too large
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master-d5d1baa
> 
> Jan Engelhardt (6):
>       netfilter: iptables: remove unused function arguments
>       netfilter: reduce NF_HOOK by one argument
>       netfilter: get rid of the grossness in netfilter.h
>       netfilter: xtables: print details on size mismatch
>       netfilter: xtables: constify args in compat copying functions
>       netfilter: xtables: add const qualifiers


Pulled and pushed out again, thanks.

> And the second run would be
> 
> 
> The following changes since commit d5d1baa15f5b05e9110403724d5dc72d6d541e04:
>   Jan Engelhardt (1):
>         netfilter: xtables: add const qualifiers
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (6):
>       netfilter: xtables: replace XT_ENTRY_ITERATE macro
>       netfilter: xtables: optimize call flow around xt_entry_foreach
>       netfilter: xtables: replace XT_MATCH_ITERATE macro
>       netfilter: xtables: optimize call flow around xt_ematch_foreach
>       netfilter: xtables: reduce arguments to translate_table
>       netfilter: xtables2: make ip_tables reentrant

These will have to wait until I can review them. This won't happen
today since I want to get the first batch of patches out previously.
