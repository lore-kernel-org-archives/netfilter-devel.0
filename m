From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: Fwd: [PATCH] nf_nat_core: eliminate find_appropriate_src call if range is set IP_NAT_RANGE_PROTO_RANDOM bit on
Date: Mon, 30 Jun 2008 21:34:02 +0800
Message-ID: <412e6f7f0806300634g1d82ffcewd3ba7ef0b951cd1a@mail.gmail.com>
References: <412e6f7f0806292132l18c747d6h982c64ce7c9d9c85@mail.gmail.com>
	 <412e6f7f0806300100t6bc37635pc922405705f1784d@mail.gmail.com>
	 <4868D76D.6050008@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:17620 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbYF3NeE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:34:04 -0400
Received: by ti-out-0910.google.com with SMTP id b6so786620tic.23
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2008 06:34:02 -0700 (PDT)
In-Reply-To: <4868D76D.6050008@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 30, 2008 at 8:54 PM, Patrick McHardy <kaber@trash.net> wrote:
> Changli Gao wrote:
>>
>> ---------- Forwarded message ----------
>> From: Changli Gao <xiaosuo@gmail.com>
>> Date: 2008/6/30
>> Subject: [PATCH] nf_nat_core: eliminate find_appropriate_src call if
>> range is set IP_NAT_RANGE_PROTO_RANDOM bit on
>> To: netfilter-devel@lists.netfilter.org
>> Cc: Changli Gao <xiaosuo@gmail.com>
>>
>>
>> Eliminate find_appropriate_src call if range is set
>> IP_NAT_RANGE_PROTO_RANDOM bit on.
>
> Please explain why the call isn't necessary.
>
In fact, my patch doesn't change the logic of the code, it just
eliminates the uesless call find_appropriate_src. Because the tuple
returned by find_appropriate is only useful when the
IP_NAT_RANGE_PROTO_RANDOM isn't set on.  instead of testing the bit
IP_NAT_RANGE_PROTO_RANDOM after calling find_appropriate_src, I do
that before it to eliminate the cost of calling find_appropriate_src.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
