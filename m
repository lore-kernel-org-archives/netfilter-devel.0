Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9E836A35A
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 09:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504694; cv=none; b=BP8wd2nTpMTyXOZVy38QahjgAtVDpH3oASvh+IUZw8peG+SwsUanvGkQDdWla89el1j+P9CuuO6hosbK929Nzz5G1W8hl/FNB1Y+qbgpArHuDwkMwMnEu4JDPXOZMQFIdX9+7sNZUgrgInx/DHA9UwAChO2pxEqw8btgRct4lLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504694; c=relaxed/simple;
	bh=ZPZ8Ghpofvj3SxI2tuKyXiYtS79lSc4K8bhJ3ppreTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufDSlVbIsvuVWwpEmrT2TXz5a+LcKUMOHC06Nd/sVNRcDKuoJYYlUaCCWUoW0NsJMtMABTGna04Dw6n8BW3xcpYoD2TUS5pxk7vwLqkWvuXZYIy+9RZM3FHVgdmkMdbz/7FqEI6qbnLXVzaZy3wUBVEt/WapKL3fqGC+8aW6DBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HptC63VL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAhN7SFy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HptC63VL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAhN7SFy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783504692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZPaMybjeMNKNpD8AtX/8HSMSCIwjQpAmfLjC6sDrjw=;
	b=HptC63VLBmON6gB8DF7tfthve4rMu6392jSxWg4VPEkAsNgiTj8floUCCtqgw/f48J5MUK
	73ZxaxDzTw7Q5FA+KlEIse8Uq92ByGnNJzTzO0vEBOVvMIX03NhwrsQL/QncvrCouJXeaN
	8Tc+0ExB6e7iHu+CLex1hyfgrWZz8NY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-gM98yoCpMwCTchcYli96wA-1; Wed, 08 Jul 2026 05:58:11 -0400
X-MC-Unique: gM98yoCpMwCTchcYli96wA-1
X-Mimecast-MFC-AGG-ID: gM98yoCpMwCTchcYli96wA_1783504690
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493c1bc7a70so4452525e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2026 02:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783504690; x=1784109490; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZPaMybjeMNKNpD8AtX/8HSMSCIwjQpAmfLjC6sDrjw=;
        b=LAhN7SFyMNxgdC3eCNsZJ7NpwILQH0VQ7ps9BlsMbNl6xyYsdYyzFSy0Ks02AH0GHM
         p3yJ0yAhwKENfKrljwmppPUb6so8K3v28GXtIN40ZPu0Ng7QosIqkN5dkKWI9y+xrsNt
         u3KB0K1GTQVyjIFt7J8neEdh8hPWENDJQ/s74WI+cF6DIY37X61Tv/n1KV9OxnewjYr4
         u8v63Lcbo6etOIpsWymXhhYfEvh+LKYp7qzghPkxXcVeb56l40bPXPpmkwwZun/8SPcV
         qcQ3q4cMglE+rytPdjxAjOi0/a9ytzB22pddRqiMeRqnhrPO1lzufCm7F9Twf1BQLd0X
         q59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783504690; x=1784109490;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZPaMybjeMNKNpD8AtX/8HSMSCIwjQpAmfLjC6sDrjw=;
        b=GGIJOjnYjIEAyJF+r+wgqAk+7pfZ2XVxt32d8TdRxqnjxmFQFmR5sMqrqaeyxfER/a
         XBj41yivBOOIospPWjrUHMqRzAoVPM1gx3CpTAsBynIiMPqSfTRq/4qtlkeCPZGkMJOy
         AlnOnxy4U7i5/jMThhvP/RA3+mKZYq8mFx/RcOWCjtZDS9JPGZfQxhAcj6IhVSH3RD1D
         I9uiptfVKJwQoZU9O9KE6qbOh/iKbSdV1T/848kYTWXasMfexvca9WHwnCxjGLVs2kny
         hdA9Dw2aaMi3kWXt1DaPl9YGRgjWu2H1wiNMFtdouzcWw6jImNyND0a7nScxNFSVJpsg
         /IOw==
