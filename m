From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Quota on SMP AGAIN
Date: Fri, 28 Dec 2007 16:50:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: gpf <gpf@simm.ru>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51407 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbXL1PuX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:50:23 -0500
In-Reply-To: <477515BB.1060303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 28 2007 16:26, Patrick McHardy wrote:
> gpf wrote:
>> hi
>>
>> iptables, iptables-save not working properly
>>
>> [root@ns bind] iptables -L quot |grep devel
>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>> 226620450 bytes
>> [root@ns bind] dpkg -l |grep iptables
>> ii  iptables                   1.3.6.0debian1-5
>>   
>
> The quota extension in old iptables releases is incompatible with the
> version merged upstream.

I am seeing this too on 2.6.23.10 with iptables-1.4.0svn7097.
No incompatibilities obvious to me, both kernel and iptables use
the same xt_quota.h.
