From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/29] [NETFILTER]: remove arpt_table indirection macro
Date: Tue, 01 Apr 2008 15:08:25 +0200
Message-ID: <47F233C9.7090509@trash.net>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr> <d77e5bacf4b9bb4fcc89fd261529a31c7c5002b2.1206469820.git.jengelh@computergmbh.de> <47EAB39C.3050004@trash.net> <alpine.LNX.1.10.0803270216480.22661@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61759 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYDANI2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:08:28 -0400
In-Reply-To: <alpine.LNX.1.10.0803270216480.22661@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Wednesday 2008-03-26 21:35, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>>  Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>>
>> Applied, but this triggered some warnings caused by the
>> constification patches I missed earlier:
>>
>> net/ipv4/netfilter/arp_tables.c: In function 
>> 'compat_copy_entries_to_user':
>> net/ipv4/netfilter/arp_tables.c:1569: warning: passing argument 1 of 
>> 'alloc_counters' discards qualifiers from pointer target type
>> net/ipv4/netfilter/arp_tables.c: In function 'compat_get_entries':
>> net/ipv4/netfilter/arp_tables.c:1628: warning: passing argument 1 of 
>> 'xt_table_unlock' discards qualifiers from pointer target type
>> net/ipv4/netfilter/arp_tables.c: In function 
>> 'compat_copy_entries_to_user':
>> net/ipv4/netfilter/arp_tables.c:1569: warning: passing argument 1 of 
>> 'alloc_counters' discards
>>
>> Again, please test with CONFIG_COMPAT if you touch this code.
>> I'm leaving for tonight, please send me a patch on top of the
>> faulty one to fold in for fixing this.
> 
> Right...

Does not apply on top of 7/29:

patching file net/ipv4/netfilter/arp_tables.c
Hunk #1 FAILED at 737.
Hunk #2 FAILED at 1555.
Hunk #3 FAILED at 1593.
3 out of 3 hunks FAILED -- saving rejects to file 
net/ipv4/netfilter/arp_tables.c.rej
