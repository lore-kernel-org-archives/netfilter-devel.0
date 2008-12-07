From: Patrick McHardy <kaber@trash.net>
Subject: Re: More nf_conntrack_sip questions
Date: Sun, 07 Dec 2008 17:06:50 +0100
Message-ID: <493BF49A.8090203@trash.net>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com> <49396F30.3@trash.net> <49397007.9030809@redfish-solutions.com> <493970C0.2070003@trash.net> <493973BE.9010001@redfish-solutions.com> <4939754F.50905@trash.net> <493B194F.20805@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYLGQGx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:06:53 -0500
In-Reply-To: <493B194F.20805@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Prindeville wrote:
> Patrick McHardy wrote:
>> Philip Prindeville wrote:
>> That version is known not to work very well, 2.6.26 includes
>> a largely rewritten version.
>>
>> This is a backport to 2.6.25:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.25-sip.git
> 
> Well, it might be easier to simply jump to 2.6.26.8 (unless there's 
> something horribly wrong with that version).
> 
> Just means going through patch hell again as we munge patches for ocf, 
> imq, squashfs, unionfs, multi-routing, etc.
> 
> Say, I've been wondering about that: what is the status of dead default 
> gateway detection?  Not sure why it requires a patch and isn't just 
> something selectable via CONFIG_xxx...

I'm guessing the patch hasn't been submitted yet.
