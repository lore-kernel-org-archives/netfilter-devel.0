From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next V2] netfilter: conntrack: simplify the code by
 using nf_conntrack_get_ht
Date: Fri, 12 Aug 2016 19:12:32 +0800
Message-ID: <CAML_gOf4_Gc-KzdGmakdtg+2a3EvRbdpcf=r=Z2GhpFGwocEuQ@mail.gmail.com>
References: <1469878973-15201-1-git-send-email-zlpnobody@163.com> <20160812103442.GA3484@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:36085 "EHLO
	mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbcHLLMm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 07:12:42 -0400
Received: by mail-ua0-f195.google.com with SMTP id 74so1782229uau.3
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 04:12:42 -0700 (PDT)
In-Reply-To: <20160812103442.GA3484@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi pablo,

2016-08-12 18:34 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sat, Jul 30, 2016 at 07:42:53PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <liping.zhang@spreadtrum.com>
>>
>> Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
>> nf_conntrack proc read and hash resize") introdue the
>> nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
>> again and again to get the hash table and hash size.
>>
>> But keep ____nf_conntrack_find unchanged, because it is performance
>> critical path, increase the overhead of the function call is not so
>> good.
>
> I'm not very happy with this solution.

Yes.
>
> I think it is a good time to kill compat /proc/net/ip_conntrack*. That
> has been there for so long already. So we can inline this function,
> this is the only one that needs it to export it, right?

If just for the purpose of using nf_conntrack_get_ht to simply the source code,
I'm not sure is it worth to delete the compat /proc/net/ip_conntrack*?

So I'm inclined to keep the original source codes unchanged :)

Thanks
