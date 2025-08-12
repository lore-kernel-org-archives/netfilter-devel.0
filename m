Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F258E2D9ECF
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Aug 2025 07:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754985499; cv=none; b=BID8eP5y1Re6QsDvH89Ja7PQr8Ak9FCh4G3+qUpBYEN4O0uPAy7yvWfjoyvlwzdv7OMsiD4yaYFYL/B/i31PR4Sk0/T/uN5p0CdqJc7dcSXXEWXcmNOPa6t6J0OE6zNWJF+WP78XzbJqyEUeSBslfG+BwvOKEAF5hadDWi14iaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754985499; c=relaxed/simple;
	bh=/m6G9D4OqODQ3c13RA3kRRXSajiSL1Hn3Oq6jPIDEAM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=upEJYOTxCdx+dycTi7QcIe1MI/qfImcUbummv0c8qvAlvwPmiixP4j/GY7ML+BT8zmR97E2D7mtXLtjB8sVgekgMcnPhmETIq0SKX1D9Pl5mJGeJh3O10KACk4YicqQdUQDi8kl/9p0pEaycGOAG1P86p0yRr6HLy4RP8Z63zRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cAwrS87a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAwrS87a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754985496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nVnZS37k4cktu+HvOOSYeayJ3wo84XR8QPcitb+eTw=;
	b=cAwrS87aWJI1flknHt4tTr0+ms4eyNk+xwTrATYMrVRkdW7zyfdbA0wuPSbJj0rEpGL2Lc
	veZ7SZOcDVdYM/bKCRHFNEpyD3qvjGoZHNZmEK1MYwSCBR9CzNvp1EiHI5TLYfkas8b7hg
	hkMNPK9eDSAm4E7DLlruhdqOoTbQhMA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-fLSjmH3-O4GeRWGZVnTF2g-1; Tue, 12 Aug 2025 03:58:15 -0400
X-MC-Unique: fLSjmH3-O4GeRWGZVnTF2g-1
X-Mimecast-MFC-AGG-ID: fLSjmH3-O4GeRWGZVnTF2g_1754985495
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b08d73cc8cso144411511cf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Aug 2025 00:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754985495; x=1755590295;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nVnZS37k4cktu+HvOOSYeayJ3wo84XR8QPcitb+eTw=;
        b=TrBJALsmbIFiUSshephG5gHnuasqqY/rKGOXeN+Bsx7vGqmou9+LAO5WEc89py8BYa
         vtgJU3b3s2plhBKRR2wAyq5Pz1AmFeNOyuU+zyUp0U/kogKPl3onoMQoTlPs3j+iJr/K
         Q6zK8Hxz3HSpwOSbtjRwbL491/Xw7Y/GwYnPhF3kTIyg49q7+dGNEXqmX1/lvh2gvGVV
         yilhnkw2dKdwP9Qrm1ZtWIC6I5TjArCbD36ABn+tKqJrpl9ZdcpK4JQwnIWyEoX3RsEy
         j0j+PGvIpAeU4BuC1PA3QmyPENN0Bx+TqzGWDO+GnexfUgsKhF0OizQTQdA/p8Ntj9mD
         ucxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw9SV5Se73X/bYQYxF/xcaq3XtbY7mbl1+soiWaJ1fTBbKmYeSFRj7KlS1+ye6fGR83+MosQkzNPEt/7O61Z0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/UbD69UDGtlGr4/xt+FRZ9q7yfA9WqZZDt7QiMc7rYOtUijVz
	6duOTrX9mFwLZfyKE+kmbjwz2x0BgCEIDcxT7QzlRdnYBJtZ4iu0gj41Q53xRO8/k+EYaV8ZR69
	nbChb92wMK6m7sj99jVFYNV3/YtBTl9kkCXo574EvEskRYt93NY9qaWBVhAcAvECxTVZJfXje4s
	1JEA==
