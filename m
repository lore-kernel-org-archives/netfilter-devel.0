From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Mar 2010 17:32:54 +0100
Message-ID: <4BA3A736.6010900@trash.net>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <201003191604.45719.thomas.jarosch@intra2net.com> <4BA39B3D.4070509@trash.net> <201003191719.54550.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Tim Gardner <timg@tpi.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41007 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0CSQc7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:32:59 -0400
In-Reply-To: <201003191719.54550.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> On Friday, 19. March 2010 16:41:49 you wrote:
>   
>>> Maybe this is related to the xt_recent
>>> proc interface creating the entry
>>> (with a zero hit count)?
>>>       
>> Mhh, looking at that patch again, I think it should actually do:
>>
>> if (!info->hit_count || ++hits >= info->hit_count)
>>     ...
>>
>> since a hit_count of 0 implies that the user just wants to check for the
>> presence of the entry. Thomas, could you give that a try?
>>     
>
> The new code works. Isn't that almost the same as reverting
> the original patch? info->hit_count == 0 will match again.
>
> So we could just go back to
>
> "if (++hits >= info->hit_count)"
>
> Or am I missing something?
>   

I think you're right. Tim, please remind me, why was the match on zero
hits considered a false positive?
