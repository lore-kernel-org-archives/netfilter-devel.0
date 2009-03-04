From: Bryan Duff <bduff@ecessa.com>
Subject: Re: operation failure on delete
Date: Wed, 04 Mar 2009 13:01:14 -0600
Message-ID: <49AECFFA.6030401@astrocorp.com>
References: <49AEA966.2020007@astrocorp.com> <49AEC4A8.7020000@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21606 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZCDTBH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:01:07 -0500
In-Reply-To: <49AEC4A8.7020000@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks, the patch works.

Adding esp would be superfantabulous as well.

-Bryan

Pablo Neira Ayuso wrote:
> Bryan Duff wrote:
>   
>> //snip - conntrack search and attempted delete.
>> root@localhost / # conntrack -L -p gre  unknown  47 27 src=60.60.60.151
>> dst=192.168.2.2 packets=6 bytes=648 [UNREPLIED] src=10.10.10.100
>> dst=60.60.60.151 packets=0 bytes=0 mark=2 use=1
>> conntrack v0.9.11 (conntrack-tools): 1 flow entries has been shown.
>> root@localhost / # conntrack -D -p gre
>> conntrack v0.9.11 (conntrack-tools): Operation failed: invalid parameters
>> //end snip
>>
>> But I can delete tcp, udp, icmp conntrack entries.  I can only guess
>> that there is a problem with "unknown" protocols like gre (haven't
>> checked on esp, and so forth).  Using the protocol number (in this case
>> 47) also fails.
>>     
>
> No, it seems that the problem is that libnetfilter_conntrack-0.0.99 does
> not include support for GRE yet.
>
>   
>> I'm using  libnfnetlink-0.0.40 and libnetfilter_conntrack-0.0.99
>>
>> Kernel version 2.6.29-rc7.  The conntrack version is that released on
>> the website (md5sum: ae97d335ad44e9611adde881490c8ec9).
>>     
>
> The following patch should add it, it compiles, I didn't tested though.
> I'd appreciate if you call tell me how it goes with it.
>
>   