X-Gm-Gg: ASbGncvBmjpoIBigrjZJr8eS1VSZtQDi0CTUDwtvtQUxoe7CUOuLDlHFW5G/BrUInDj
	9YR8rZltKm9GxTEr1lwJGBsQkNPaNF0PxtRyj7sKnzBKWogjWLGbO6/l3p/o16tIt4J2DJ9o7n9
	DU1G+sa7mELz4gBKBbi1FyrIv0Fe/nbClnLdRfqeSnSXnHbyj7Miko51pmKpVw+P/fbS4/aQr6P
	9kG4UiO8Rg3qOmUwsAmbezD0AS2YqEOGFrIgvOjXCT7yRMghx2CxJJV+guNSg1qZSxwY+t68uDu
	Akatm1YTImurtcysmcnlt7IiYCcX3NooQ64gqK7baUg=
X-Received: by 2002:a05:622a:311:b0:4ab:9586:bdd6 with SMTP id d75a77b69052e-4b0eccef470mr39094101cf.53.1754985494833;
        Tue, 12 Aug 2025 00:58:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcDnbdEYlxPjyWRUPmnEUsEptOCYnii0fU0tlD6+Q8OpR1Zr5lMiOkDQhE3+YjeJRH46HgFg==
X-Received: by 2002:a05:622a:311:b0:4ab:9586:bdd6 with SMTP id d75a77b69052e-4b0eccef470mr39093911cf.53.1754985494407;
        Tue, 12 Aug 2025 00:58:14 -0700 (PDT)
Received: from [192.168.0.115] ([212.105.149.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b0860f9df0sm97241301cf.1.2025.08.12.00.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 00:58:14 -0700 (PDT)
Message-ID: <78f95723-0c65-4060-b9d6-7e69d24da2da@redhat.com>
Date: Tue, 12 Aug 2025 09:58:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: nft_flowtable.sh selftest failures
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <766e4508-aaba-4cdc-92b4-e116e52ae13b@redhat.com>
Content-Language: en-US
In-Reply-To: <766e4508-aaba-4cdc-92b4-e116e52ae13b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/25 9:50 AM, Paolo Abeni wrote:
> the mentioned self test failed in the last 2 CI iterations, on both
> metal and debug build, with the following output:
> 
> # PASS: flow offload for ns1/ns2 with dnat and pmtu discovery ns1 <- ns2
> # Error: Requested AUTH algorithm not found.
> # Error: Requested AUTH algorithm not found.
> # Error: Requested AUTH algorithm not found.
> # Error: Requested AUTH algorithm not found.
> # FAIL: file mismatch for ns1 -> ns2
> # -rw------- 1 root root 2097152 Aug 11 20:23 /tmp/tmp.x1oVr3mu0P
> # -rw------- 1 root root 0 Aug 11 20:23 /tmp/tmp.77gElv9oit
> # FAIL: file mismatch for ns1 <- ns2
> # -rw------- 1 root root 2097152 Aug 11 20:23 /tmp/tmp.x1oVr3mu0P
> # -rw------- 1 root root 0 Aug 11 20:23 /tmp/tmp.ogDiTh8ZXf
> # FAIL: ipsec tunnel mode for ns1/ns2
> 
> see, i.e.:
> https://netdev-3.bots.linux.dev/vmksft-nf/results/249461/14-nft-flowtable-sh/
> 
> I don't see relevant patches landing in the relevant builds, I suspect
> the relevant kernel config knob (CONFIG_CRYPTO_SHA1 ?) was always
> missing in the ST config, pulled in by NIPA due to some CI setup tweak
> possibly changed recently (Jakub could possibly have a better idea/view
> about the latter). Could you please have a look?
> 
> NIPA generates the kernel config and the kernel build itself with
> something alike:
> 
> rm -f .config
> vng --build  --config tools/testing/selftests/net/forwarding/config

Addendum: others (not nft-related) tests (vrf-xfrm-tests.sh,
xfrm_policy.sh) are failing apparently due to the same root cause
(missing sha1 knob), so I guess it's really a NIPA issue.

/P

