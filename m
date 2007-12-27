From: gpf <gpf@simm.ru>
Subject: Re: Quota on SMP AGAIN
Date: Thu, 27 Dec 2007 19:55:19 +0300
Message-ID: <4773D8F7.1060700@simm.ru>
References: <4773C13D.1040106@simm.ru> <Pine.LNX.4.64.0712271653410.29013@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns.simm.ru ([89.239.191.1]:56303 "EHLO ns.simm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbXL0Qza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2007 11:55:30 -0500
In-Reply-To: <Pine.LNX.4.64.0712271653410.29013@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt ?????:
> On Dec 27 2007 18:14, gpf wrote:
>   
>> iptables, iptables-save not working properly
>>
>> [root@ns bind] iptables -L quot |grep devel
>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>> 226620450 bytes
>> [root@ns bind] iptables -L quot |grep devel
>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>> 226620036 bytes
>> [root@ns bind] iptables -L quot |grep devel
>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>> 227219801 bytes
>> [root@ns bind] iptables -L quot |grep devel
>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>> 227219801 bytes
>> [root@ns bind] iptables -L quot |grep devel
>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>> 226619312 bytes
>>
>>     
> Well at least I can reproduce it fairly easily :-)
>
> Linux ccgmbh 2.6.23.10-ccj62-regular #1 SMP 2007/10/26 14:17:15 UTC x86_64
> x86_64 x86_64 GNU/Linux
>   
kernel upgrade:
[root@ns ~] uname -a
Linux ns 2.6.22-3-686 #1 SMP Tue Dec 4 02:25:59 UTC 2007 i686 GNU/Linux

[root@ns ~] iptables -L quot |grep Yanus
RETURN 0 -- anywhere Yanus.simm.ru quota: 138260287 bytes
[root@ns ~] iptables -L quot |grep Yanus
RETURN 0 -- anywhere Yanus.simm.ru quota: 138258218 bytes
[root@ns ~] iptables -L quot |grep Yanus
RETURN 0 -- anywhere Yanus.simm.ru quota: 138334555 bytes

:((((((
