From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] deliver events for conntracks created via ctnetlink
Date: Tue, 24 Jun 2008 19:19:03 +0200
Message-ID: <48612C87.9050207@netfilter.org>
References: <4857A939.6050701@netfilter.org> <486118A9.5030808@trash.net> <48611CA3.1050305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59029 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755737AbYFXRTI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:19:08 -0400
In-Reply-To: <48611CA3.1050305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> A few minor nits:
>>
>>> ...
> 
> One more thing: the patch still doesn't follow the correct
> netlink semantic for notifations on changes triggered by
> userspace I described in the review of the first version
> of this patch.
> 
> Please always mention which changes requested during a
> review were made and which weren't (any why) when sending
> updated versions.

Sorry, there's no particular reason, I forgot to include this. With
regards to nlmsg_report/nlmsg_notify, I just noticed that the echo
cannot be unset for destroy messages since we call nf_conntrack_event()
inside destroy_conntrack().

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
