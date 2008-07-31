From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 7/7] dynamic calculation of event message size for ctnetlin
Date: Thu, 31 Jul 2008 18:42:15 +0200
Message-ID: <4891EB67.7000404@netfilter.org>
References: <48904B37.7090108@netfilter.org> <4891E7C1.2060203@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52051 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751653AbYGaQmW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:42:22 -0400
In-Reply-To: <4891E7C1.2060203@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Pablo Neira Ayuso wrote:
>> [PATCH] dynamic calculation of event message size for ctnetlink
>>
>> This patch adds dynamic message size calculation for ctnetlink. This
>> reduces CPU consumption since the overhead in the message trimming
>> is removed.
> 
> Thanks for the patch.
> 
> Just did some performance tests. On average it saves 5% CPU usage at
> ~1600pps (UDP packets, 1000B payload, random source ports) on my router
> (IXP4XX, 266Mhz).
> 
> With the unclean patch the performance gain was slightly higher. I have
> posted it was 10%, but as far as I remember it was actually a bit less
> then that. The remaining difference can be explained by the length
> calculation overhead and measuring inaccuracy.

How are you measuring CPU consumption? I would not trust "top" or
something similar too much. I usually use cyclesoak, however I guess
that you'll need a bit of hacking to get it working there.

I'll try to do some measurements in my platform soon anyway.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
