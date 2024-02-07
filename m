Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E88446C8
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326987; cv=none; b=SXYMZLHyKCuKX5E2Qcik311StcI6KJ02ou/npRk5CYFNij1xzh1/h6zPxDQWhOT9c6Vsu+qxK6r2OzDJJFmkbPJfbWvT/3m6P2HxkuRyoyD5HPIbN0D+HdB2LOcHhKc+b6u2v1e25lXPTjCNUaLBX6k9J7IizI765CA9u01Bn+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326987; c=relaxed/simple;
	bh=ZYnLliq0g+ZmD9ZTplgrzhIZwVcNvXVEPmtCGeAyPN0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPK1KToi8MbJeIAbDwf6ryZ17Ndr8+92QWvxcY609tCi4wNtF2n3bx70beGgsAhI5ISc+2CsoQTs9ZBHdleJNkKUvkn+n9YMZ2T73rXGCI2EDG71+J64c3UZmvsYDBXwjPQMYR0l2G/ylnK/3fCLDLvcxV5VAffTg8tWMIaZ2/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijVvu5eR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijVvu5eR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707326984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=INNekAAuewILwWNTQ4nQ5t2yvxT6iMuu3dqp+gzL2oA=;
	b=ijVvu5eRlmSo7Ht3i8R2XgofmkFLEOwZq2tSd0FxPw2eYplo2cYrn5khqF5ylHBQ0AEm0h
	8atjZ1kEAU3MWEfMj7pJMBxKo5n4HQN+Eryqm22GCqIAVucUADyMx6u7y5xUx7N/TaUqJZ
	B19Vyo5IJPWVTBuLlKimkM/c916pr5Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-s9K0jhfTNu2K9EOnZZHyeQ-1; Wed, 07 Feb 2024 12:29:42 -0500
X-MC-Unique: s9K0jhfTNu2K9EOnZZHyeQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3872c93742so5494066b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2024 09:29:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326981; x=1707931781;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=INNekAAuewILwWNTQ4nQ5t2yvxT6iMuu3dqp+gzL2oA=;
        b=jI7w26LZZJQH3Gohz+eruCJk9lGruAxaKWOE60JPM52+64P7NBGE3G12sx2OZvUfzQ
         fYoCCQILd23LesJrUIUY8BsQX/0pzRWrOY3neKa6LFxa1fAfzeChw1eTF0lwlgPdL2RY
         pRcO5hMwQSXybGcP3Tt8gAVWLh3HYuMHS+wkZeGxI9OIBl7J/FkXsHOnVR8nfBKd57CA
         pNu0iDaKGyS7ar/fHJ3tGECaRicISFV/PJgFy/Z3+EEAaVwhYFP1ybbNbpvjjYA/owhV
         4voXHZ4jqm+/8bqMFqVOevj9Sqk9lKr+gM9VZs9OkCFc5943Ai26zW/lzqGti3kVAbc7
         AdyA==
X-Gm-Message-State: AOJu0Ywp/KO1b1gv3q8jWNp9buPXi5i/Y0DPv4flp2Y4pIZKP0FcBsYo
	NBYzUTo7KV07zVvrgX29aAvsRa2KQgB/QErEepHNiMxWS2g1tUA9LQcEcEDn7TAmEjG/I5vgaoO
	dy5uuFZxpLUTegG7AJi+4M2XpT4+ajD3U9Sa4y81NZY281E4CopulPi8k5f/V0aCg5fiSArXsmV
	Jo
X-Received: by 2002:a17:906:c404:b0:a35:3eb8:2f6e with SMTP id u4-20020a170906c40400b00a353eb82f6emr173722ejz.33.1707326981224;
        Wed, 07 Feb 2024 09:29:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEmSkicjW/tePdTnYtyPNP3btGjLW+dixDv02RiQgJ3tjRpyRo2E8EkzsQOz4/kZShFWIYTQ==
X-Received: by 2002:a17:906:c404:b0:a35:3eb8:2f6e with SMTP id u4-20020a170906c40400b00a353eb82f6emr173707ejz.33.1707326980955;
        Wed, 07 Feb 2024 09:29:40 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id pw2-20020a17090720a200b00a370066b810sm961375ejb.165.2024.02.07.09.29.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2024 09:29:40 -0800 (PST)
Date: Wed, 7 Feb 2024 18:29:06 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 2/3] netfilter: nft_set_pipapo: add helper to release
 pcpu scratch area
Message-ID: <20240207182847.06bd8dde@elisabeth>
In-Reply-To: <20240206122531.21972-3-fw@strlen.de>
References: <20240206122531.21972-1-fw@strlen.de>
	<20240206122531.21972-3-fw@strlen.de>
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

On Tue,  6 Feb 2024 13:23:07 +0100
Florian Westphal <fw@strlen.de> wrote:

> After next patch simple kfree() is not enough anymore, so add
> a helper for it.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index a8aa915f3f0b..3d308e31b048 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1108,6 +1108,19 @@ static void pipapo_map(struct nft_pipapo_match *m,
>  		f->mt[map[i].to + j].e = e;
>  }
>  
> +static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int cpu)

Almost everything else here has kerneldoc-style comments, perhaps
(already accounting for 3/3):

/**
 * pipapo_free_scratch() - Free per-CPU map at original (not aligned) address
 * @m:		Matching data
 * @cpu:	CPU number
 */

Other than this,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

