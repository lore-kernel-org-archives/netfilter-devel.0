From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5] conntrack: ecache: move event cache to conntrack
 extension infrastructure
Date: Fri, 27 Mar 2009 12:58:49 +0100
Message-ID: <49CCBF79.4000800@trash.net>
References: <20090327093822.8259.50902.stgit@Decadence> <20090327094009.8259.64117.stgit@Decadence> <49CCA1DA.7060902@trash.net> <49CCBA7C.2090609@netfilter.org> <49CCBB87.2080404@trash.net> <49CCBF1F.8010806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59514 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZC0L7A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:59:00 -0400
In-Reply-To: <49CCBF1F.8010806@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Patrick McHardy wrote:
>>>> Generally, I'd say a better approach is to get rid of the notifier
>>>> chain (unnecessary overhead for the single user we have), replace it
>>>> by a function pointer for event delivery and use that as an indication
>>>> that events should be tracked.
>>> I have a fuzzy morning. I get the idea of replacing the notifier chain
>>> by a function pointer but I don't get the idea of the indication.
>> Something like:
>>
>> if (nf_ct_deliver_events == NULL)
>>     don't cache events, try to avoid any other event-related overhead
>>
>> with nf_ct_deliver_events being the function pointer. Similar to
>> the sysctl, that allows to enable/disable hopefully most of the
>> event stuff at runtime.
> 
> Thanks, now I see, I was mixing this with the extra atomic operations
> that nf_conntrack_event_cache() adds in my patch. I'm going to reply
> your other email which refers to the extra atomic-operations issue.

You could of course still add the sysctl on top for the people
doing non-modular builds. It would have to default to "on" though,
so I'm not sure its really worth it.
