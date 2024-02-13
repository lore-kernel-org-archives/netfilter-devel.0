Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA055EE87
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707840520; cv=none; b=m9QDV4ywUxxOiwRRCgu8E/bVAyYO9jpJHCHu6jS/18znuXH1x6xnpuJVP81+dUZ++z7CsfCU50cMpQRfkxqSuEHuynGfofgheyBASORPgCWXqae8XoXjX8/9T/V/4gD+r80hYe+ORauErVsplKiX0gMaf98HMBcNiBfEgdlXNtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707840520; c=relaxed/simple;
	bh=a4XHzphfiia0OmZjZ8M1cSewAFBFBq+VkGifxgjHl9o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWxzHoX30Iutqy2XAUxsgEAf4axrl1sD1+2+6+DCfuT98fzHlqB3qIt9q3kuB+fABE9DfDkvodEMfQGlICLtAO7DheG2Zw/XoXf5daLcipHhFa35Ga4uL7aBmGyXWlgci9de+447rDQrh6OhfbHMnr5i4HhB+zxd5DbaMIODJcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnpeDI8E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnpeDI8E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707840517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=klBzpgXNOi4B1h8h5wdLTFKd+DvOvQKvLHMC8RLmEk8=;
	b=GnpeDI8EK8qYmPU/L4kmjqukjoEFXxDVFi+403RsKDZkJCOQK+ZE9nyWeuAdIppY9srTVk
	gjlJqa6ooMCKLY+Ck7q28VeDIAK3jOCC7dtAg2zRKdLJ1/1HaFm9kHcVhO6yGh82IYCqOm
	gi/lBxWDb35NtIdxBkYPtRU2SqZg3Zs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-w3CNGVQAMBKk9TF_G8h-ow-1; Tue, 13 Feb 2024 11:08:35 -0500
X-MC-Unique: w3CNGVQAMBKk9TF_G8h-ow-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-55ffc81c768so2441220a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 08:08:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707840514; x=1708445314;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=klBzpgXNOi4B1h8h5wdLTFKd+DvOvQKvLHMC8RLmEk8=;
        b=trQasCMa4JjDC9LeZH7me8kYKLWFn5IBL7RDb3ZdeB+A3OA+imVQ0QL/TF1YywsP2w
         Yv/Ybfp5P0Uei43vkVbdqvbC68NZPUNDXXKdOeFho0QT28tNyis3oeMk2E8zpcdTcNye
         fjWbhmJ6hw6Cmddo3Be3NM2YUQ1Fna6gyXZMhz41Nvu/gVZZZAegRzSnTBDztntmOqMZ
         fhKC5OkO/+C5jkPCR+fVbtSajYvp5rTxpyKQdIWgocm3AiajA4x0I6sLPvgsjP4S0igp
         o6ARa7pTh3v6igo06XCzv8T43Qa/F/StHZVAOl0qs8AqDkJ4DGawDAt8MVolAvfPvTYv
         uIAQ==
X-Gm-Message-State: AOJu0YycKg+j9PXGPnAyHBJz8yI+dPO6zJN5E/ZbTFd/LjhezO8SGn8A
	8I4eiftSm8a5zsPCjwmYYJux5rFrvfYSlEDDeLf18+BhFGB5qPAgE3cfAD2FinCr+ZFHje2uulm
	jnVK6kNv9AdSHoRzpWCqBHP0YgODF4K9npRk7tA8wcZyMRKdaB94wUrWT9RJRvsaVkg==
X-Received: by 2002:aa7:c49a:0:b0:562:149c:d2b3 with SMTP id m26-20020aa7c49a000000b00562149cd2b3mr71019edq.34.1707840514478;
        Tue, 13 Feb 2024 08:08:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeItkUTKA5EJeB8zPqfmEhPu1BYKkpBAs+SxvLfqlYtrhxsKaCX1oJrLQGLa3+gQLvDdoxAg==
X-Received: by 2002:aa7:c49a:0:b0:562:149c:d2b3 with SMTP id m26-20020aa7c49a000000b00562149cd2b3mr71011edq.34.1707840514234;
        Tue, 13 Feb 2024 08:08:34 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id t22-20020a50d716000000b0055fe55441cbsm4043655edi.40.2024.02.13.08.08.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Feb 2024 08:08:33 -0800 (PST)
Date: Tue, 13 Feb 2024 17:07:59 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2 nf-next 0/4] netfilter: nft_set_pipapo: speed up bulk
 element insertions
Message-ID: <20240213170759.6c3a9f60@elisabeth>
In-Reply-To: <20240213152345.10590-1-fw@strlen.de>
References: <20240213152345.10590-1-fw@strlen.de>
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

On Tue, 13 Feb 2024 16:23:36 +0100
Florian Westphal <fw@strlen.de> wrote:

> v2: addressed comments from Stefano, see patches for details.
> 
> Bulk insertions into pipapo set type take a very long time, each new
> element allocates space for elem+1 elements, then copies all existing
> elements and appends the new element.
> 
> Alloc extra slack space to reduce the realloc overhead to speed this up.
> 
> While at it, shrink a few data structures, in may cases a much smaller
> type can be used.
> 
> Florian Westphal (4):
>   netfilter: nft_set_pipapo: constify lookup fn args where possible
>   netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
>   netfilter: nft_set_pipapo: shrink data structures
>   netfilter: nft_set_pipapo: speed up bulk element insertions

For the series,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

