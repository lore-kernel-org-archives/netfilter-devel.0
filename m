Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86C83DB630
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786876728; cv=none; b=K2iXy12wS8nWDvXvf5i+g5Sr/edogjPEDaz5G2IS9hU9h3+8PhDkM3fqA0IXaIFa6fu5DsxMjzavQ+Sy/yfy/OqpJxONmWKEDtYQ2HR4dYAJN0a2IBBQkOQAXzoEKUgU2Q+uaGXolK2qUmA4+YloK4nzEIcMp6MlK8kYKdVXQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786876728; c=relaxed/simple;
	bh=E1DtirF/DQyijYx6juRJxgXtDCMrWh5fDkYaKtFffkE=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=X9WjV89PzuxQKNp49B4hirCs4NacTFjxm3It+AxwAWCyBQ08zxPXSFJb897pZtQHdfYUpoZudkJYVsLkNzowCBK3Mqu7zY1aogbJztxOy5kkD+HQn4s1vb4U3INxmXONNozsrXt91iwb3FDg+0Y8davNHWatcY7aCW221W9l1LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UaFnlrBM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pJFpEucP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UaFnlrBM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pJFpEucP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786876725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6KOR7ml/I3DeYY8E5GuQK4htPpObD433wHZPRRbJLQ=;
	b=UaFnlrBMx0S5nD7384Ew8WlTgUGFQmqnmE6MbqY406Zpa7r1klbgqAj7kHOBp4D5nyyKWF
	UbS8TdkQGqTi6vDHubYyCT0xXll1/AldfBDwDoGSQ4B8TSRQbf7KSQjiwdlNL7pYlxBFoK
	zLdIWWgbzN22XFZHPbQJ16ik+TWG24E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-uxV7_NihO369DTmW9Kv8NQ-1; Sun, 16 Aug 2026 06:38:44 -0400
X-MC-Unique: uxV7_NihO369DTmW9Kv8NQ-1
X-Mimecast-MFC-AGG-ID: uxV7_NihO369DTmW9Kv8NQ_1786876723
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4954c2d4081so21054575e9.2
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 03:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786876723; x=1787481523; darn=vger.kernel.org;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J6KOR7ml/I3DeYY8E5GuQK4htPpObD433wHZPRRbJLQ=;
        b=pJFpEucPf5DMeLJKJbdO7d89hkwY8IsKiYvq6ZSvcHOuPuDUK6F2hFGkbiaIClq37j
         oN6Yn42ONARMQUK5Uezx7sV6DsGZNXEmLZ0oDAVCV875FumDIEOlkK9VbvOcqmC9LzMc
         YUlO2RsrLy3swiVkHVKWCGbA0m3wHLZmoj5+kWIEjlnQwHyMWATXz2fIXe3xXM63lm3s
         F0tlssNvjL20XoAqo5YZc3vz5zg8nlVF3BFzbqpNBGZH4vhG7NkX45zE62kvbm/+2FyC
         8kNrLwzHJfN9avw4s3Y40llt0PNgtRHY11ID5mrUqep3YYusXHHvqywKYmfMz7GyqPdg
         XOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786876723; x=1787481523;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J6KOR7ml/I3DeYY8E5GuQK4htPpObD433wHZPRRbJLQ=;
        b=NyC4pEoB5WRcamF+wruvnvAvBDS8RGrs2Q5LChxD2RaYRrZkC+mVCCn44+sJrbF+2P
         YT/JsS2LlSRxLT6myfHv/ZW1/ZU6cVl55Akkl9yi6LuFHXRUNJ/PGZu/1qeU1qBsQj8r
         7zhmWCT+xr3JwtVOneSEbG9ZRX6O09CO61bZ9Ep/PD07upM1TMFXQ5YBh09Yt48iZ3N4
         P1CXRzWUT1ylfKASihSqYzCvEMYV3+sPKXvSXmt7vWkPesLcOlqlsIks1kKsh5UrPsJQ
         8J1uLMiQCMrvkumLQzIojgr92hPdoJKSupX9doUgA13vPrjvn6BDLfZn1QzoN1rikU/k
         OnOQ==
X-Forwarded-Encrypted: i=1; AHgh+RoZkJnLrNGMwmebbp52uZUExr9JzevRjlAH+VHwDnvT3b7KVTJFfbLmDEXbcB0M83W/fUDdeIQlgUtqvdL/BCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHMY6ZswocS7S1oXwSj3I3flTctjd/pQVFyWnGt5MDhRyUZ2PX
	Y1oIveoQE6a1rSFSmN3N2w4CO2VU2HIMLbD1qCTLPw1GWK1F+UtXTEQp5XkduGlZEDFdfWpp5on
	Hmn9KLCADJ4WwofBprPXOPHL6CupOgleU9DFjaCUFMhLvoaczedJnJHJ+zW85nZwzSnnCkg==
X-Gm-Gg: AR+sD13olLvV24PY55FBl9IztKJmEepAoJSeH97HIsgwPcODvP5iYhn2BKamsTCK/0B
	BGcjVdAMxU4bfmXXBfwTdYrI5faxWLbrcV2V5TndxtE+xn65q8P5vT3E8NMayvEGGplNJP4ENOk
	tmXXezn3l84qpNX5A0L0NT/D3mtz0+ObSGlNCeQRiSQXMc0Zo/oY5twleUeqW/fq5r95RX6lwxt
	//8HuBoSKSxEmNcZfaGuj3QLFB29JFly3gPV3lx+bCq6hNAw7fs3YMJ0X3rHBtR/jTLJ6BEKl0h
	H1IDibHxXPudUW7AfcZXuIYWTdpRhLUwoTH2QKmWnvA/12Ut74Peutoqo7O8YIDckkwKsh7wgV9
	b2Yhck7HSScM=
X-Received: by 2002:a05:600c:1f91:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-4998797d111mr236172515e9.15.1786876723044;
        Sun, 16 Aug 2026 03:38:43 -0700 (PDT)
X-Received: by 2002:a05:600c:1f91:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-4998797d111mr236172095e9.15.1786876722609;
        Sun, 16 Aug 2026 03:38:42 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b1a31esm211201745e9.2.2026.08.16.03.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 03:38:41 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>, stable@vger.kernel.org
Subject: Re: [PATCH 6/6] netfilter: nft_set_pipapo_avx2: add missing
 vzeroupper
Message-ID: <20260816123839.3670e5c3@elisabeth>
In-Reply-To: <20260815205750.169336-7-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
	<20260815205750.169336-7-ebiggers@kernel.org>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sun, 16 Aug 2026 12:38:41 +0200 (CEST)

Eric, thanks for taking care of this.

The patch looks good to me, I just have two questions:

On Sat, 15 Aug 2026 13:57:50 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
> returning from it.  This is needed to avoid degrading the performance of
> any later SSE code that may happen to be executed.

Out of curiosity: was this prompted by some observed latency spike in
execution of SSE code, or it's just meant to satisfy the recommendation
from AMD and Intel to use it while transitioning from AVX to SSE modes?

> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Cc: stable@vger.kernel.org

Is this really stable material? Skipping vzeroupper might have a
performance impact, but it's not an issue for correctness.

The main reason why I'm asking is that, while vzeroupper might look
harmless and obviously safe, it actually caused CVE-2023-20593
("ZenBleed") on AMD Zen 2.

I expect systems receiving stable kernel updates to also run the
patched microcode by now, so I'm not overly concerned in any case.

-- 
Stefano

