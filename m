Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837003368BA
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 10:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775730495; cv=none; b=u0UzpobN2RvfE1+P6LOmuuBWA0cAzoTNYeTb8zlyIVqxqOtVhhfQNdTxw/KYl54vYMV3SOJm8PwL4mmvkmH/DAKJE5FTjY9/YLF7lStSzKnMb3Xt+Hs1wv+gMs58SlHiSPFuuv18SOAZ1xbW6ui8qudgXjd0GYYmGGkfPmDQ8EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775730495; c=relaxed/simple;
	bh=HBpE0Qr3G9FdPjVxabBqZSm+dyf82OT76+ny3GIy2tE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=emtjcjcdCmUeq6ID/lNKVGAUXeVymiRjcuKkKugkgo9jAbFkd3DhLhgRzk3/6pZmnFWCxxVSy5wWp85HrCsbmVu+IW63Z0jEX+UWdjYI9aSh+rzF+32f6svg83FRydy9aj/9Hn36vE0pKnFMcZn2NB4f45GXiL4C4AiXSfuU9OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=FpmG6TVD; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="FpmG6TVD"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4frwv90cxBzGFDMN;
	Thu,  9 Apr 2026 12:21:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1775730067; x=1777544468; bh=sEXGiKqpGQ
	QuDYghIZvxIh6H4h5aPRg+dyptCQK5fd8=; b=FpmG6TVDUdHEYWvDfsGvXvBa/Q
	AC4AGSMTAXv0GXFMrHHYCpB5Y45LlpuJq/o4K5NsDLbJxXSM45vlAQuzkaFCzQZH
	9Yls8Dyhc1j5mvbMaS1BBnPUB7kpj59t7OAIbEUL4QTLXR+T8eEyEvYkKWtEGskn
	dISMnwFKXnycSB7Mo=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id YroY1A30pre3; Thu,  9 Apr 2026 12:21:07 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4frwv70HP7zGFDM8;
	Thu,  9 Apr 2026 12:21:07 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id F1A0F34316A; Thu,  9 Apr 2026 12:21:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id F02AD340D75;
	Thu,  9 Apr 2026 12:21:06 +0200 (CEST)
Date: Thu, 9 Apr 2026 12:21:06 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: David Baum <davidbaum461@gmail.com>, netfilter-devel@vger.kernel.org, 
    kadlec@netfilter.org
Subject: Re: [PATCH] netfilter: ipset: harden payload calculation in
 call_ad()
In-Reply-To: <add5lL88z9oJqTJY@strlen.de>
Message-ID: <9d6f4d79-f645-a944-ad7c-121f8f91621f@blackhole.kfki.hu>
References: <20260313180132.75655-1-davidbaum461@gmail.com> <add5lL88z9oJqTJY@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Thu, 9 Apr 2026, Florian Westphal wrote:

> David Baum <davidbaum461@gmail.com> wrote:
>> call_ad() computes the netlink error payload size with
>> min(SIZE_MAX, sizeof(*errmsg) + nlmsg_len(nlh)), but min(SIZE_MAX, x)
>> is always x, so the guard is a no-op.
>>
>> Replace it with an explicit negative-length check and
>> check_add_overflow() so the addition is validated before being passed
>> to nlmsg_new().
>
> Jozsef, are you ok with this patch?
> Full quote below.

Yes, the patch is fine. It seems I missed it :-(.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

>> Signed-off-by: David Baum <davidbaum461@gmail.com>
>> ---
>>  net/netfilter/ipset/ip_set_core.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
>> index a2fe711cb5e3..11d3854d9b11 100644
>> --- a/net/netfilter/ipset/ip_set_core.c
>> +++ b/net/netfilter/ipset/ip_set_core.c
>> @@ -10,6 +10,7 @@
>>  #include <linux/module.h>
>>  #include <linux/moduleparam.h>
>>  #include <linux/ip.h>
>> +#include <linux/overflow.h>
>>  #include <linux/skbuff.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/rculist.h>
>> @@ -1763,13 +1764,18 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>>  		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
>>  		struct sk_buff *skb2;
>>  		struct nlmsgerr *errmsg;
>> -		size_t payload = min(SIZE_MAX,
>> -				     sizeof(*errmsg) + nlmsg_len(nlh));
>> +		int nlmsg_payload_len = nlmsg_len(nlh);
>> +		size_t payload;
>>  		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
>>  		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
>>  		struct nlattr *cmdattr;
>>  		u32 *errline;
>>
>> +		if (nlmsg_payload_len < 0 ||
>> +		    check_add_overflow(sizeof(*errmsg),
>> +				       (size_t)nlmsg_payload_len, &payload))
>> +			return -ENOMEM;
>> +
>>  		skb2 = nlmsg_new(payload, GFP_KERNEL);
>>  		if (!skb2)
>>  			return -ENOMEM;
>
>
