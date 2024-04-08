Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B151411EF
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 15:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591196; cv=none; b=rOTHbmpKiPC45wYE3yqDLdZgafiIzRYerPd36x/dbzpTKJKZVsopOoxY4yO2FcWKGOSteVwZ0rvVNWAS136EbTg4EA8hCPSKJywWkBDtrVi07geVUkLenGrBeG1ury/rbvq7Vo/6ZclUmkD0J9Lim2jRunxrGhsXXptmG3ZmF9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591196; c=relaxed/simple;
	bh=B4HiyIFhE8S/fj6rOvF/7//nzHemPA0SBmGRiuyhdu8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTlXaY/r3gLxCxBpoliTMJGSjeTlvjZEsVD4HCAiRrnCJ2buTd4sYx1i6CnB1GuijqLQtHcfEPLSDYfjYrmnhN5QUctZ/0a7yAMJHTn9sxgvlMeRTg5c/dNwIYP2pTooDQbJu/lJJHAaeas7378WDEYf2YSBG+esD9/e41FOVbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AIl38YTg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIl38YTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712591193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nGtKyjAEhoPqRJQvGNhE2fWM02c+1BVqR/NHfBMtA3k=;
	b=AIl38YTgtMxzdWLDTvFKvGaIMY3GWpVdTj59WYPKihhJ9Mw5H4DU0q8Z3ZRkD/v2T416UX
	FiuIIyjz71KZQDP3oJnh8AOcy7mHKfC2a27NveDBmnJyZVzIde6gbPIj30CcCKFHnkQZ7V
	jkfJ+mA7GpRJbEKgAvJRxGybgfJ5WOk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-FKy9vLshONaJ-HL9lg3yhg-1; Mon, 08 Apr 2024 11:46:31 -0400
X-MC-Unique: FKy9vLshONaJ-HL9lg3yhg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56e42e754easo1159166a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 08:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712591189; x=1713195989;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nGtKyjAEhoPqRJQvGNhE2fWM02c+1BVqR/NHfBMtA3k=;
        b=GON3eMktuv3Nk7e65N/TiB3VM/Yiiyw3Ik30ahdLPGcEzvZ8Ftggl6HBJWa/l0+P3j
         aLLGO2mhenHuqsOkhlJWa0NtfNq1NJvNRWj9P3gXxypcOWcwzQqYHV6mTUYtwQSXlh8J
         bN/UMdcjhQFxoCTaAu8iBConsZoJ62TZoihERViQlqKHP/uic0h9bYtInLzbcC6lR93F
         2124V6fLzANxd4Mm5K0/xJenMPX4wgssvNvD4q0I5dtVV+GppYFsUo3axaUCqSUJZhtV
         UK0wXIBNUwqsKN8H+ZTF519RIrA5fniVDu1KRZc4giHNK8NKKmCpZjfrxUFyEnEdIei0
         cKuQ==
X-Gm-Message-State: AOJu0Yyye9iDxogQLWlemnOYdsx5NGjLRuZHOs+iurn8jMiZQLin0lIa
	c9hLSpKXyCCo1lL8zPeBvHWxgbtEtgXX3xVxpHt09LgRNrPycMNQHfryk29WRFUWnukGMQ5/GUd
	35HQ9hlEBOTYkQc633q1+0oDVYt6yP1NGgzGLH7daeF3XSBqk23zy2/bbWXESs0mmpY5t5AFYMG
	Ll
X-Received: by 2002:a50:f609:0:b0:56a:ae8a:acc0 with SMTP id c9-20020a50f609000000b0056aae8aacc0mr5966671edn.21.1712591189392;
        Mon, 08 Apr 2024 08:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxg8K6J6nMCQfZHZSC8osmUIzyHfGU3Dw/j1LZr1xYusGJCk2/VO0JyefQHxwHoC1iXFDkrg==
X-Received: by 2002:a50:f609:0:b0:56a:ae8a:acc0 with SMTP id c9-20020a50f609000000b0056aae8aacc0mr5966654edn.21.1712591188845;
        Mon, 08 Apr 2024 08:46:28 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id g37-20020a056402322500b0056e2e9d916bsm2936797eda.0.2024.04.08.08.46.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2024 08:46:28 -0700 (PDT)
Date: Mon, 8 Apr 2024 17:45:52 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 8/9] netfilter: nft_set_pipapo: move cloning of
 match info to insert/removal path
Message-ID: <20240408174552.6c1dc303@elisabeth>
In-Reply-To: <20240403084113.18823-9-fw@strlen.de>
References: <20240403084113.18823-1-fw@strlen.de>
	<20240403084113.18823-9-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  3 Apr 2024 10:41:08 +0200
Florian Westphal <fw@strlen.de> wrote:

> This set type keeps two copies of the sets' content,
>    priv->match (live version, used to match from packet path)
>    priv->clone (work-in-progress version of the 'future' priv->match).
> 
> All additions and removals are done on priv->clone.  When transaction
> completes, priv->clone becomes priv->match and a new clone is allocated
> for use by next transaction.
> 
> Problem is that the cloning requires GFP_KERNEL allocations but we
> cannot fail at either commit or abort time.
> 
> This patch defers the clone until we get an insertion or removal
> request.  This allows us to handle OOM situations correctly.
> 
> This also allows to remove ->dirty in a followup change:
> 
> If ->clone exists, ->dirty is always true
> If ->clone is NULL, ->dirty is always false, no elements were added
> or removed (except catchall elements which are external to the specific
> set backend).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 62 ++++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 21 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 2cc905e92889..eef6a978561f 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -615,6 +615,9 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
>  	struct nft_pipapo_match *m = priv->clone;
>  	struct nft_pipapo_elem *e;
>  
> +	if (!m)
> +		m = rcu_dereference(priv->match);
> +
>  	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
>  		       nft_genmask_cur(net), get_jiffies_64(),
>  		       GFP_ATOMIC);
> @@ -1259,6 +1262,23 @@ static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
>  #endif
>  }
>  
> +static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old);
> +
> +static struct nft_pipapo_match *pipapo_maybe_clone(const struct nft_set *set)

Nit:

/**
 * pipapo_maybe_clone() - Build clone for pending data changes, if not existing
 * @set:	nftables API set representation
 *
 * Return: newly created or existing clone, if any. NULL on allocation failure
 */

The rest of the series looks good (and like a big improvement) to me,
thanks! For all the patches minus 3/9,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