X-Forwarded-Encrypted: i=1; AHgh+RoqU45Hc3fa6eacB4IE+yflWInOQdaKztveSecGMzvMEvQ//gEIjUxF/2uRH1NixC1bx/2Gd0QlK/wkcdpKDfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDe0S6DwaVstjQdLdmY7NxyR9rE+sju6E8F/HAU+ObCa+5sxYE
	UJuFVBI3bC+9GQBCG0kmoS55MgRnkjlYnF3HZQEhii4OT4Z5+C4ABD8WnOOt+2jLN6Na8Lxol4x
	NELUFjYKNm+VImyxYLXGXhpNXjr/IQyUneOSeG2ESHKcuITBIzXm2uWgX48incZpS4mcrFg==
X-Gm-Gg: AfdE7clBGIXjVZSrGUnaJPbWYyMe0d5FiCzYKW1JlvWjvcd8KB8HyrAu1ZE5hIUmKyr
	zqAGEniRIgv45TzvtqhX5/quf6zfrV8ocvHVZZnRIt6kg2AERsDzqxPKUC+YTPNJbvPM0SB6lEd
	zzRM+2EMNaUbT+27/wsMe4l/XZZD/DbR7SJLk1nqX75/uJDE0nNSZyJCeAj9/DaI2uj2vWV8Ep+
	5qKAH8jNOWpY4kePboiN0ngU6XGGKEb9YmmIwcE3WAx7di9UibnFWqqCv3OG0x3nM1LzTcBf9mt
	W9bh7ErU1YM9/04duth8O5pEnf8lpQdUvnwvmZ6xc9jy9mEm0BH/LKTT4f+bs89K4iKNUZD90sP
	tK2o+YZKjBpLZPh4d2Mz2NG+oWzNDeGJs+liocDIwLA51ilDPpcs+UdiNTtxjncu3HWcD5TBrsU
	oXSZozLETuLYIz
X-Received: by 2002:a05:600c:3e11:b0:493:df1d:7488 with SMTP id 5b1f17b1804b1-493e6904b5dmr20334565e9.16.1783504689815;
        Wed, 08 Jul 2026 02:58:09 -0700 (PDT)
X-Received: by 2002:a05:600c:3e11:b0:493:df1d:7488 with SMTP id 5b1f17b1804b1-493e6904b5dmr20334145e9.16.1783504689342;
        Wed, 08 Jul 2026 02:58:09 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fccf2dsm135091445e9.15.2026.07.08.02.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 02:58:08 -0700 (PDT)
Message-ID: <e981a64f-ec3f-45d6-b20f-e03b61a91f2b@redhat.com>
Date: Wed, 8 Jul 2026 11:58:06 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
To: Yuan Tan <yuantan098@gmail.com>, linux-kernel@vger.kernel.org,
 workflows@vger.kernel.org
Cc: jhs@mojatatu.com, gregkh@linuxfoundation.org, sven@narfation.org,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
References: <20260708092247.4188498-1-yuantan098@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260708092247.4188498-1-yuantan098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/8/26 11:22 AM, Yuan Tan wrote:
> The rough idea
> ==============
> 
> VEGA would have a public dashboard, similar to syzbot, and would
> send selected bug reports to the relevant kernel mailing lists.
> 
> The goal is to send reports that contain enough information for maintainers
> or other developers to pick up, understand, reproduce and fix the issue.
> 
> For each public report, we expect to include:
> 
>   - a description of the bug
>   - the tested kernel tree and commit
>   - the kernel config and environment
>   - the crash log
>   - a minimized user-space reproducer
>   - the suspected introducing commit
>   - a suggested fix patch
> 
> The suggested fix patch is meant to reduce maintainer burden. It still need
> human review, but hopefully it can save a lot time from building a patch
> from scratch.

Thanks for sharing. This sounds very interesting to me, modulo final
impact on the ML - overall load is severely increased since the LLM era,
while the maintainers pool not so much.

A few notes on top of my head:
- the amount/rate of reports is critical. The higher the rate, the
better need to be the reproducer and the suggested patch.
- the crash log should include the decoded stack trace.
- IIRC syzbot reports sharing is [always] human
moderated/limited/controlled. I think that is the correct default and I
hope it should be possible for you, too.
- it's not entirely clear to me who exactly is 'you' and would
appreciate more info about that.
- it would be great to discuss this topic in person, i.e. in the
upcoming NetDev.

Thanks,

Paolo

