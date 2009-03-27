From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] conntrack: ecache: move event cache to conntrack
 extension infrastructure
Date: Fri, 27 Mar 2009 12:57:19 +0100
Message-ID: <49CCBF1F.8010806@netfilter.org>
References: <20090327093822.8259.50902.stgit@Decadence> <20090327094009.8259.64117.stgit@Decadence> <49CCA1DA.7060902@trash.net> <49CCBA7C.2090609@netfilter.org> <49CCBB87.2080404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39690 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbZC0L51 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:57:27 -0400
In-Reply-To: <49CCBB87.2080404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Generally, I'd say a better approach is to get rid of the notifier
>>> chain (unnecessary overhead for the single user we have), replace it
>>> by a function pointer for event delivery and use that as an indication
>>> that events should be tracked.
>>
>> I have a fuzzy morning. I get the idea of replacing the notifier chain
>> by a function pointer but I don't get the idea of the indication.
> 
> Something like:
> 
> if (nf_ct_deliver_events == NULL)
>     don't cache events, try to avoid any other event-related overhead
> 
> with nf_ct_deliver_events being the function pointer. Similar to
> the sysctl, that allows to enable/disable hopefully most of the
> event stuff at runtime.

Thanks, now I see, I was mixing this with the extra atomic operations
that nf_conntrack_event_cache() adds in my patch. I'm going to reply
your other email which refers to the extra atomic-operations issue.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
