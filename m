From: Jan Engelhardt <jengelh@medozas.de>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_netfilter=3A_xtables=3A_introduce_xt=5Flength_revision_2=C2=BD?=
Date: Mon, 2 Aug 2010 19:01:27 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008021859300.27949@obet.zrqbmnf.qr>
References: <1279961719-20479-1-git-send-email-jengelh@medozas.de> <1279971776.2451.66.camel@edumazet-laptop> <alpine.LSU.2.01.1007241344270.11738@obet.zrqbmnf.qr> <4C56EBED.7030708@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, xiaosuo@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35423 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab0HBRB3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:01:29 -0400
In-Reply-To: <4C56EBED.7030708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-08-02 18:01, Patrick McHardy wrote:
>>>> +	if (info->flags & XT_LENGTH_LAYER3)
>>>> +		len = ntohs(iph->tot_len);
>>>> +	else if (info->flags & XT_LENGTH_LAYER4)
>>>> +		len = ntohs(iph->tot_len) - par->thoff;
>>>> +	else if (info->flags & XT_LENGTH_LAYER5)
>>>> +		hit = xtlength_layer5(&len, skb, iph->protocol, par->thoff);
>>>> +	else if (info->flags & XT_LENGTH_LAYER7)
>>>> +		hit = xtlength_layer7(&len, skb, iph->protocol, par->thoff);
>>>> +	if (!hit)
>>>> +		return false;
>>>> +}
>>>
>>> This serie of tests is expensive and useless.[...]
>> Not really[...]
>> 
>> The compiler is smart enough to see that a run of if tests against
>> the same variable with different values is transformable into a
>> switch statement.
>
>They are mutually exclusive though, so using a bitmask doesn't make
>much sense.

Right. Since that's been already fixed in the submission, can it go in? 
:)
