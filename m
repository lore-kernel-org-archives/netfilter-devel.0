From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Mon, 24 Sep 2012 15:12:46 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1209241512310.11550@stinky-local.trash.net>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
 <1348302412-2811-1-git-send-email-jengelh@inai.de>
 <58f14b4c-67ab-48aa-bbaf-3ce244500b93@email.android.com>
 <alpine.LNX.2.01.1209241501440.16909@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org, jrobinson@infoblox.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35691 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab2IXNMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:12:55 -0400
In-Reply-To: <alpine.LNX.2.01.1209241501440.16909@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Sep 2012, Jan Engelhardt wrote:

>
> On Sunday 2012-09-23 14:43, Patrick McHardy wrote:
>> Jan Engelhardt <jengelh@inai.de> schrieb:
>>
>>> Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
>>> a running state is saved to userspace and then reinstated from there.
>>>
>>> Make sure that priv is initialized with some values when that happens.
>>>
>>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>>> ---
>>> net/netfilter/xt_limit.c |    8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
>>> index 5c22ce8..a4c1e45 100644
>>> --- a/net/netfilter/xt_limit.c
>>> +++ b/net/netfilter/xt_limit.c
>>> @@ -117,11 +117,11 @@ static int limit_mt_check(const struct
>>> xt_mtchk_param *par)
>>>
>>> 	/* For SMP, we only want to use one set of state. */
>>> 	r->master = priv;
>>> +	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
>>> +	   128. */
>>> +	priv->prev = jiffies;
>>> +	priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
>>> 	if (r->cost == 0) {
>>> -		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
>>> -		   128. */
>>> -		priv->prev = jiffies;
>>> -		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
>>> 		r->credit_cap = priv->credit; /* Credits full. */
>>> 		r->cost = user2credits(r->avg);
>>> 	}
>>
>> I don't think we can do any better than this.
>
> "This" being the state as of 3.5, or this patch?
> priv-> really should be initialized, somehow.
> Being a kernel-only structure, can't rely on userspace to do it.

"This" as in your patch.
