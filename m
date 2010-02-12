From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Fri, 12 Feb 2010 14:32:08 +0200
Message-ID: <b6fcc0a1002120432t133ef769jc877d92b1f106af2@mail.gmail.com>
References: <20100211173117.GD4099@x200> <4B744565.2010808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:45634 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0BLMcI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:32:08 -0500
Received: by iwn39 with SMTP id 39so554645iwn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Feb 2010 04:32:08 -0800 (PST)
In-Reply-To: <4B744565.2010808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 7:59 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
> Alexey Dobriyan wrote:
>> --- a/net/bridge/br_netfilter.c
>> +++ b/net/bridge/br_netfilter.c
>> @@ -792,9 +792,11 @@ static unsigned int br_nf_local_out(unsigned in=
t hook, struct sk_buff *skb,
>> =A0}
>>
>> =A0#if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTR=
ACK_IPV4_MODULE)
>> +#include <net/netfilter/nf_conntrack.h>
>> +
>> =A0static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>> =A0{
>> - =A0 =A0 if (skb->nfct !=3D NULL &&
>> + =A0 =A0 if ((skb->nfct !=3D NULL || nf_ct_is_untracked(skb)) &&
>
> Seems unnecessary since nfct should be NULL when the conntrack
> is untracked.

Before untracked connections would pass the test, so additional check r=
equired.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
