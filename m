From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 15:12:50 +0200
Message-ID: <47FCC0D2.7060306@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYDINMx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:12:53 -0400
In-Reply-To: <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 14:52, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> +enum {
>>> +	__NFPROTO_MIN = AF_MAX,
>>> +	NFPROTO_ARP,
>>> +	__NFPROTO_MAX,
>>> +};
>>> [...]
>>> -	xt = kmalloc(sizeof(struct xt_af) * NPROTO, GFP_KERNEL);
>>> +	xt = kmalloc(sizeof(struct xt_af) * __NFPROTO_MAX, GFP_KERNEL);
>> Thats quite ugly. I'd also prefer to keep the size in
>> the nf_hooks declaration and elsewhere.
>>
>> How about:
>>
>> enum {
>> 	__NFPROTO_MIN = AF_MAX - 1,   (AF_MAX is actually max + 1)
>> 	NFPROTO_ARP,
>> 	__NFPROTO_MAX
>> };
>> #define NFPROTO_MAX	(__NFPROTO_MAX - 1)
> 
> Then what's the point of defining __NFPROTO_MAX?

Its so ugly that everyone adding new values will notice it
and not add something after it :)

>> The array declarations should then use NFPROTO_MAX + 1.
> 
> Why +1 if MAX is ARP?

Because array indices start at zero.

