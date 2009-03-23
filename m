From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: drop packet without verdict from nfqueue after timeout
Date: Mon, 23 Mar 2009 23:15:09 +0100
Message-ID: <49C809ED.8070308@trash.net>
References: <1691181420.20090323214823@yandex.ru>	 <49C7E095.9020002@trash.net> <1237845953.4786.47.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50096 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170AbZCWWPN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:15:13 -0400
In-Reply-To: <1237845953.4786.47.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
>> There's a very easy and cheap way to handle this. The packets have
>> sequence numbers and userspace should issues verdicts in ascending
>> order anyways to avoid reordering. Just add something that will drop
>> everything in the queue up to the sequence number contained in the
>> netlink message.
>>     
>
> I don't think the described mechanism is generic enough to be a default
> behaviour. It should be useful for projects like snort-inline but it
> will really a problem for software like NuFW which are asynchronous by
> design.
>
> In NuFW, packet authentication is triggered by a user message (signing
> of packet is done is userspace). Thus the ordering of the answer depends
> of the ordering of user messages. As NuFW authenticate packet at network
> scale (there is thus plenty of users), it is not possible to assume that
> the answer will be ordered.
>
> Thus, even if it could be useful, this mechanism should only be
> activated by an explicit userspace query. 

Good point. The in-sequence handling is also only necessary per flow,
so this definitely would need to be enabled explicitly.

