From: Tim Gardner <timg@tpi.com>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Mar 2010 10:38:42 -0600
Message-ID: <4BA3A892.8010303@tpi.com>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <201003191604.45719.thomas.jarosch@intra2net.com> <4BA39B3D.4070509@trash.net> <201003191719.54550.thomas.jarosch@intra2net.com> <4BA3A736.6010900@trash.net>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2717 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0CSQj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:39:26 -0400
In-Reply-To: <4BA3A736.6010900@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/19/2010 10:32 AM, Patrick McHardy wrote:
> Thomas Jarosch wrote:
>> On Friday, 19. March 2010 16:41:49 you wrote:
>>
>>>> Maybe this is related to the xt_recent
>>>> proc interface creating the entry
>>>> (with a zero hit count)?
>>>>
>>> Mhh, looking at that patch again, I think it should actually do:
>>>
>>> if (!info->hit_count || ++hits>= info->hit_count)
>>>      ...
>>>
>>> since a hit_count of 0 implies that the user just wants to check for the
>>> presence of the entry. Thomas, could you give that a try?
>>>
>>
>> The new code works. Isn't that almost the same as reverting
>> the original patch? info->hit_count == 0 will match again.
>>
>> So we could just go back to
>>
>> "if (++hits>= info->hit_count)"
>>
>> Or am I missing something?
>>
>
> I think you're right. Tim, please remind me, why was the match on zero
> hits considered a false positive?
>

Because it looked like it? Maybe its just whining after the fact, but 3 
of us missed that it was also an exit condition. IMHO it was too subtle. 
I like your final patch much better because, as Thomas pointed out, it 
makes it a bit clearer what that clause is doing.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
