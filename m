From: Patrick McHardy <kaber@trash.net>
Subject: Re: [0/3] conntrack event kernel issues
Date: Fri, 23 May 2008 13:38:17 +0200
Message-ID: <4836ACA9.5040507@trash.net>
References: <1211447573.6878.36.camel@pumper.lan.luxnet.ch> <48369678.7000905@trash.net> <4836AB4C.8030304@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32910 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYEWLiU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 07:38:20 -0400
In-Reply-To: <4836AB4C.8030304@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>>> patch1: export ct->status on all conntrack events
>>> patch2: set SEEN_REPLY before destroying a conntrack on TCP RST
>>> patch3: new status flag SEEN_RELATED
>>
>> I can't imagine other uses for this than the one you described,
>> especially for 2 and 3. Patch 3 also adds code in a hot path,
>> so unless someone can present good arguments in favour of these
>> patches, I don't really want to apply them.
> 
> This is what I had expected. Especially for patch 3 I know that it's 
> very unlikely to be integrated because of its limited use and the 
> changes it makes.
> 
> For not exporting the connection status on a destroy event I see no 
> reason. The information is there and should be exported. Might also be 
> interesting to have the EXPECTED or ASSURED flags.

Yes, that one I'm fine with.

> Then there is this thing with the TCP RST. I think, that the event data 
> should be accurate. If the status is returned (with patch 1), then it 
> should have the SEEN_REPLY flag set. Another issue is that the 
> accounting counters are not updated. IMHO this should be done as well 
> (is not in my patches).

Fully agreed about the counters. About the SEEN_REPLY bit - that
depends on how you define its meaning. So far its only set if
a valid reply for the connection is seen - which a RST isn't.


