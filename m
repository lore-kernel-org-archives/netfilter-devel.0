From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Fri, 16 Jul 2010 13:20:57 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007161320310.14608@obet.zrqbmnf.qr>
References: <1279278635.1603.53.camel@powerslave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39736 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028Ab0GPLU7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:20:59 -0400
In-Reply-To: <1279278635.1603.53.camel@powerslave>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-07-16 13:10, Luciano Coelho wrote:
>Jan Engelhardt <jengelh@medozas.de> writes:
>> On Thursday 2010-04-22 13:14, Patrick McHardy wrote:
>> 
>> > This looks better, thanks. A few remaining questions about things
>> > I missed previously:
>> 
>> Will deal with it shortly.
>
>Are you planning to resend this patch with the changes Patrick
>suggested?

I can try.

>As you may have seen in my earlier rfc email, I'm interested in
>something similar to the condition match.  I'm not sure whether the best
>approach is to create a CONDITION target where we can set the condition
>variable in the iptables itself or if it is better to create a new
>"variable match" and an accompanying "VARIABLE target" that keeps the
>variables in memory, instead of using procfs.

procfs is in memory :)
