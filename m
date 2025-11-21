Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75C2C21C0
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 11:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763725017; cv=none; b=XwwIn85NRyCKSC31IAnoa0caW5N7jHuZ6XMVpY8yx7G5FBmkTU8VMFAp1kovYA097vuWLZ+Ya6rVHGnCxeO/Aoa1jkaZ49lKXa7dslJ35DtlmGEDLuc5nvW/tmln4E+J3xRbi6D2J/Lh8XJ+9L1mqysbTqZKEaeQfVm7dd1QKr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763725017; c=relaxed/simple;
	bh=2YhHun6h5TPZJPb5erjEIpsM643I39VH2RfBhKTc8MM=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=hg8IhjXyAy+cDhPuCLP7wcmRTwTG6cNHfGzPa7qcmeVgL5EFXWAfanqS3JUmfOStXvD2plPWKZx8k4nFwi11of8Nijay/7WnUtabfFAS9bKm/53/PCZ2iq6MC9m4HYLsb8FBZmDi95FyaBf0BIyI7rm80WTqy2b8/BYUXglqGmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4JAN0gh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4JAN0gh"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so16776615e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 03:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763725011; x=1764329811; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fEL/unmTGTd7Hwoq2i5Bt8Vk37qtmt2aavwNGtQcKk0=;
        b=k4JAN0ghN2HrJsm0n6OWj+TlyMhsOFDfy4duBR/1590P99RDYuI90jKderNxb07X+S
         NNpfFhmyWebzua69RfKluGPM2d62pNRBMYWGRk+OUlGVjNX34HIvNULWLlF4YiVQQP13
         0G7KnZfAW6AzANET9uZupmG3f9MePAJVUjrjprjyjmlx8hGQZ2D6ce14KjleSbbyOOjR
         al5I/2oQNbgaP8Oj5wz5aBqVbr0F8WKlQ91FSZxSlcwD6S+Bla+89kuwMQF2PuMDfljX
         mVSvk46GFCGUPY2sYID/kuCMmCiNwykILFY0ZvOO9RY9evgG3i5khmT9cpcI9d7liW09
         hwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763725011; x=1764329811;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fEL/unmTGTd7Hwoq2i5Bt8Vk37qtmt2aavwNGtQcKk0=;
        b=dRs10X6YOtXbDt0672205ia+c0pxU3vL1DOz+617tmZn5SbApQGHJfKLpbM9k3hqT8
         I4WDw6GaECZjnT0rZyD6hHBM7oKu/ugEZaA6JFp1JBxINKVDFR5GwP+dIN9gVeqWxk8B
         StmoVUIdtDSVNAVcLNvLd1UMeLAc1w92Z6lV39LsNmwTD+w4apyfzNn7GyhJHWiSw+s8
         CfiAqbixgDw4KS6KlAemf7omw+UNF05i0nx2nRAts2rJzREftxY0Dj09h5b9KnnhRFVr
         a4qp72jODYWzxv2xci4uUjmsgx4kdZ8e6CtU63itrzbdG/Ubx5k1lAp+/m42tgk6RnUf
         5vwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbx3993KppxsdrEDBVzUBv1b9lqp59dyZ48yna92E9kLe4VI17bg15BYt0vfm+dEJ0VeuQxqXryUlh86m6KxA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy5BMqxtjdGGgTuBD07mItoEmoQ/JzcnzLk0PZAeyE//Y4O+7N
	bphDvedlUvYuN6JZ/bZMzlsKxPQ3Irxx5afcwU/J/YlwrpmCV8y6b5WO
X-Gm-Gg: ASbGncv7RTTPSqJtxNwXPMM79WV4jX7JagFhyCqvmfgCgbFPsI0CDM7SBsL2X1AABMU
	nhhHF1+qQD2a/EMBa1Nt3jFDo0rE/SwKKm7zyA7cK4SbkQeKRH/91GjYKDME78or2ohgdQkzkAV
	ORsHbpFiY+hGgi/xheiZCGedp/lb6XppO96Yej4GbIrr/1e3e0dfGMucxJbp86acV/OzF9sMFae
	nvMlwn6/VNCm+tvLRgvNmoOyIgCB0WMMXjvitw3fjOXrTjXCges5nrbtaUwdlOJ1riLSXvkfLml
	mZc+7VJRZTen6MZKc/GJ6gMBt/mn08SNrL/T+/K8E+fLCpwlMMT728ZjeOEMC/SZ0/cZ8aHvvCq
	yUZTg9FvXgcstWy91mhX+NoK1xl0P8d0h57mEEZZvrxIMfbGejOHqLFhvDVFfqlwoz6udWa8VLR
	KbSRq/Q0pmiRHupeDgtv6E+3s=
X-Google-Smtp-Source: AGHT+IHiWl/LbQdLCaHamlI44jxsdkR7SpMvvFRZBQA37tgZFbQIG2lm/npPeeMv7MO4497KZLWILA==
X-Received: by 2002:a05:600c:1c0d:b0:471:14b1:da13 with SMTP id 5b1f17b1804b1-477c018a12cmr23820885e9.14.1763725011008;
        Fri, 21 Nov 2025 03:36:51 -0800 (PST)
Received: from imac ([2a02:8010:60a0:0:f819:b939:9ed6:5114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1f3e63sm39654205e9.7.2025.11.21.03.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:36:50 -0800 (PST)
From: Donald Hunter <donald.hunter@gmail.com>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>,  netdev@vger.kernel.org,  Pablo Neira
 Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik <kadlec@netfilter.org>,
  Florian Westphal <fw@strlen.de>,  Phil Sutter <phil@nwl.cc>,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org
Subject: Re: [PATCH v5 1/6] doc/netlink: netlink-raw: Add max check
In-Reply-To: <20251120151754.1111675-2-one-d-wide@protonmail.com>
Date: Fri, 21 Nov 2025 10:03:37 +0000
Message-ID: <m2wm3j4s92.fsf@gmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
	<20251120151754.1111675-2-one-d-wide@protonmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Remy D. Farley" <one-d-wide@protonmail.com> writes:

> Suggested-by: Donald Hunter <donald.hunter@gmail.com>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>

Missing description, therwise, LGTM.

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>

> ---
>  Documentation/netlink/netlink-raw.yaml | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/netlink/netlink-raw.yaml b/Documentation/netlink/netlink-raw.yaml
> index 0166a7e4a..dd98dda55 100644
> --- a/Documentation/netlink/netlink-raw.yaml
> +++ b/Documentation/netlink/netlink-raw.yaml
> @@ -19,6 +19,12 @@ $defs:
>      type: [ string, integer ]
>      pattern: ^[0-9A-Za-z_-]+( - 1)?$
>      minimum: 0
> +  len-or-limit:
> +    # literal int, const name, or limit based on fixed-width type
> +    # e.g. u8-min, u16-max, etc.
> +    type: [ string, integer ]
> +    pattern: ^[0-9A-Za-z_-]+$
> +    minimum: 0
>  
>  # Schema for specs
>  title: Protocol
> @@ -270,7 +276,10 @@ properties:
>                      type: string
>                    min:
>                      description: Min value for an integer attribute.
> -                    type: integer
> +                    $ref: '#/$defs/len-or-limit'
> +                  max:
> +                    description: Max value for an integer attribute.
> +                    $ref: '#/$defs/len-or-limit'
>                    min-len:
>                      description: Min length for a binary attribute.
>                      $ref: '#/$defs/len-or-define'
