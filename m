From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: stomping static data pull
Date: Fri, 4 Dec 2009 13:06:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912041305280.23887@obet.zrqbmnf.qr>
References: <1255166535-6386-1-git-send-email-jengelh@medozas.de> <4AE869FB.1000506@trash.net> <alpine.LSU.2.00.0910281817210.15948@obet.zrqbmnf.qr> <4AE9BBFE.400@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43249 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbZLDMGm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:06:42 -0500
In-Reply-To: <4AE9BBFE.400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-10-29 16:59, Patrick McHardy wrote:
>> On Wednesday 2009-10-28 16:57, Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>> I incorporated your suggestions and propose this new 4-series set.
>>> Could you give me a short description of the changes relative
>>> to the first incarnation? Thanks.
>> 
>> http://osdir.com/ml/general/2009-08/msg10540.html
>> - splitting xt_repldata_create
>> - giving it a name of your choice
>> - return semantics (found a missing return keyword; just refreshed top 
>> is commit v2.6.32-rc3-4-g7891b6c)
>> 
>
>OK thanks, that leaves my worries about adding additional runtime
>overhead. I'll do some quick benchmarks to see if it really has
>a measurable impact.
>
How would one measure this in a meaningful way? rdtsc? (that would only 
work on x86, in fact.)

And I guess that one could 
always construct a case whereby the patched result looks 'slow'. :/
