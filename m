From: Patrick McHardy <kaber@trash.net>
Subject: Re: Wrong ethernet headers after double postrouting fix
Date: Thu, 13 Dec 2007 17:55:10 +0100
Message-ID: <476163EE.7040307@trash.net>
References: <9a4a382a0712130005l49a72164r26e5818060534285@mail.gmail.com>	 <4760F020.5070405@trash.net> <9a4a382a0712130733g21dd4390w9f457bed7ad19777@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48330 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbXLMQzc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:55:32 -0500
In-Reply-To: <9a4a382a0712130733g21dd4390w9f457bed7ad19777@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Damien Th=E9bault wrote:
> On Dec 13, 2007 9:41 AM, Patrick McHardy <kaber@trash.net> wrote:
>> Could you try this patch please?
>>
>>
>> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfil=
ter_bridge.h
>> index 533ee35..499aa93 100644
>> --- a/include/linux/netfilter_bridge.h
>> +++ b/include/linux/netfilter_bridge.h
>> @@ -50,7 +50,8 @@ enum nf_br_hook_priorities {
>>  extern int nf_bridge_copy_header(struct sk_buff *skb);
>>  static inline int nf_bridge_maybe_copy_header(struct sk_buff *skb)
>>  {
>> -       if (skb->nf_bridge)
>> +       if (skb->nf_bridge &&
>> +           skb->nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT=
))
>>                 return nf_bridge_copy_header(skb);
>>         return 0;
>>  }
>>
>>
>=20
> I tried it and it successfully solves this problem. Everything is fin=
e now.


Thanks a lot for testing.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
