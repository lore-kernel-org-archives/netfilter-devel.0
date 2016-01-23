From: =?UTF-8?Q?st=c3=a9phane_bryant?= <stephane.ml.bryant@gmail.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Sat, 23 Jan 2016 10:30:57 +0100
Message-ID: <56A34851.8080800@gmail.com>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115110218.GA2361@salvia> <20160115140412.GD7462@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33920 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbcAWJbG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jan 2016 04:31:06 -0500
Received: by mail-wm0-f66.google.com with SMTP id b14so2064575wmb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Jan 2016 01:31:05 -0800 (PST)
In-Reply-To: <20160115140412.GD7462@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/15/2016 03:04 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> For the specific case of nfnetlink_queue, I would expose the vlan
>> information through a new netlink attribute NFQA_VLAN (similar to what
>> we do for NFQA_HWADDR for the layer 3).
> 
> If we do this I think it does make sense to consider putting
> the entire L2 mac header under its own attr too.
> 
> This is especially good if we'd later add support for NETDEV
> family.  Since drivers already pull the L2 header userspace
> would not need to handle arbirary L2 protocols.
> 
>>> +				payload += VLAN_HLEN;
>>> +				payload_len -= VLAN_HLEN;
>>> +			} else {
>>> +				entry->skb->vlan_tci &= ~VLAN_TAG_PRESENT;
>>> +				entry->skb->protocol = veth->h_vlan_proto;
>>> +			}
>>> +		}
>>
>> I'm awar it's more work, but it would be good to reduce ifdef pollution
>> by placing all this bridge netfilter code wrapped into functions under
>> one single ifdef in this file to improve maintainability.
> 
> Right, but for anything family specifiy it would be even better to push
> it into nf afinfo. In case thats too much work or too cumbersome (e.g.
> because you'd need 12 function arguments ...) then the ifdef-wrapped
> helper is fine of course.

As the nf_afinfo saveroute/reroute hooks are called on the original
packet skb, at a location where netlink attributes are not in existence,
it only seems possible to use these hooks to hide the L2 code if we
pull-in/pull out the L2 header into/from the original skb, and forego
the new attributes -- which is fine by me as it is precisely what i was
doing in the original patches (albeit in a different location).
If we use new netlink attributes (NFQA_VLAN, NFQA_L2HDR) we will have to
wrap them in a #ifder helper, it seems.
I can go either way.

> .
> 

