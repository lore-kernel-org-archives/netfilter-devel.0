From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next V2] netfilter: conntrack: simplify the code by
 using nf_conntrack_get_ht
Date: Fri, 12 Aug 2016 21:55:39 +0800
Message-ID: <CAML_gOfr-UdY4g6TX6nvNDL-fVPps3mfGAZJCfYiM+gyz6533g@mail.gmail.com>
References: <1469878973-15201-1-git-send-email-zlpnobody@163.com>
 <20160812103442.GA3484@salvia> <CAML_gOf4_Gc-KzdGmakdtg+2a3EvRbdpcf=r=Z2GhpFGwocEuQ@mail.gmail.com>
 <20160812114939.GA3794@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:33030 "EHLO
	mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbcHLNzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 09:55:41 -0400
Received: by mail-ua0-f193.google.com with SMTP id u13so2098286uau.0
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 06:55:40 -0700 (PDT)
In-Reply-To: <20160812114939.GA3794@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-08-12 19:49 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Fri, Aug 12, 2016 at 07:12:32PM +0800, Liping Zhang wrote:
>> 2016-08-12 18:34 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
>> >
>> > I think it is a good time to kill compat /proc/net/ip_conntrack*. That
>> > has been there for so long already. So we can inline this function,
>> > this is the only one that needs it to export it, right?
>>
>> If just for the purpose of using nf_conntrack_get_ht to simply the source code,
>> I'm not sure is it worth to delete the compat /proc/net/ip_conntrack*?
>>
>> So I'm inclined to keep the original source codes unchanged :)
>
> Just sent a patch to kill that compat code. It is also missing new
> supported layer 4 protocols, as well as IPv6. We have too many
> interfaces already, actually I'd be happy to kill nf_conntrack sysctl
> entries at some point and leave just the ctnetlink interface.
>
> I'm attaching an incomplete patch that moves nf_conntrack_get_ht() as
> inline. It applies on top of:
>
>         http://patchwork.ozlabs.org/patch/658620/
>
> Feel free to take it over and finish it. Thanks.

OK. Will be happy to follow up on this:)

Thanks.
