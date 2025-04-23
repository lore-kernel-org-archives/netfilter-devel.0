Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F76526460B
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 09:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745399114; cv=none; b=K9mAYI6JKDZozOfo0tryqyla3logSJuvVUThcqUB6aIhNIuC+Km6BucgIT/v6V7ch5g/UDqtSSkIISurc8/qkZIuFYt+BS7evFiG+ZFMj4XE1lyMLOAvnThY4M1n3iKcsqDPL5tl7JlRRjm+nnUpViUNh6KETvP1hs3/OIqORPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745399114; c=relaxed/simple;
	bh=9B5WV9aULjs3LpDHxpgA8d7QfOHOGHfhV58B01vswvc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obl0MPEInZHvFWu7SHzfTlne9m7CDoxKapF3EVoU7niSNQmysvOrg5L1c2Tlino561Ra5kzCk3ZEgSPF6GcTPCL5gbDh5SDUuI6xT4APXkXMDTsFvOXfnNRz9WEF+W4ttLXgINdGigEJumaeshCikHeKn6VB5Z/Ym3FAEx6C2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MIaOVudG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIaOVudG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745399109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISLflHtiyX+aJkgGwOKcGkcHvTz3KrcLAR5s78yy0gg=;
	b=MIaOVudGH+K9cTN7/IJbe7iS0NOvDm/mYTu6xI/bb1zJAMM9qs2V+vAB3tckM5V4NHsDZz
	9wa1f++LlRG9Mychm24C4RAm09vUgVpxNlq2vIlm15LOoaMLQkwyacEJ7M1K9InZxmTFPW
	I+FREqHFpTL5n7bDUu2jTQuYGtgphrM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-DaFd_1qWNxu_4k3TBriChQ-1; Wed, 23 Apr 2025 05:05:06 -0400
X-MC-Unique: DaFd_1qWNxu_4k3TBriChQ-1
X-Mimecast-MFC-AGG-ID: DaFd_1qWNxu_4k3TBriChQ_1745399106
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so27961525e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 02:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745399105; x=1746003905;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ISLflHtiyX+aJkgGwOKcGkcHvTz3KrcLAR5s78yy0gg=;
        b=nm9dhIAiQLDiAz4CNyu/4/uF4NE3arjRjO9vSOGR9Q6nj5DPxexpXrR6+f7ARe8dYo
         NvgRO31xgmlGRtbHK7KRodTMVlhAKnuMCeb52HPXXEWq/hOHdpXjrT5JJx2OWVBCIlo1
         If5mLfXu0jgExWFCyVU3Am06OX4VY+rYoJlyXVAYiAevWsE85BIsEIP9896sZYeVLl21
         zmVQxz7/wkjrmo2tbQCcpg0UmDYJ1brhDOQ/JMw6kJV7gUNBzmlKebdIQlO3tAUTt4Ej
         UJJaXdIPgkDegguiS94EquAfrpjl6D5Pqd1EgjIGkudv9n+Csa9ch5s2OIQyx4A56EXK
         XD5Q==
X-Gm-Message-State: AOJu0YzqmMlMIxVaWP5l5Z1HXogz76j0MCAQuxZE075rllIx7saOWN/A
	kg8wY+b8s2IQTJZUm/7eJTgCLiMw19PSAoz2e62g9ZqdjUjpbvfep21StFEuKdTuPTim0XoNNG4
	Zgb82USpPzaIyXfNEsBr7ZuIfdbIphB512KEiPBevfKzdVOm6zWoUU/GiF969HHHZi/LZh5YIgA
	==
X-Gm-Gg: ASbGncvDhtVt/scRIQR1eV1SoL/VHcGNj3HY/MT75q7GQGVnaZ1MgcbiBPUXDNUxBBW
	RhkWY7fubZWXyLlMoinZSx8R4Xn1eX6lsBq9iLBn24uGXQe/ar8RU3NJmVmrByWSNKPtFoUloHb
	excRPsOCtWTIycDGVxYKc5NfRyzPDg0QLLtSholMjk0kfG0qpKPgZwDGotFxazG54y0M4+1LxTd
	873NZRmpwg5qtW5dHEjcSIJtCvPxxCvQKGZ55oUTEESRyIXt7svTSUwz+ePQNmfiYYhcnfBk6vb
	abch+AnNwY0kmGUGFzs/7sw=
X-Received: by 2002:a05:600c:3b9b:b0:43c:e478:889 with SMTP id 5b1f17b1804b1-4406aa8984fmr187225945e9.0.1745399104888;
        Wed, 23 Apr 2025 02:05:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7ywdY28pqe5xFl1MHbWJSdMILRYhWcFcPKCMdTH2vJm+iWtUwqU68be6dxV/C3n/pWvBmig==
X-Received: by 2002:a05:600c:3b9b:b0:43c:e478:889 with SMTP id 5b1f17b1804b1-4406aa8984fmr187225605e9.0.1745399104392;
        Wed, 23 Apr 2025 02:05:04 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4332dasm18279368f8f.34.2025.04.23.02.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 02:05:03 -0700 (PDT)
Date: Wed, 23 Apr 2025 11:05:02 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v2 1/2] netfilter: nft_set_pipapo: prevent
 overflow in lookup table allocation
Message-ID: <20250423110502.38218b6b@elisabeth>
In-Reply-To: <20250422195244.269803-1-pablo@netfilter.org>
References: <20250422195244.269803-1-pablo@netfilter.org>
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

On Tue, 22 Apr 2025 21:52:43 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> When calculating the lookup table size, ensure the following
> multiplication does not overflow:
> 
> - desc->field_len[] maximum value is U8_MAX multiplied by
>   NFT_PIPAPO_GROUPS_PER_BYTE(f) that can be 2, worst case.
> - NFT_PIPAPO_BUCKETS(f->bb) is 2^8, worst case.
> - sizeof(unsigned long), from sizeof(*f->lt), lt in
>   struct nft_pipapo_field.
> 
> Then, use check_mul_overflow() to multiply by bucket size and then use
> check_add_overflow() to the alignment for avx2 (if needed). Finally, add
> lt_size_check_overflow() helper and use it to consolidate this.
> 
> While at it, replace leftover allocation using the GFP_KERNEL to
> GFP_KERNEL_ACCOUNT for consistency, in pipapo_resize().
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for the follow-up!

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

