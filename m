From: Patrick McHardy <kaber@trash.net>
Subject: Re: [0/3] conntrack event kernel issues
Date: Sun, 25 May 2008 16:57:11 +0200
Message-ID: <48397E47.2020305@trash.net>
References: <1211447573.6878.36.camel@pumper.lan.luxnet.ch> <48369678.7000905@trash.net> <4836AB4C.8030304@gmx.ch> <4836ACA9.5040507@trash.net> <4836C30C.8020305@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYEYO5P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 May 2008 10:57:15 -0400
In-Reply-To: <4836C30C.8020305@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>>> Then there is this thing with the TCP RST. I think, that the event 
>>> data should be accurate. If the status is returned (with patch 1), 
>>> then it should have the SEEN_REPLY flag set. Another issue is that 
>>> the accounting counters are not updated. IMHO this should be done as 
>>> well (is not in my patches).
>>
>> Fully agreed about the counters. About the SEEN_REPLY bit - that
>> depends on how you define its meaning. So far its only set if
>> a valid reply for the connection is seen - which a RST isn't.
> 
> I consider a RST as a valid reply for a connection. It matches the tuple 
> and is in reply direction (ctinfo is set to IS_REPLY). Further the TCP 
> protocol handler returns no error. The SEEN_REPLY bit is actually set at 
> the end of nf_conntrack_in() but the destroy event is already triggered 
> by the TCP handler.
> 
> Increasing the counters in reply direction without setting the 
> SEEN_REPLY bit seems a bit weird to me.


OK, you've convinced me. If you send me a patch to update
the counters properly and set the SEEN_REPLY bit, I'll
apply it.



