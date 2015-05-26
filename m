From: Eddi Linder <eddi@guardicore.com>
Subject: Re: [PATCH 1/1] netfilter: Added vlan matching extension
Date: Tue, 26 May 2015 17:24:56 +0300
Message-ID: <CADgXnSO8EOwA_2tPgoZN=nHrsemhteep3ROSRLK6L-0Dn57NHA@mail.gmail.com>
References: <1432586250-42147-1-git-send-email-eddi@guardicore.com>
	<20150525215108.GH3629@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36420 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbEZOY5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 10:24:57 -0400
Received: by igbpi8 with SMTP id pi8so59281940igb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2015 07:24:57 -0700 (PDT)
In-Reply-To: <20150525215108.GH3629@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for answering so fast Florian,

Yes, I do plan to use it with a bridge, but I don't think ebtables is
the proper solution, as I'd like to be able to use the matches and the
targets provided by the iptables extensions.
I plan to use vlan matching on an hypervisor that uses vlans for
tenant separation, and by using the iptables multiport extension I
plan to block unwanted traffic per tenant (which means per vlan).
I'll send my fixes shortly.

Thanks, Eddie

On Tue, May 26, 2015 at 12:51 AM, Florian Westphal <fw@strlen.de> wrote:
> Eddie Linder <eddi@guardicore.com> wrote:
>> Signed-off-by: Eddie Linder <eddi@guardicore.com>
>
> Why do we need a vlan tag match in iptables?
> For bridged traffic we have ebtables' net/bridge/netfilter/ebt_vlan.c .
>
> And for routed traffic you'd just use -i vlan.id.0 or whatever?
>
> What is this match being used for, and more importantly where/how?
> (Is this for call-iptables=1 invocation from bridge netfilter?)
>
> Nevertheless, a couple of comments below.
>
>> diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
>> index 1d973d2..2ca36db 100644
>> --- a/include/uapi/linux/netfilter/Kbuild
>> +++ b/include/uapi/linux/netfilter/Kbuild
>> @@ -85,3 +85,4 @@ header-y += xt_tcpmss.h
>>  header-y += xt_tcpudp.h
>>  header-y += xt_time.h
>>  header-y += xt_u32.h
>> +header-y += xt_vlan.h
>> diff --git a/include/uapi/linux/netfilter/xt_vlan.h b/include/uapi/linux/netfilter/xt_vlan.h
>> new file mode 100644
>> index 0000000..3c31b6b
>> --- /dev/null
>> +++ b/include/uapi/linux/netfilter/xt_vlan.h
>> @@ -0,0 +1,11 @@
>> +#ifndef _XT_VLAN_H
>> +#define _XT_VLAN_H
>> +
>> +
>> +struct xt_vlan_info {
>> +     unsigned short vlan_id;
>> +     unsigned char vlan_pcp;
>
> Please consider using explicit types for all of these, i.e.
>         __u16 vlan_id;
>         __u8 vlan_pcp;
>
>> +MODULE_ALIAS("ipt_vlan");
>> +MODULE_ALIAS("ip6t_vlan");
>> +MODULE_ALIAS("ipt_VLAN");
>> +MODULE_ALIAS("ip6t_VLAN");
>
> _VLAN aliases are only needed for -j VLAN target, which isn't
> added here, please remove them.
>
>> +static bool vlan_mt(const struct sk_buff *skb, struct xt_action_param *par)
>> +{
>> +     const struct xt_vlan_info *info = par->matchinfo;
>> +     u16 vlan_tci = ~VLAN_TAG_PRESENT;
>> +     bool ret;
>> +
>> +     if (skb->vlan_tci & VLAN_TAG_PRESENT)
>> +             /* Strip the 4096 bit (invalid vlan) from the vlan tci bits */
>> +             vlan_tci = skb->vlan_tci;
>
> if (skb_vlan_tag_present(skb))
>         vlan_tci = skb_vlan_tag_get(skb);
>
>> +     else {
>> +             if (unlikely(skb->len < VLAN_ETH_HLEN &&
>
> This is weird.  Why test len < VLAN_ETH_HLEN (> ? >= ? )
>
>> +                          skb->protocol == htons(ETH_P_8021Q)))
>> +                     if (unlikely(!parse_vlan(skb, &vlan_tci)))
>> +                             return false;
>> +                     else
>> +                             return false;
>> +     }
>
> Why call parse_vlan?  We always return false without looking at
> vlan_tci...
