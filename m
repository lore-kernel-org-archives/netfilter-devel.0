From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC 2/3] netfilter: add ipv4 reverse path filter match
Date: Tue, 30 Aug 2011 15:03:54 +0200
Message-ID: <4E5CDFBA.3010509@trash.net>
References: <1314350465-19598-1-git-send-email-fw@strlen.de> <1314350465-19598-3-git-send-email-fw@strlen.de> <4E5CD8DA.1010204@trash.net> <20110830124119.GB7548@Chamillionaire.breakpoint.cc> <4E5CDB71.9080504@trash.net> <20110830125736.GD7548@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1H3NDz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:03:55 -0400
In-Reply-To: <20110830125736.GD7548@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30.08.2011 14:57, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>> On 30.08.2011 14:41, Florian Westphal wrote:
>>> Patrick McHardy <kaber@trash.net> wrote:
>>>>> main drawback:
>>>>> - additional fib lookup to get oif (used as flow key in reverse lookup)
>>>>
>>>> As discussed during the workshop, we could just perform input routing
>>>> in the module to get the oif for free. That would require to take care
>>>> of statistics as currently done in ip_rcv_finish() though.
>>>
>>> Right.
>>> Any idea on how to solve the 'struct sk_buff *' (ip_route_input) vs.
>>> 'const struct sk_buff *' (matches) problem?
>>>
>>> We'd have to modify all the match signatures...
>>
>> Some modules already remove the const by casting it away, not
>> pretty, but works. Since the kernel doesn't assume strict aliasing
>> this also shouldn't cause any problems in the future. Alternatively
>> we can change the function signatures of course, although that would
>> be a bit unfortunate just for this special case.
> 
> Agreed, modifying the match function signature for this case would be
> sad.
> 
> I'll wait a couple of days and will send an updated version
> that uses the ugly cast + ip_route_input.

Regarding the statistic update, I'd suggest to move those to
a new function and call it from your module to avoid duplication
and possibly getting out of sync in the future.

