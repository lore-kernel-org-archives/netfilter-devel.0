Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9499314A98
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777987295; cv=none; b=R0Ohm4EolNj68L+6Dg6B26/zGNxPPFBiTmpWpY0Az8hpBiIsOlk8T4pSMsD3AnK98q76G2QhkEc+GMn60uUQSw1yCKx3w4V+QOIQzkWt2hNSGDmEHpRHAH3kwnm/ObqOQbMh1SxAz5O53utN5ttoqHtqjD8ibIkPtgmhCFgDShY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777987295; c=relaxed/simple;
	bh=9oAquL+9QR4upB9NqT+y+0ltWMfWLhqGmtQLQbdE/0Y=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DP3G+YQKLrRJrRvjel5P0epEtcyflq5o9OeGUlooqLhu2RzBGZ7VwpOn8zEBfARcIQIPFEenn0OBU/x3j66iTlsiW0flpCFEyWVoHL1/Fpa1OJX7f+a/lgLLK6SY0hwVL9M5q7WVXR/K3vyfyFgUxXEmVaUUlFUSVnyJsCrdrBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-ba60d78aff3so744588866b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 05 May 2026 06:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777987292; x=1778592092;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFP1M9ngPhbDqurwCPa+EQuS7F1mZci5tAmPJa9MqJo=;
        b=V3XGgWyaiPMqPDKtrMbOWz8BbOGMFV13fQHYoYa72e481o8io5K4PnioXEIpcZKGEH
         zFY/FxLJUiZ1rR+AjiAA04NAf7YuaGKO3XrEFhJIzVIw04d5CGbANGcZPm3McbNSbVp8
         J+cH3SBFep4Qv98TgxGmQIN+e+dIgCzoKcj/1Lr3h03R90AshuJEFtojy/BvHrSkg7gk
         tevaj13+CgkjLtNieNSu92KI6tN2A6tn9Ufs0h58ZaAsEyAjK9jDfJDQ036XKHM7J3L4
         +8iN9cMN8/ZZ1aok+tIzEptM+l9+ihJ3dlGvj7VAQZ+LoTMzvHfbZzLflEFHTckz4C0+
         BRuQ==
X-Forwarded-Encrypted: i=1; AFNElJ9QUr53WhsRUOOiBziUAohRDLFCzeNp9f4LqzgxDkLGaCRmR2NP6N6HP+TH+vcROWykiLnGF9aaOFB2o6lXaAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+omdcLyWFXofEBrCZPiUB32c5/XbNgavNPllxrUOHq0wyHATE
	0kUpo1PIlahZY9wal8pGg71QsK3gfSis1tRFPZJ04F80fGYUfQKB3gKX
X-Gm-Gg: AeBDiesUqTeHnHbXtHpohTGiDKejOfwrTaxeyxvwXm5qcxS9O+kocpidwa0hshBaHjU
	iEOerFgcxopzVSqp2UwXAOYY4Q1ca9gmARAQgnUKagz8wHJ1+ZRwV0IPFtpVmIxBi5ZhjHDrCV7
	ajEHCW9CFoOgpofM/J9PAJeQC1s8jxW0cxZ1UYCSIH+X4LmkMo6zUvapWQJ1gJzu/nAcrW18zNj
	Dv1udk7YEaWRshDs7n+ZGS5xtaerSarzonnROXe4lad66S0/pbuE2xl3VJGFSfVbz4OX43D20lt
	mXkl5x7VpkF0cbMeh7ZmeLd81fmO0LzyUAD/hRHwHaGC6FSmq85utx3WS5L4nlwJaoKbZztvXyZ
	g7HvbHFWvlSZVSRMlTsiXDA9vcAkAU52xgpEuCOdrPCQO6v5MW6sAut3CNeZuMx9lRiB/SDtl2N
	DmqbUt2I51krIXjO5eYbNygqEaif2+/savDKYxBvXgS9IRR9T15a93lojM6agjOpWeHQ==
X-Received: by 2002:a17:907:3d0f:b0:bc4:12f1:d7b1 with SMTP id a640c23a62f3a-bc412f1f95emr161848366b.40.1777987291646;
        Tue, 05 May 2026 06:21:31 -0700 (PDT)
Received: from [192.168.88.241] (37-48-40-237.nat.epc.tmcz.cz. [37.48.40.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bbe69f6b9c8sm484645766b.9.2026.05.05.06.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 06:21:30 -0700 (PDT)
Message-ID: <ccc52c4e-8615-49f6-b078-520b4ab6a60c@ovn.org>
Date: Tue, 5 May 2026 15:21:28 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: i.maximets@ovn.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_expect: restore helper
 propagation via expectation
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260505114213.406362-1-pablo@netfilter.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20260505114213.406362-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/5/26 1:42 PM, Pablo Neira Ayuso wrote:
> A recent series to fix expectations broke helper propagation via
> expectation, this mechanism is used by the sip and h323 helper. This
> also propagates the conntrack helper to expected connections. I changed
> semantics of exp->helper which now tells us the actual helper that
> created the expectation.
> 
> Add an explicit assign_helper field to expectations for this purpose
> and update helpers to use it.
> 
> Restore this feature for userspace conntrack helper via ctnetlink
> nfqueue integration so it is again possible to attach a helper to an
> expectation, where it makes sense. This is not restored via ctnetlink
> expectation creation as there is not client for such feature.
> 
> Make sure the expectation using this helper propagation mechanism also
> go away when the helper is unregistered.
> 
> Fixes: 9c42bc9db90a ("netfilter: nf_conntrack_expect: honor expectation helper field")
> Fixes: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
> Reported-by: Ilya Maximets <i.maximets@ovn.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_expect.h |  5 ++++-
>  net/netfilter/nf_conntrack_broadcast.c      |  1 +
>  net/netfilter/nf_conntrack_core.c           |  4 ++--
>  net/netfilter/nf_conntrack_expect.c         |  2 ++
>  net/netfilter/nf_conntrack_h323_main.c      | 12 ++++++------
>  net/netfilter/nf_conntrack_helper.c         |  5 +++++
>  net/netfilter/nf_conntrack_netlink.c        | 18 ++++++++++++++++--
>  net/netfilter/nf_conntrack_sip.c            |  2 +-
>  8 files changed, 37 insertions(+), 12 deletions(-)

Thanks, Pablo!

I re-run OVS tests with this version of the patch and they worked fine.
So, for the the core part (didn't test sip or h323):

Tested-by: Ilya Maximets <i.maximets@ovn.org>
