Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3235273811
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 08:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756455819; cv=none; b=IvmzbT6zRRLTnBRxsocXBxbbJNYyFIzLgQ50C5MhjWu58a9S4pzl9yow420CRa3T2QC0d72NYMqNM7AqhrjrOay3n+h6BcjD/lWIO/fO1jB0QwxlCtcrd2yzzUpfpsLgWRa4KtQDdrGFrWjcR3aC95PLqP/FNW2tQuoGhoCnmWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756455819; c=relaxed/simple;
	bh=DI+ZjWxtDi8zDnofdodcO+1bwbRlushzDoX57aj7XUc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJ/mKoYtkbIhVYy8+SMhrm8Pj1ofIrtHM1pt/XiGwDOAXgNhim7NEH1bWeYRoPJUzirSAJs/DFnKGZD/kMsA0dZnoZkiTBmDXvlTG3TQMO7STGJVKNybbUCRS6Unj26jlcWRHkr/RlqDvir1RIdqFKvHex60Sl57iZ/6i8gel5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HlCo/E//; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlCo/E//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756455816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MmKxa710vY7oyF/1oM78b8wj4v6KnEmov3cJty9r47o=;
	b=HlCo/E//BgvOEklY946pY1icw1yvYwzsfNob1BfCaiJEMF7RYiQsYu94YlfxYAHKv4+0oc
	FR9Mu0re3QukCFDP9r0TLGs9xXCF8ArAFYD067PPtGzeiecsAcQHNwXY9KceTRhv4s6npT
	ddLDpbZCuaSUqvtQ4Bo9yg0bYtuRG4I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-0sS-O6U_OymiJai5t7Egkg-1; Fri, 29 Aug 2025 04:23:30 -0400
X-MC-Unique: 0sS-O6U_OymiJai5t7Egkg-1
X-Mimecast-MFC-AGG-ID: 0sS-O6U_OymiJai5t7Egkg_1756455809
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3c6abcfd218so1268045f8f.3
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 01:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756455809; x=1757060609;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MmKxa710vY7oyF/1oM78b8wj4v6KnEmov3cJty9r47o=;
        b=M5wFgG8cf5f+KIvFTX0YcqXVd/MaAxGeTzBi+3PUBHzBcFvlVpcGIdr5YqSDJy/yLw
         5XM4vEwUEQIBDhK7v7rWuovNXZS1NrIvy6BMfEKjtL2ViQVfBWdFLBeZjs1GkgdjD/8O
         WfCyuGS2CRr+qHiPekxTJ5Tx60j4XaMWiKvPwgJAjf98bPGNPza8eIz/xNeEHgAq7O8M
         BmIvKnQbIMvVvRAC4kvWfQfO7sKB2N4Kan+PJIBn1kM2XLCHP/H2kEf5wmUxj+yRZVKX
         SjWEN7RgChictEnoi5ucX2dV3NbPsDXCMmDBfOjXmAvDJ1leUxwmTQ3mNVclYcl4D7Mx
         mW3Q==
X-Gm-Message-State: AOJu0YzmHYjc/qqB+5dcJVKK0z+XkMk7orx+wyycusvtA9p+gEfFoKqF
	7CiIpRTYE3t6KnhzgtR7ZJIxRaTbNZ5n/m3fmwNuRqZKp82NGo1TvCs3Krc+YMY1yr/5OQOqv+M
	+I816sLcq7PTLm6CvuiYnc2kiUpqxv6xTqW4ahJCkqZzlqeVCz22tC/WGOIQmvQpaCiGIF7EnQV
	7IzQ==
X-Gm-Gg: ASbGncsfA+1wWhLnscTXpO540xUDi5D7DQ/7+g6GfWMbv7BAqS6gR0ue950bQOD2m1E
	bi9ZybFpemBiNUj8huqQe5aW4gt/FVJxpojDIOIyc/pJ+j9hjtrom4cZx7MAciVlqgMRh5Z8g5/
	KmE4LAjbT05jk32SS1Njs5cLhcDtgC7Vt1j9y4oPcxCZFOX9GJKUQTMsb7FnBqW2x2U7+GJGbML
	yHonNegL4/eIXpgefGyOXixW+MFq4aND22vvewzke9P8UdgAXOiYnYIgx4RUEEkmwtg8ljVIkSB
	ONYhvdR4rZ1gQP6guA8QmTNzXDUgDsolwVkVXXEIiB+JCmtByqY5n0FXpOhH/WNZyT8N
X-Received: by 2002:a05:6000:2910:b0:3ce:fe6a:a9e3 with SMTP id ffacd0b85a97d-3cefe6aaae3mr1796385f8f.34.1756455808939;
        Fri, 29 Aug 2025 01:23:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzuxmDfOUybUDdHu3jVuATU8Mo9YtgE6D5JM70fzmnjejmIj92clHgXpRqC/46EDLvYm4ZgA==
X-Received: by 2002:a05:6000:2910:b0:3ce:fe6a:a9e3 with SMTP id ffacd0b85a97d-3cefe6aaae3mr1796369f8f.34.1756455808513;
        Fri, 29 Aug 2025 01:23:28 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0c344f6casm1265109f8f.36.2025.08.29.01.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:23:27 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:23:26 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>
Subject: Re: [PATCH nf-next] netfilter: nft_set_pipapo: remove redundant
 test for avx feature bit
Message-ID: <20250829102326.6dc1c095@elisabeth>
In-Reply-To: <20250828235008.23351-1-fw@strlen.de>
References: <20250828235008.23351-1-fw@strlen.de>
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

On Fri, 29 Aug 2025 01:50:05 +0200
Florian Westphal <fw@strlen.de> wrote:

> Sebastian points out that avx2 depends on avx, see check_cpufeature_deps()
> in arch/x86/kernel/cpu/cpuid-deps.c:
> avx2 feature bit will be cleared when avx isn't available.

Oops, I didn't notice.

> No functional change intended.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

With or without a minor nit reported below:

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> ---
>  net/netfilter/nft_set_pipapo.c      | 2 +-
>  net/netfilter/nft_set_pipapo_avx2.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index b385cfcf886f..415be47e0407 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -530,7 +530,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
>  	local_bh_disable();
>  
>  #if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
> -	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
> +	if (boot_cpu_has(X86_FEATURE_AVX2) &&
>  	    irq_fpu_usable()) {

...this could be a single line now.

-- 
Stefano

