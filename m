Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF256336897
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 20:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777582727; cv=none; b=d9vLQ5Y4FR0Huv7J92aUAmr6SstLLwJhygNZzhB4De5CyDyW65CML64GxdCIs3ijmUhCZ+LMAziLoKq5xvnrNTWAGiNGNdsw8g7rO2ow4da4lQa3PX6Ej+IQlfIx6Hd0k6J6RTEbkF2gOlnO+y6cYvC1tJxdXBGiINFh8xNI04o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777582727; c=relaxed/simple;
	bh=bLcJu71G7WPZXPFwGj3wOrf2aAWHV9CNC4610TMQDno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nejlbk8aRD9ZVyOTNDy+OKqYQl+dkgL0pUPb0oTGuSAKNONLW28sNqcYRFJ0C5jchBeNQ6otkSEaYycj35HMNCY6Y8BV/yL/ToEPmj+2V+lrrDuuevsyKgtgWPDZPn3gj96tE62XxbypP6N5HYY4f20XHRj4jG6sRAyTDju7BEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-8acb09ddbf6so19596616d6.2
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 13:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582723; x=1778187523;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvyvGmLX7fIENRT2IT+DRsK2ttBx2k3lafk3GdB3p2E=;
        b=CK3Y/kwi1AaWN3qWADS2cc+7A5a0NNJhQkih1b37EPLg7wUe8rfql7f3VEASz3apeC
         9Uk5EQGf3zvkjJVTmHx3uw0jrgH/gOoltJARQSkazatQL6JLqoYAZBfBH05wbNaHGMvx
         cPjRDamVtrMh/NjFdA3Yb/LeKazZYZ94PdRHSowmFOOerOXMiYjnpR7iAbPy+E7Hdvs1
         MVhmGPz6rVVTDTS9d5RkUnBHOh7D75IIsH97niQjAan4Q+BBo8CxJZxh6rEnRnvG9m8B
         3gpcKF8FHvauH3y/CdXHfAU7JamRD2W/pW7lHe0HugF9uKmOh0zL5nn7Min96M5dVB7L
         wAMg==
X-Forwarded-Encrypted: i=1; AFNElJ9wIrnMGnEFOcvw+aDy8g2zEz5zr5ud25UyS9UiR45SGTTUuWaLeAtH4t4xhUYFqrWPVHsPzR/eWR9r59Y90K0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN11MnYhsvolCT2F/3DpHx1qlXRAqh88wDq3KCzsbdvhI+GQuC
	Iz+VuoTLy7PYeTJmOHnKjBLFfxI9/OKTwERODDVLTqyZVy8te+ic8XnI
X-Gm-Gg: AeBDiesWdbXBsaGsIl4Gt+Kiux1o3LrozVaCukpFZMe2A2TWmh/huUFbJkaF/01gUag
	/Lv7UUa34k9T7PdjXMhcg0mtUGsDdAu/KVmxG8zBPtF7AFHf2VS04rfzd1ftfvPK8M2j4XB0JZV
	ZmWYLuXkFZbg6WJsvAL25tzqBUMMYM1rweWAQVybCMvN5z9o/AuWgABg2OTwLmbRr39VbLNAd2R
	TAAX/HacAUeawlawdwx9meqHt3MifrEtMkLu6YJXjAC+mRuq2xJGnLJX5hQ43xvLNrDtn/i3ZnF
	GeEwDx0EjxfRmNONaJNX0DJQ/kr8pitC3A25UDtyFXFppidcuz4btLLyXPcr5zLSiPxULFM/wn9
	vDdrkZZfFLo27Gh7EmH/IbchdFwxIxhuy+8jo1UWbXNvyqYEbtCtem5B0UP7c2PbUDZIuCx+TrS
	o2Az8G/tS/hitzv9aA0/b2v+l89BoZR/g7fKfR5LHheqBiSseQlpzThq/++tkMdWhYzQ==
X-Received: by 2002:a05:6214:5f04:b0:8b3:e7b3:99ec with SMTP id 6a1803df08f44-8b3fe77dc0emr70398276d6.4.1777582723342;
        Thu, 30 Apr 2026 13:58:43 -0700 (PDT)
Received: from [192.168.88.241] (89-24-32-159.nat.epc.tmcz.cz. [89.24.32.159])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53c0e7ebdsm2231936d6.29.2026.04.30.13.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 13:58:42 -0700 (PDT)
Message-ID: <8fd5d3a3-d1d7-4542-a0db-1678989940d4@ovn.org>
Date: Thu, 30 Apr 2026 22:58:38 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 06/12] netfilter: nf_conntrack_expect: honor
 expectation helper field
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 fw@strlen.de
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, horms@kernel.org,
 i.maximets@ovn.org, Eelco Chaudron <echaudro@redhat.com>,
 Aaron Conole <aconole@redhat.com>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <20260326125153.685915-7-pablo@netfilter.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20260326125153.685915-7-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/26 1:51 PM, Pablo Neira Ayuso wrote:
> The expectation helper field is mostly unused. As a result, the
> netfilter codebase relies on accessing the helper through exp->master.
> 
> Always set on the expectation helper field so it can be used to reach
> the helper.
> 
> nf_ct_expect_init() is called from packet path where the skb owns
> the ct object, therefore accessing exp->master for the newly created
> expectation is safe. This saves a lot of updates in all callsites
> to pass the ct object as parameter to nf_ct_expect_init().
> 
> This is a preparation patches for follow up fixes.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Hi, Pablo and Florian.

I was investigating FTP test failures in OVS with 7.0 kernel and bisected
the issue down to this commit.  AFAIU, with this change all the related
connections over time gain their parents' helpers,.  This is causing a change
visible to the userspace, because FTP data connections are now reported to
have helpers in the conntrack dump:

# conntrack -L
tcp      6 119 TIME_WAIT src=10.1.1.1 dst=10.1.1.2 sport=59534 dport=21 \
                         src=10.1.1.2 dst=10.1.1.1 sport=21    dport=59534 \
           [ASSURED] mark=0 helper=ftp use=2
tcp      6 119 TIME_WAIT src=10.1.1.2 dst=10.1.1.1 sport=52709 dport=52381 \
                         src=10.1.1.1 dst=10.1.1.2 sport=52381 dport=52709 \
           [ASSURED] mark=0 helper=ftp use=1

Before this commit only the control connection had helper=ftp reported in
the dump.  The traffic seems to work fine, but our tests fail because we
do not expect the helper attached.

AFAIU, it's generally not something that should be happening, as helpers
on data connections do not really make much sense.  But I'm just trying to
figure out if you would consider this as a regression and fix in the kernel
or if we should adjust our userspace components for this new dump content,
which would not be very straightforward to do if we want to be able to run
tests on both old and the new versions.

What do you think?

Best regards, Ilya Maximets.
