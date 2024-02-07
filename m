Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3B82865
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707327010; cv=none; b=id1cdj64J9C3UXHHI3TItUe+iCiUpbSbhnK0Mqo8ALfyXUYpKZ2YZdiYWZ95SPDXKiHRL1Lw05PdQLqP9uFrBW2W/v9CH4KmrmVKo7sW/cnNJib6XMmEh6yAvoYMqJC3Vpxk71AVVTsq5BrYMUGVcQPRd4lIhR5u7E8Z7li0g8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707327010; c=relaxed/simple;
	bh=IvEgQYoyfKlosa1h7nW3/qqieg51jcMlbdoiZ1GJeZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJsFUk1bNxCe7Xo77zWdViMflMy+/kjNxP6r+ULDbzPvKkpu/6BOc93IWzDQ4x5j3SZjohih++eBLcrqiFB3G0rlfNq6T90lGdqfjvDNWFIhlW1T75oIBF0TEIGOwQH/xohlRiT5WgHENNj9l2f+0TzBjyrVyPMgFkS1hTSKb2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShDxJ0lQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShDxJ0lQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707327006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P1DSVo4An4kWpl4fdV9Q8OrYwJJvyrL1FDjSIapAm60=;
	b=ShDxJ0lQGlwNGi7izx94YMW9MsWzboMv84ESTW9h1Le6W0/KwpQjDS4IcDIt098cBgpSHZ
	QFM+SDPHXmsw5Ukx4juikVAGrwBI6ZvVxzKU2i/aWjrEHNf+5d9oQLp/uE4GzdzY83FvDV
	KxZ5bT1O3bePCFLKcnKIzJ6lO2T6sSg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-H2pbbEFVMVqlS_aGvRBTPQ-1; Wed, 07 Feb 2024 12:30:04 -0500
X-MC-Unique: H2pbbEFVMVqlS_aGvRBTPQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50e91f9d422so1150593e87.2
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2024 09:30:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707327002; x=1707931802;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P1DSVo4An4kWpl4fdV9Q8OrYwJJvyrL1FDjSIapAm60=;
        b=V4CBOLIPTj/dY6F5Nw19S+GLqbLYpaltbN6TdTOgUSGQuLL3Jux9ZeoS4J0lB1zlc4
         wg5zQqPZ/SCDMypOTfptss85jD8GHNAvDe5VLQhOn0v8pAcipVhF6x1VLlhgb1e/Ww1b
         SKEoms2TmZCpno2BGp0ll+weNdsGaQc7UdHw6qbkx3mlsMfEucuWLN8SCsOBtfWZoSJ8
         6dGbYRuzM2W5uTv1evPMTo2QrMwl+oJ0gqIoDv6tvADdWOrQ8RvAwuUNRkg7t2qBBFIq
         YWNmYOPCZU+/ppy9ijDB/wYnqgOaY80ZWfmRSRYBgurHv5k4GuJ6tScK1sjm37nOBrud
         OtOQ==
X-Gm-Message-State: AOJu0YxVGjUbq+f1QbWri12/ttCY2UvODwDPod/lMvrZYbfAoyvChsfg
	knVKf4Kf09Duhz1CxYhUJj66QLK/yPRuooJOo56FHU3NpgzK4qL2HJrvjU38ydo9/dZZ0t4b4u5
	4IyChP1+gT+nmPOdeeH1eaYrB72W5c/qJCoyLg5PSaWEQYGlHm1QZ9JUrca3tyY9P3qY6v+RjWp
	Ab
X-Received: by 2002:a19:c505:0:b0:511:4ff0:5328 with SMTP id w5-20020a19c505000000b005114ff05328mr4286668lfe.32.1707327002562;
        Wed, 07 Feb 2024 09:30:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/yjyY16oO4D4O7b+Cf0u1xTgI7cl3fVFvIVwwGGxC1N7ooUyX37xuVHlVrPi6gS3gQZtPFw==
X-Received: by 2002:a19:c505:0:b0:511:4ff0:5328 with SMTP id w5-20020a19c505000000b005114ff05328mr4286656lfe.32.1707327002282;
        Wed, 07 Feb 2024 09:30:02 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id w24-20020a17090652d800b00a3738c18c9csm974322ejn.178.2024.02.07.09.30.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2024 09:30:01 -0800 (PST)
Date: Wed, 7 Feb 2024 18:29:27 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 3/3] netfilter: nft_set_pipapo: remove
 scratch_aligned pointer
Message-ID: <20240207182927.5bebba55@elisabeth>
In-Reply-To: <20240206122531.21972-4-fw@strlen.de>
References: <20240206122531.21972-1-fw@strlen.de>
	<20240206122531.21972-4-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Feb 2024 13:23:08 +0100
Florian Westphal <fw@strlen.de> wrote:

> use ->scratch for both avx2 and the generic implementation.
> 
> After previous change the scratch->map member is always aligned properly
> for AVX2, so we can just use scratch->map in AVX2 too.
> 
> The alignoff delta is stored in the scratchpad so we can reconstruct
> the correct address to free the area again.

That's a nice simplification, thanks.

> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

