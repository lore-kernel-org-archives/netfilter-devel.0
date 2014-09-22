From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 4/4 v3] nft: complete reject support
Date: Mon, 22 Sep 2014 18:23:18 +0200
Message-ID: <54204CF6.6050007@gmail.com>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com> <1411327957-19379-4-git-send-email-alvaroneay@gmail.com> <20140922082058.GK4971@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37156 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIVQXF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:23:05 -0400
Received: by mail-wi0-f173.google.com with SMTP id r20so3273900wiv.6
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Sep 2014 09:23:03 -0700 (PDT)
In-Reply-To: <20140922082058.GK4971@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 22/09/14 10:20, Patrick McHardy escribi=F3:
> On Sun, Sep 21, 2014 at 09:32:37PM +0200, Alvaro Neira Ayuso wrote:
>> This patch allows to use the reject action in rules. Example:
>>
>>    nft add rule filter input udp dport 22 reject
>>
>> In this rule, we assume that the reason is network unreachable. Also
>> we can specify the reason with the option "with" and the reason. Exa=
mple:
>>
>>    nft add rule filter input tcp dport 22 reject with host-unreach
>>
>> In the bridge tables and inet tables, we can use this action too. Ex=
ample:
>>
>>    nft add rule inet filter input reject with icmp-host-unreach
>>
>> In this rule above, this generates a meta nfproto dependency to matc=
h
>> ipv4 traffic because we use a icmpv4 reason to reject.
>>
>> If the reason is not specified, we infer it from the context.
>
> There are a couple of things I don't like very much about this concep=
t.
>
> First of all, the types have redundant information (icmp-*, icmpv6-*)=
=2E
> This might not look to bad if you only consider the reject statement,
> but the redundancy becomes very obvious if you consider a set declara=
tion
> which explicitly specifies the data type and still has to use the icm=
p
> prefix for every value.
>
> Its also not consistent with the remaining keywords, we don't use
> tcp-syn, tcp-fin etc.
>
> I also don't like having a reject specific family, without taking ext=
ra
> care this prevents protocol conflict detection and determination of
> the protocol for following expressions.
>
> I'd rather have this very explicit:
>
> reject with icmp host-unreachable
> reject with icmpv6 host-unreachable
> reject with icmp
>
> So the protocol would be an explizit parameter without strcmp hacks a=
nd
> the type keywords would not encode the protocol. I'd also not be
> against just using the exact same syntax as for matches:
>
> reject with icmp type host-unreach (note the extra "type").
>
>> Insufficient context for using reject
>>    * nft add rule inet filter input reject
>>    * nft add rule bridge filter input reject
>
> Well, we do have the inet reject expression and I consider it importa=
nt
> that we actually support it, we want to help make easier rulesets.
>
> It does actually work today without a specific type as in your exampl=
e,
> so why wouldn't this work anymore?
>
> I actually think we should add full support for this by adding an
> inet-specific ICMP type table which is the intersection of the ICMP
> and ICMPv6 types for inet and map those to the corresponding real
> types:
>
> nft inet filter input reject with host-unreachable
>

I have seen the ICMP and ICMPv6 types and I have done this map:

CODE		 |	ICMPv6		|	ICMPv4
admin-prohibited | admin-prohibited	|	admin-prohibited
port-unreach	 | port-unreach		|	port-unreach
no-route	 | no-route		|	net-unreach
host-unreach	 | addr-unreach		|	host-unreach

What do you think?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
