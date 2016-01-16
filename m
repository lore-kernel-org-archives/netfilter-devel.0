From: =?UTF-8?Q?st=c3=a9phane_bryant?= <stephane.ml.bryant@gmail.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Sat, 16 Jan 2016 12:00:24 +0100
Message-ID: <569A22C8.9030707@gmail.com>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115110218.GA2361@salvia> <20160115140412.GD7462@breakpoint.cc>
 <20160115163315.GA1276@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33770 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbcAPLAc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2016 06:00:32 -0500
Received: by mail-wm0-f67.google.com with SMTP id u188so7227219wmu.0
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2016 03:00:32 -0800 (PST)
In-Reply-To: <20160115163315.GA1276@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I will rework the patches taking all these remarks into consideration.

Regarding the entire L2 header attribute. I assume it would be a
separate attribute from the existing NFQA_HWADDR? or would it make sense
to collapse these 2 into one (potentially with helpers to access each
relevant field) to avoid duplicating information (and redundancy, and
potential discrepancies)?

On 01/15/2016 05:33 PM, Pablo Neira Ayuso wrote:
> On Fri, Jan 15, 2016 at 03:04:12PM +0100, Florian Westphal wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> For the specific case of nfnetlink_queue, I would expose the vlan
>>> information through a new netlink attribute NFQA_VLAN (similar to what
>>> we do for NFQA_HWADDR for the layer 3).
>>
>> If we do this I think it does make sense to consider putting
>> the entire L2 mac header under its own attr too.
>>
>> This is especially good if we'd later add support for NETDEV
>> family.  Since drivers already pull the L2 header userspace
>> would not need to handle arbirary L2 protocols.
> 
> Good point, fine with me.
> 
>>>> +				payload += VLAN_HLEN;
>>>> +				payload_len -= VLAN_HLEN;
>>>> +			} else {
>>>> +				entry->skb->vlan_tci &= ~VLAN_TAG_PRESENT;
>>>> +				entry->skb->protocol = veth->h_vlan_proto;
>>>> +			}
>>>> +		}
>>>
>>> I'm awar it's more work, but it would be good to reduce ifdef pollution
>>> by placing all this bridge netfilter code wrapped into functions under
>>> one single ifdef in this file to improve maintainability.
>>
>> Right, but for anything family specifiy it would be even better to push
>> it into nf afinfo. In case thats too much work or too cumbersome (e.g.
>> because you'd need 12 function arguments ...) then the ifdef-wrapped
>> helper is fine of course.
> 
> I'm fine with pushing this info afinfo if it fits fine there.
> 

