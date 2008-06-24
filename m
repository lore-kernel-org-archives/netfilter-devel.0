From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv2] deliver events for conntracks created via ctnetlink
Date: Tue, 24 Jun 2008 19:28:57 +0200
Message-ID: <48612ED9.40708@trash.net>
References: <4857A939.6050701@netfilter.org> <486118A9.5030808@trash.net> <48611CA3.1050305@trash.net> <48612C87.9050207@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59175 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbYFXR3D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:29:03 -0400
In-Reply-To: <48612C87.9050207@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> A few minor nits:
>>>
>>>> ...
>> One more thing: the patch still doesn't follow the correct
>> netlink semantic for notifations on changes triggered by
>> userspace I described in the review of the first version
>> of this patch.
>>
>> Please always mention which changes requested during a
>> review were made and which weren't (any why) when sending
>> updated versions.
> 
> Sorry, there's no particular reason, I forgot to include this. With
> regards to nlmsg_report/nlmsg_notify, I just noticed that the echo
> cannot be unset for destroy messages since we call nf_conntrack_event()
> inside destroy_conntrack().

Mhh .. its not pretty, but one thing that might work is
deliver the event manually and then set the DYING bit
manually to avoid further event delivery for the entry.
