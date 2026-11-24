Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528072;
	b=ZcqzmsxfQlJRP4ZJZygQVaPDluYq5/BgzGhn360rW/CnWBFAoAWpsyf8Ny6s5zOPyCgx
	 VQJoP6wSN5rYG37coB16EZMZRsyADoww3wxTONSGLeHFsn5FyEfUtNH7UXE0js0B1boTo
	 NLgjUsQA94EIbXeTqWU4grqEDUfuSTSBZwZX92tzI1v1O+2qfuZ0BgwgiL4KF7HHb/NHK
	 J0K07gRpZiQjz0q5LhDnb+0XtxAMCatpXDc6d4YQBEeVJAYM5WQlZXx+QtSupKmoJIZ1g
	 s7uTk+VqjDU8pDZtKPcoLLrDDqqoS0IXpoKucOmfTUkD9vPjvVYi2f5Ar+CoGuCpFbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528072;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=vHjTkySiFKXus94DhefzL4/420JVXKmOAhnRz8n+Tt4=;
	b=BN1zwugrwJ7sWmIiamJjOMxh5INaBHWewatz0g9QhUcTWDIzFTfi+Uzd2wwF/zcEIl7C
	 l5dT7UOapnijZzK7HxxZkAgdlFF8sFQp9jlOxvhByMjUY7pm73mIKVocsFeAMSfyLxWg2
	 nU7BgYBddSzb3PRjKbe7ZOH7mRpXbclTNd71btMonCFxAEL+kiOQLPOvQqdq1311gvsVo
	 fZ/9cQlIUt4Hk/2zvC2+GLxEWYF7SwBcHIoymauUckELDFFtI/zZUJOtavVgAoNzAfchS
	 R+lPSgXJinZEoq9aIpWLMCmSPrv3KisqIry0s1vADmyT2Oighixv/Q5fdt2dYAj1V3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ka558X0q;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ArrzaBJl;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE6606A322
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 13:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19DE6606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ka558X0q;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ArrzaBJl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795528071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHjTkySiFKXus94DhefzL4/420JVXKmOAhnRz8n+Tt4=;
	b=Ka558X0qeEWbteC5u6hcD7tJnkkK+dy3JDc3j4EjPy/UUJTMP4VDwEsZFZUHy3CS09jkys
	wdDMOTdYMKP/hlpUWaI6GvB1aPXRQr4LyUr8Nf5YwdTOiu9gtNhgRCO8+g/pi22POvTsk0
	dJ83vVrfd76loOf86IlY+xzIwTVQfHM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-693MUcvPNSSWK6fJWeAGKw-1; Tue, 24 Nov 2026 13:47:49 +0000
X-MC-Unique: 693MUcvPNSSWK6fJWeAGKw-1
X-Mimecast-MFC-AGG-ID: 693MUcvPNSSWK6fJWeAGKw_1795528068
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4a82fb7e71eso2549464f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 05:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795528068; x=1796132868; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vHjTkySiFKXus94DhefzL4/420JVXKmOAhnRz8n+Tt4=;
        b=ArrzaBJlogyiXM1AD76+wJEfFi8xXOggsQYo1Sxb0e7/x3QEzZLwO5YAJApIeQ9fas
         cBFg6lue27VBGJigf+uKTOUwWTtohtqMpXyd2atQ8x3Ss4vrb9I4Th1JF6UlXlukHDpA
         0N2NrLMmUa/JwDDGkMD8469Ol490+vWVz7fuTyBzICyFK4fpaMVCjIYi7twkGR4LUANG
         9tbjNBsCPB7Z7rpMGnKKr/bPd+c88uAWaECp9a3Y7vwQ4d4NG94PXVlRcmtEx8FPBJFh
         3LmBACtHmsb4jYtyyJRAxMvebSqBSb687YO4pWMG3z4nmfPf0ZXLhZdBRvotnVHtEU7h
         SdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528068; x=1796132868;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vHjTkySiFKXus94DhefzL4/420JVXKmOAhnRz8n+Tt4=;
        b=cbOfNOAqidqz4bLjNaBn1K0OqV9Y6oLF77JXjEafBDJ9CIOrcwaAJxwe/JzoGYEQ5g
         60PzqkOYnxKRF7v6Rn9pQvvX/OkGfHXG0eL0X34k2DddulIcNQjEBzyDig8TXP4EHGdb
         zcu9amKiU6laPT18IEaTDiIB3a+sz4MeVGGA0I0FzqWiX3V1ef9g8j2+b0efvkBEVOhl
         hXehRVZurW7chAeTYdAU6EJA5bBQZQiCDcdRFpJ2YmhhXCqauMkShVPAiRbr+ipMbSO+
         8O0Kdx1EvWRHrhMpdeHeoyWXluPLEyYQYpWuFsYXn2FOdQLh0NqmsqXhW6YFDnd5745T
         grEQ==
X-Forwarded-Encrypted: i=1; AL+hErHAFG9ql1n3kFLmmLFV/oRF3P/JU3A90BQyibVl5NRTZDhZ0JPDE4be7rNNMNyRO5e55QjKsDP1tGIpXJJCei8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8BHP0ldM9ka8tnJWoEE6LhK675/NEJ2yhjz9FKluCcYgItfS6y
	UTGbsAxzlUsTD/GZnIJngnhr2LpaDR9jfN6JrGIfDZVYeyph4Xh9X47Ub5bl+2a05IT61J3lbbB
	RUJt5X59OnIM/8fVFfExWK5CofG+MaZIxAgN4d8sWkwwbUUX9ImvjQlrpGSBFt0WJNACauA==
