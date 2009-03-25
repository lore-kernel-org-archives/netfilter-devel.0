From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [PATCH] dynamic calculation of event message size for
 ctnetlink
Date: Wed, 25 Mar 2009 18:22:39 +0100
Message-ID: <49CA685F.9040503@trash.net>
References: <20090317094909.6434.27331.stgit@Decadence> <49BF91A8.2070900@trash.net> <20090317121446.GB3526@mail.eitzenberger.org> <49BF94A6.6080508@trash.net> <49C0266B.40204@netfilter.org> <49C07B87.90404@trash.net> <20090318083840.GA9679@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35252 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZCYRWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:22:46 -0400
In-Reply-To: <20090318083840.GA9679@mail.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> On Wed, Mar 18, 2009 at 05:41:43AM +0100, Patrick McHardy wrote:
> 
>>> This calculation results in no message trim if most of those attributes
>>> are present. However, assuming the worst case (no counters, no helper,
>>> no mark, no master tuple, etc.), netlink_trim() may be called. My patch
>>> calculates the exact size, so there's no trimming for any case.
>> The numbers imply that its still a net win. But its a valid point, if
>> the common case will still result in reallocations, it might make sense
>> to include the space for a few of those members optionally to make
>> sure we don't cross the 50% waste threshold.
> 
> That's a good point.
> 
> For reference these are the attributes of TCP conntrack event, I have
> marked the optional NLAs.  I don't know what the ratio is in bytes
> though.

Thanks Holger. I'm going to apply your patches since they're already
an improvement, we can do further refinement on top.
