From: Andre Correa <andre.correa@pobox.com>
Subject: Re: [linuximq] Re: [PATCH] pom-ng version of IMQ target (file is
 attached this time)
Date: Thu, 03 Jun 2004 12:24:21 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40BF42A5.7070002@pobox.com>
References: <40A29E4A.94165870@info-link.net> <40A2D9D8.2050201@trash.net> <40A39C34.639DC30E@info-link.net> <40BB2C43.90704@dsl.pipex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: linuximq@yahoogroups.com
In-Reply-To: <40BB2C43.90704@dsl.pipex.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Andy, I cannot tell about netfilter, but I would like to see you 
patch anyway for testing and maybe include it on IMQ.

Some patchs sent by people are queued and I hope to review and publish 
then soon. Does your patch changes iptables too? Please send it on pvt.

To be honest I'm not willing to get in a "fight" for putting IMQ patch 
into p-o-m. I think it should be there the way IMQ is right now, but we 
better give it some time. I'm not sure too that dummy will satisfy all 
needs. I'm more to the good-old IMQ implementation.

tks

Andre

Andy Furniss wrote:
> Brad Fisher wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>
>>>Andre Correa already asked me about inclusion of the IMQ target. I would
>>>rather not include at this time it for two reasons:
>>>
>>>- IMQ still has stability problems
>>>- Jamal is working on a netfilter-independant replacement, I would like to
>>>see how it works out first. See
>>>http://marc.theaimsgroup.com/?t=108202471500003&r=1&w=2
>>>
>>>Regards
>>>Patrick
>>
>>
>>That's fine, I wasn't really asking for inclusion quite yet (though I would
>>like to see it happen someday :).  I just wanted to let people who may be
>>interested know that a pom-ng version of the patch existed.
>>
>>-Brad
> 
> 
> I am still not sure whether using Dummy will satisfy other IMQ users 
> though, the thread above just deals with my setup - using ingress IMQ. 
> There must be people on here using IMQ for egress/ multiple IMQs to 
> solve their own problems. I changed IMQ to hook before NAT for egress, 
> just to see if it worked, as someone on the LARTC list wanted to use 
> ESFQ for a large NATed LAN - it appears to be OK - but will a netfilter 
> independent replacement allow this sort of flexability?
> 
> Andy.
> 
> 
> 
> 
> ------------------------ Yahoo! Groups Sponsor --------------------~--> 
> Yahoo! Domains - Claim yours for only $14.70
> http://us.click.yahoo.com/Z1wmxD/DREIAA/yQLSAA/dkFolB/TM
> --------------------------------------------------------------------~-> 
> 
>  
> Yahoo! Groups Links
> 
> <*> To visit your group on the web, go to:
>      http://groups.yahoo.com/group/linuximq/
> 
> <*> To unsubscribe from this group, send an email to:
>      linuximq-unsubscribe@yahoogroups.com
> 
> <*> Your use of Yahoo! Groups is subject to:
>      http://docs.yahoo.com/info/terms/
>  
> 
> 
> 