X-Gm-Gg: AZFdTZdZzM/T6IEjC5jiIYX0sCfstJQFIHP0+lxjqpmrnQO4gmBJVE5uFkh9aztHy+o
	qHWLzGgsq8IofAOJnvaAAEk2o9Rfl01jbLfZS1UvKxiaKRd6BSCEgTJyhqvSLSfux3QFS6Cc5y5
	pii/DIORKlSNpmpPpRr/EuA34tmqo8H5wPZX3SBAVZ/qWb55MEPJGQM0B7dcQkQtXpbW/gHOcGm
	/tcXwPcg0TyU/WCTKHbICAO41s95bhTCBwtqjo4PhvA+3jww9fiQqAcQVKhh7eBEMpGFBfF/ePE
	sJg71c8ktxmpFHHXu8u4Sg4qqldplSgu29N0DZeiUQiClbti7z+39Hdrizx4vTmgo3YxKcD501K
	zlwDWnQ6K7SM86fAFhDq5FL3XiUvP6Mas7/oxkj/enqLYSJaW6kvnLNFKEiIq+b82R0UKTCa7vT
	Uo/jALHbHDUP6aAUzBE23sM5YT85nwBBYrCtQoQhD4HGpU
X-Received: by 2002:a05:600c:3ba5:b0:4b0:a307:46f8 with SMTP id 5b1f17b1804b1-4bb8880f29bmr339494935e9.10.1795528067763;
        Tue, 24 Nov 2026 05:47:47 -0800 (PST)
X-Received: by 2002:a05:600c:3ba5:b0:4b0:a307:46f8 with SMTP id 5b1f17b1804b1-4bb8880f29bmr339494285e9.10.1795528067293;
        Tue, 24 Nov 2026 05:47:47 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442693sm385064995e9.1.2026.11.24.05.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 05:47:46 -0800 (PST)
Message-ID: <e7a9c532-d063-4eb4-bbcb-39b4ef80a51a@redhat.com>
Date: Tue, 24 Nov 2026 14:47:45 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWEtyMI_-VEreFq@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <awWEtyMI_-VEreFq@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/26 13:36, Florian Westphal wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
>> Unfortunately a couple of in-flight nf patches prevent the CI from
>> picking this series:
>>
>> https://lore.kernel.org/all/20261120111910.67379-1-juny24602@gmail.com/
>> https://lore.kernel.org/all/20261121212037.149722-1-omermetekaya0@gmail.com/
>>
>> Could you please re-post it? thanks!
>>
>> (Do I recall correctly that guidance for nf patches is to not CC netdev?)
> 
> CC'ing netdev@ provides no extra value to us.  Quite the opposite as
> seen here, this means another delay to a backlogged subsystem.
> 
> This is coming from get_maintainer.pl, which for these patches gives:
> 
> Pablo Neira Ayuso <pablo@netfilter.org> (maintainer:NETFILTER,commit_signer:11/16=69%)
> Florian Westphal <fw@strlen.de> (maintainer:NETFILTER,commit_signer:9/16=56%,authored:3/16=19%,added_lines:168/436=39%,removed_lines:73/217=34%)
> Phil Sutter <phil@nwl.cc> (reviewer:NETFILTER,commit_signer:1/16=6%)
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
> Eric Dumazet <edumazet@kernel.org> (maintainer:NETWORKING [GENERAL])
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
> Simon Horman <horms@kernel.org> (reviewer:NETWORKING [GENERAL])
> Jozsef Kadlecsik <kadlec@netfilter.org> (commit_signer:11/16=69%,authored:10/16=62%,added_lines:264/436=61%,removed_lines:139/217=64%,blamed_fixes:1/1=100%)
> Yifan Wu <yifanwucs@gmail.com> (commit_signer:1/16=6%,authored:1/16=6%)
> David Lee <david.lee@trailofbits.com> (authored:1/16=6%)
> netfilter-devel@vger.kernel.org (open list:NETFILTER)
> coreteam@netfilter.org (open list:NETFILTER)
> netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
> linux-kernel@vger.kernel.org (open list)
> 
> ... which is waaay too much, IMO.
> 
> Would you mind a patch that alters this to only suggest:
> 
> Pablo Neira Ayuso <pablo@netfilter.org> (maintainer:NETFILTER,commit_signer:11/16=69%)
> Florian Westphal <fw@strlen.de> (maintainer:NETFILTER,commit_signer:9/16=56%,authored:3/16=19%,added_lines:168/436=39%,removed_lines:73/217=34%)
> Phil Sutter <phil@nwl.cc> (reviewer:NETFILTER,commit_signer:1/16=6%)
> Jozsef Kadlecsik <kadlec@netfilter.org> (commit_signer:11/16=69%,authored:10/16=62%,added_lines:264/436=61%,removed_lines:139/217=64%,blamed_fixes:1/1=100%)
> Yifan Wu <yifanwucs@gmail.com> (commit_signer:1/16=6%,authored:1/16=6%)
> David Lee <david.lee@trailofbits.com> (authored:1/16=6%)
> netfilter-devel@vger.kernel.org (open list:NETFILTER)
> coreteam@netfilter.org (open list:NETFILTER)
FWIW, LGTM!

The only delta I can see is that patches landing on netdev currently get
clashiko review, which could (or could be not) a positive thing.

But in the long term we should have hopefully clashiko-like reviews
everywhere.

/P

