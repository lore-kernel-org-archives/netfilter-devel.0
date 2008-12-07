From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Re: More nf_conntrack_sip questions
Date: Sat, 06 Dec 2008 16:31:11 -0800
Message-ID: <493B194F.20805@redfish-solutions.com>
References: <4935B885.8030107@redfish-solutions.com> <493954ED.9070002@trash.net> <49396C4D.7020400@redfish-solutions.com> <49396DDD.9080308@trash.net> <49396E91.1060403@redfish-solutions.com> <49396F30.3@trash.net> <49397007.9030809@redfish-solutions.com> <493970C0.2070003@trash.net> <493973BE.9010001@redfish-solutions.com> <4939754F.50905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:58281 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbYLGAbR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Dec 2008 19:31:17 -0500
In-Reply-To: <4939754F.50905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Philip Prindeville wrote:
>> Patrick McHardy wrote:
>>> Try sip_direct_media=0
>>
>> That's not an option in 2.6.25.19...  when did it get introduced?  Do 
>> we need to run a more recent version to pick up useful fixes?
>>
>> Also, does 2.6.25.19 include the port-range helpers?
>>
>> Unless I'm misunderstanding something....
>
> That version is known not to work very well, 2.6.26 includes
> a largely rewritten version.
>
> This is a backport to 2.6.25:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.25-sip.git

Well, it might be easier to simply jump to 2.6.26.8 (unless there's 
something horribly wrong with that version).

Just means going through patch hell again as we munge patches for ocf, 
imq, squashfs, unionfs, multi-routing, etc.

Say, I've been wondering about that: what is the status of dead default 
gateway detection?  Not sure why it requires a patch and isn't just 
something selectable via CONFIG_xxx...

-Philip

