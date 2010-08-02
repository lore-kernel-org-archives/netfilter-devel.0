From: Patrick McHardy <kaber@trash.net>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbmV0ZmlsdGVyOiB4dGFibGVzOiBpbnRyb2R1Y2U=?=
 =?UTF-8?B?IHh0X2xlbmd0aCByZXZpc2lvbiAywr0=?=
Date: Mon, 02 Aug 2010 18:01:49 +0200
Message-ID: <4C56EBED.7030708@trash.net>
References: <1279961719-20479-1-git-send-email-jengelh@medozas.de> <1279971776.2451.66.camel@edumazet-laptop> <alpine.LSU.2.01.1007241344270.11738@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, xiaosuo@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62810 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBQBu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:01:50 -0400
In-Reply-To: <alpine.LSU.2.01.1007241344270.11738@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.07.2010 14:27, Jan Engelhardt wrote:
> 
> On Saturday 2010-07-24 13:42, Eric Dumazet wrote:
>>> +static bool
>>> +length2_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>> +{
>>> +	const struct xt_length_mtinfo2 *info = par->matchinfo;
>>> +	const struct iphdr *iph = ip_hdr(skb);
>>> +	unsigned int len = 0;
>>> +	bool hit = true;
>>> +
>>> +	if (info->flags & XT_LENGTH_LAYER3)
>>> +		len = ntohs(iph->tot_len);
>>> +	else if (info->flags & XT_LENGTH_LAYER4)
>>> +		len = ntohs(iph->tot_len) - par->thoff;
>>> +	else if (info->flags & XT_LENGTH_LAYER5)
>>> +		hit = xtlength_layer5(&len, skb, iph->protocol, par->thoff);
>>> +	else if (info->flags & XT_LENGTH_LAYER7)
>>> +		hit = xtlength_layer7(&len, skb, iph->protocol, par->thoff);
>>> +	if (!hit)
>>> +		return false;
>>> +
>>> +	return (len >= info->min && len <= info->max) ^
>>> +	       !!(info->flags & XT_LENGTH_INVERT);
>>> +}
>>
>>
>> This serie of tests is expensive and useless.
>>
>> - A switch() would be faster,
>>  - if you dont use a bit mask, but continuous values to get the layer.
>> - Also, using a u16 is more expensive than a u32.
>> - On x86, compiler is forced to use prefixes or conversions instructions
>>  (movzwl), this makes code bigger.
> 
> I might agree with u16/u32 in that some CPUs need to run an extra
> "AND" when they don't have (movw/cmpw), but... the other things
> cast my doubts.
> 
> C does not specify a "speed" for switch or if. I agree that some
> constructs may desire to be reworked to work around limitations of
> the compiler's smartness, but in the case that is before us, it looks
> like some of your arguments have no base - at least on x86_64.
> 
> length2_mt as it stands (bitmask, u16, if): 800 bytes
> length2_mt with u32 flag: 800 bytes
> length2_mt with switch: 800 bytes
> length2_mt with continuous values and u32: 816 bytes
> length2_mt with cont.v, u32, and switch: 816 bytes
> 
> The compiler is smart enough to see that a run of if tests against
> the same variable with different values is transformable into a
> switch statement.

They are mutually exclusive though, so using a bitmask doesn't make
much sense.
