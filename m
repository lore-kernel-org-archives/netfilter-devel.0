From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: SNAT before IPSEC - why?
Date: Sat, 08 Oct 2011 17:09:34 -0400
Message-ID: <4E90BC0E.8030004@earthlink.net>
References: <4E8FB084.6030807@earthlink.net> <alpine.LNX.2.01.1110081124330.2367@frira.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:45709 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190Ab1JHVUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Oct 2011 17:20:52 -0400
In-Reply-To: <alpine.LNX.2.01.1110081124330.2367@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/08/2011 05:26 AM, Jan Engelhardt wrote:
> On Saturday 2011-10-08 04:08, Stephen Clark wrote:
>
>    
>> Hi,
>>
>> What is the reasoning for having SNAT happen before ipsec encryption?
>>      
> It can happen before and/or after - see the nf flow graph.
>
>    
Do you have a link to the graph?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



