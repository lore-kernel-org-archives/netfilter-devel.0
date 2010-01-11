From: Patrick McHardy <kaber@trash.net>
Subject: Re: Question about ipt_REJECT
Date: Mon, 11 Jan 2010 12:08:34 +0100
Message-ID: <4B4B06B2.9040703@trash.net>
References: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>	 <4B41E5B2.1080609@trash.net> <c794cd671001100524g2700b23crb8fa31e9d1f8e293@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Xiong Wu <xiong.wu1981@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0AKLIn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:08:43 -0500
In-Reply-To: <c794cd671001100524g2700b23crb8fa31e9d1f8e293@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Xiong Wu wrote:
> Hi,
> 
> I have to reject some connection which are confirmed, therefor I apply
> the following patch to solve this problem. Please help me to review
> this patch.

As I said, this doesn't work properly since conntrack can't associate
packets generated in response to half-way NATed packets with the
original connection.

The manual conntrack association is necessary, you need to find a way
to make the packet visible to TCP conntrack. I think what might work
is to change the condition ignoring already-tracked packets in
nf_conntrack to only ignore packets using either nf_conntrack_untracked
or received in NF_INET_PRE_ROUTING.

> --- linux-2.6.32.3/net/ipv4/netfilter/ipt_REJECT.c      2010-01-07
> 07:07:45.000000000 +0800
> +++ linux-2.6.32.3-new/net/ipv4/netfilter/ipt_REJECT.c  2010-01-10
> 21:18:11.000000000 +0800
> @@ -23,6 +23,7 @@
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter_ipv4/ip_tables.h>
>  #include <linux/netfilter_ipv4/ipt_REJECT.h>
> +#include <include/net/netfilter/nf_conntrack.h>
>  #ifdef CONFIG_BRIDGE_NETFILTER
>  #include <linux/netfilter_bridge.h>
>  #endif
> @@ -40,6 +41,9 @@
>         const struct tcphdr *oth;
>         struct tcphdr _otcph, *tcph;
>         unsigned int addr_type;
> +       enum ip_conntrack_info ctinfo;
> +       const struct nf_conn *ct;
> +
> 
>         /* IP header checks: fragment. */
>         if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
> @@ -120,7 +124,12 @@
>         if (nskb->len > dst_mtu(skb_dst(nskb)))
>                 goto free_nskb;
> 
> -       nf_ct_attach(nskb, oldskb);
> +       /*only when the ct isn't confirmed, attach it to reset packet*/
> +       ct = nf_ct_get(skb, &ctinfo);
> +       if((ct != NULL) && (!nf_ct_is_confirmed(ct)))
> +       {
> +               nf_ct_attach(nskb, oldskb);
> +       }
> 
>         ip_local_out(nskb);
>         return;
> 
> Thanks,
> Xiong
> 
> 2010/1/4 Patrick McHardy <kaber@trash.net>:
>> Xiong Wu wrote:
>>> Hi All,
>>>
>>> I found the TCP RST packet sent from ipt_REJECT target isn't able to
>>> update related conntrack state.
>>>
>>> I install a 2.6.30.10 kernel as a router and add a iptables rule with
>>> REJECT target to reset specific connections.  However  I found  when
>>> the packets is handled by the ipt_REJECT and the TCP RST packet is
>>> sent, the related conntrack state isn't updated to CLOSE state.
>>>
>>> Then I review the ipt_REJECT codes. I found the target attach the old
>>> conntrack to RST packet as:
>>> {
>>>    nf_ct_attach(nskb, oldskb);
>>>    ip_local_out(nskb);
>>> }
>>>
>>> Therefor the nf_conntrack_in() will ignore this RST packet due to the
>>> nfct is valid in skb.
>>> {
>>>      if (skb->nfct) {
>>>                     NF_CT_STAT_INC_ATOMIC(net, ignore);
>>>                     return NF_ACCEPT;
>>>      }
>>> }
>>>
>>>
>>> Is there any reason to attach the old conntrack to new RST skb?  I
>>> think let the RST packet lookup and update related conntrack is
>>> better.
>> The packet that is rejected might be half-way mangled by NAT (DNAT
>> performed, SNAT not yet performed). In this state conntrack is
>> be unable to associate the generated RST packet with the conntrack
>> entry. The same applies when you reject the first packet of a
>> connection which hasn't entered the hash tables yet.
>>
>> Usually this shouldn't be a problem exactly because you would
>> normally reject the first packet of a connection, so it wouldn't
>> be placed in the conntrack hash.
>>
>>
> 

