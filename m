Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DE02EE26B
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755704752; cv=none; b=Hcfud9Rhs+UW67XxjCLh2jxXP8XHKcssYIbc8DqI1dxE3LkStN90YELYEnUf7DkRRNzvtMvUpBH9VArt88bAIAoT0LH81JvXL9liwQiWV1K0MdtFAdHQBgxHxSJ7XYCVlSm1/BNYrAYQCGh/vTy1KsVqaCmhEHBl4OAh+d8Rwnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755704752; c=relaxed/simple;
	bh=PF7834m2zmBGeYNYT92AdeweVy9hXj/FOYFfPOv3ciI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBYsEX63bD5J2zTjEbe9AVwD3fIIt7smtrgV91Shr5yIAqH5fzDvjeyfQ+t3EKgkI1YuQ+O/dxbw0CE+jaCVdaoj1+B/VUlBL5vj5jeXl0frbbLSMD3jATVfFwtiAacwKGGjkCu/Uh8Yd5LTAgGvV+GiuoYGwMHCpl4+pQzv0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SglFcrPp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SglFcrPp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755704749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MaIQl8sxIrb95R4ZFBO0Jfm8W4+5z/KA412HXcZp9KM=;
	b=SglFcrPpzgDK6BYa4iXbnLpWSFuJMe+NaorZ2C51JhmWdGi/JdPb59vkqy2sMNUSVfG44z
	gKtLVJ6BimJ36rnHx1MqeM7f4kLiOKgSwcp0ojXXsvI7d9AETP49lTlmUbOxILwsR27VUU
	fM1bJeEgG8yR6rIu3xzwZZJa1qNkuXs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-rqrmZ3J_OwyHZ0_X3655SA-1; Wed, 20 Aug 2025 11:45:48 -0400
X-MC-Unique: rqrmZ3J_OwyHZ0_X3655SA-1
X-Mimecast-MFC-AGG-ID: rqrmZ3J_OwyHZ0_X3655SA_1755704747
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf34ad0so29971f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 08:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755704747; x=1756309547;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MaIQl8sxIrb95R4ZFBO0Jfm8W4+5z/KA412HXcZp9KM=;
        b=dADaZtbYPiFNVZ0dY+f5E9dNiKJUN2pamKB0TKfmNcTODmb2umzdNKsPgLY9kYeV+f
         4mWd146m/PLl5V1iRXZWhBOX0Ol7cz7HO+lBKVi0HA+gBYqr4guwZ43WS5AnHlqEknkX
         Ug+cmCRq+PZbK7+Y7c+jY2/JzWtlCZ8e3DV1mLM1IKSWF92LThYxxIgDJuZPKZRasNlT
         NHAh7M1V2PJ2D0a2TQxtf6BUKiVqI1pIqHP3yJfWDNyPSyTC7tRi7MPXP7pwp2zntD3U
         2h95rC3Jc7eqnEtxYjuG0lb9ldaLdYishNnJ3ZI5Llx/iw6qUbvvYZz6U872vmuCFJ9t
         D2Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUHltArFEY8ZW60iC22jgJBh/oQRYxmwfO5jOe608qgHle15jcmAGnEBqAKlPRDSzV2qHxdO8hbyMIRjF/3Dns=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza1vOSUoP5NquZN66QXuSH4fL5kzar9sFmH8ym4iulvEUlmTyX
	euOa+hOjkPLE96kJOlUJwYsMjab3nxeOIKfgyX/FgPjB7TxDGVMxAIEDHXPoQYE2S557ZYlvoOX
	ox70SiS89kMy1hCSZuhHWkVjpasqIB0zwURAvx/6auaWiPkQsyHVOOhAErPXLd5PPEZ7QZQ==
X-Gm-Gg: ASbGncvo7Tq/P8Z7PMxfzJbF5LWihEcg6ysNSW9WJ3UVVdB0KmTTbWZ3MBVTtyqEqq7
	QJCdnXXpW1L1bEhIMKk5f5MjeFAJfkDotUkhVkcjORFHi/KrZyCtmytZ1ctLtyTbtdq3n7ySSMg
	n/6WIwa09eygFpwQdDPRdBy1z8w8jiu/1MR9YF8NVwI+h1WviQdjqGoXkq8/Fg6V77Mw0OaIbcX
	9aOhe4Vl5AxWat+JU+TZwfOFEN4LMA/pbnuwxEEgFkp+xk5cnlvKDlKCI44dycCn5i+SUF8pL/z
	AhsMWDx1m9hMORKWhvU+0H3MAclKineTcK+txv9ydn//FbYGgNlDuzXzAcHXk0nepzp/
X-Received: by 2002:a05:6000:420d:b0:3b9:1d32:cf4a with SMTP id ffacd0b85a97d-3c32e6fe728mr2870326f8f.44.1755704747133;
        Wed, 20 Aug 2025 08:45:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEft7cxfwgnuC9fvgTvhd5Lg5v+e3eJCWb3Fa4JXUDbgyRD6cxdCOQrdQIX6hHvos7uCBDKZQ==
X-Received: by 2002:a05:6000:420d:b0:3b9:1d32:cf4a with SMTP id ffacd0b85a97d-3c32e6fe728mr2870305f8f.44.1755704746638;
        Wed, 20 Aug 2025 08:45:46 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c07487a009sm8151635f8f.11.2025.08.20.08.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 08:45:46 -0700 (PDT)
Date: Wed, 20 Aug 2025 17:45:45 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, <netfilter-devel@vger.kernel.org>,
 pablo@netfilter.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 4/6] netfilter: nft_set_pipapo: use avx2
 algorithm for insertions too
Message-ID: <20250820174545.398b2373@elisabeth>
In-Reply-To: <20250820144738.24250-5-fw@strlen.de>
References: <20250820144738.24250-1-fw@strlen.de>
	<20250820144738.24250-5-fw@strlen.de>
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

On Wed, 20 Aug 2025 16:47:36 +0200
Florian Westphal <fw@strlen.de> wrote:

> Always prefer the avx2 implementation if its available.
> This greatly improves insertion performance (each insertion
> checks if the new element would overlap with an existing one):
> 
> time nft -f - <<EOF
> table ip pipapo {
> 	set s {
> 		typeof ip saddr . tcp dport
> 		flags interval
> 		size 800000
> 		elements = { 10.1.1.1 - 10.1.1.4 . 3996,
> [.. 800k entries elided .. ]
> 
> before:
> real    1m55.993s
> user    0m2.505s
> sys     1m53.296s
> 
> after:
> real    0m42.586s
> user    0m2.554s
> sys     0m39.811s
> 
> Fold patch from Sebastian:
> 
> kernel_fpu_begin_mask()/ _end() remains in pipapo_get_avx2() where it is
> required.
> 
> A followup patch will add local_lock_t to struct nft_pipapo_scratch in
> order to protect the map pointer. The lock can not be acquired in
> preemption disabled context which is what kernel_fpu_begin*() does.
> 
> Link: https://lore.kernel.org/netfilter-devel/20250818110213.1319982-2-bigeasy@linutronix.de/
> Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

