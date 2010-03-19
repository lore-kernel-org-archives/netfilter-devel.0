From: Tim Gardner <timg@tpi.com>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Mar 2010 10:14:51 -0600
Message-ID: <4BA3A2FB.1020508@tpi.com>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <4B83DF52.5000806@trash.net> <201003191604.45719.thomas.jarosch@intra2net.com> <4BA39B3D.4070509@trash.net>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4650 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0CSQPg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:15:36 -0400
In-Reply-To: <4BA39B3D.4070509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/19/2010 09:41 AM, Patrick McHardy wrote:
> Thomas Jarosch wrote:
>> On Tuesday, 23. February 2010 14:59:46 Patrick McHardy wrote:
>>
>>> Tim Gardner wrote:
>>>
>>>> > From 146111514a8c126268e848e45b7dd967329b072f Mon Sep 17 00:00:00 2001
>>>>
>>>> From: Tim Gardner<tim.gardner@canonical.com>
>>>> Date: Thu, 18 Feb 2010 20:33:00 -0700
>>>> Subject: [PATCH] xt_recent: Fix false match.
>>>>
>>>> A rule with a zero hit_count will always match.
>>>>
>>> Also applied, thanks Tim.
>>>
>>
>> I just updated from kernel 2.6.32.9 to kernel 2.6.32.10 which contains
>> the xt_recent "zero hit_count will always match" fix.
>>
>> After that xt_recent stopped working for this scenario:
>>
>> iptables -A INPUT -m recent --rcheck --rdest --name INET_IP -j LOG
>> echo "+1.2.3.4">/proc/net/xt_recent/INET_IP
>>
>> The ip address 1.2.3.4 represents the current ip of my dial up connection.
>>
>> If I change "--rcheck" to "--update", it works again.
>> Reverting the patch fixes the issue.
>>
>> Maybe this is related to the xt_recent
>> proc interface creating the entry
>> (with a zero hit count)?
>>
>
> Mhh, looking at that patch again, I think it should actually do:
>
> if (!info->hit_count || ++hits>= info->hit_count)
>      ...
>
> since a hit_count of 0 implies that the user just wants to check for the
> presence of the entry. Thomas, could you give that a try?
>

I think you're right. Its kind of a subtle exit condition.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
