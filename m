From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in death_by_timeout()
Date: Wed, 26 Nov 2008 12:16:45 +0100
Message-ID: <492D301D.3080305@trash.net>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net> <4922C2D0.9060207@trash.net> <20081125080903.GA3195@zebra.home> <492BDD51.2020306@trash.net> <20081125224853.GL3195@zebra.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54477 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYKZLQ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:16:57 -0500
In-Reply-To: <20081125224853.GL3195@zebra.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BORBELY Zoltan wrote:
> Hi,
> 
> On Tue, Nov 25, 2008 at 12:11:13PM +0100, Patrick McHardy wrote:
>> Crap, I missed a spot. Does this patch help?
>>
>>
> 
>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
>> index 3b009a3..5f4a651 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -1138,7 +1138,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
>>  		}
>>  	}
>>  
>> -	nf_ct_acct_ext_add(ct, GFP_KERNEL);
>> +	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
>>  
>>  #if defined(CONFIG_NF_CONNTRACK_MARK)
>>  	if (cda[CTA_MARK])
> 
> Thanks, the BUG messages have disappeared.

Great, thanks for testing.
