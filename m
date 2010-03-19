From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Mar 2010 16:41:49 +0100
Message-ID: <4BA39B3D.4070509@trash.net>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <4B83DF52.5000806@trash.net> <201003191604.45719.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Tim Gardner <timg@tpi.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40261 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0CSPl4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:41:56 -0400
In-Reply-To: <201003191604.45719.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> On Tuesday, 23. February 2010 14:59:46 Patrick McHardy wrote:
>   
>> Tim Gardner wrote:
>>     
>>> >From 146111514a8c126268e848e45b7dd967329b072f Mon Sep 17 00:00:00 2001
>>>       
>>> From: Tim Gardner <tim.gardner@canonical.com>
>>> Date: Thu, 18 Feb 2010 20:33:00 -0700
>>> Subject: [PATCH] xt_recent: Fix false match.
>>>
>>> A rule with a zero hit_count will always match.
>>>       
>> Also applied, thanks Tim.
>>     
>
> I just updated from kernel 2.6.32.9 to kernel 2.6.32.10 which contains
> the xt_recent "zero hit_count will always match" fix.
>
> After that xt_recent stopped working for this scenario:
>
> iptables -A INPUT -m recent --rcheck --rdest --name INET_IP -j LOG
> echo "+1.2.3.4" >/proc/net/xt_recent/INET_IP
>
> The ip address 1.2.3.4 represents the current ip of my dial up connection.
>
> If I change "--rcheck" to "--update", it works again.
> Reverting the patch fixes the issue.
>
> Maybe this is related to the xt_recent
> proc interface creating the entry
> (with a zero hit count)?
>   

Mhh, looking at that patch again, I think it should actually do:

if (!info->hit_count || ++hits >= info->hit_count)
    ...

since a hit_count of 0 implies that the user just wants to check for the
presence of the entry. Thomas, could you give that a try?
