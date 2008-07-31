From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 7/7] dynamic calculation of event message size for ctnetlin
Date: Thu, 31 Jul 2008 17:54:45 +0100
Message-ID: <4891EE55.5020102@gmx.ch>
References: <48904B37.7090108@netfilter.org> <4891E7C1.2060203@gmx.ch> <4891EB67.7000404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47909 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752662AbYGaQyr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:54:47 -0400
In-Reply-To: <4891EB67.7000404@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Fabian Hugelshofer wrote:
>> Pablo Neira Ayuso wrote:
>>> [PATCH] dynamic calculation of event message size for ctnetlink
>>>
>>> This patch adds dynamic message size calculation for ctnetlink. This
>>> reduces CPU consumption since the overhead in the message trimming
>>> is removed.
>> Thanks for the patch.
>>
>> Just did some performance tests. On average it saves 5% CPU usage at
>> ~1600pps (UDP packets, 1000B payload, random source ports) on my router
>> (IXP4XX, 266Mhz).
>>
>> With the unclean patch the performance gain was slightly higher. I have
>> posted it was 10%, but as far as I remember it was actually a bit less
>> then that. The remaining difference can be explained by the length
>> calculation overhead and measuring inaccuracy.
> 
> How are you measuring CPU consumption? I would not trust "top" or
> something similar too much. I usually use cyclesoak, however I guess
> that you'll need a bit of hacking to get it working there.
> 
> I'll try to do some measurements in my platform soon anyway.

I am using top indeed. I run it in batch mode with a period of 10s and 
dump to a file. At the end I calculate the average idle usage over 5 
periods (ignoring the first one).

